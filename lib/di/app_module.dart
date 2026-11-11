import 'dart:math';

import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/storage/settings_local_data_source.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Third-party types the app's classes depend on, which can't carry
/// `injectable` annotations themselves.
@module
abstract class AppModule {
  /// "Now" for every timestamp. Tests replace it with a fixed clock.
  @lazySingleton
  Clock get clock => const Clock();

  /// The randomness behind the simulated market. Tests use a seeded one.
  @lazySingleton
  Random get random => Random();

  /// The app bundle, where the fake market service reads its JSON.
  @lazySingleton
  AssetBundle get assetBundle => rootBundle;

  /// `@preResolve` awaits this while the composition root is built, before
  /// `runApp`, so the settings are read synchronously from the first frame:
  /// the app opens in the chosen theme and currency, with no flash of the
  /// defaults (Correctness Rule 14).
  @preResolve
  @lazySingleton
  Future<SharedPreferencesWithCache> get preferences =>
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: SettingsLocalDataSource.allowList,
        ),
      );
}
