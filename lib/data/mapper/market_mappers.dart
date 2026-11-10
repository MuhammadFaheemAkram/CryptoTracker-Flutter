import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/network/dto/coin_dto.dart';
import 'package:crypto_tracker/core/network/dto/exchange_rates_dto.dart';
import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/exchange_rates.dart';
import 'package:crypto_tracker/domain/model/quote.dart';

/// DTO → domain, checking every value on the way.
///
/// The service's strings become numbers here, and anything that would break
/// the app later (a price of zero, a change of −100 % or worse, a missing
/// rate) is rejected now as a [DataFormatException]: one damaged record
/// means the market's data can't be trusted, so the whole load fails and the
/// screen offers "Try again".
extension CoinDtoMapper on CoinDto {
  Coin toCoin() {
    if (id.trim().isEmpty || symbol.trim().isEmpty || name.trim().isEmpty) {
      throw const DataFormatException();
    }
    if (marketCapRank < 1) throw const DataFormatException();
    return Coin(
      id: id,
      symbol: symbol,
      name: name,
      rank: marketCapRank,
      marketCapUsd: _positive(marketCap),
      volume24hUsd: _nonNegative(totalVolume),
      circulatingSupply: _positive(circulatingSupply),
      totalSupply: switch (totalSupply) {
        null => null,
        final value => _positive(value),
      },
      allTimeHighUsd: _positive(allTimeHigh),
      isStablecoin: isStablecoin,
      sparkline7d: [
        for (final price in sparkline7d)
          if (price.isFinite && price > 0)
            price
          else
            throw const DataFormatException(),
      ],
    );
  }

  /// The coin's first quote, stamped [at].
  Quote toQuote({required DateTime at}) {
    final change = priceChangePercentage24h;
    // −100 % would mean the price 24 h ago was infinite.
    if (!change.isFinite || change <= -100) throw const DataFormatException();
    return Quote.fromChange(
      coinId: id,
      priceUsd: _positive(currentPrice),
      change24hPercent: change,
      updatedAt: at,
    );
  }
}

extension ExchangeRatesDtoMapper on ExchangeRatesDto {
  /// Every [Currency] must have a positive rate, and the base must be the
  /// dollar (USD at exactly 1).
  ExchangeRates toDomain() {
    if (base != Currency.usd.code) throw const DataFormatException();
    final perUsd = <Currency, double>{};
    for (final currency in Currency.values) {
      final rate = rates[currency.code];
      if (rate == null || !rate.isFinite || rate <= 0) {
        throw const DataFormatException();
      }
      perUsd[currency] = rate;
    }
    if (perUsd[Currency.usd] != 1) throw const DataFormatException();
    return ExchangeRates(perUsd);
  }
}

double _positive(String value) {
  final number = _number(value);
  if (number <= 0) throw const DataFormatException();
  return number;
}

double _nonNegative(String value) {
  final number = _number(value);
  if (number < 0) throw const DataFormatException();
  return number;
}

/// `double.tryParse` already ignores spaces around the number (" 1000 "),
/// and rejects anything else that isn't one.
double _number(String value) {
  final number = double.tryParse(value);
  if (number == null || !number.isFinite) throw const DataFormatException();
  return number;
}
