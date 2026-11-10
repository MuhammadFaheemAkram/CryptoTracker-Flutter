import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:injectable/injectable.dart';

/// Loads what the market starts from (a one-shot `Future`: streams are for
/// values that change over time, and the seed doesn't).
@injectable
class LoadMarketUseCase {
  const LoadMarketUseCase(this._market);

  final MarketRepository _market;

  Future<Result<MarketSeed>> call() => _market.loadMarket();
}
