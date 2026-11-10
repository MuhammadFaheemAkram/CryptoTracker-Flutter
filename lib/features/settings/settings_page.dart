import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:material_ui/material_ui.dart';

/// The Settings tab: currency, update interval, appearance and About.
/// Phase 6 fills it.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const EmptyStateView(
        icon: Icons.tune,
        title: 'Settings arrive in Phase 6',
        message: 'Currency, update interval and appearance.',
      ),
    );
  }
}
