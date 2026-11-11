import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('a screen reader reads the label and the value as one', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpThemed(
      const StatTile(label: 'Market cap', value: r'$1.32T'),
    );

    expect(find.bySemanticsLabel('Market cap\n\$1.32T'), findsOneWidget);
    semantics.dispose();
  });
}
