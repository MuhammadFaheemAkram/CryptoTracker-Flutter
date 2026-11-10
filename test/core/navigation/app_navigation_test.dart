import 'package:crypto_tracker/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';

void main() {
  tearDown(getIt.reset);

  group('tabs', () {
    testWidgets('the app opens on the Market', (tester) async {
      await pumpCryptoTracker(tester);

      expect(appBarTitled('Market'), findsOneWidget);
      expect(tester.selectedTab, 0);
    });

    testWidgets('each tab shows its own screen', (tester) async {
      await pumpCryptoTracker(tester);

      for (final (index, label) in [
        (1, 'Watchlist'),
        (2, 'Portfolio'),
        (3, 'Settings'),
        (0, 'Market'),
      ]) {
        await tester.tapAndSettle(destination(label));
        expect(tester.selectedTab, index);
        expect(appBarTitled(label), findsOneWidget);
      }
    });

    testWidgets('the bare root opens the Market', (tester) async {
      await pumpCryptoTracker(tester, initialLocation: '/');

      expect(appBarTitled('Market'), findsOneWidget);
    });
  });

  group('a coin', () {
    testWidgets('opens above the tabs, and Back returns to the Market', (
      tester,
    ) async {
      await pumpCryptoTracker(tester);

      await tester.tapAndSettle(find.text('Open Bitcoin'));
      expect(appBarTitled('Coin'), findsOneWidget);
      expect(find.text('Coin "bitcoin"'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tapAndSettle(find.byType(BackButton));
      expect(appBarTitled('Market'), findsOneWidget);
    });

    testWidgets('by link, it opens with a Close button to the Market', (
      tester,
    ) async {
      await pumpCryptoTracker(tester, initialLocation: '/coins/ethereum');
      expect(find.text('Coin "ethereum"'), findsOneWidget);
      expect(find.byType(BackButton), findsNothing);

      await tester.tapAndSettle(find.byTooltip('Close'));

      expect(appBarTitled('Market'), findsOneWidget);
    });

    testWidgets('by link, it keeps Close after rebuilding while another '
        'screen covers it (conventions §11.96)', (tester) async {
      await pumpCryptoTracker(tester, initialLocation: '/coins/bitcoin');
      await tester.tapAndSettle(find.text('Add to portfolio'));

      // Anything that rebuilds the covered coin must not take its way out
      // away. From Phase 4 the coin rebuilds on every price tick; the rule
      // itself is tested in fallback_close_button_test.dart.
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await tester.pumpAndSettle();
      await tester.tapAndSettle(find.byType(CloseButton));

      expect(find.text('Coin "bitcoin"'), findsOneWidget);
      await tester.tapAndSettle(find.byTooltip('Close'));
      expect(appBarTitled('Market'), findsOneWidget);
    });

    testWidgets('an encoded id arrives decoded', (tester) async {
      await pumpCryptoTracker(
        tester,
        initialLocation: '/coins/wrapped%20bitcoin',
      );

      expect(find.text('Coin "wrapped bitcoin"'), findsOneWidget);
    });
  });

  group('the holding form', () {
    testWidgets('slides up as a full-screen dialog from the Portfolio, and '
        'Close returns to it', (tester) async {
      await pumpCryptoTracker(tester, initialLocation: '/portfolio');

      await tester.tapAndSettle(find.text('Add holding'));
      expect(appBarTitled('Add holding'), findsOneWidget);
      expect(find.text('A new holding.'), findsOneWidget);
      final route = ModalRoute.of(tester.element(find.text('A new holding.')));
      expect(route, isA<PageRoute<void>>());
      expect((route! as PageRoute<void>).fullscreenDialog, isTrue);
      expect(find.byType(CloseButton), findsOneWidget);

      await tester.tapAndSettle(find.byType(CloseButton));
      expect(appBarTitled('Portfolio'), findsOneWidget);
    });

    testWidgets("from a coin's page, it starts with that coin", (tester) async {
      await pumpCryptoTracker(tester, initialLocation: '/coins/solana');

      await tester.tapAndSettle(find.text('Add to portfolio'));

      expect(appBarTitled('Add holding'), findsOneWidget);
      expect(find.text('A new holding of "solana".'), findsOneWidget);
      await tester.tapAndSettle(find.byType(CloseButton));
      expect(find.text('Coin "solana"'), findsOneWidget);
    });

    testWidgets('by link, a new holding keeps its coin (the query)', (
      tester,
    ) async {
      await pumpCryptoTracker(
        tester,
        initialLocation: '/holdings/new?coin-id=bitcoin',
      );

      expect(find.text('A new holding of "bitcoin".'), findsOneWidget);
    });

    testWidgets('by link, editing opens with Close to the Portfolio', (
      tester,
    ) async {
      await pumpCryptoTracker(tester, initialLocation: '/holdings/7/edit');
      expect(appBarTitled('Edit holding'), findsOneWidget);
      expect(find.text('Holding 7.'), findsOneWidget);

      await tester.tapAndSettle(find.byTooltip('Close'));

      expect(appBarTitled('Portfolio'), findsOneWidget);
    });

    testWidgets('a holding id that is not a number matches no route', (
      tester,
    ) async {
      await pumpCryptoTracker(tester, initialLocation: '/holdings/abc/edit');

      expect(find.text('Page not found'), findsOneWidget);
    });
  });

  testWidgets('an unknown location shows "Page not found", with a way back', (
    tester,
  ) async {
    await pumpCryptoTracker(tester, initialLocation: '/nowhere');
    expect(find.text('Page not found'), findsOneWidget);

    await tester.tapAndSettle(find.text('Go to the Market'));
    expect(appBarTitled('Market'), findsOneWidget);
  });
}
