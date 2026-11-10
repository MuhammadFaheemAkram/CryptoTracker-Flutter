import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/data/mapper/market_mappers.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/scripted_market_api.dart';
import '../../helpers/fixtures.dart';

void main() {
  final damaged = throwsA(isA<DataFormatException>());

  group('a coin', () {
    test('its strings become numbers', () {
      final coin = coinDto().toCoin();

      expect(coin.id, 'bitcoin');
      expect(coin.rank, 1);
      expect(coin.marketCapUsd, 1324500000000);
      expect(coin.volume24hUsd, 42180000000);
      expect(coin.circulatingSupply, 19710000);
      expect(coin.totalSupply, 21000000);
      expect(coin.allTimeHighUsd, 73750.07);
      expect(coin.sparkline7d, [66182.571, 67240.5]);
      expect(coin.isStablecoin, isFalse);
    });

    test('no total supply means none (unlimited)', () {
      expect(coinDto(total: null).toCoin().totalSupply, isNull);
    });

    test('a price that isn’t a positive number is damaged data', () {
      for (final price in ['', 'abc', '0', '-5', 'NaN', 'Infinity']) {
        expect(
          () => coinDto(price: price).toQuote(at: testNow),
          damaged,
          reason: price,
        );
      }
    });

    test('so are the other numbers', () {
      expect(() => coinDto(marketCap: '0').toCoin(), damaged);
      expect(() => coinDto(volume: '-1').toCoin(), damaged);
      expect(() => coinDto(circulating: 'x').toCoin(), damaged);
      expect(() => coinDto(total: '0').toCoin(), damaged);
      expect(() => coinDto(allTimeHigh: '').toCoin(), damaged);
      expect(() => coinDto(sparkline: [1, 0]).toCoin(), damaged);
      expect(() => coinDto(sparkline: [double.nan]).toCoin(), damaged);
    });

    test('a zero volume is fine (nothing traded)', () {
      expect(coinDto(volume: '0').toCoin().volume24hUsd, 0);
    });

    test('a blank id, symbol or name, or a rank below 1, is damaged', () {
      expect(() => coinDto(id: ' ').toCoin(), damaged);
      expect(() => coinDto(symbol: '').toCoin(), damaged);
      expect(() => coinDto(name: '').toCoin(), damaged);
      expect(() => coinDto(rank: 0).toCoin(), damaged);
    });

    test('spaces around a number are ignored (double.tryParse does it)', () {
      expect(coinDto(marketCap: ' 1000 ').toCoin().marketCapUsd, 1000);
    });
  });

  group('a quote', () {
    test('keeps the price 24 h ago, so the change is derived', () {
      final quote = coinDto(price: '110', change: 10).toQuote(at: testNow);

      expect(quote.coinId, 'bitcoin');
      expect(quote.priceUsd, 110);
      expect(quote.open24hUsd, closeTo(100, 1e-9));
      expect(quote.change24hPercent, closeTo(10, 1e-9));
      expect(quote.updatedAt, testNow);
    });

    test('a change of −100 % or worse, or not a number, is damaged', () {
      expect(() => coinDto(change: -100).toQuote(at: testNow), damaged);
      expect(() => coinDto(change: -120).toQuote(at: testNow), damaged);
      expect(() => coinDto(change: double.nan).toQuote(at: testNow), damaged);
    });
  });

  group('the rates', () {
    test('become a rate per currency', () {
      final rates = ratesDto().toDomain();

      expect(rates, testRates);
      expect(rates.rateFor(Currency.jpy), 151.2);
    });

    test('a missing, zero or negative rate is damaged', () {
      expect(
        () => ratesDto(rates: {'USD': 1, 'EUR': 0.92}).toDomain(),
        damaged,
      );
      expect(
        () =>
            ratesDto(rates: {'USD': 1, 'EUR': 0, 'GBP': 0.79, 'JPY': 151.2})
                .toDomain(),
        damaged,
      );
    });

    test('they must be per US dollar', () {
      expect(() => ratesDto(base: 'EUR').toDomain(), damaged);
      expect(
        () =>
            ratesDto(rates: {'USD': 2, 'EUR': 0.92, 'GBP': 0.79, 'JPY': 151.2})
                .toDomain(),
        damaged,
      );
    });
  });
}
