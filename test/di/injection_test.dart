import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/core/database/daos/portfolio_dao.dart';
import 'package:crypto_tracker/core/database/daos/watchlist_dao.dart';
import 'package:crypto_tracker/core/network/fake_market_api.dart';
import 'package:crypto_tracker/core/network/market_api.dart';
import 'package:crypto_tracker/core/prices/price_history.dart';
import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/core/prices/ticker_scheduler.dart';
import 'package:crypto_tracker/data/repository/market_repository_impl.dart';
import 'package:crypto_tracker/data/repository/portfolio_repository_impl.dart';
import 'package:crypto_tracker/data/repository/settings_repository_impl.dart';
import 'package:crypto_tracker/data/repository/watchlist_repository_impl.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/model/app_info.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:crypto_tracker/domain/repository/portfolio_repository.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:crypto_tracker/domain/repository/watchlist_repository.dart';
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_cubit.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_cubit.dart';
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart';
import 'package:crypto_tracker/features/settings/cubit/settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(configureTestDependencies);
  tearDown(getIt.reset);

  test('the composition root picks the fake service and the real '
      'repositories', () {
    expect(getIt<MarketApi>(), isA<FakeMarketApi>());
    expect(getIt<MarketRepository>(), isA<MarketRepositoryImpl>());
    expect(getIt<SettingsRepository>(), isA<SettingsRepositoryImpl>());
    expect(getIt<WatchlistRepository>(), isA<WatchlistRepositoryImpl>());
    expect(getIt<PortfolioRepository>(), isA<PortfolioRepositoryImpl>());
  });

  test('one SettingsCubit for the whole app (the theme, and the Settings '
      'tab), and the app\'s name and version read at launch', () {
    expect(getIt<SettingsCubit>(), same(getIt<SettingsCubit>()));
    expect(getIt<AppInfo>().name, 'CryptoTracker');
    expect(getIt<AppInfo>().version, '1.0.0');
  });

  test('one database for the whole app, and its DAO comes from it', () {
    expect(getIt<AppDatabase>(), same(getIt<AppDatabase>()));
    expect(getIt<WatchlistDao>(), same(getIt<AppDatabase>().watchlistDao));
    expect(getIt<PortfolioDao>(), same(getIt<AppDatabase>().portfolioDao));
  });

  test('the holding form gets its own Cubit, for a coin or a holding (two '
      'factory parameters)', () async {
    final fromCoin = getIt<HoldingFormCubit>(param1: 'bitcoin');
    final editing = getIt<HoldingFormCubit>(param2: 7);
    expect((fromCoin.coinId, fromCoin.holdingId), ('bitcoin', null));
    expect((editing.coinId, editing.holdingId), (null, 7));
    await (fromCoin.close(), editing.close()).wait;
  });

  test("a coin's page gets its own Cubit, for its coin (a factory "
      'parameter)', () async {
    final bitcoin = getIt<CoinDetailCubit>(param1: 'bitcoin');
    final ether = getIt<CoinDetailCubit>(param1: 'ethereum');
    expect(bitcoin.coinId, 'bitcoin');
    expect(ether.coinId, 'ethereum');
    await (bitcoin.close(), ether.close()).wait;
  });

  test('one ticker, one history, one scheduler, one repository each: '
      'app-wide singletons', () {
    expect(getIt<PriceTicker>(), same(getIt<PriceTicker>()));
    expect(getIt<PriceHistory>(), same(getIt<PriceHistory>()));
    expect(getIt<TickerScheduler>(), same(getIt<TickerScheduler>()));
    expect(getIt<MarketRepository>(), same(getIt<MarketRepository>()));
  });

  test('each screen gets its own Cubit', () async {
    final a = getIt<MarketCubit>();
    final b = getIt<MarketCubit>();
    expect(a, isNot(same(b)));
    await (a.close(), b.close()).wait;
  });

  test(
    'the settings are ready before the first frame (read synchronously)',
    () {
      expect(getIt<SettingsRepository>().current.livePricesPaused, isFalse);
    },
  );

  test(
    'the real graph loads the bundled market and seeds the ticker',
    () async {
      final result = await getIt<MarketRepository>().loadMarket();

      expect(result, isA<Ok<MarketSeed>>());
      expect((result as Ok<MarketSeed>).value.coins, hasLength(32));
      expect(getIt<PriceTicker>().quotes.value, hasLength(32));
    },
  );
}
