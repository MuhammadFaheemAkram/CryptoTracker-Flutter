import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Creates the app's [GoRouter].
///
/// A factory rather than a global: the app widget owns one router for its
/// lifetime, and every widget test starts from a fresh one.
GoRouter createAppRouter({String? initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation ?? const MarketRoute().location,
    routes: $appRoutes,
    // The bare root is the Market, as on launch.
    redirect: (context, state) =>
        state.uri.path == '/' ? const MarketRoute().location : null,
    errorBuilder: (context, state) =>
        _NotFoundPage(location: state.uri.toString()),
  );
}

/// Shown when a location matches no route, e.g. a mistyped deep link.
class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: EmptyStateView(
        icon: Icons.travel_explore_outlined,
        title: 'Page not found',
        message: 'Nothing lives at "$location".',
        action: FilledButton.tonal(
          onPressed: () => const MarketRoute().go(context),
          child: const Text('Go to the Market'),
        ),
      ),
    );
  }
}
