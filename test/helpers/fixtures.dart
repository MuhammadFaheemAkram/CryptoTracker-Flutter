import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/exchange_rates.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/quote.dart';

/// The moment every test quote is stamped with.
final testNow = DateTime.utc(2026, 11, 10, 9, 41);

/// A coin with sensible defaults; override what the test is about.
Coin coin(
  String id, {
  int rank = 1,
  String? symbol,
  String? name,
  bool isStablecoin = false,
  List<double> sparkline7d = const [],
}) => Coin(
  id: id,
  symbol: symbol ?? (id.length > 3 ? id.substring(0, 3) : id),
  name: name ?? '${id[0].toUpperCase()}${id.substring(1)}',
  rank: rank,
  marketCapUsd: 1e9,
  volume24hUsd: 1e8,
  circulatingSupply: 1e7,
  totalSupply: 2e7,
  allTimeHighUsd: 100,
  isStablecoin: isStablecoin,
  sparkline7d: sparkline7d,
);

/// A quote at [price] with a 24 h [change] (percent).
Quote quote(String coinId, double price, {double change = 0}) =>
    Quote.fromChange(
      coinId: coinId,
      priceUsd: price,
      change24hPercent: change,
      updatedAt: testNow,
    );

/// The demo's fixed rates.
final testRates = ExchangeRates({
  Currency.usd: 1,
  Currency.eur: 0.92,
  Currency.gbp: 0.79,
  Currency.jpy: 151.2,
});

/// A small market: Bitcoin, Ethereum, Tether, Solana.
MarketSeed smallMarket() {
  final coins = [
    coin('bitcoin', symbol: 'btc'),
    coin('ethereum', rank: 2, symbol: 'eth'),
    coin('tether', rank: 3, symbol: 'usdt', isStablecoin: true),
    coin('solana', rank: 5, symbol: 'sol'),
  ];
  return MarketSeed(
    coins: coins,
    quotes: {
      'bitcoin': quote('bitcoin', 67240.5, change: 2.41),
      'ethereum': quote('ethereum', 3512.18, change: -1.24),
      'tether': quote('tether', 1.0002, change: 0.01),
      'solana': quote('solana', 148.92, change: 6.08),
    },
    rates: testRates,
  );
}
