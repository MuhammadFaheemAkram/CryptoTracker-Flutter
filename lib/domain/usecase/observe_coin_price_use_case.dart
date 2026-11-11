import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:injectable/injectable.dart';

/// One coin's price, live (`null` before the market has it): the holding
/// form's "worth now". Another coin's tick emits nothing (`distinct`).
@injectable
class ObserveCoinPriceUseCase {
  const ObserveCoinPriceUseCase(this._market);

  final MarketRepository _market;

  Stream<double?> call(String coinId) =>
      _market.quotes.map((quotes) => quotes[coinId]?.priceUsd).distinct();
}
