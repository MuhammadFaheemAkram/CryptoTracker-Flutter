import 'dart:math' as math;

import 'package:crypto_tracker/domain/model/currency.dart';

/// Why a typed number can't be saved.
enum DecimalInputError {
  /// Nothing typed.
  empty,

  /// Not a plain decimal number ("1.2.3", "abc", "-1", "1e5").
  notANumber,

  /// Zero: an amount or a price must be more than that.
  notPositive,

  /// More than [maxDecimals] digits after the point.
  tooManyDecimals,

  /// More than [maxWholeDigits] digits before the point.
  tooLarge,
}

/// At most 8 decimals: a satoshi is 0.00000001 BTC (Correctness Rule 11).
const maxDecimals = 8;

/// A trillion is plenty for a demo, and keeps every value far from where a
/// `double` stops being exact to the cent.
const maxWholeDigits = 12;

/// [text] with the digits of other scripts as ASCII ones: Arabic-Indic
/// (٠–٩) and Eastern Arabic-Indic (۰–۹), as an Arabic or Persian keyboard
/// types them, and the Arabic decimal separator (٫) as a point. Each
/// character maps to one character, so a cursor position stays valid.
String normalizeDigits(String text) => String.fromCharCodes([
  for (final unit in text.codeUnits)
    switch (unit) {
      >= 0x0660 && <= 0x0669 => 0x30 + unit - 0x0660, // ٠–٩
      >= 0x06F0 && <= 0x06F9 => 0x30 + unit - 0x06F0, // ۰–۹
      0x066B => 0x2E, // ٫
      _ => unit,
    },
]);

/// Parses what the user typed in an amount or a price field: plain digits
/// (in any script [normalizeDigits] knows), with at most one decimal point
/// (a comma counts as one, for keyboards that offer it), positive, finite,
/// at most [maxDecimals] decimals (Correctness Rule 11).
///
/// Returns the value, or why it isn't one. Pure, so every rule is tested
/// without a form.
({double? value, DecimalInputError? error}) parseDecimalInput(String text) {
  final typed = normalizeDigits(text).trim().replaceAll(',', '.');
  if (typed.isEmpty) return (value: null, error: DecimalInputError.empty);
  final match = RegExp(r'^(\d*)(?:\.(\d*))?$').firstMatch(typed);
  if (match == null || typed == '.') {
    return (value: null, error: DecimalInputError.notANumber);
  }
  final whole = match.group(1)!;
  final fraction = match.group(2) ?? '';
  if (fraction.length > maxDecimals) {
    return (value: null, error: DecimalInputError.tooManyDecimals);
  }
  if (whole.replaceFirst(RegExp('^0+'), '').length > maxWholeDigits) {
    return (value: null, error: DecimalInputError.tooLarge);
  }
  final value = double.parse(typed.startsWith('.') ? '0$typed' : typed);
  if (value <= 0) return (value: null, error: DecimalInputError.notPositive);
  return (value: value, error: null);
}

/// [value] written for a field: up to [maxDecimals] decimals, without the
/// trailing zeros ("0.5", "67240.5", "0.00002345"). What the form shows for
/// a holding being edited, or the current price it suggests.
String formatDecimalInput(double value) {
  final fixed = value.toStringAsFixed(maxDecimals);
  final trimmed = fixed.replaceFirst(RegExp(r'0+$'), '');
  return trimmed.endsWith('.')
      ? trimmed.substring(0, trimmed.length - 1)
      : trimmed;
}

/// A buy price to suggest for [priceUsd] in [currency] (rate units per
/// dollar): as precise as prices are shown, not as the market computes
/// them ("69762.39", not "69762.39175474"). The currency's decimals from
/// one unit up (none for yen), four significant digits below.
String suggestedPriceInput(double priceUsd, Currency currency, double rate) {
  final value = priceUsd * rate;
  final decimals = value >= 1
      ? currency.decimals
      : math.min(maxDecimals, 3 - (math.log(value) / math.ln10).floor());
  return formatDecimalInput(double.parse(value.toStringAsFixed(decimals)));
}
