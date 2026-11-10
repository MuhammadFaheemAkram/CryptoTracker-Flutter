import 'package:crypto_tracker/features/coin_detail/coin_detail_page.dart';
import 'package:crypto_tracker/features/holding_form/holding_form_page.dart';
import 'package:crypto_tracker/features/market/market_page.dart';
import 'package:crypto_tracker/features/portfolio/portfolio_page.dart';
import 'package:crypto_tracker/features/settings/settings_page.dart';
import 'package:crypto_tracker/features/shell/main_shell.dart';
import 'package:crypto_tracker/features/watchlist/watchlist_page.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

part 'app_routes.g.dart';

// Typed routes: every destination is a class, and `go_router_builder`
// generates its path parsing, `location` getter and `go`/`push` helpers. A
// typo or a missing parameter is a compile error instead of a runtime "page
// not found".
//
// The tree has two parts:
// 1. the tab shell: Market, Watchlist, Portfolio, Settings;
// 2. root-level screens, pushed *above* the shell: a coin (reachable from
//    three tabs) and the holding form (a full-screen dialog).

// ---------------------------------------------------------------------------
// 1. The tab shell

/// `StatefulShellRoute` gives every tab its own Navigator and keeps inactive
/// tabs alive in an IndexedStack, so switching tabs preserves each tab's
/// state (a scroll position, a search being typed).
@TypedStatefulShellRoute<MainShellRoute>(
  branches: [
    TypedStatefulShellBranch<MarketBranch>(
      routes: [TypedGoRoute<MarketRoute>(path: '/market')],
    ),
    TypedStatefulShellBranch<WatchlistBranch>(
      routes: [TypedGoRoute<WatchlistRoute>(path: '/watchlist')],
    ),
    TypedStatefulShellBranch<PortfolioBranch>(
      routes: [TypedGoRoute<PortfolioRoute>(path: '/portfolio')],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
class MainShellRoute extends StatefulShellRouteData {
  const MainShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainShell(navigationShell: navigationShell);
  }
}

// A named navigator key per tab makes each back stack addressable (and
// readable in debugging tools).

class MarketBranch extends StatefulShellBranchData {
  const MarketBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'marketTab');
}

class WatchlistBranch extends StatefulShellBranchData {
  const WatchlistBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'watchlistTab');
}

class PortfolioBranch extends StatefulShellBranchData {
  const PortfolioBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'portfolioTab');
}

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'settingsTab');
}

class MarketRoute extends GoRouteData with $MarketRoute {
  const MarketRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MarketPage();
}

class WatchlistRoute extends GoRouteData with $WatchlistRoute {
  const WatchlistRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WatchlistPage();
}

class PortfolioRoute extends GoRouteData with $PortfolioRoute {
  const PortfolioRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PortfolioPage();
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}

// ---------------------------------------------------------------------------
// 2. Root-level screens
//
// Declared at the top level, so they live in the *root* Navigator: pushing
// one covers the tab bar, and Back (or the iOS swipe) returns to the tab with
// its state intact.

/// `/coins/:coinId`: one coin. Opened from the Market, the Watchlist and the
/// Portfolio, so it belongs to none of them.
@TypedGoRoute<CoinDetailRoute>(path: '/coins/:coinId')
class CoinDetailRoute extends GoRouteData with $CoinDetailRoute {
  const CoinDetailRoute({required this.coinId});

  final String coinId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CoinDetailPage(coinId: coinId);
}

/// `/holdings/new?coin-id=…`: the holding form, for a new holding. From a
/// coin's page, [coinId] picks the coin in advance (go_router_builder
/// writes query parameter names in kebab-case).
@TypedGoRoute<NewHoldingRoute>(path: '/holdings/new')
class NewHoldingRoute extends GoRouteData with $NewHoldingRoute {
  const NewHoldingRoute({this.coinId});

  /// A query parameter: the coin to start with, if any.
  final String? coinId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _formPage(state, HoldingFormPage(coinId: coinId));
}

/// `/holdings/:holdingId/edit`: the holding form, for an existing holding.
@TypedGoRoute<EditHoldingRoute>(path: '/holdings/:holdingId/edit')
class EditHoldingRoute extends GoRouteData with $EditHoldingRoute {
  const EditHoldingRoute({required this.holdingId});

  /// The holding's database id (an `int`: go_router_builder parses it, and
  /// a path that isn't a number matches no route).
  final int holdingId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _formPage(state, HoldingFormPage(holdingId: holdingId));
}

/// A form is a full-screen dialog: it slides up and has Close instead of
/// Back (the Material counterpart of an iOS sheet).
Page<void> _formPage(GoRouterState state, Widget child) => MaterialPage<void>(
  key: state.pageKey,
  fullscreenDialog: true,
  child: child,
);
