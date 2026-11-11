import 'dart:async';

import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/network/market_api.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/repository/portfolio_repository.dart';
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
        bool tall = true,
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
        // list: the checks see only what is built. Not under a dialog: a
        // page beneath one is snapshotted for its transition, and a picture
        // that tall can't be rasterized.
        if (tall) tester.view.physicalSize = const Size(390 * 3, 6000 * 3);
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
        ('Coin not found', '/coins/not-a-coin'),
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

      testWidgets('Watchlist, starred coins and the Undo bar', (tester) async {
        await open(tester, '/market');
        await tester.tapAndWrite(find.byTooltip('Add Bitcoin to watchlist'));
        await tester.tapAndWrite(find.byTooltip('Add Tether to watchlist'));
        await tester.tapAndSettle(destination('Watchlist'));
        await tester.tapAndWrite(
          find.byTooltip('Remove Bitcoin from watchlist'),
        );
        expect(find.text('Undo'), findsOneWidget);
        expect(find.text('Tether'), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets('Coin, loading', (tester) async {
        await open(
          tester,
          '/coins/bitcoin',
          marketApi: ScriptedMarketApi()..gate = Completer<void>(),
          settle: false,
        );
        expect(find.text('Loading the coin…'), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets('Coin, live chart, caught mid-flash', (tester) async {
        await open(tester, '/coins/bitcoin', livePrices: true, settle: false);
        await tester.pump(const Duration(seconds: 1)); // the seed
        await tester.pump(const Duration(seconds: 2)); // a tick
        await tester.pump(const Duration(seconds: 2)); // another
        await tester.runAsync(pumpEventQueue); // the history (§11.123)
        await tester.pump(const Duration(milliseconds: 50)); // flashing
        expect(find.text(PriceLineChart.collectingMessage), findsNothing);
        await expectAccessible(tester);
        await tester.pauseMarket();
      });

      testWidgets('Coin, 7 days, starred, paused', (tester) async {
        await open(tester, '/coins/bitcoin');
        await tester.tapAndWrite(find.byTooltip('Add Bitcoin to watchlist'));
        await tester.tapAndSettle(find.text('7 days'));
        expect(find.byTooltip('Remove Bitcoin from watchlist'), findsOneWidget);
        expect(find.textContaining('over 7 days'), findsWidgets);
        expect(find.byType(PausedChip), findsOneWidget);
        await expectAccessible(tester);
      });

      /// Three holdings, so the donut, the legend and the rows all show.
      Future<void> addHoldings(WidgetTester tester) async {
        for (final (coin, amount) in [
          ('bitcoin', 0.5),
          ('ethereum', 4.0),
          ('tether', 1000.0),
        ]) {
          await tester.write(
            () => getIt<PortfolioRepository>().add(
              coinId: coin,
              amount: amount,
              buyPriceUsd: 1,
            ),
          );
        }
      }

      testWidgets('Portfolio, holdings and the Undo bar', (tester) async {
        await open(tester, '/portfolio');
        await addHoldings(tester);
        expect(find.byType(AllocationDonut), findsOneWidget);
        await tester.drag(
          find.byType(PositionTile).first,
          const Offset(-600, 0),
        );
        await tester.pump();
        await tester.settleRealAsync();
        expect(find.text('Undo'), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets('Holding form, every error showing', (tester) async {
        await open(tester, '/holdings/new');
        await tester.enterText(find.byType(TextField).first, '0');
        await tester.tapAndSettle(find.text('Save'));
        expect(find.text('Choose a coin'), findsOneWidget);
        expect(find.text('Must be more than 0'), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets('Holding form, the coin picker open', (tester) async {
        await open(tester, '/holdings/new');
        await tester.tapAndSettle(find.text('Coin'));
        expect(find.text('Choose a coin'), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets('Holding form, editing, and the discard question', (
        tester,
      ) async {
        await open(tester, '/portfolio', tall: false);
        await addHoldings(tester);
        // Not `.first` while nothing is built: it throws instead of
        // matching nothing.
        final bitcoin = find.text(r'Cost $0.50');
        await tester.scrollTo(bitcoin);
        await tester.tapAndSettle(bitcoin);
        expect(find.text('Edit holding'), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, '2');
        await tester.pumpAndSettle(); // the change shows before Close
        await tester.tapAndSettle(find.byType(CloseButton));
        expect(find.text('Discard changes?'), findsOneWidget);
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
