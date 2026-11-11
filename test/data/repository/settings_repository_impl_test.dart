import 'package:async/async.dart';
import 'package:crypto_tracker/core/storage/settings_local_data_source.dart';
import 'package:crypto_tracker/data/repository/settings_repository_impl.dart';
import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferencesWithCache preferences;
  late SettingsRepositoryImpl repository;

  setUp(() async {
    preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: SettingsLocalDataSource.allowList,
      ),
    );
    repository = SettingsRepositoryImpl(SettingsLocalDataSource(preferences));
  });

  test('the stored settings are there at once (current is synchronous)', () {
    expect(repository.current, const AppSettings());
  });

  test('watch: the current settings at once, then each change', () async {
    final changes = StreamQueue(repository.watch());
    expect(await changes.next, const AppSettings());

    await repository.update((s) => s.copyWith(currency: Currency.eur));

    expect(await changes.next, const AppSettings(currency: Currency.eur));
    await changes.cancel();
  });

  test('a change applies in memory at once, and is stored', () async {
    final updating = repository.update(
      (s) => s.copyWith(livePricesPaused: true),
    );
    expect(repository.current.livePricesPaused, isTrue);
    await updating;

    expect(
      SettingsLocalDataSource(preferences).read().livePricesPaused,
      isTrue,
    );
  });

  test('a change to the same settings emits nothing', () async {
    final emitted = <AppSettings>[];
    final subscription = repository.watch().listen(emitted.add);
    await pumpEventQueue();

    await repository.update((s) => s);
    await pumpEventQueue();

    expect(emitted, hasLength(1));
    await subscription.cancel();
  });
}
