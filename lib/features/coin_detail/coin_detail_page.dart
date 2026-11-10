import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:crypto_tracker/core/navigation/fallback_close_button.dart';
import 'package:material_ui/material_ui.dart';

/// One coin, pushed above the tabs. Phase 4 shows its live price, stats and
/// chart, with the coin's name as the title.
class CoinDetailPage extends StatelessWidget {
  const CoinDetailPage({super.key, required this.coinId});

  final String coinId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin'),
        // Opened by a link, there is nothing to go back to: Close goes to
        // the Market.
        leading: fallbackCloseButton(
          context,
          () => const MarketRoute().go(context),
        ),
      ),
      body: EmptyStateView(
        icon: Icons.currency_bitcoin,
        title: 'Coin "$coinId"',
        message: 'Its live price, stats and chart arrive in Phase 4.',
        action: FilledButton.tonal(
          onPressed: () => NewHoldingRoute(coinId: coinId).push<void>(context),
          child: const Text('Add to portfolio'),
        ),
      ),
    );
  }
}
