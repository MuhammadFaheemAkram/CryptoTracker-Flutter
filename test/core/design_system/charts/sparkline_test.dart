import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

void main() {
  const size = Size(60, 30);

  group('offsetsFor', () {
    test('spreads the points evenly across, lowest at the bottom, highest '
        'at the top', () {
      final offsets = SparklinePainter.offsetsFor([10, 30, 20], size);

      expect(offsets, const [Offset(0, 30), Offset(30, 0), Offset(60, 15)]);
    });

    test('a move smaller than 2 % of the price stays small, centred (a '
        'stablecoin doesn\'t zigzag)', () {
      // 0.998 → 1.002: a 0.4 % band, drawn as a fifth of the height.
      final offsets = SparklinePainter.offsetsFor([0.998, 1.002], size);

      expect(offsets.first.dy, closeTo(18, 1e-9));
      expect(offsets.last.dy, closeTo(12, 1e-9));
    });

    test('a move larger than 2 % fills the height', () {
      final offsets = SparklinePainter.offsetsFor([100, 110], size);

      expect(offsets.map((o) => o.dy), [30, 0]);
    });

    test('a flat line sits in the middle', () {
      final offsets = SparklinePainter.offsetsFor([5, 5, 5], size);

      for (final offset in offsets) {
        expect(offset.dy, closeTo(15, 1e-9));
      }
    });

    test('fewer than two points have no line', () {
      expect(SparklinePainter.offsetsFor([], size), isEmpty);
      expect(SparklinePainter.offsetsFor([1], size), isEmpty);
    });
  });

  group('shouldRepaint', () {
    const color = Color(0xFF00FF00);
    const painter = SparklinePainter(points: [1, 2, 3], color: color);

    test('not for the same points and color (a row rebuilding)', () {
      expect(
        painter.shouldRepaint(
          const SparklinePainter(points: [1, 2, 3], color: color),
        ),
        isFalse,
      );
    });

    test('for new points or a new color', () {
      expect(
        painter.shouldRepaint(
          const SparklinePainter(points: [1, 2, 4], color: color),
        ),
        isTrue,
      );
      expect(
        painter.shouldRepaint(
          const SparklinePainter(points: [1, 2, 3], color: Color(0xFFFF0000)),
        ),
        isTrue,
      );
    });
  });

  Color colorOf(WidgetTester tester) =>
      (tester
                  .widget<CustomPaint>(
                    find.descendant(
                      of: find.byType(Sparkline),
                      matching: find.byType(CustomPaint),
                    ),
                  )
                  .painter!
              as SparklinePainter)
          .color;

  testWidgets('is colored by its own trend: up, down or flat', (tester) async {
    await tester.pumpThemed(const Sparkline(points: [1, 2]));
    expect(colorOf(tester), AppColors.light.up);

    await tester.pumpThemed(const Sparkline(points: [2, 1]));
    expect(colorOf(tester), AppColors.light.down);

    await tester.pumpThemed(const Sparkline(points: [2, 3, 2]));
    expect(colorOf(tester), AppColors.light.flat);
  });
}
