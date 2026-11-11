import 'dart:math' as math;

import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:intl/intl.dart';

/// Formats US-dollar values in a chosen [currency] (Correctness Rule 12).
///
/// Every value in the app is stored in dollars; this is the edge where one
/// becomes text, so it's also where the rate applies: a formatter for EUR
/// shows $1.00 as €0.92. Phase 2 always uses USD at a rate of 1; Phase 3
/// passes the user's currency and its rate.
///
/// The locale is fixed to `en_US` (the app is in English), so grouping and
/// the decimal point are the same on every device and in every test.
final class MoneyFormatter {
  MoneyFormatter(this.currency, {this.rate = 1})
    : assert(rate > 0, 'a rate is units per dollar');

  final Currency currency;

  /// Units of [currency] per US dollar.
  final double rate;

  static const _locale = 'en_US';

  /// Significant digits kept for a price under one unit.
  static const smallPriceDigits = 4;

  /// A price, e.g. "$67,240.50", "¥10,166,764", "$0.0000241".
  ///
  /// - At or above one unit: the currency's decimals (two; none for yen).
  /// - Below one unit: [smallPriceDigits] significant digits, so a coin
  ///   worth a fraction of a cent doesn't read "$0.00". Trailing zeros are
  ///   dropped ("$0.0724", not "$0.07240"), down to the currency's decimals.
  String price(double usd) {
    final value = usd * rate;
    final magnitude = value.abs();
    final fraction = magnitude >= 1 || magnitude == 0
        ? currency.decimals
        : smallPriceDigits - 1 - (math.log(magnitude) / math.ln10).floor();
    return (NumberFormat.currency(
            locale: _locale,
            symbol: currency.symbol,
            decimalDigits: fraction,
          )
          ..minimumFractionDigits = math.min(currency.decimals, fraction)
          ..maximumFractionDigits = fraction)
        .format(value);
  }

  /// A gain or a loss, with its sign: "+$1,234.56", "−€12.00" (the
  /// typographic minus, as wide as the plus). An amount that shows as zero
  /// has no sign, so the sign never disagrees with the digits.
  String signedPrice(double usd) {
    final digits = price(usd.abs());
    if (digits == price(0)) return digits;
    return '${usd > 0 ? '+' : '−'}$digits';
  }

  /// The same gain or loss in words, for a screen reader: "plus $1,234.56",
  /// "minus €12.00".
  String describeSignedPrice(double usd) {
    final signed = signedPrice(usd);
    return signed
        .replaceFirst(RegExp(r'^\+'), 'plus ')
        .replaceFirst(RegExp('^−'), 'minus ');
  }

  /// An amount of a coin, as precise as it was typed (up to 8 decimals)
  /// and grouped: "0.5", "1,250,000", "0.00012345".
  static String coinAmount(double amount) =>
      NumberFormat('#,##0.########', _locale).format(amount);

  /// A large amount, compact, to three significant digits (intl's
  /// convention): "$1.32T", "$42.2B", "€920B".
  String compact(double usd) => NumberFormat.compactSimpleCurrency(
    locale: _locale,
    name: currency.code,
  ).format(usd * rate);

  /// A large count (a coin's supply), compact and without a currency:
  /// "19.71M", "589.5T".
  static String compactNumber(double value) => (NumberFormat.compact(
    locale: _locale,
  )..maximumFractionDigits = 2).format(value);
}
