import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

void main() {
  String dollars(double value) => '\$${value.toStringAsFixed(0)}';

  testWidgets('a line, with its high above and its low below', (tester) async {
    await tester.pumpThemed(
      PriceLineChart(
        points: const [10, 30, 20],
        summary: 'Up 100.00% over the last 3 updates',
        formatValue: dollars,
      ),
    );

    expect(find.text(r'High $30'), findsOneWidget);
    expect(find.text(r'Low $10'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text(r'High $30')).dy,
      lessThan(tester.getTopLeft(find.text(r'Low $10')).dy),
    );
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('one node for a screen reader: the trend, then the range', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpThemed(
      PriceLineChart(
        points: const [10, 30, 20],
        summary: 'Up 100.00% over the last 3 updates',
        formatValue: dollars,
      ),
    );

    expect(
      find.bySemanticsLabel(
        r'Up 100.00% over the last 3 updates. Low $10, high $30.',
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(r'High $30'), findsNothing);
    semantics.dispose();
  });

  testWidgets('fewer than two points: "Collecting prices…", no line', (
    tester,
  ) async {
    for (final points in [
      const <double>[],
      const [42.0],
    ]) {
      await tester.pumpThemed(
        PriceLineChart(points: points, summary: null, formatValue: dollars),
      );

      expect(find.text('Collecting prices…'), findsOneWidget);
      expect(
        find.byType(RepaintBoundary).evaluate().where((e) {
          final widget = e.widget as RepaintBoundary;
          return widget.child is CustomPaint &&
              (widget.child! as CustomPaint).painter is PriceLinePainter;
        }),
        isEmpty,
      );
    }
  });

  test('repaints only for new points or colors', () {
    const a = PriceLinePainter(
      points: [1, 2],
      color: Colors.green,
      dotRingColor: Colors.white,
    );

    expect(
      a.shouldRepaint(
        const PriceLinePainter(
          points: [1, 2],
          color: Colors.green,
          dotRingColor: Colors.white,
        ),
      ),
      isFalse,
    );
    expect(
      a.shouldRepaint(
        const PriceLinePainter(
          points: [1, 3],
          color: Colors.green,
          dotRingColor: Colors.white,
        ),
      ),
      isTrue,
    );
    expect(
      a.shouldRepaint(
        const PriceLinePainter(
          points: [1, 2],
          color: Colors.red,
          dotRingColor: Colors.white,
        ),
      ),
      isTrue,
    );
    expect(
      a.shouldRepaint(
        const PriceLinePainter(
          points: [1, 2],
          color: Colors.green,
          dotRingColor: Colors.black,
        ),
      ),
      isTrue,
    );
  });
}
