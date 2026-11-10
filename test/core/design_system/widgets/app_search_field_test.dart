import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('Clear appears once something is typed, and empties the field', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var cleared = 0;
    await tester.pumpThemed(
      AppSearchField(
        controller: controller,
        hintText: 'Search coins',
        onCleared: () => cleared++,
      ),
    );
    expect(find.byTooltip('Clear search'), findsNothing);

    await tester.enterText(find.byType(TextField), 'btc');
    await tester.pump();
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(cleared, 1);
    expect(find.byTooltip('Clear search'), findsNothing);
  });

  testWidgets('autocorrect is off (iOS would capitalise a symbol)', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpThemed(
      AppSearchField(controller: controller, hintText: 'Search coins'),
    );

    expect(
      tester.widget<TextField>(find.byType(TextField)).autocorrect,
      isFalse,
    );
  });
}
