import 'package:crypto_tracker/domain/model/app_settings.dart';

/// The user's preferences: read at once, watched as they change.
abstract interface class SettingsRepository {
  /// The settings now. Synchronous: they were read before the first frame,
  /// so the app starts in the right theme and currency (Rule 14).
  AppSettings get current;

  /// The current settings at once, then every change. Each pipeline maps
  /// it to the part it needs (`distinct`, so a change elsewhere doesn't
  /// reach it).
  Stream<AppSettings> watch();

  /// Applies [change] to the current settings and stores the result.
  Future<void> update(AppSettings Function(AppSettings settings) change);
}
