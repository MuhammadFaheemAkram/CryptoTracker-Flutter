import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:crypto_tracker/domain/usecase/settings_use_cases.dart';
import 'package:crypto_tracker/features/settings/cubit/settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_settings_repository.dart';

void main() {
  late FakeSettingsRepository settings;
  late SettingsCubit cubit;

  SettingsCubit newCubit() => SettingsCubit(
    CurrentSettingsUseCase(settings),
    ObserveSettingsUseCase(settings),
    UpdateCurrencyUseCase(settings),
    UpdateIntervalUseCase(settings),
    UpdateThemeUseCase(settings),
    SetLivePricesPausedUseCase(settings),
  );

  setUp(() {
    settings = FakeSettingsRepository(
      const AppSettings(themeMode: AppThemeMode.dark, currency: Currency.eur),
    );
    cubit = newCubit();
  });
  tearDown(() async {
    await cubit.close();
    await settings.dispose();
  });

  test('starts from the stored settings, synchronously: the first frame '
      'has the theme (Correctness Rule 14)', () {
    expect(cubit.state.themeMode, AppThemeMode.dark);
    expect(cubit.state.currency, Currency.eur);
  });

  test(
    'every control writes the repository, and the state follows it',
    () async {
      await cubit.currencyChanged(Currency.jpy);
      await cubit.intervalChanged(TickInterval.oneSecond);
      await cubit.themeChanged(AppThemeMode.light);
      await cubit.livePricesChanged(live: false);
      await pumpEventQueue();

      const expected = AppSettings(
        currency: Currency.jpy,
        interval: TickInterval.oneSecond,
        themeMode: AppThemeMode.light,
        livePricesPaused: true,
      );
      expect(settings.current, expected);
      expect(cubit.state, expected);
    },
  );

  test('a change made elsewhere (the Market\'s Pause) shows here', () async {
    await SetLivePricesPausedUseCase(settings)(paused: true);
    await pumpEventQueue();

    expect(cubit.state.livePricesPaused, isTrue);
  });

  test('close: nothing after it', () async {
    await cubit.close();
    final before = cubit.state;

    await settings.update((s) => s.copyWith(currency: Currency.gbp));
    await pumpEventQueue();

    expect(cubit.state, before);
  });
}
