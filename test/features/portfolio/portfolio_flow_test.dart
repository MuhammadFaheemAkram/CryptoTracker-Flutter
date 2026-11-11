import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/repository/portfolio_repository.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';

// The portfolio and the holding form on the real DI graph, with the
// database in memory: every save is a real drift write, and the Portfolio
// re-values from its own query.
void main() {
  tearDown(getIt.reset);

  PortfolioRepository portfolio() => getIt<PortfolioRepository>();

  /// A holding added behind the screens' back; its id.
  Future<int> addHolding(
    WidgetTester tester, {
    String coinId = 'bitcoin',
    double amount = 0.5,
    double price = 60000,
  }) async {
    final result = await tester.write(
      () => portfolio().add(coinId: coinId, amount: amount, buyPriceUsd: price),
    );
    return (result as Ok<int>).value;
  }

  /// The holdings now, read on the real loop (§11.27).
  Future<List<Holding>> holdings(WidgetTester tester) async =>
      (await tester.runAsync(() => portfolio().watchHoldings().first))!;

  testWidgets('empty → Add holding → choose a coin → an amount → Save: '
      'valued on the Portfolio', (tester) async {
    await pumpCryptoTracker(tester, initialLocation: '/portfolio');
    expect(find.text('Add your first holding'), findsOneWidget);

    await tester.tapAndSettle(find.text('Add holding'));
    await tester.tapAndSettle(find.text('Coin'));
    await tester.enterText(find.byType(TextField).last, 'bitc');
    await tester.pumpAndSettle();
    await tester.tapAndSettle(find.text('Bitcoin').last);
    expect(find.text('Bitcoin · BTC'), findsOneWidget);
    // Its price now, suggested.
    expect(find.widgetWithText(TextField, '67240.5'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '0.5');
    await tester.pumpAndSettle();
    // Worth now, and the cost: bought at the price now, they're equal.
    expect(find.text(r'$33,620.25'), findsNWidgets(2));
    await tester.tapAndWrite(find.text('Save'));

    expect(appBarTitled('Portfolio'), findsOneWidget);
    expect(find.text('Added 0.5 BTC to your portfolio'), findsOneWidget);
    expect(find.text('Holdings (1)'), findsOneWidget);
    expect(find.text(r'$33,620.25'), findsWidgets);
    expect((await holdings(tester)).single.buyPriceUsd, 67240.5);
  });

  testWidgets("Add to portfolio on a coin's page: that coin, then back to "
      'the coin', (tester) async {
    await pumpCryptoTracker(tester, initialLocation: '/coins/solana');
    await tester.scrollTo(find.text('Add to portfolio'));
    await tester.tapAndSettle(find.text('Add to portfolio'));

    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '10');
    await tester.pumpAndSettle();
    await tester.tapAndWrite(find.text('Save'));

    expect(appBarTitled('Solana'), findsOneWidget);
    expect(find.text('Added 10 SOL to your portfolio'), findsOneWidget);
    expect((await holdings(tester)).single.coinId, 'solana');
  });

  testWidgets('tap a holding → edit it → Save: the row changes', (
    tester,
  ) async {
    await pumpCryptoTracker(tester, initialLocation: '/portfolio');
    final id = await addHolding(tester);

    await tester.scrollTo(find.text(r'Cost $30,000.00'));
    await tester.tapAndSettle(find.text(r'Cost $30,000.00'));
    expect(appBarTitled('Edit holding'), findsOneWidget);
    expect(find.widgetWithText(TextField, '0.5'), findsOneWidget);
    expect(find.widgetWithText(TextField, '60000'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '2');
    await tester.pumpAndSettle();
    await tester.tapAndWrite(find.text('Save'));

    expect(find.text('Updated your 2 BTC'), findsOneWidget);
    await tester.scrollTo(find.text(r'Cost $120,000.00'));
    final edited = (await holdings(tester)).single;
    expect((edited.id, edited.amount), (id, 2));
  });

  testWidgets('remove with a swipe, then Undo: the same holding, the same '
      'id', (tester) async {
    await pumpCryptoTracker(tester, initialLocation: '/portfolio');
    final id = await addHolding(tester);
    await tester.scrollTo(find.byType(PositionTile));

    await tester.drag(find.byType(PositionTile), const Offset(-500, 0));
    await tester.pump();
    await tester.settleRealAsync();
    expect(find.text('Add your first holding'), findsOneWidget);
    expect(find.text('0.5 BTC removed'), findsOneWidget);

    await tester.tapAndWrite(find.text('Undo'));
    expect(find.text('Holdings (1)'), findsOneWidget);
    expect((await holdings(tester)).single.id, id);
  });

  testWidgets('a price typed in euros is stored in dollars, and shown in '
      'euros again (Correctness Rule 2)', (tester) async {
    await pumpCryptoTracker(tester, initialLocation: '/portfolio');
    await tester.write(
      () => getIt<SettingsRepository>().update(
        (s) => s.copyWith(currency: Currency.eur),
      ),
    );

    await tester.tapAndSettle(find.text('Add holding'));
    await tester.tapAndSettle(find.text('Coin'));
    await tester.tapAndSettle(find.text('Ethereum'));
    expect(find.text('EUR'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '1');
    await tester.enterText(
      find.widgetWithText(TextField, 'Buy price per coin'),
      '2760',
    );
    await tester.pumpAndSettle();
    await tester.tapAndWrite(find.text('Save'));

    expect((await holdings(tester)).single.buyPriceUsd, closeTo(3000, 1e-9));
    await tester.scrollTo(find.text('Cost €2,760.00'));
  });

  testWidgets('leaving the form with changes asks first', (tester) async {
    await pumpCryptoTracker(tester, initialLocation: '/portfolio');
    await tester.tapAndSettle(find.text('Add holding'));
    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '1');
    await tester.pumpAndSettle();

    await tester.tapAndSettle(find.byType(CloseButton));
    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tapAndSettle(find.text('Discard'));

    expect(appBarTitled('Portfolio'), findsOneWidget);
    expect(await holdings(tester), isEmpty);
  });

  testWidgets('the portfolio is live: a tick moves its value', (tester) async {
    await pumpCryptoTracker(
      tester,
      initialLocation: '/portfolio',
      livePrices: true,
      settle: false,
    );
    await tester.pump(const Duration(seconds: 1)); // the seed
    await tester.settleRealAsync();
    await addHolding(tester);
    expect(find.text(r'$33,620.25'), findsWidgets);

    await tester.pump(const Duration(seconds: 2)); // a tick
    await tester.runAsync(pumpEventQueue);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(r'$33,620.25'), findsNothing);
    await tester.pauseMarket();
  });
}
