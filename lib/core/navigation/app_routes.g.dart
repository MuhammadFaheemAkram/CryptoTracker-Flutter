// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $mainShellRoute,
  $coinDetailRoute,
  $newHoldingRoute,
  $editHoldingRoute,
];

RouteBase get $mainShellRoute => StatefulShellRouteData.$route(
  factory: $MainShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      navigatorKey: MarketBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/market',
          hasOverriddenOnExit: false,
          factory: $MarketRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: WatchlistBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/watchlist',
          hasOverriddenOnExit: false,
          factory: $WatchlistRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: PortfolioBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/portfolio',
          hasOverriddenOnExit: false,
          factory: $PortfolioRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: SettingsBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/settings',
          hasOverriddenOnExit: false,
          factory: $SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $MainShellRouteExtension on MainShellRoute {
  static MainShellRoute _fromState(GoRouterState state) =>
      const MainShellRoute();
}

mixin $MarketRoute on GoRouteData {
  static MarketRoute _fromState(GoRouterState state) => const MarketRoute();

  @override
  String get location => GoRouteData.$location('/market');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $WatchlistRoute on GoRouteData {
  static WatchlistRoute _fromState(GoRouterState state) =>
      const WatchlistRoute();

  @override
  String get location => GoRouteData.$location('/watchlist');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PortfolioRoute on GoRouteData {
  static PortfolioRoute _fromState(GoRouterState state) =>
      const PortfolioRoute();

  @override
  String get location => GoRouteData.$location('/portfolio');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $coinDetailRoute => GoRouteData.$route(
  path: '/coins/:coinId',
  hasOverriddenOnExit: false,
  factory: $CoinDetailRoute._fromState,
);

mixin $CoinDetailRoute on GoRouteData {
  static CoinDetailRoute _fromState(GoRouterState state) =>
      CoinDetailRoute(coinId: state.pathParameters['coinId']!);

  CoinDetailRoute get _self => this as CoinDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/coins/${Uri.encodeComponent(_self.coinId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $newHoldingRoute => GoRouteData.$route(
  path: '/holdings/new',
  hasOverriddenOnExit: false,
  factory: $NewHoldingRoute._fromState,
);

mixin $NewHoldingRoute on GoRouteData {
  static NewHoldingRoute _fromState(GoRouterState state) =>
      NewHoldingRoute(coinId: state.uri.queryParameters['coin-id']);

  NewHoldingRoute get _self => this as NewHoldingRoute;

  @override
  String get location => GoRouteData.$location(
    '/holdings/new',
    queryParams: {if (_self.coinId != null) 'coin-id': _self.coinId},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editHoldingRoute => GoRouteData.$route(
  path: '/holdings/:holdingId/edit',
  hasOverriddenOnExit: false,
  factory: $EditHoldingRoute._fromState,
);

mixin $EditHoldingRoute on GoRouteData {
  static EditHoldingRoute _fromState(GoRouterState state) => EditHoldingRoute(
    holdingId: int.parse(state.pathParameters['holdingId']!),
  );

  EditHoldingRoute get _self => this as EditHoldingRoute;

  @override
  String get location => GoRouteData.$location(
    '/holdings/${Uri.encodeComponent(_self.holdingId.toString())}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
