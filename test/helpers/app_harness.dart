import 'package:crypto_tracker/app/crypto_tracker_app.dart';
import 'package:crypto_tracker/core/network/market_api.dart';
import 'package:crypto_tracker/core/storage/settings_local_data_source.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import 'pump_app.dart';
import 'test_dependencies.dart';

/// Starts the whole app on the real DI graph, optionally on a deep link.
/// Pair it with `tearDown(getIt.reset)`.
///
/// - **Live prices are paused** unless [livePrices] is true: a market that
///   ticks forever never lets `pumpAndSettle` settle, and a test that
///   leaves a periodic timer running fails. A test that wants ticks turns
///   them on, and calls `tester.pauseMarket()` before it ends.
/// - [marketApi] replaces the fake market service (a failing or a waiting
///   one, for the error and loading states).
/// - With [settle] false it pumps a few frames instead of settling: a
///   spinner that never stops would never settle.
Future<void> pumpCryptoTracker(
  WidgetTester tester, {
  String? initialLocation,
  MarketApi? marketApi,
  bool livePrices = false,
  bool settle = true,
}) async {
  await tester.runAsync(() async {
    if (!livePrices) {
      // Stored before the app reads its settings: it starts paused, as if
      // the user had paused it last time.
      await SharedPreferencesAsyncPlatform.instance!.setBool(
        SettingsLocalDataSource.pausedKey,
        true,
        const SharedPreferencesOptions(),
      );
    }
    await configureTestDependencies();
  });
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

  /// Scrolls [finder] fully into view: `scrollUntilVisible` alone stops as
  /// soon as a lazy list *builds* the target, which can leave it at the
  /// viewport's edge, under the tab bar (conventions §11.88).
  Future<void> scrollTo(Finder finder) async {
    await scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await ensureVisible(finder);
    await pumpAndSettle();
  }

  /// Taps [finder] (a star, Undo: a database write), lets the write run on
  /// the real event loop, then settles. A drift write started in fake time
  /// may never finish; its queries' streams answer only on the real loop
  /// (conventions §11.27, §11.95).
  Future<void> tapAndWrite(Finder finder) async {
    await tap(finder);
    await pump();
    await settleRealAsync();
  }

  /// One write to the app's data while it's on screen (a holding added
  /// behind the screen's back, the currency changed), then the screens
  /// catch up. One write per call: a second in the same `runAsync` can wait
  /// forever on the database the screens hold (conventions §11.95).
  Future<T> write<T>(Future<T> Function() change) async {
    final result = await runAsync(change);
    await settleRealAsync();
    return result as T;
  }

  /// Lets work on the real event loop finish (a database write and the
  /// queries it wakes), then settles; twice, as a write's answer can
  /// start another frame's work.
  Future<void> settleRealAsync() async {
    for (var i = 0; i < 2; i++) {
      await runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await pumpAndSettle();
    }
  }

  /// Pauses live prices through the app's own settings, so the ticker's
  /// timer stops before the test ends (and `pumpAndSettle` can settle).
  Future<void> pauseMarket() async {
    await getIt<SettingsRepository>().update(
      (settings) => settings.copyWith(livePricesPaused: true),
    );
    await pumpAndSettle();
  }
}
