import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/domain/model/quote.dart';

/// The market's data: the coins, their live prices and the exchange rates.
///
/// Two kinds of answer, on purpose: the seed is a one-shot `Future` (it
/// doesn't change), the quotes and what's derived from them are `Stream`s
/// (they do).
abstract interface class MarketRepository {
  /// Loads the seed (the coins, their first quotes, the rates), once.
  ///
  /// After a success, later calls answer from memory; after a failure, the
  /// next call tries again ("Try again"). Concurrent calls share one load.
  Future<Result<MarketSeed>> loadMarket();

  /// Every coin's quote, live: the current snapshot at once, then one per
  /// tick. Nothing before the market has loaded.
  Stream<Map<String, Quote>> get quotes;

  /// [coinId]'s recent prices, oldest first (up to the last 60 updates
  /// since launch), live: the coin page's Live chart.
  Stream<List<PricePoint>> history(String coinId);

  /// [coinId]'s highest price since launch, live (`null` before the market
  /// has loaded).
  Stream<double?> highestPrice(String coinId);
}
