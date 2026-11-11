import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/validation/decimal_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Correctness Rule 11: what an amount or a price may be', () {
    void accepts(String typed, double value) => expect(
      parseDecimalInput(typed),
      (value: value, error: null),
      reason: typed,
    );
    void refuses(String typed, DecimalInputError error) =>
        expect(parseDecimalInput(typed).error, error, reason: typed);

    test('plain decimals, positive', () {
      accepts('1', 1);
      accepts('0.5', 0.5);
      accepts('.5', 0.5);
      accepts('2.', 2);
      accepts(' 67240.5 ', 67240.5);
      accepts('0007', 7);
    });

    test('a comma counts as the decimal point (some keyboards offer only '
        'that)', () {
      accepts('0,25', 0.25);
    });

    test('nothing typed', () {
      refuses('', DecimalInputError.empty);
      refuses('   ', DecimalInputError.empty);
    });

    test('not a plain number', () {
      for (final typed in ['abc', '1.2.3', '-1', '+1', '1e5', '.', '1 000']) {
        refuses(typed, DecimalInputError.notANumber);
      }
    });

    test('zero is not an amount', () {
      refuses('0', DecimalInputError.notPositive);
      refuses('0.00000000', DecimalInputError.notPositive);
    });

    test('at most 8 decimals (a satoshi)', () {
      accepts('0.00000001', 0.00000001);
      refuses('0.000000001', DecimalInputError.tooManyDecimals);
    });

    test('at most 12 digits before the point (and so always finite)', () {
      accepts('999999999999', 999999999999);
      // Leading zeros don't count: thirteen characters, but the value 1.
      accepts('0000000000001', 1);
      refuses('1000000000000', DecimalInputError.tooLarge);
      refuses('9' * 400, DecimalInputError.tooLarge);
    });
  });

  test('a value written back for a field: no trailing zeros, 8 decimals at '
      'most', () {
    expect(formatDecimalInput(0.5), '0.5');
    expect(formatDecimalInput(67240.5), '67240.5');
    expect(formatDecimalInput(2), '2');
    expect(formatDecimalInput(0.00002345), '0.00002345');
    expect(formatDecimalInput(61861.26000000001), '61861.26');
    expect(formatDecimalInput(1 / 3), '0.33333333');
  });

  test('what it writes, it reads back', () {
    for (final value in [0.5, 67240.5, 0.00002345, 123456.789, 1e-8]) {
      expect(parseDecimalInput(formatDecimalInput(value)).value, value);
    }
  });

  group('digits from an Arabic or Persian keyboard (found on the simulator, '
      'whose keyboard types them)', () {
    test('become ASCII, one character for one', () {
      expect(normalizeDigits('٠١٢٣٤٥٦٧٨٩'), '0123456789');
      expect(normalizeDigits('۰۱۲۳۴۵۶۷۸۹'), '0123456789');
      expect(normalizeDigits('٠٫٥'), '0.5');
      expect(normalizeDigits('abc 1.5'), 'abc 1.5');
    });

    test('parse like any other', () {
      expect(parseDecimalInput('٠٫٥').value, 0.5);
      expect(parseDecimalInput('۱۲.۵').value, 12.5);
    });
  });

  group('a suggested buy price is as precise as a shown price', () {
    test('from one unit up: the currency\'s decimals', () {
      expect(suggestedPriceInput(69762.39175474, Currency.usd, 1), '69762.39');
      expect(suggestedPriceInput(67240.5, Currency.usd, 1), '67240.5');
      expect(suggestedPriceInput(67240.5, Currency.eur, 0.92), '61861.26');
      expect(suggestedPriceInput(67240.5, Currency.jpy, 151.2), '10166764');
    });

    test('below one unit: four significant digits', () {
      expect(
        suggestedPriceInput(0.000023456789, Currency.usd, 1),
        '0.00002346',
      );
      expect(suggestedPriceInput(0.52174, Currency.usd, 1), '0.5217');
    });

    test('never more decimals than may be typed', () {
      expect(
        parseDecimalInput(suggestedPriceInput(1e-12, Currency.usd, 1)).error,
        isNot(DecimalInputError.tooManyDecimals),
      );
    });
  });
}
