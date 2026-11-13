import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/core/storage/settings_local_data_source.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/repository/portfolio_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';

// Settings on the real DI graph: each control reaches every pipeline that
// depends on it, and the stored settings apply from the first frame.
void main() {
  tearDown(getIt.reset);

  Brightness brightnessOf(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness;

  testWidgets('a stored dark theme applies from the first frame (Correctness '
      'Rule 14)', (tester) async {
    await pumpCryptoTracker(
      tester,
      stored: {SettingsLocalDataSource.themeModeKey: 'dark'},
      settle: false,
    );

    expect(brightnessOf(tester), Brightness.dark);
    await tester.pumpAndSettle(); // the market loads; no timer left behind
  });

  testWidgets('Appearance re-themes the whole app, and is stored', (
    tester,
  ) async {
    await pumpCryptoTracker(tester, initialLocation: '/settings');
    expect(brightnessOf(tester), Brightness.light);

    await tester.scrollTo(find.text('Dark'));
    await tester.tapAndSettle(find.text('Dark'));
    await tester.settleRealAsync();

    expect(brightnessOf(tester), Brightness.dark);
    expect(getIt<SettingsLocalDataSource>().read().themeMode.name, 'dark');
  });

  testWidgets('another currency converts the Market and the Portfolio '
      '(Correctness Rule 2)', (tester) async {
    await pumpCryptoTracker(tester, initialLocation: '/settings');
    await tester.write(
      () => getIt<PortfolioRepository>().add(
        coinId: 'bitcoin',
        amount: 1,
        buyPriceUsd: 60000,
      ),
    );

    await tester.tapAndSettle(find.text('Euro'));
    await tester.settleRealAsync();

    await tester.tapAndSettle(destination('Market'));
    expect(find.text('€61,861.26'), findsOneWidget); // $67,240.50 × 0.92
    await tester.tapAndSettle(destination('Portfolio'));
    expect(find.text('€61,861.26'), findsWidgets);
    expect(find.text(r'$67,240.50'), findsNothing);
  });

  testWidgets('Live prices off in Settings is the Market\'s Pause', (
    tester,
  ) async {
    await pumpCryptoTracker(tester, livePrices: true, settle: false);
    await tester.pump(const Duration(seconds: 1)); // the seed
    expect(find.byType(PausedChip), findsNothing);

    await tester.tap(destination('Settings'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();
    await tester.runAsync(pumpEventQueue);
    await tester.pumpAndSettle();

    await tester.tapAndSettle(destination('Market'));
    expect(find.byType(PausedChip), findsOneWidget);
  });

  testWidgets('a new interval restarts the ticker at that pace, from the '
      'current prices', (tester) async {
    // The Market loads the seed (a tab not yet opened loads nothing).
    await pumpCryptoTracker(tester, livePrices: true, settle: false);
    await tester.pump(const Duration(seconds: 1)); // the seed
    await tester.tap(destination('Settings'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.scrollTo(find.text('5 s'));
    await tester.tap(find.text('5 s'));
    await tester.pump();
    await tester.runAsync(pumpEventQueue);
    await tester.pump();
    final before = getIt<PriceTicker>().quotes.value;

    await tester.pump(const Duration(seconds: 4)); // not yet
    expect(getIt<PriceTicker>().quotes.value, same(before));
    await tester.pump(const Duration(seconds: 1)); // 5 s
    expect(getIt<PriceTicker>().quotes.value, isNot(same(before)));

    await tester.pauseMarket();
  });
}
