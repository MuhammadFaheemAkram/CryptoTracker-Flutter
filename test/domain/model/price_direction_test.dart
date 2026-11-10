import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PriceDirection.ofChange', () {
    test('a rise is up, a fall is down', () {
      expect(PriceDirection.ofChange(2.41), PriceDirection.up);
      expect(PriceDirection.ofChange(-1.2), PriceDirection.down);
    });

    test('zero, and anything that rounds to 0.00 %, is flat', () {
      expect(PriceDirection.ofChange(0), PriceDirection.flat);
      expect(PriceDirection.ofChange(0.004), PriceDirection.flat);
      expect(PriceDirection.ofChange(-0.0049), PriceDirection.flat);
    });

    test('the smallest change that shows as 0.01 % is not flat', () {
      expect(PriceDirection.ofChange(0.006), PriceDirection.up);
      expect(PriceDirection.ofChange(-0.006), PriceDirection.down);
    });

    test('not a number is flat', () {
      expect(PriceDirection.ofChange(double.nan), PriceDirection.flat);
      expect(PriceDirection.ofChange(double.infinity), PriceDirection.flat);
    });
  });
}
