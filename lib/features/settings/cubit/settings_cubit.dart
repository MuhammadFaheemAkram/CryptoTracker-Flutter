import 'dart:async';

import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:crypto_tracker/domain/usecase/settings_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// The user's settings, for the whole app: the theme above the router, and
/// the Settings tab's controls.
///
/// It starts from the settings **as stored** (read synchronously: the
/// preferences were opened before `runApp`), so the very first frame has
/// the right theme (Correctness Rule 14). Then it follows every change,
/// wherever it was made (the Market's Pause button writes the same
/// setting).
///
/// The Cubit writes nothing itself into its state: a change goes to the
/// repository, and comes back through [ObserveSettingsUseCase] like any
/// other. One source of truth, as for the prices.
@lazySingleton
class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(
    CurrentSettingsUseCase currentSettings,
    this._observeSettings,
    this._updateCurrency,
    this._updateInterval,
    this._updateTheme,
    this._setPaused,
  ) : super(currentSettings()) {
    _subscription = _observeSettings().listen(emit);
  }

  final ObserveSettingsUseCase _observeSettings;
  final UpdateCurrencyUseCase _updateCurrency;
  final UpdateIntervalUseCase _updateInterval;
  final UpdateThemeUseCase _updateTheme;
  final SetLivePricesPausedUseCase _setPaused;
  late final StreamSubscription<AppSettings> _subscription;

  Future<void> currencyChanged(Currency currency) => _updateCurrency(currency);

  Future<void> intervalChanged(TickInterval interval) =>
      _updateInterval(interval);

  Future<void> themeChanged(AppThemeMode mode) => _updateTheme(mode);

  /// The Live prices switch: the same setting as the Market's Pause.
  Future<void> livePricesChanged({required bool live}) =>
      _setPaused(paused: !live);

  @override
  @disposeMethod
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
