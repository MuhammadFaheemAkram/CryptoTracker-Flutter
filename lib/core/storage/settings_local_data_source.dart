import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The settings in `shared_preferences`, one key each.
///
/// `SharedPreferencesWithCache` reads everything once at startup (it's
/// created before `runApp`), so [read] is synchronous. Enums are stored by
/// name; a value the app doesn't know (an old version's, or a typo) falls
/// back to the default rather than failing.
@lazySingleton
class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._preferences);

  final SharedPreferencesWithCache _preferences;

  static const currencyKey = 'settings.currency';
  static const intervalKey = 'settings.interval';
  static const pausedKey = 'settings.livePricesPaused';
  static const themeModeKey = 'settings.themeMode';

  /// The only keys the cache loads and allows.
  static const allowList = {currencyKey, intervalKey, pausedKey, themeModeKey};

  AppSettings read() {
    const defaults = AppSettings();
    return AppSettings(
      currency: _enum(Currency.values, currencyKey) ?? defaults.currency,
      interval: _enum(TickInterval.values, intervalKey) ?? defaults.interval,
      livePricesPaused:
          _preferences.getBool(pausedKey) ?? defaults.livePricesPaused,
      themeMode: _enum(AppThemeMode.values, themeModeKey) ?? defaults.themeMode,
    );
  }

  /// Stores [next], writing only the keys that differ from [previous].
  Future<void> write(AppSettings previous, AppSettings next) async {
    await [
      if (next.currency != previous.currency)
        _preferences.setString(currencyKey, next.currency.name),
      if (next.interval != previous.interval)
        _preferences.setString(intervalKey, next.interval.name),
      if (next.livePricesPaused != previous.livePricesPaused)
        _preferences.setBool(pausedKey, next.livePricesPaused),
      if (next.themeMode != previous.themeMode)
        _preferences.setString(themeModeKey, next.themeMode.name),
    ].wait;
  }

  T? _enum<T extends Enum>(List<T> values, String key) {
    final name = _preferences.getString(key);
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
