import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/exchange_rates.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('converts dollars into each currency', () {
    expect(testRates.fromUsd(100, Currency.usd), 100);
    expect(testRates.fromUsd(100, Currency.eur), closeTo(92, 1e-9));
    expect(testRates.fromUsd(100, Currency.jpy), closeTo(15120, 1e-9));
  });

  test('and back: a price typed in euros is stored in dollars', () {
    expect(testRates.toUsd(92, Currency.eur), closeTo(100, 1e-9));
    for (final currency in Currency.values) {
      expect(
        testRates.toUsd(testRates.fromUsd(123.45, currency), currency),
        closeTo(123.45, 1e-9),
      );
    }
  });

  test('value equality', () {
    expect(
      ExchangeRates({
        Currency.usd: 1,
        Currency.eur: 0.92,
        Currency.gbp: 0.79,
        Currency.jpy: 151.2,
      }),
      testRates,
    );
  });

  test('every currency has its code, symbol and decimals', () {
    expect(Currency.values.map((c) => c.code), ['USD', 'EUR', 'GBP', 'JPY']);
    expect(Currency.jpy.decimals, 0);
    expect(Currency.eur.symbol, '€');
  });
}
