// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:math' as _i407;

import 'package:clock/clock.dart' as _i454;
import 'package:crypto_tracker/core/database/app_database.dart' as _i36;
import 'package:crypto_tracker/core/database/daos/portfolio_dao.dart' as _i486;
import 'package:crypto_tracker/core/database/daos/watchlist_dao.dart' as _i576;
import 'package:crypto_tracker/core/network/asset_json_loader.dart' as _i223;
import 'package:crypto_tracker/core/network/fake_market_api.dart' as _i771;
import 'package:crypto_tracker/core/network/market_api.dart' as _i253;
import 'package:crypto_tracker/core/prices/price_history.dart' as _i469;
import 'package:crypto_tracker/core/prices/price_ticker.dart' as _i611;
import 'package:crypto_tracker/core/prices/random_walk.dart' as _i607;
import 'package:crypto_tracker/core/prices/ticker_scheduler.dart' as _i501;
import 'package:crypto_tracker/core/storage/settings_local_data_source.dart'
    as _i406;
import 'package:crypto_tracker/data/repository/market_repository_impl.dart'
    as _i434;
import 'package:crypto_tracker/data/repository/portfolio_repository_impl.dart'
    as _i56;
import 'package:crypto_tracker/data/repository/settings_repository_impl.dart'
    as _i937;
import 'package:crypto_tracker/data/repository/watchlist_repository_impl.dart'
    as _i34;
import 'package:crypto_tracker/di/app_module.dart' as _i799;
import 'package:crypto_tracker/domain/repository/market_repository.dart'
    as _i847;
import 'package:crypto_tracker/domain/repository/portfolio_repository.dart'
    as _i125;
import 'package:crypto_tracker/domain/repository/settings_repository.dart'
    as _i782;
import 'package:crypto_tracker/domain/repository/watchlist_repository.dart'
    as _i585;
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart'
    as _i54;
import 'package:crypto_tracker/domain/usecase/observe_coin_detail_use_case.dart'
    as _i11;
import 'package:crypto_tracker/domain/usecase/observe_coin_price_use_case.dart'
    as _i646;
import 'package:crypto_tracker/domain/usecase/observe_market_use_case.dart'
    as _i524;
import 'package:crypto_tracker/domain/usecase/observe_portfolio_use_case.dart'
    as _i561;
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart'
    as _i128;
import 'package:crypto_tracker/domain/usecase/observe_watchlist_rows_use_case.dart'
    as _i171;
import 'package:crypto_tracker/domain/usecase/portfolio_use_cases.dart'
    as _i1003;
import 'package:crypto_tracker/domain/usecase/settings_use_cases.dart' as _i13;
import 'package:crypto_tracker/domain/usecase/watchlist_use_cases.dart'
    as _i301;
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_cubit.dart'
    as _i16;
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_cubit.dart'
    as _i55;
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart'
    as _i428;
import 'package:crypto_tracker/features/portfolio/cubit/portfolio_cubit.dart'
    as _i651;
import 'package:crypto_tracker/features/watchlist/cubit/watchlist_cubit.dart'
    as _i137;
import 'package:flutter/services.dart' as _i281;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i454.Clock>(() => appModule.clock);
    gh.lazySingleton<_i407.Random>(() => appModule.random);
    gh.lazySingleton<_i36.AppDatabase>(() => appModule.database);
    gh.lazySingleton<_i281.AssetBundle>(() => appModule.assetBundle);
    await gh.lazySingletonAsync<_i460.SharedPreferencesWithCache>(
      () => appModule.preferences,
      preResolve: true,
    );
    gh.lazySingleton<_i607.RandomWalk>(
      () => _i607.RandomWalk(gh<_i407.Random>()),
    );
    gh.lazySingleton<_i611.PriceTicker>(
      () => _i611.PriceTicker(gh<_i607.RandomWalk>(), gh<_i454.Clock>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i406.SettingsLocalDataSource>(
      () =>
          _i406.SettingsLocalDataSource(gh<_i460.SharedPreferencesWithCache>()),
    );
    gh.singleton<_i469.PriceHistory>(
      () => _i469.PriceHistory(gh<_i611.PriceTicker>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i223.AssetJsonLoader>(
      () => _i223.AssetJsonLoader(gh<_i281.AssetBundle>()),
    );
    gh.lazySingleton<_i782.SettingsRepository>(
      () => _i937.SettingsRepositoryImpl(gh<_i406.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i576.WatchlistDao>(
      () => appModule.watchlistDao(gh<_i36.AppDatabase>()),
    );
    gh.lazySingleton<_i486.PortfolioDao>(
      () => appModule.portfolioDao(gh<_i36.AppDatabase>()),
    );
    gh.lazySingleton<_i253.MarketApi>(
      () => _i771.FakeMarketApi(gh<_i223.AssetJsonLoader>()),
    );
    gh.lazySingleton<_i125.PortfolioRepository>(
      () => _i56.PortfolioRepositoryImpl(
        gh<_i486.PortfolioDao>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.lazySingleton<_i501.TickerScheduler>(
      () => _i501.TickerScheduler(
        gh<_i611.PriceTicker>(),
        gh<_i782.SettingsRepository>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i13.ObserveSettingsUseCase>(
      () => _i13.ObserveSettingsUseCase(gh<_i782.SettingsRepository>()),
    );
    gh.factory<_i13.CurrentSettingsUseCase>(
      () => _i13.CurrentSettingsUseCase(gh<_i782.SettingsRepository>()),
    );
    gh.factory<_i13.SetLivePricesPausedUseCase>(
      () => _i13.SetLivePricesPausedUseCase(gh<_i782.SettingsRepository>()),
    );
    gh.lazySingleton<_i847.MarketRepository>(
      () => _i434.MarketRepositoryImpl(
        gh<_i253.MarketApi>(),
        gh<_i454.Clock>(),
        gh<_i611.PriceTicker>(),
        gh<_i469.PriceHistory>(),
      ),
    );
    gh.lazySingleton<_i585.WatchlistRepository>(
      () => _i34.WatchlistRepositoryImpl(
        gh<_i576.WatchlistDao>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.factory<_i1003.FindHoldingUseCase>(
      () => _i1003.FindHoldingUseCase(gh<_i125.PortfolioRepository>()),
    );
    gh.factory<_i1003.AddHoldingUseCase>(
      () => _i1003.AddHoldingUseCase(gh<_i125.PortfolioRepository>()),
    );
    gh.factory<_i1003.UpdateHoldingUseCase>(
      () => _i1003.UpdateHoldingUseCase(gh<_i125.PortfolioRepository>()),
    );
    gh.factory<_i1003.RemoveHoldingUseCase>(
      () => _i1003.RemoveHoldingUseCase(gh<_i125.PortfolioRepository>()),
    );
    gh.factory<_i1003.RestoreHoldingUseCase>(
      () => _i1003.RestoreHoldingUseCase(gh<_i125.PortfolioRepository>()),
    );
    gh.factory<_i54.LoadMarketUseCase>(
      () => _i54.LoadMarketUseCase(gh<_i847.MarketRepository>()),
    );
    gh.factory<_i646.ObserveCoinPriceUseCase>(
      () => _i646.ObserveCoinPriceUseCase(gh<_i847.MarketRepository>()),
    );
    gh.factory<_i128.ObservePriceMovesUseCase>(
      () => _i128.ObservePriceMovesUseCase(gh<_i847.MarketRepository>()),
    );
    gh.factory<_i171.ObserveWatchlistRowsUseCase>(
      () => _i171.ObserveWatchlistRowsUseCase(
        gh<_i128.ObservePriceMovesUseCase>(),
        gh<_i585.WatchlistRepository>(),
        gh<_i782.SettingsRepository>(),
      ),
    );
    gh.factory<_i524.ObserveMarketUseCase>(
      () => _i524.ObserveMarketUseCase(
        gh<_i128.ObservePriceMovesUseCase>(),
        gh<_i782.SettingsRepository>(),
        gh<_i585.WatchlistRepository>(),
      ),
    );
    gh.factory<_i301.ObserveWatchlistUseCase>(
      () => _i301.ObserveWatchlistUseCase(gh<_i585.WatchlistRepository>()),
    );
    gh.factory<_i301.ToggleWatchUseCase>(
      () => _i301.ToggleWatchUseCase(gh<_i585.WatchlistRepository>()),
    );
    gh.factory<_i301.RemoveFromWatchlistUseCase>(
      () => _i301.RemoveFromWatchlistUseCase(gh<_i585.WatchlistRepository>()),
    );
    gh.factory<_i301.RestoreWatchedCoinUseCase>(
      () => _i301.RestoreWatchedCoinUseCase(gh<_i585.WatchlistRepository>()),
    );
    gh.factory<_i561.ObservePortfolioUseCase>(
      () => _i561.ObservePortfolioUseCase(
        gh<_i128.ObservePriceMovesUseCase>(),
        gh<_i125.PortfolioRepository>(),
        gh<_i782.SettingsRepository>(),
      ),
    );
    gh.factory<_i11.ObserveCoinDetailUseCase>(
      () => _i11.ObserveCoinDetailUseCase(
        gh<_i128.ObservePriceMovesUseCase>(),
        gh<_i847.MarketRepository>(),
        gh<_i585.WatchlistRepository>(),
        gh<_i782.SettingsRepository>(),
      ),
    );
    gh.factory<_i428.MarketCubit>(
      () => _i428.MarketCubit(
        gh<_i54.LoadMarketUseCase>(),
        gh<_i524.ObserveMarketUseCase>(),
        gh<_i13.SetLivePricesPausedUseCase>(),
        gh<_i301.ToggleWatchUseCase>(),
      ),
    );
    gh.factoryParam<_i16.CoinDetailCubit, String, dynamic>(
      (coinId, _) => _i16.CoinDetailCubit(
        coinId,
        gh<_i54.LoadMarketUseCase>(),
        gh<_i11.ObserveCoinDetailUseCase>(),
        gh<_i301.ToggleWatchUseCase>(),
      ),
    );
    gh.factoryParam<_i55.HoldingFormCubit, String?, int?>(
      (coinId, holdingId) => _i55.HoldingFormCubit(
        coinId,
        holdingId,
        gh<_i54.LoadMarketUseCase>(),
        gh<_i1003.FindHoldingUseCase>(),
        gh<_i1003.AddHoldingUseCase>(),
        gh<_i1003.UpdateHoldingUseCase>(),
        gh<_i646.ObserveCoinPriceUseCase>(),
        gh<_i13.CurrentSettingsUseCase>(),
      ),
    );
    gh.factory<_i137.WatchlistCubit>(
      () => _i137.WatchlistCubit(
        gh<_i54.LoadMarketUseCase>(),
        gh<_i171.ObserveWatchlistRowsUseCase>(),
        gh<_i301.RemoveFromWatchlistUseCase>(),
        gh<_i301.RestoreWatchedCoinUseCase>(),
      ),
    );
    gh.factory<_i651.PortfolioCubit>(
      () => _i651.PortfolioCubit(
        gh<_i54.LoadMarketUseCase>(),
        gh<_i561.ObservePortfolioUseCase>(),
        gh<_i1003.RemoveHoldingUseCase>(),
        gh<_i1003.RestoreHoldingUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i799.AppModule {}
