import 'package:crypto_tracker/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';

// Every screen, in light and dark, with text at 200 %: no layout overflows
// (an overflow fails the test), tap targets of at least 48 × 48, a label on
// everything tappable, and readable text contrast. A new screen, or a new
// state of one (loading, empty, error, paused), gets a stop here.
void main() {
  tearDown(getIt.reset);

  for (final brightness in Brightness.values) {
    group('${brightness.name} theme, text at 200 %', () {
      for (final (name, location) in [
        ('Market', '/market'),
        ('Watchlist', '/watchlist'),
        ('Portfolio', '/portfolio'),
        ('Settings', '/settings'),
        ('Coin', '/coins/bitcoin'),
        ('Add holding', '/holdings/new?coin-id=bitcoin'),
        ('Edit holding', '/holdings/1/edit'),
        ('Page not found', '/nowhere'),
      ]) {
        testWidgets(name, (tester) async {
          tester.platformDispatcher
            ..textScaleFactorTestValue = 2
            ..platformBrightnessTestValue = brightness;
          addTearDown(tester.platformDispatcher.clearAllTestValues);
          await pumpCryptoTracker(tester, initialLocation: location);
          // Phone width, but tall enough to lay out every item of a long
          // list: the checks see only what is built.
          tester.view.physicalSize = const Size(390 * 3, 6000 * 3);
          await tester.pumpAndSettle();
          final context = tester.element(find.byType(Scaffold).last);
          expect(MediaQuery.textScalerOf(context).scale(10), 20);
          expect(Theme.of(context).brightness, brightness);

          final handle = tester.ensureSemantics();
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          handle.dispose();
        });
      }
    });
  }

  testWidgets('the tab labels keep their size at any text setting (a long '
      'press shows them)', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await pumpCryptoTracker(tester);

    final label = destination('Portfolio');
    expect(MediaQuery.textScalerOf(tester.element(label)).scale(10), 10);

    final before = find.text('Portfolio').evaluate().length;
    await tester.longPress(label);
    await tester.pumpAndSettle();
    // One more: the tooltip over the bar.
    expect(find.text('Portfolio'), findsNWidgets(before + 1));
  });
}
