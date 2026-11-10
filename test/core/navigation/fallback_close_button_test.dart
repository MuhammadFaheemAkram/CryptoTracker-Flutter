import 'dart:async';

import 'package:crypto_tracker/core/navigation/fallback_close_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  /// A page opened first (as by a link), whose own `build` runs again each
  /// time [rebuilds] changes, like a coin's page on every price tick.
  Widget linkedPage(ValueNotifier<int> rebuilds, VoidCallback onClose) =>
      ValueListenableBuilder<int>(
        valueListenable: rebuilds,
        builder: (context, _, _) => Scaffold(
          appBar: AppBar(
            title: const Text('Coin'),
            leading: fallbackCloseButton(context, onClose),
          ),
        ),
      );

  testWidgets('a screen with nothing below gets Close; one with a screen '
      'below keeps its Back', (tester) async {
    final rebuilds = ValueNotifier(0);
    addTearDown(rebuilds.dispose);
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(navigatorKey: navigator, home: linkedPage(rebuilds, () {})),
    );
    expect(find.byTooltip('Close'), findsOneWidget);

    unawaited(
      navigator.currentState!.push(
        MaterialPageRoute<void>(builder: (_) => linkedPage(rebuilds, () {})),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BackButton), findsOneWidget);
    expect(find.byTooltip('Close'), findsNothing);
  });

  testWidgets('a linked screen keeps Close after rebuilding while another '
      'covers it (it asks about its own route, not the whole stack, '
      'conventions §11.96)', (tester) async {
    final rebuilds = ValueNotifier(0);
    addTearDown(rebuilds.dispose);
    final navigator = GlobalKey<NavigatorState>();
    var closes = 0;
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        home: linkedPage(rebuilds, () => closes++),
      ),
    );
    unawaited(
      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('The form')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    rebuilds.value++; // rebuilt underneath: the stack can pop now
    await tester.pumpAndSettle();
    navigator.currentState!.pop();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Close'));
    expect(closes, 1);
  });
}
