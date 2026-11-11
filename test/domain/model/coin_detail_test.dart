import 'package:crypto_tracker/domain/model/chart_range.dart';
import 'package:crypto_tracker/domain/model/coin_detail.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  // The fixture coin: 1e7 circulating, an all-time high of 100.
  CoinDetail detail({double price = 50, double? highestSeen}) => CoinDetail(
    coin: coin('a', sparkline7d: const [1, 2, 3]),
    quote: quote('a', price),
    highestSeenUsd: highestSeen,
    livePoints: [
      PricePoint(at: testNow, priceUsd: 48),
      PricePoint(at: testNow, priceUsd: 50),
    ],
    currency: Currency.usd,
    rate: 1,
  );

  group('Correctness Rule 9: live stats agree with the price', () {
    test('market cap = circulating supply × the current price', () {
      expect(detail().marketCapUsd, 5e8); // at $50
      expect(detail(price: 60).marketCapUsd, 6e8);
    });

    test('the all-time high is the seed\'s until a price beats it', () {
      expect(detail(highestSeen: 80).allTimeHighUsd, 100);
      expect(detail(price: 90, highestSeen: 120).allTimeHighUsd, 120);
    });

    test('the price itself counts, before the history records it', () {
      expect(detail(price: 130, highestSeen: 120).allTimeHighUsd, 130);
      expect(detail(price: 130).allTimeHighUsd, 130);
    });
  });

  test('the chart shows the live points or the 7 days', () {
    expect(detail().chartPoints, [48, 50]);
    expect(detail().copyWith(range: ChartRange.sevenDays).chartPoints, [
      1,
      2,
      3,
    ]);
  });
}
