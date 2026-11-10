import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/exchange_rates.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_seed.freezed.dart';

/// Everything the market starts from, loaded once at launch: the coins,
/// their first quotes, and the exchange rates.
///
/// From Phase 3 the quotes move on the ticker; the coins and the rates stay.
@freezed
abstract class MarketSeed with _$MarketSeed {
  const factory MarketSeed({
    /// In rank order.
    required List<Coin> coins,

    /// The first quote of every coin, by coin id.
    required Map<String, Quote> quotes,
    required ExchangeRates rates,
  }) = _MarketSeed;
}
