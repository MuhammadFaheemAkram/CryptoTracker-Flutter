import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/domain/model/app_info.dart';
import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:crypto_tracker/features/settings/cubit/settings_cubit.dart';
import 'package:crypto_tracker/features/settings/settings_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class _MockSettingsCubit extends MockCubit<AppSettings>
    implements SettingsCubit {}

void main() {
  late _MockSettingsCubit cubit;
  late int licenses;

  setUpAll(() {
    registerFallbackValue(Currency.usd);
    registerFallbackValue(TickInterval.oneSecond);
    registerFallbackValue(AppThemeMode.system);
  });

  setUp(() {
    cubit = _MockSettingsCubit();
    licenses = 0;
    when(() => cubit.currencyChanged(any())).thenAnswer((_) async {});
    when(() => cubit.intervalChanged(any())).thenAnswer((_) async {});
    when(() => cubit.themeChanged(any())).thenAnswer((_) async {});
    when(() => cubit.livePricesChanged(live: any(named: 'live')))
        .thenAnswer((_) async {});
  });

  Future<void> show(
    WidgetTester tester, [
    AppSettings settings = const AppSettings(),
  ]) async {
    when(() => cubit.state).thenReturn(settings);
    await tester.pumpScreen(
      BlocProvider<SettingsCubit>.value(
        value: cubit,
        child: SettingsView(
          appInfo: const AppInfo(
            name: 'CryptoTracker',
            version: '1.0.0',
            buildNumber: '7',
          ),
          onShowLicenses: () => licenses++,
        ),
      ),
    );
  }

  testWidgets('the currency: picking one asks the Cubit', (tester) async {
    await show(tester);

    await tester.tap(find.text('Euro'));

    verify(() => cubit.currencyChanged(Currency.eur)).called(1);
  });

  testWidgets('live prices: the switch shows the setting and changes it', (
    tester,
  ) async {
    await show(tester, const AppSettings(livePricesPaused: true));

    final live = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(live.value, isFalse);
    await tester.tap(find.byType(SwitchListTile));
    verify(() => cubit.livePricesChanged(live: true)).called(1);
  });

  testWidgets('the interval: shown, and choosable even while paused', (
    tester,
  ) async {
    await show(tester, const AppSettings(livePricesPaused: true));
    await tester.scrollUntilVisible(find.text('5 s'), 100);

    final button = tester.widget<SegmentedButton<TickInterval>>(
      find.byType(SegmentedButton<TickInterval>),
    );
    expect(button.selected, {TickInterval.twoSeconds});
    await tester.tap(find.text('5 s'));
    verify(() => cubit.intervalChanged(TickInterval.fiveSeconds)).called(1);
  });

  testWidgets('the appearance', (tester) async {
    await show(tester, const AppSettings(themeMode: AppThemeMode.dark));
    await tester.scrollUntilVisible(find.text('Light'), 100);

    final button = tester.widget<SegmentedButton<AppThemeMode>>(
      find.byType(SegmentedButton<AppThemeMode>),
    );
    expect(button.selected, {AppThemeMode.dark});
    await tester.tap(find.text('Light'));
    verify(() => cubit.themeChanged(AppThemeMode.light)).called(1);
  });

  testWidgets('About: the version, the simulated-prices note, the licenses', (
    tester,
  ) async {
    await show(tester);
    await tester.scrollUntilVisible(find.text('Open-source licenses'), 100);

    expect(find.text('Version 1.0.0 (7)'), findsOneWidget);
    expect(
      find.text('Prices are simulated, not real market data.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Open-source licenses'));
    expect(licenses, 1);
  });

  testWidgets('large text: the segments stack, nothing overflows', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await show(tester);
    await tester.scrollUntilVisible(find.text('5 s'), 100);

    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.text('1 s')).dy,
      lessThan(tester.getTopLeft(find.text('5 s')).dy),
    );
  });
}
