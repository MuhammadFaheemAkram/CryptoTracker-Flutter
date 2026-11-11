import 'package:crypto_tracker/core/storage/settings_local_data_source.dart';
import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// The settings, held in a `BehaviorSubject` seeded from the stored ones.
///
/// The subject makes the settings a stream with a current value: [current]
/// is synchronous, and a pipeline that starts listening later still gets
/// them at once (the ticker scheduler, the market). A change is applied in
/// memory first, so every listener sees it on the same frame, then stored.
///
/// It lives as long as the app, so its subject is never closed (and it's
/// registered under its interface, which has no `dispose` to call).
@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._local)
    : _settings = BehaviorSubject.seeded(_local.read());

  final SettingsLocalDataSource _local;
  final BehaviorSubject<AppSettings> _settings;

  @override
  AppSettings get current => _settings.value;

  @override
  Stream<AppSettings> watch() => _settings.stream;

  @override
  Future<void> update(AppSettings Function(AppSettings settings) change) {
    final previous = _settings.value;
    final next = change(previous);
    if (next == previous) return Future.value();
    _settings.add(next);
    return _local.write(previous, next);
  }
}
