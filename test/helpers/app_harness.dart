import 'package:crypto_tracker/app/crypto_tracker_app.dart';
import 'package:crypto_tracker/core/network/market_api.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'pump_app.dart';

/// Starts the whole app on the real DI graph, optionally on a deep link.
/// Pair it with `tearDown(getIt.reset)`.
///
/// [marketApi] replaces the fake market service (a failing or a waiting
/// one, for the error and loading states). With [settle] false it pumps a
/// few frames instead of settling: a spinner that never stops would never
/// settle.
Future<void> pumpCryptoTracker(
  WidgetTester tester, {
  String? initialLocation,
  MarketApi? marketApi,
  bool settle = true,
}) async {
  configureDependencies();
  if (marketApi != null) {
    getIt
      ..unregister<MarketApi>()
      ..registerSingleton<MarketApi>(marketApi);
  }
  tester.usePhoneSurface();
  await tester.pumpWidget(CryptoTrackerApp(initialLocation: initialLocation));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// The bottom bar's destination labelled [label] (a tab).
Finder destination(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

/// The app bar showing [title]: which screen is on top.
Finder appBarTitled(String title) => find.widgetWithText(AppBar, title);

extension AppHarness on WidgetTester {
  /// The index of the selected tab.
  int get selectedTab =>
      widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

  Future<void> tapAndSettle(Finder finder) async {
    await tap(finder);
    await pumpAndSettle();
  }
}
