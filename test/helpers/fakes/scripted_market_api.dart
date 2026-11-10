import 'dart:async';

import 'package:crypto_tracker/core/network/dto/coin_dto.dart';
import 'package:crypto_tracker/core/network/dto/exchange_rates_dto.dart';
import 'package:crypto_tracker/core/network/market_api.dart';

/// A [MarketApi] that answers what the test says: the coins, the rates, a
/// failure, or a wait until [gate] completes. It counts its calls.
class ScriptedMarketApi implements MarketApi {
  ScriptedMarketApi({List<CoinDto>? coins, ExchangeRatesDto? rates})
    : coins = coins ?? [coinDto()],
      rates = rates ?? ratesDto();

  List<CoinDto> coins;
  ExchangeRatesDto rates;

  /// Thrown by the next calls, until cleared.
  Exception? failure;

  /// While set and not completed, every call waits for it.
  Completer<void>? gate;

  int coinCalls = 0;
  int rateCalls = 0;

  @override
  Future<List<CoinDto>> getCoins() async {
    coinCalls++;
    await _answer();
    return coins;
  }

  @override
  Future<ExchangeRatesDto> getExchangeRates() async {
    rateCalls++;
    await _answer();
    return rates;
  }

  Future<void> _answer() async {
    await gate?.future;
    if (failure case final failure?) throw failure;
  }
}

/// A valid coin DTO; override the field a test is about.
CoinDto coinDto({
  String id = 'bitcoin',
  String symbol = 'btc',
  String name = 'Bitcoin',
  int rank = 1,
  String price = '67240.50',
  double change = 2.41,
  String marketCap = '1324500000000',
  String volume = '42180000000',
  String circulating = '19710000',
  String? total = '21000000',
  String allTimeHigh = '73750.07',
  List<double> sparkline = const [66182.571, 67240.5],
  bool isStablecoin = false,
}) => CoinDto(
  id: id,
  symbol: symbol,
  name: name,
  marketCapRank: rank,
  currentPrice: price,
  priceChangePercentage24h: change,
  marketCap: marketCap,
  totalVolume: volume,
  circulatingSupply: circulating,
  totalSupply: total,
  allTimeHigh: allTimeHigh,
  sparkline7d: sparkline,
  isStablecoin: isStablecoin,
);

/// The demo's rates, as the service sends them.
ExchangeRatesDto ratesDto({
  String base = 'USD',
  Map<String, double> rates = const {
    'USD': 1,
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 151.2,
  },
}) => ExchangeRatesDto(base: base, rates: rates);
