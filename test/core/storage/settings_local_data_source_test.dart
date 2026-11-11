import 'package:crypto_tracker/core/storage/settings_local_data_source.dart';
import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

// On the real SharedPreferencesWithCache, over the in-memory platform that
// flutter_test_config.dart installs for every test.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<SharedPreferencesWithCache> open() =>
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: SettingsLocalDataSource.allowList,
        ),
      );

  Future<void> store(String key, Object value) {
    const options = SharedPreferencesOptions();
    final platform = SharedPreferencesAsyncPlatform.instance!;
    return switch (value) {
      final bool flag => platform.setBool(key, flag, options),
      _ => platform.setString(key, '$value', options),
    };
  }

  test('nothing stored: the defaults', () async {
    final local = SettingsLocalDataSource(await open());

    expect(local.read(), const AppSettings());
  });

  test('reads what was stored (synchronously, once open)', () async {
    await store(SettingsLocalDataSource.currencyKey, 'eur');
    await store(SettingsLocalDataSource.intervalKey, 'fiveSeconds');
    await store(SettingsLocalDataSource.pausedKey, true);
    await store(SettingsLocalDataSource.themeModeKey, 'dark');

    final local = SettingsLocalDataSource(await open());

    expect(
      local.read(),
      const AppSettings(
        currency: Currency.eur,
        interval: TickInterval.fiveSeconds,
        livePricesPaused: true,
        themeMode: AppThemeMode.dark,
      ),
    );
  });

  test('a value the app doesn\'t know falls back to the default', () async {
    await store(SettingsLocalDataSource.currencyKey, 'doge');
    await store(SettingsLocalDataSource.intervalKey, 'paused'); // an old one

    final local = SettingsLocalDataSource(await open());

    expect(local.read().currency, Currency.usd);
    expect(local.read().interval, TickInterval.twoSeconds);
  });

  test(
    'a write survives a restart (a new cache over the same storage)',
    () async {
      final local = SettingsLocalDataSource(await open());
      const changed = AppSettings(
        currency: Currency.gbp,
        interval: TickInterval.oneSecond,
        livePricesPaused: true,
        themeMode: AppThemeMode.light,
      );

      await local.write(const AppSettings(), changed);

      expect(SettingsLocalDataSource(await open()).read(), changed);
    },
  );

  test('only the keys that changed are written, whichever they are '
      '(Rule 14)', () async {
    final local = SettingsLocalDataSource(await open());

    await local.write(
      const AppSettings(),
      const AppSettings(livePricesPaused: true),
    );

    final stored = await SharedPreferencesAsyncPlatform.instance!.getKeys(
      const GetPreferencesParameters(filter: PreferencesFilters()),
      const SharedPreferencesOptions(),
    );
    expect(stored, {SettingsLocalDataSource.pausedKey});
  });

  test('only the keys that changed are written (Rule 14)', () async {
    final local = SettingsLocalDataSource(await open());

    await local.write(
      const AppSettings(),
      const AppSettings(currency: Currency.jpy),
    );

    final stored = await SharedPreferencesAsyncPlatform.instance!.getKeys(
      const GetPreferencesParameters(filter: PreferencesFilters()),
      const SharedPreferencesOptions(),
    );
    expect(stored, {SettingsLocalDataSource.currencyKey});
  });
}
