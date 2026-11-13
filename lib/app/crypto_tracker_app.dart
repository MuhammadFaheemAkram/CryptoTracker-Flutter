import 'package:crypto_tracker/app/live_ticker.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/navigation/app_router.dart';
import 'package:crypto_tracker/core/prices/ticker_scheduler.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/features/settings/cubit/settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The root widget: themes and the router.
///
/// This `State` owns the router and disposes it. The router is created once,
/// not in `build`: a new router on every rebuild would reset navigation.
/// The app-scoped pieces go here, above `MaterialApp.router`: [LiveTicker]
/// (it starts and stops the price ticker) and [SettingsCubit] (the theme
/// here, and the Settings tab's controls below). The Cubit starts from the
/// stored settings, so the first frame already has the chosen theme.
class CryptoTrackerApp extends StatefulWidget {
  const CryptoTrackerApp({super.key, this.initialLocation});

  /// Lets tests start on a deep link. The app itself starts on the Market.
  final String? initialLocation;

  @override
  State<CryptoTrackerApp> createState() => _CryptoTrackerAppState();
}

class _CryptoTrackerAppState extends State<CryptoTrackerApp> {
  late final GoRouter _router = createAppRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // A lazy singleton: the DI root owns it and closes it (`getIt.reset`).
      value: getIt<SettingsCubit>(),
      child: LiveTicker(
        scheduler: getIt<TickerScheduler>(),
        // Only the theme mode rebuilds the app: a currency change reaches
        // the screens through their own pipelines.
        child: BlocSelector<SettingsCubit, AppSettings, AppThemeMode>(
          selector: (settings) => settings.themeMode,
          builder: (context, mode) => MaterialApp.router(
            title: 'CryptoTracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: switch (mode) {
              AppThemeMode.system => ThemeMode.system,
              AppThemeMode.light => ThemeMode.light,
              AppThemeMode.dark => ThemeMode.dark,
            },
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}
