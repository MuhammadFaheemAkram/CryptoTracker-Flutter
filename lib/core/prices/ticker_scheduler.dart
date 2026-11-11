import 'dart:async';

import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// Decides when the [PriceTicker] runs, and how fast: a small pipeline
/// with one side effect.
///
/// ```
/// foreground ── switchMap ─▶ true:  settings ─▶ interval, or null if paused
///                            false: null (stopped)
///            ── distinct ─▶ start(interval) | stop()
/// ```
///
/// `switchMap` is the point: while the app is in the background it isn't
/// listening to the settings at all, and when the app comes back it
/// switches to them again, picking up the current values (they live in a
/// `BehaviorSubject`). `distinct` means a change to the currency or the
/// theme never restarts the ticker. Only the interval or the pause does.
@lazySingleton
class TickerScheduler {
  TickerScheduler(this._ticker, this._settings);

  final PriceTicker _ticker;
  final SettingsRepository _settings;

  final _foreground = BehaviorSubject<bool>.seeded(true);
  StreamSubscription<Duration?>? _subscription;

  /// Starts following the foreground and the settings. Calling it again
  /// does nothing.
  void attach() {
    _subscription ??= _foreground
        .distinct()
        .switchMap(
          (foreground) => foreground
              ? _settings.watch().map(_periodOf)
              : Stream<Duration?>.value(null),
        )
        .distinct()
        .listen(_apply);
  }

  /// The app came to the foreground (`true`) or left it (`false`). Prices
  /// stop in the background: nobody sees them, and a timer would keep the
  /// app busy for nothing.
  void setForeground({required bool foreground}) {
    if (!_foreground.isClosed) _foreground.add(foreground);
  }

  /// Stops following, and stops the ticker.
  Future<void> detach() async {
    await _subscription?.cancel();
    _subscription = null;
    _ticker.stop();
  }

  static Duration? _periodOf(AppSettings settings) =>
      settings.livePricesPaused ? null : settings.interval.period;

  void _apply(Duration? period) =>
      period == null ? _ticker.stop() : _ticker.start(period);

  @disposeMethod
  Future<void> dispose() async {
    await detach();
    await _foreground.close();
  }
}
