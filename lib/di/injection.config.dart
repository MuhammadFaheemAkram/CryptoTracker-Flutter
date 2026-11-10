// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:clock/clock.dart' as _i454;
import 'package:crypto_tracker/core/network/asset_json_loader.dart' as _i223;
import 'package:crypto_tracker/core/network/fake_market_api.dart' as _i771;
import 'package:crypto_tracker/core/network/market_api.dart' as _i253;
import 'package:crypto_tracker/data/repository/market_repository_impl.dart'
    as _i434;
import 'package:crypto_tracker/di/app_module.dart' as _i799;
import 'package:crypto_tracker/domain/repository/market_repository.dart'
    as _i847;
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart'
    as _i54;
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart'
    as _i428;
import 'package:flutter/services.dart' as _i281;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i454.Clock>(() => appModule.clock);
    gh.lazySingleton<_i281.AssetBundle>(() => appModule.assetBundle);
    gh.lazySingleton<_i223.AssetJsonLoader>(
      () => _i223.AssetJsonLoader(gh<_i281.AssetBundle>()),
    );
    gh.lazySingleton<_i253.MarketApi>(
      () => _i771.FakeMarketApi(gh<_i223.AssetJsonLoader>()),
    );
    gh.lazySingleton<_i847.MarketRepository>(
      () =>
          _i434.MarketRepositoryImpl(gh<_i253.MarketApi>(), gh<_i454.Clock>()),
    );
    gh.factory<_i54.LoadMarketUseCase>(
      () => _i54.LoadMarketUseCase(gh<_i847.MarketRepository>()),
    );
    gh.factory<_i428.MarketCubit>(
      () => _i428.MarketCubit(gh<_i54.LoadMarketUseCase>()),
    );
    return this;
  }
}

class _$AppModule extends _i799.AppModule {}
