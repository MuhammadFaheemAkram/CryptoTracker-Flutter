import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

/// The settings: now, and as they change.
@injectable
class ObserveSettingsUseCase {
  const ObserveSettingsUseCase(this._settings);

  final SettingsRepository _settings;

  Stream<AppSettings> call() => _settings.watch();
}

/// The settings now, read once (the holding form takes the currency the
/// buy price is typed in when it opens).
@injectable
class CurrentSettingsUseCase {
  const CurrentSettingsUseCase(this._settings);

  final SettingsRepository _settings;

  AppSettings call() => _settings.current;
}

/// Pauses or resumes live prices. Resuming keeps the interval the user
/// chose.
@injectable
class SetLivePricesPausedUseCase {
  const SetLivePricesPausedUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call({required bool paused}) => _settings.update(
    (settings) => settings.copyWith(livePricesPaused: paused),
  );
}

/// Settings → Currency: every price on every screen converts (Correctness
/// Rule 2), through each pipeline's settings input.
@injectable
class UpdateCurrencyUseCase {
  const UpdateCurrencyUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call(Currency currency) =>
      _settings.update((settings) => settings.copyWith(currency: currency));
}

/// Settings → Update interval: the ticker restarts at the new period, from
/// the current prices (no jump, Correctness Rule 8).
@injectable
class UpdateIntervalUseCase {
  const UpdateIntervalUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call(TickInterval interval) =>
      _settings.update((settings) => settings.copyWith(interval: interval));
}

/// Settings → Appearance: System, Light or Dark.
@injectable
class UpdateThemeUseCase {
  const UpdateThemeUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call(AppThemeMode mode) =>
      _settings.update((settings) => settings.copyWith(themeMode: mode));
}
