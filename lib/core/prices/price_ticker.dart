import 'dart:async';

import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/prices/random_walk.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// The live market: one stream of every coin's quote, which always has a
/// current value. The heart of the app (the one rule).
///
/// **Why a `BehaviorSubject`:** a screen that starts listening in the middle
/// of a session (the Watchlist, a coin's page) must see the prices *now*,
/// not wait for the next tick. A `BehaviorSubject` replays its latest value
/// to every new listener, and has a synchronous `.value`: it's rxdart's
/// equivalent of Kotlin's `StateFlow` and Combine's `CurrentValueSubject`.
/// A plain broadcast `StreamController` would leave a late listener with
/// nothing until the next tick.
///
/// It's a **hot** stream: it ticks whether or not anyone listens (the price
/// history records from launch), and every listener sees the same prices.
@lazySingleton
class PriceTicker {
  PriceTicker(this._walk, this._clock);

  final RandomWalk _walk;
  final Clock _clock;

  final _quotes = BehaviorSubject<Map<String, Quote>>();
  Timer? _timer;

  /// Where each coin started (the walk pulls back towards it).
  Map<String, double> _anchors = const {};
  Set<String> _stablecoins = const {};

  /// Every coin's quote, by id: the current snapshot at once for a new
  /// listener, then one per tick. Nothing until [seed].
  ValueStream<Map<String, Quote>> get quotes => _quotes.stream;

  /// Whether a timer is ticking (paused, in the background or not started,
  /// it isn't).
  bool get isRunning => _timer != null;

  /// Takes the first prices, once: the market starts from the seed, and
  /// only a new launch starts it again (Correctness Rule 8).
  void seed(MarketSeed seed) {
    if (_quotes.hasValue) return;
    _anchors = {
      for (final MapEntry(key: id, value: quote) in seed.quotes.entries)
        id: quote.priceUsd,
    };
    _stablecoins = {
      for (final coin in seed.coins)
        if (coin.isStablecoin) coin.id,
    };
    _quotes.add(Map.unmodifiable(seed.quotes));
  }

  /// Ticks every [interval] from now, from the current prices.
  ///
  /// Restarting (a new interval) cancels the old timer first: there is only
  /// ever one, and the prices carry on from where they are, with no jump
  /// (Correctness Rule 8).
  void start(Duration interval) {
    stop();
    _timer = Timer.periodic(interval, (_) => tick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Moves every price one step. The timer calls it; tests may too.
  @visibleForTesting
  void tick() {
    if (!_quotes.hasValue || _quotes.isClosed) return;
    final now = _clock.now().toUtc();
    _quotes.add(
      Map.unmodifiable({
        for (final MapEntry(key: id, value: quote) in _quotes.value.entries)
          // Only the price and the time change: the price 24 h ago stays,
          // so the 24 h change is always derived from it (Rule 1).
          id: quote.copyWith(
            priceUsd: _walk.next(
              priceUsd: quote.priceUsd,
              anchorUsd: _anchors[id] ?? quote.priceUsd,
              isStablecoin: _stablecoins.contains(id),
            ),
            updatedAt: now,
          ),
      }),
    );
  }

  @disposeMethod
  Future<void> dispose() async {
    stop();
    await _quotes.close();
  }
}
