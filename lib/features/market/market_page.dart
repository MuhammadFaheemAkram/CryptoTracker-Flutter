import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:material_ui/material_ui.dart';

/// The Market tab: every coin, live. Phase 2 lists the seed; Phase 3 makes
/// it tick.
class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market')),
      body: EmptyStateView(
        icon: Icons.show_chart,
        title: 'The market arrives in Phase 2',
        message: 'A coin and the holding form already have their routes.',
        action: FilledButton.tonal(
          onPressed: () =>
              const CoinDetailRoute(coinId: 'bitcoin').push<void>(context),
          child: const Text('Open Bitcoin'),
        ),
      ),
    );
  }
}
