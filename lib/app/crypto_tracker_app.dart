import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/navigation/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The root widget: themes and the router.
///
/// This `State` owns the router and disposes it. The router is created once,
/// not in `build`: a new router on every rebuild would reset navigation.
/// The app-scoped pieces go here, above `MaterialApp.router`: `LiveTicker`
/// (Phase 3: it starts and stops the price ticker) and `SettingsCubit`
/// (Phase 6: the theme and the currency).
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
    return MaterialApp.router(
      title: 'CryptoTracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: _router,
    );
  }
}
