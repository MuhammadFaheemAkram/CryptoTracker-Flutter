import 'dart:async';

import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/network/market_api.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes/scripted_market_api.dart';

// Every screen, in light and dark, with text at 200 %: no layout overflows
// (an overflow fails the test), tap targets of at least 48 × 48, a label on
// everything tappable, and readable text contrast. A new screen, or a new
// state of one (loading, empty, error, paused), gets a stop here.
void main() {
  tearDown(getIt.reset);

  for (final brightness in Brightness.values) {
    group('${brightness.name} theme, text at 200 %', () {
      Future<void> open(
        WidgetTester tester,
        String location, {
        MarketApi? marketApi,
        bool settle = true,
        bool livePrices = false,
      }) async {
        tester.platformDispatcher
          ..textScaleFactorTestValue = 2
          ..platformBrightnessTestValue = brightness;
        addTearDown(tester.platformDispatcher.clearAllTestValues);
        await pumpCryptoTracker(
          tester,
          initialLocation: location,
          marketApi: marketApi,
          settle: settle,
          livePrices: livePrices,
        );
        // Phone width, but tall enough to lay out every item of a long
        // list: the checks see only what is built.
        tester.view.physicalSize = const Size(390 * 3, 6000 * 3);
        settle
            ? await tester.pumpAndSettle()
            : await tester.pump(const Duration(milliseconds: 100));
        final context = tester.element(find.byType(Scaffold).last);
        expect(MediaQuery.textScalerOf(context).scale(10), 20);
        expect(Theme.of(context).brightness, brightness);
      }

      Future<void> expectAccessible(WidgetTester tester) async {
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      }

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
          await open(tester, location);
          await expectAccessible(tester);
        });
      }

      testWidgets('Market, loading', (tester) async {
        await open(
          tester,
          '/market',
          marketApi: ScriptedMarketApi()..gate = Completer<void>(),
          settle: false,
        );
        expect(find.text('Loading the market…'), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets('Market, failed', (tester) async {
        await open(
          tester,
          '/market',
          marketApi: ScriptedMarketApi()..failure = const NetworkException(),
        );
        expect(find.text('Try again'), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets('Market, nothing matches', (tester) async {
        await open(tester, '/market');
        await tester.enterText(find.byType(TextField), 'zzz');
        await tester.pumpAndSettle();
        expect(find.text('No coins match “zzz”'), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets(
        'Market, live, caught mid-flash (text over the flash tints)',
        (tester) async {
          await open(tester, '/market', livePrices: true, settle: false);
          await tester.pump(const Duration(seconds: 1)); // the seed
          await tester.pump(const Duration(seconds: 2)); // a tick
          await tester.pump(const Duration(milliseconds: 50)); // flashing
          expect(find.byType(PausedChip), findsNothing);
          await expectAccessible(tester);
          await tester.pauseMarket();
        },
      );

      testWidgets('Market, paused', (tester) async {
        await open(tester, '/market');
        expect(find.byType(PausedChip), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets('Market, the sort menu open', (tester) async {
        await open(tester, '/market');
        await tester.tap(find.byTooltip('Sort by rank'));
        await tester.pumpAndSettle();
        await expectAccessible(tester);
      });
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
