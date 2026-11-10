import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';

/// The market's data: the coins, their prices and the exchange rates.
///
/// Phase 2 has the one-shot load; Phase 3 adds the live quotes (a stream)
/// and Phase 4 the price history.
abstract interface class MarketRepository {
  /// Loads the seed (the coins, their first quotes, the rates), once.
  ///
  /// After a success, later calls answer from memory; after a failure, the
  /// next call tries again ("Try again"). Concurrent calls share one load.
  Future<Result<MarketSeed>> loadMarket();
}
