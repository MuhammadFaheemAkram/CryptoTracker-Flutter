import 'package:crypto_tracker/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';

// The Market on the real DI graph: the fake service and the bundled seed.
void main() {
  tearDown(getIt.reset);

  testWidgets('launch: the 32 coins, Bitcoin first', (tester) async {
    await pumpCryptoTracker(tester);

    expect(find.text('32 coins · by rank'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text(r'$67,240.50'), findsOneWidget);
  });

  testWidgets('search, sort, and open a coin', (tester) async {
    await pumpCryptoTracker(tester);

    await tester.enterText(find.byType(TextField), 'ethereum');
    await tester.pumpAndSettle();
    expect(find.text('2 matches · by rank'), findsOneWidget);
    expect(find.text('Ethereum'), findsOneWidget);
    expect(find.text('Ethereum Classic'), findsOneWidget);

    await tester.tap(find.byTooltip('Sort by rank'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();
    expect(find.text('2 matches · by price'), findsOneWidget);

    await tester.tapAndSettle(find.text('Ethereum Classic'));
    expect(find.text('Coin "ethereum-classic"'), findsOneWidget);

    // Back on the Market, the search and the sort are still there.
    await tester.tapAndSettle(find.byType(BackButton));
    expect(find.text('2 matches · by price'), findsOneWidget);
  });

  testWidgets('the market survives a trip to another tab', (tester) async {
    await pumpCryptoTracker(tester);
    await tester.enterText(find.byType(TextField), 'sol');
    await tester.pumpAndSettle();

    await tester.tapAndSettle(destination('Portfolio'));
    await tester.tapAndSettle(destination('Market'));

    expect(find.widgetWithText(TextField, 'sol'), findsOneWidget);
    expect(find.text('Solana'), findsOneWidget);
  });
}
