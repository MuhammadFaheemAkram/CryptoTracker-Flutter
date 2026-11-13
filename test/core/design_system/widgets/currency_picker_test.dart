import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('every currency, by name, code and symbol; the selected one '
      'checked, for a screen reader too', (tester) async {
    final semantics = tester.ensureSemantics();
    final picked = <Currency>[];
    await tester.pumpThemed(
      CurrencyPicker(selected: Currency.eur, onChanged: picked.add),
    );

    expect(find.text('US dollar'), findsOneWidget);
    expect(find.text(r'USD ($)'), findsOneWidget);
    expect(find.text('Japanese yen'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('Euro')),
      isSemantics(isChecked: true),
    );
    expect(
      tester.getSemantics(find.text('US dollar')),
      isSemantics(isChecked: false),
    );

    await tester.tap(find.text('British pound'));
    expect(picked, [Currency.gbp]);
    semantics.dispose();
  });
}
