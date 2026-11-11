import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// The user's preferences. Stored on the device, read before the first
/// frame (the theme never flashes, Correctness Rule 14).
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(Currency.usd) Currency currency,
    @Default(TickInterval.twoSeconds) TickInterval interval,

    /// Live prices stopped by the user. Moving content must be pausable
    /// (WCAG 2.2.2, "Pause, Stop, Hide"), and resuming keeps [interval].
    @Default(false) bool livePricesPaused,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
  }) = _AppSettings;
}
