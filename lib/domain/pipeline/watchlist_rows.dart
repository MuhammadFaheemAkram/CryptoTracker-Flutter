import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/market_coin.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/quote.dart';

/// The watchlist's rows: the coins in [watchedIds]' order (the order they
/// were starred), each with its quote and which way it moved.
///
/// Pure, like `buildMarketRows`. An id the market doesn't know (a coin
/// starred in an older version of the seed), or a coin without a quote, is
/// left out: there is nothing to show for it.
List<MarketCoin> buildWatchlistRows({
  required List<Coin> coins,
  required Map<String, Quote> quotes,
  required List<String> watchedIds,
  Map<String, PriceDirection> directions = const {},
}) {
  final byId = {for (final coin in coins) coin.id: coin};
  return [
    for (final id in watchedIds)
      if ((byId[id], quotes[id]) case (final coin?, final quote?))
        MarketCoin(
          coin: coin,
          quote: quote,
          direction: directions[id] ?? PriceDirection.flat,
          isWatched: true,
        ),
  ];
}
