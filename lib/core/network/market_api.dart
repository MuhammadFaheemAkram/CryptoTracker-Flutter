import 'package:crypto_tracker/core/network/dto/coin_dto.dart';
import 'package:crypto_tracker/core/network/dto/exchange_rates_dto.dart';

/// The market service, as a real HTTP client would present it.
///
/// The app has no backend: [FakeMarketApi] answers from bundled JSON. A real
/// implementation (`dio`, say) would replace it without changing a caller.
abstract interface class MarketApi {
  /// Every coin: metadata, the current price and 24 h change, and the last
  /// 7 days.
  Future<List<CoinDto>> getCoins();

  /// Units of each currency per US dollar.
  Future<ExchangeRatesDto> getExchangeRates();
}
