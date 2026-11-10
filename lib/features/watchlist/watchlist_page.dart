import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:material_ui/material_ui.dart';

/// The Watchlist tab: the starred coins, live. Phase 4 fills it.
class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: const EmptyStateView(
        icon: Icons.star_outline,
        title: 'The watchlist arrives in Phase 4',
        message: 'Starred coins will update here as their prices move.',
      ),
    );
  }
}
