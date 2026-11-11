import 'dart:async';

import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/domain/pipeline/price_history.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// Every coin's recent prices, recorded from launch: the live chart's data
/// (Phase 4).
///
/// A `scan` over the ticker: the accumulator is the history so far, and each
/// snapshot appends a point per coin ([appendSnapshot], capped at
/// [priceHistoryCapacity]). It starts with the app (an eager singleton) and
/// keeps listening, so a coin's chart has points the first time it's opened,
/// even a minute in.
@singleton
class PriceHistory {
  PriceHistory(PriceTicker ticker) {
    _subscription = ticker.quotes
        .scan<Map<String, List<PricePoint>>>(
          (history, quotes, _) => appendSnapshot(history, quotes),
          const {},
        )
        .listen(_history.add);
  }

  final _history = BehaviorSubject<Map<String, List<PricePoint>>>.seeded(
    const {},
  );
  late final StreamSubscription<Map<String, List<PricePoint>>> _subscription;

  /// [coinId]'s points, oldest first: the history so far at once, then each
  /// time it grows. A tick that didn't touch the coin emits nothing (its
  /// list is the same object, so `distinct` drops it).
  Stream<List<PricePoint>> watch(String coinId) => _history.stream
      .map((history) => history[coinId] ?? const <PricePoint>[])
      .distinct(identical);

  @disposeMethod
  Future<void> dispose() async {
    await _subscription.cancel();
    await _history.close();
  }
}
