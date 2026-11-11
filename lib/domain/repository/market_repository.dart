import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/quote.dart';

/// The market's data: the coins, their live prices and the exchange rates.
///
/// Two kinds of answer, on purpose: the seed is a one-shot `Future` (it
/// doesn't change), the quotes are a `Stream` (they do). Phase 4 adds the
/// price history.
abstract interface class MarketRepository {
  /// Loads the seed (the coins, their first quotes, the rates), once.
  ///
  /// After a success, later calls answer from memory; after a failure, the
  /// next call tries again ("Try again"). Concurrent calls share one load.
  Future<Result<MarketSeed>> loadMarket();

  /// Every coin's quote, live: the current snapshot at once, then one per
  /// tick. Nothing before the market has loaded.
  Stream<Map<String, Quote>> get quotes;
}
