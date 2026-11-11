import 'package:crypto_tracker/domain/model/chart_range.dart';
import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/coin_detail.dart';
import 'package:crypto_tracker/domain/model/exchange_rates.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/pipeline/price_display.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:crypto_tracker/domain/repository/watchlist_repository.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// One coin's page, live: six inputs, one [CoinDetail].
///
/// ```
/// snapshots ─ this coin's (quote, direction) ─ distinct ┐
/// history(id) ──────────────────────────────────────────┤   (scan, capped at 60)
/// highestPrice(id) ─────────────────────────────────────┤   (scan, never capped)
/// watchlist.watchContains(id) ──────────────────────────┼─ combineLatest6 ─▶ CoinDetail
/// settings ─ priceDisplay ──────────────────────────────┤   (currency, paused)
/// range ─ distinct ─────────────────────────────────────┘   (Live | 7 days)
/// ```
///
/// The snapshot carries every coin; `map` + `distinct` keep only this one's
/// changes, so another coin's tick (or a tick that left this price alone)
/// never rebuilds the page.
@injectable
class ObserveCoinDetailUseCase {
  const ObserveCoinDetailUseCase(
    this._moves,
    this._market,
    this._watchlist,
    this._settings,
  );

  final ObservePriceMovesUseCase _moves;
  final MarketRepository _market;
  final WatchlistRepository _watchlist;
  final SettingsRepository _settings;

  Stream<CoinDetail> call(
    Coin coin, {
    required ExchangeRates rates,
    required Stream<ChartRange> range,
  }) => Rx.combineLatest6(
    _moves()
        .map(
          (snapshot) => (
            quote: snapshot.quotes[coin.id],
            direction: snapshot.directions[coin.id] ?? PriceDirection.flat,
          ),
        )
        .distinct(),
    _market.history(coin.id),
    _market.highestPrice(coin.id),
    _watchlist.watchContains(coin.id),
    _settings.watch().priceDisplay(),
    range.distinct(),
    (move, history, high, watched, display, range) => switch (move.quote) {
      final quote? => CoinDetail(
        coin: coin,
        quote: quote,
        direction: move.direction,
        livePoints: history,
        highestSeenUsd: high,
        isWatched: watched,
        range: range,
        currency: display.currency,
        rate: rates.rateFor(display.currency),
        isPaused: display.paused,
      ),
      // No quote, no price to show: wait for one.
      null => null,
    },
  ).whereType<CoinDetail>();
}
