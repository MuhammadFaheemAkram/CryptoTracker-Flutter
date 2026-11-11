import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('signed money and a signed percentage; one sentence for a '
      'screen reader', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpThemed(
      const ValueChange(
        label: 'P/L',
        semanticLabel: 'Profit and loss',
        money: '−\$12.00',
        moneyInWords: r'minus $12.00',
        percent: -1.5,
      ),
    );

    expect(find.text('P/L'), findsOneWidget);
    expect(find.text('−\$12.00'), findsOneWidget);
    expect(find.text('−1.50%'), findsOneWidget);
    expect(
      find.bySemanticsLabel(r'Profit and loss, minus $12.00, Down 1.50%'),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('the money takes the change\'s color', (tester) async {
    await tester.pumpThemed(
      const ValueChange(
        label: '24 h',
        money: r'+$5.00',
        moneyInWords: r'plus $5.00',
        percent: 2,
      ),
    );

    final context = tester.element(find.text(r'+$5.00'));
    expect(
      tester.widget<Text>(find.text(r'+$5.00')).style?.color,
      context.appColors.up,
    );
  });
}
