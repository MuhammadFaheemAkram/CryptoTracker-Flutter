import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  PositionTile tile({VoidCallback? onTap, VoidCallback? onRemove}) =>
      PositionTile(
        symbol: 'btc',
        name: 'Bitcoin',
        amount: '0.5 BTC',
        value: r'$33,620.25',
        cost: r'$30,000.00',
        profit: r'+$3,620.25',
        profitInWords: r'plus $3,620.25',
        profitPercent: 12.07,
        onTap: onTap,
        onRemove: onRemove,
      );

  testWidgets('shows the holding, what it\'s worth and the P/L', (
    tester,
  ) async {
    await tester.pumpThemed(tile());

    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('0.5 BTC'), findsOneWidget);
    expect(find.text(r'Cost $30,000.00'), findsOneWidget);
    expect(find.text(r'$33,620.25'), findsOneWidget);
    expect(find.text(r'+$3,620.25 (+12.07%)'), findsOneWidget);
  });

  testWidgets('one button for a screen reader, with a Remove action', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    var removes = 0;
    await tester.pumpThemed(
      tile(onTap: () => taps++, onRemove: () => removes++),
    );

    final node = tester.getSemantics(
      find.bySemanticsLabel(RegExp('^Bitcoin, 0.5 BTC')),
    );
    expect(
      node.label,
      r'Bitcoin, 0.5 BTC, worth $33,620.25, cost $30,000.00, '
      r'plus $3,620.25, Up 12.07%',
    );
    final data = node.getSemanticsData();
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    final remove = data.customSemanticsActionIds!.single;
    expect(CustomSemanticsAction.getAction(remove)?.label, 'Remove');

    // As a screen reader does it: the node's custom action, by its label.
    tester.semantics.customAction(
      find.semantics.byLabel(RegExp('^Bitcoin, 0.5 BTC')),
      const CustomSemanticsAction(label: 'Remove'),
    );
    expect(removes, 1);
    expect(taps, 0);
    semantics.dispose();
  });

  testWidgets('no remove callback, no Remove action', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpThemed(tile(onTap: () {}));

    final data = tester
        .getSemantics(find.bySemanticsLabel(RegExp('^Bitcoin, 0.5 BTC')))
        .getSemanticsData();
    expect(data.customSemanticsActionIds ?? const [], isEmpty);
    semantics.dispose();
  });

  testWidgets('large text: stacked, nothing overflows', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    tester.usePhoneSurface();
    await tester.pumpThemed(tile());

    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.text(r'$33,620.25')).dy,
      greaterThan(tester.getTopLeft(find.text('Bitcoin')).dy),
    );
  });
}
