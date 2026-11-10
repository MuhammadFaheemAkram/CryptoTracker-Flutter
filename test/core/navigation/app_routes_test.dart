import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:crypto_tracker/features/shell/main_shell.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every destination has its typed location', () {
    expect(const MarketRoute().location, '/market');
    expect(const WatchlistRoute().location, '/watchlist');
    expect(const PortfolioRoute().location, '/portfolio');
    expect(const SettingsRoute().location, '/settings');
    expect(const CoinDetailRoute(coinId: 'bitcoin').location, '/coins/bitcoin');
    expect(const NewHoldingRoute().location, '/holdings/new');
    expect(
      const NewHoldingRoute(coinId: 'ethereum').location,
      '/holdings/new?coin-id=ethereum',
    );
    expect(const EditHoldingRoute(holdingId: 7).location, '/holdings/7/edit');
  });

  test('ids are encoded into their locations', () {
    expect(
      const CoinDetailRoute(coinId: 'wrapped bitcoin').location,
      '/coins/wrapped%20bitcoin',
    );
    expect(const CoinDetailRoute(coinId: 'a/b').location, '/coins/a%2Fb');
  });

  test("the tabs are in the shell branches' order", () {
    expect(AppTab.values.map((tab) => tab.label), [
      'Market',
      'Watchlist',
      'Portfolio',
      'Settings',
    ]);
  });
}
