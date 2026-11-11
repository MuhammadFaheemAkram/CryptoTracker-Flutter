import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

/// The settings: now, and as they change.
@injectable
class ObserveSettingsUseCase {
  const ObserveSettingsUseCase(this._settings);

  final SettingsRepository _settings;

  Stream<AppSettings> call() => _settings.watch();
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
