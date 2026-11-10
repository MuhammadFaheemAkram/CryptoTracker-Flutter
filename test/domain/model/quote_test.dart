import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('the price 24 h ago is the one that grew by the change', () {
    final up = Quote.fromChange(
      coinId: 'bitcoin',
      priceUsd: 110,
      change24hPercent: 10,
      updatedAt: testNow,
    );
    expect(up.open24hUsd, closeTo(100, 1e-9));

    final down = Quote.fromChange(
      coinId: 'bitcoin',
      priceUsd: 75,
      change24hPercent: -25,
      updatedAt: testNow,
    );
    expect(down.open24hUsd, closeTo(100, 1e-9));
  });

  test('the change is derived from the open, so it round-trips', () {
    for (final change in [-50.0, -1.24, 0.0, 0.01, 2.41, 300.0]) {
      expect(
        quote('bitcoin', 67240.5, change: change).change24hPercent,
        closeTo(change, 1e-9),
      );
    }
  });

  test('a new price at the same open changes the change (no accumulating)', () {
    final first = quote('bitcoin', 100);
    final moved = first.copyWith(priceUsd: 105);

    expect(moved.change24hPercent, closeTo(5, 1e-9));
    expect(moved.copyWith(priceUsd: 100).change24hPercent, closeTo(0, 1e-9));
  });

  test('value equality (freezed)', () {
    expect(quote('a', 1, change: 2), quote('a', 1, change: 2));
    expect(quote('a', 1, change: 2), isNot(quote('a', 1, change: 3)));
  });
}
