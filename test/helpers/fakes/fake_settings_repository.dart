import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:rxdart/rxdart.dart';

/// A [SettingsRepository] in memory, starting from [initial].
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository([AppSettings initial = const AppSettings()])
    : _settings = BehaviorSubject.seeded(initial);

  final BehaviorSubject<AppSettings> _settings;

  @override
  AppSettings get current => _settings.value;

  @override
  Stream<AppSettings> watch() => _settings.stream;

  @override
  Future<void> update(AppSettings Function(AppSettings settings) change) async {
    final next = change(_settings.value);
    if (next != _settings.value) _settings.add(next);
  }

  Future<void> dispose() => _settings.close();
}
