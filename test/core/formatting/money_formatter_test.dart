import 'package:crypto_tracker/core/formatting/money_formatter.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final usd = MoneyFormatter(Currency.usd);

  group('price', () {
    test('at or above one dollar: two decimals and grouping', () {
      expect(usd.price(67240.5), r'$67,240.50');
      expect(usd.price(3512.18), r'$3,512.18');
      expect(usd.price(1.0002), r'$1.00');
      expect(usd.price(1), r'$1.00');
    });

    test('below one: four significant digits, trailing zeros dropped', () {
      expect(usd.price(0.5241), r'$0.5241');
      expect(usd.price(0.0724), r'$0.0724');
      expect(usd.price(0.0268), r'$0.0268');
      // SHIB: a fraction of a cent never reads "$0.00".
      expect(usd.price(0.0000241), r'$0.0000241');
      expect(usd.price(0.00002345), r'$0.00002345');
    });

    test('below one, at least the currency’s decimals stay', () {
      expect(usd.price(0.5), r'$0.50');
      expect(usd.price(0.1), r'$0.10');
    });

    test('zero is plain', () {
      expect(usd.price(0), r'$0.00');
    });

    test('converts at the rate, in the currency’s symbol and decimals', () {
      expect(MoneyFormatter(Currency.eur, rate: 0.92).price(100), '€92.00');
      expect(MoneyFormatter(Currency.gbp, rate: 0.79).price(100), '£79.00');
      // Yen has no decimals…
      expect(
        MoneyFormatter(Currency.jpy, rate: 151.2).price(67240.5),
        '¥10,166,764',
      );
      // …but a price under one yen still shows its digits.
      expect(
        MoneyFormatter(Currency.jpy, rate: 151.2).price(0.0000241),
        '¥0.003644',
      );
    });
  });

  group('compact', () {
    test('market caps and volumes, to three significant digits', () {
      expect(usd.compact(1324500000000), r'$1.32T');
      expect(usd.compact(42180000000), r'$42.2B');
      expect(usd.compact(445000000), r'$445M');
    });

    test('converts too, in the currency’s symbol', () {
      expect(
        MoneyFormatter(Currency.jpy, rate: 151.2).compact(1324500000000),
        '¥200T',
      );
      expect(
        MoneyFormatter(Currency.gbp, rate: 0.79).compact(42180000000),
        '£33.3B',
      );
      expect(MoneyFormatter(Currency.eur, rate: 0.92).compact(1e12), '€920B');
    });
  });

  group('compactNumber', () {
    test('supplies, without a currency', () {
      expect(MoneyFormatter.compactNumber(19710000), '19.71M');
      expect(MoneyFormatter.compactNumber(21000000), '21M');
      expect(MoneyFormatter.compactNumber(589500000000000), '589.5T');
    });
  });
}
