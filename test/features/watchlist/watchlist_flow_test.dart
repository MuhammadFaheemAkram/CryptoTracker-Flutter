import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/repository/watchlist_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';

// The watchlist and a coin's page on the real DI graph, with the database
// in memory: every star is a real drift write, and every screen learns of
// it from its own query.
void main() {
  tearDown(getIt.reset);

  testWidgets('search → a coin → star it → it\'s on the Watchlist', (
    tester,
  ) async {
    await pumpCryptoTracker(tester);
    await tester.tapAndSettle(destination('Watchlist'));
    expect(find.text('Star coins to watch them here'), findsOneWidget);
    await tester.tapAndSettle(destination('Market'));

    await tester.enterText(find.byType(TextField), 'sol');
    await tester.pumpAndSettle();
    await tester.tapAndSettle(find.text('Solana'));
    expect(appBarTitled('Solana'), findsOneWidget);

    await tester.tapAndWrite(find.byTooltip('Add Solana to watchlist'));
    expect(find.byTooltip('Remove Solana from watchlist'), findsOneWidget);

    // Back on the Market, the row's star is filled too: nobody told it.
    await tester.tapAndSettle(find.byType(BackButton));
    expect(find.byTooltip('Remove Solana from watchlist'), findsOneWidget);

    await tester.tapAndSettle(destination('Watchlist'));
    expect(find.text('1 coin · in the order you starred them'), findsOneWidget);
    expect(find.text('Solana'), findsOneWidget);
  });

  testWidgets('stars from the Market come in the order they were made', (
    tester,
  ) async {
    await pumpCryptoTracker(tester);

    await tester.tapAndWrite(find.byTooltip('Add Ethereum to watchlist'));
    await tester.tapAndWrite(find.byTooltip('Add Bitcoin to watchlist'));
    await tester.tapAndSettle(destination('Watchlist'));

    expect(
      tester.getTopLeft(find.text('Ethereum')).dy,
      lessThan(tester.getTopLeft(find.text('Bitcoin')).dy),
    );
  });

  testWidgets('remove with the star, then Undo: back in its place', (
    tester,
  ) async {
    await pumpCryptoTracker(tester);
    await tester.tapAndWrite(find.byTooltip('Add Bitcoin to watchlist'));
    await tester.tapAndWrite(find.byTooltip('Add Ethereum to watchlist'));
    await tester.tapAndSettle(destination('Watchlist'));

    await tester.tapAndWrite(find.byTooltip('Remove Bitcoin from watchlist'));
    expect(find.text('Bitcoin removed from watchlist'), findsOneWidget);
    expect(find.text('1 coin · in the order you starred them'), findsOneWidget);

    await tester.tapAndWrite(find.text('Undo'));
    expect(
      find.text('2 coins · in the order you starred them'),
      findsOneWidget,
    );
    expect(
      tester.getTopLeft(find.text('Bitcoin')).dy,
      lessThan(tester.getTopLeft(find.text('Ethereum')).dy),
    );
    // On the real loop: a drift stream's `first` hangs in fake time
    // (conventions §11.27).
    final ids = await tester.runAsync(
      () => getIt<WatchlistRepository>().watchIds().first,
    );
    expect(ids, ['bitcoin', 'ethereum']);
  });

  testWidgets('remove with a swipe', (tester) async {
    await pumpCryptoTracker(tester);
    await tester.tapAndWrite(find.byTooltip('Add Bitcoin to watchlist'));
    await tester.tapAndSettle(destination('Watchlist'));

    await tester.drag(find.text('Bitcoin'), const Offset(-500, 0));
    await tester.pump();
    await tester.settleRealAsync();

    expect(find.text('Star coins to watch them here'), findsOneWidget);
    expect(find.text('Bitcoin removed from watchlist'), findsOneWidget);
  });

  testWidgets('a coin\'s page by link: not found', (tester) async {
    await pumpCryptoTracker(tester, initialLocation: '/coins/not-a-coin');

    expect(appBarTitled('Coin not found'), findsOneWidget);
    await tester.tapAndSettle(find.text('Browse the market'));
    expect(appBarTitled('Market'), findsOneWidget);
  });

  testWidgets('a coin\'s page is live: the price ticks, the chart fills, '
      'and Pause freezes it', (tester) async {
    await pumpCryptoTracker(
      tester,
      initialLocation: '/coins/bitcoin',
      livePrices: true,
      settle: false,
    );
    await tester.pump(const Duration(seconds: 1)); // the seed (600 ms)
    await tester.settleRealAsync();
    expect(appBarTitled('Bitcoin'), findsOneWidget);
    // Only the seed so far: one point.
    expect(find.text(PriceLineChart.collectingMessage), findsOneWidget);

    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(seconds: 2)); // a tick each
    }
    // The history started with the app, inside `runAsync`: its listener
    // lives in the root zone, so its points arrive on the real event loop,
    // which fake-time pumps never turn (conventions §11.123).
    await tester.runAsync(pumpEventQueue);
    await tester.pump();

    expect(find.text(PriceLineChart.collectingMessage), findsNothing);
    expect(find.textContaining('over the last 4 updates'), findsOneWidget);

    await tester.pauseMarket();
    expect(find.byType(PausedChip), findsOneWidget);
  });
}
