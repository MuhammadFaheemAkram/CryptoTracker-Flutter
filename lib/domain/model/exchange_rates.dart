import 'package:crypto_tracker/domain/model/currency.dart';

/// How many units of each currency one US dollar buys.
///
/// The rates are fixed for the demo (from `exchange_rates.json`): the point
/// is that changing the currency **converts** every value (€0.92 for $1.00),
/// instead of only swapping the symbol (Correctness Rule 2).
final class ExchangeRates {
  /// [perUsd] must have a rate for every [Currency], and USD must be 1: the
  /// mapper checks both before building one.
  ExchangeRates(Map<Currency, double> perUsd)
    : _perUsd = Map.unmodifiable(perUsd) {
    assert(Currency.values.every(_perUsd.containsKey), 'a currency is missing');
    assert(_perUsd[Currency.usd] == 1, 'rates are per US dollar');
  }

  final Map<Currency, double> _perUsd;

  /// Units of [currency] per dollar.
  double rateFor(Currency currency) => _perUsd[currency]!;

  /// [usd] dollars, in [currency].
  double fromUsd(double usd, Currency currency) => usd * rateFor(currency);

  /// [amount] of [currency], in dollars.
  double toUsd(double amount, Currency currency) => amount / rateFor(currency);

  @override
  bool operator ==(Object other) =>
      other is ExchangeRates &&
      Currency.values.every((c) => other._perUsd[c] == _perUsd[c]);

  @override
  int get hashCode =>
      Object.hashAll([for (final c in Currency.values) _perUsd[c]]);
}
