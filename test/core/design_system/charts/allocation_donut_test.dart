import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

void main() {
  const slices = [
    DonutSlice(label: 'Bitcoin', basisPoints: 5237, color: Colors.indigo),
    DonutSlice(label: 'Ethereum', basisPoints: 3010, color: Colors.amber),
    DonutSlice(label: 'Other', basisPoints: 1753, color: Colors.grey),
  ];

  testWidgets('one node for a screen reader, every slice in words', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpThemed(
      const Row(
        children: [
          AllocationDonut(slices: slices),
          Expanded(child: AllocationLegend(slices: slices)),
        ],
      ),
    );

    expect(
      find.bySemanticsLabel(
        'Allocation by value: Bitcoin 52.37%, Ethereum 30.10%, Other 17.53%',
      ),
      findsOneWidget,
    );
    // The legend shows the same, and isn't read a second time.
    expect(find.text('52.37%'), findsOneWidget);
    expect(find.bySemanticsLabel('52.37%'), findsNothing);
    semantics.dispose();
  });

  testWidgets('a legend line per slice, never overflowing at large text', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    tester.usePhoneSurface();
    await tester.pumpThemed(const AllocationLegend(slices: slices));

    expect(find.text('Ethereum'), findsOneWidget);
    expect(find.text('17.53%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('repaints only for new slices or a new gap color', () {
    const painter = DonutPainter(slices: slices, gapColor: Colors.white);

    expect(
      painter.shouldRepaint(
        const DonutPainter(slices: [...slices], gapColor: Colors.white),
      ),
      isFalse,
    );
    expect(
      painter.shouldRepaint(
        DonutPainter(slices: slices.sublist(1), gapColor: Colors.white),
      ),
      isTrue,
    );
    expect(
      painter.shouldRepaint(
        const DonutPainter(slices: slices, gapColor: Colors.black),
      ),
      isTrue,
    );
  });
}
