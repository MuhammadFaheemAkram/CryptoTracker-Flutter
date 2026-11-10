import 'package:crypto_tracker/core/formatting/percent_formatter.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const minus = PercentFormatter.minus;

  group('formatChange', () {
    test('a sign and two decimals', () {
      expect(PercentFormatter.formatChange(2.41), '+2.41%');
      expect(PercentFormatter.formatChange(-1.2), '${minus}1.20%');
      expect(PercentFormatter.formatChange(12.345), '+12.35%');
      expect(PercentFormatter.formatChange(0.5), '+0.50%');
    });

    test('the minus is the typographic one, as wide as the plus', () {
      expect(minus, '−');
      expect(PercentFormatter.formatChange(-3), isNot(contains('-')));
    });

    test('a change that rounds to zero has no sign', () {
      expect(PercentFormatter.formatChange(0), '0.00%');
      expect(PercentFormatter.formatChange(0.004), '0.00%');
      expect(PercentFormatter.formatChange(-0.004), '0.00%');
    });

    test('large changes keep their digits', () {
      expect(PercentFormatter.formatChange(1234.5), '+1234.50%');
    });

    test('not a number shows a dash', () {
      expect(PercentFormatter.formatChange(double.nan), '—');
    });

    test('the sign always agrees with PriceDirection.ofChange', () {
      for (var hundredths = -300; hundredths <= 300; hundredths++) {
        // Values just either side of each rounding boundary.
        for (final percent in [
          hundredths / 100 - 0.0049,
          hundredths / 100,
          hundredths / 100 + 0.0049,
        ]) {
          final label = PercentFormatter.formatChange(percent);
          final expected = switch (PriceDirection.ofChange(percent)) {
            PriceDirection.up => '+',
            PriceDirection.down => minus,
            PriceDirection.flat => '0',
          };
          expect(label[0], expected, reason: '$percent → $label');
        }
      }
    });
  });

  group('describeChange', () {
    test('in words, for screen readers', () {
      expect(PercentFormatter.describeChange(2.41), 'Up 2.41%');
      expect(PercentFormatter.describeChange(-1.2), 'Down 1.20%');
      expect(PercentFormatter.describeChange(0.001), 'Unchanged');
      expect(PercentFormatter.describeChange(double.nan), 'Change unknown');
    });
  });
}
