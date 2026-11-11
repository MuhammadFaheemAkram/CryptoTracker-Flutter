import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/formatting/percent_formatter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Color colorOf(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text)).style!.color!;

  testWidgets('up: an up arrow, a plus, the up color', (tester) async {
    await tester.pumpThemed(const PriceChangeBadge(percent: 2.41));

    expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
    expect(find.text('+2.41%'), findsOneWidget);
    expect(colorOf(tester, '+2.41%'), AppColors.light.up);
  });

  testWidgets('down: a down arrow, a minus, the down color', (tester) async {
    await tester.pumpThemed(const PriceChangeBadge(percent: -1.2));

    const label = '${PercentFormatter.minus}1.20%';
    expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    expect(find.text(label), findsOneWidget);
    expect(colorOf(tester, label), AppColors.light.down);
  });

  testWidgets('flat: no arrow, no sign, the flat color', (tester) async {
    await tester.pumpThemed(const PriceChangeBadge(percent: 0.001));

    expect(find.byType(Icon), findsNothing);
    expect(colorOf(tester, '0.00%'), AppColors.light.flat);
  });

  testWidgets('the dark theme uses the dark tokens', (tester) async {
    await tester.pumpThemed(
      const PriceChangeBadge(percent: 5),
      theme: AppTheme.dark(),
    );

    expect(colorOf(tester, '+5.00%'), AppColors.dark.up);
  });

  testWidgets('a screen reader hears it in words', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpThemed(const PriceChangeBadge(percent: -1.2));

    expect(find.bySemanticsLabel('Down 1.20%'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('digits are tabular, so a ticking number stays put', (
    tester,
  ) async {
    await tester.pumpThemed(const PriceChangeBadge(percent: 2.41));

    expect(
      tester.widget<Text>(find.text('+2.41%')).style!.fontFeatures,
      contains(const FontFeature.tabularFigures()),
    );
  });

  testWidgets('too narrow a space: it shrinks, never overflows or loses '
      'digits', (tester) async {
    await tester.pumpThemed(
      const Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: 40, child: PriceChangeBadge(percent: 2.41)),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('+2.41%'), findsOneWidget);
    expect(tester.getSize(find.byType(PriceChangeBadge)).width, 40);
  });
}
