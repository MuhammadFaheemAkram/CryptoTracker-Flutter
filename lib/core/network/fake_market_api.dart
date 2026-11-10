import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/network/asset_json_loader.dart';
import 'package:crypto_tracker/core/network/dto/coin_dto.dart';
import 'package:crypto_tracker/core/network/dto/exchange_rates_dto.dart';
import 'package:crypto_tracker/core/network/market_api.dart';
import 'package:injectable/injectable.dart';

/// The market service, faked: bundled JSON after a realistic delay.
///
/// It's the only place that knows the data is local. Above it, the
/// repository sees a service that can be slow and can fail.
@LazySingleton(as: MarketApi)
class FakeMarketApi implements MarketApi {
  const FakeMarketApi(this._json);

  final AssetJsonLoader _json;

  /// Flip to `true` to see the Market's error state (conventions §5).
  static const bool shouldThrowError = false;

  /// How long a request takes. The market loads both files at once, so the
  /// first screen waits about this long.
  static const latency = Duration(milliseconds: 600);

  static const coinsPath = 'assets/json/coins_seed.json';
  static const ratesPath = 'assets/json/exchange_rates.json';

  @override
  Future<List<CoinDto>> getCoins() async {
    await _request();
    final json = await _json.loadObject(coinsPath);
    final coins = json['coins'];
    if (coins is! List<Object?>) {
      throw const FormatException('Expected a "coins" array');
    }
    return [
      for (final coin in coins)
        if (coin is Map<String, Object?>)
          CoinDto.fromJson(coin)
        else
          throw const FormatException('Expected a coin object'),
    ];
  }

  @override
  Future<ExchangeRatesDto> getExchangeRates() async {
    await _request();
    return ExchangeRatesDto.fromJson(await _json.loadObject(ratesPath));
  }

  Future<void> _request() async {
    await Future<void>.delayed(latency);
    if (shouldThrowError) throw const NetworkException();
  }
}
