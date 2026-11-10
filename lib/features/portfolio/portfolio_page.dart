import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:material_ui/material_ui.dart';

/// The Portfolio tab: holdings valued live. Phase 5 fills it.
class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio')),
      body: EmptyStateView(
        icon: Icons.pie_chart_outline,
        title: 'The portfolio arrives in Phase 5',
        message: 'Its value and P/L will move with every price tick.',
        action: FilledButton.tonal(
          onPressed: () => const NewHoldingRoute().push<void>(context),
          child: const Text('Add holding'),
        ),
      ),
    );
  }
}
