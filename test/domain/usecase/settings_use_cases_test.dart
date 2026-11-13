import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:crypto_tracker/domain/usecase/settings_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_settings_repository.dart';

void main() {
  late FakeSettingsRepository settings;

  setUp(
    () => settings = FakeSettingsRepository(
      const AppSettings(livePricesPaused: true),
    ),
  );
  tearDown(() => settings.dispose());

  test('each update changes its own setting, and only it', () async {
    await UpdateCurrencyUseCase(settings)(Currency.gbp);
    await UpdateIntervalUseCase(settings)(TickInterval.fiveSeconds);
    await UpdateThemeUseCase(settings)(AppThemeMode.dark);

    expect(
      settings.current,
      const AppSettings(
        currency: Currency.gbp,
        interval: TickInterval.fiveSeconds,
        themeMode: AppThemeMode.dark,
        livePricesPaused: true,
      ),
    );
  });

  test('the current settings are read at once (no waiting)', () {
    expect(CurrentSettingsUseCase(settings)().livePricesPaused, isTrue);
  });
}
