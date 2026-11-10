import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:crypto_tracker/core/navigation/fallback_close_button.dart';
import 'package:material_ui/material_ui.dart';

/// The holding form, a full-screen dialog: a new holding, or an existing
/// one ([holdingId]). Phase 5 builds the form.
class HoldingFormPage extends StatelessWidget {
  const HoldingFormPage({super.key, this.holdingId, this.coinId});

  /// The holding being edited; `null` for a new one.
  final int? holdingId;

  /// The coin a new holding starts with (from a coin's page).
  final String? coinId;

  bool get _isEditing => holdingId != null;

  @override
  Widget build(BuildContext context) {
    final coinId = this.coinId;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit holding' : 'Add holding'),
        // A full-screen dialog brings its own Close; opened by a link, this
        // one goes to the Portfolio instead.
        leading: fallbackCloseButton(
          context,
          () => const PortfolioRoute().go(context),
        ),
      ),
      body: EmptyStateView(
        icon: Icons.add_card_outlined,
        title: 'The form arrives in Phase 5',
        message: switch ((holdingId, coinId)) {
          (final int id, _) => 'Holding $id.',
          (null, final String coin) => 'A new holding of "$coin".',
          (null, null) => 'A new holding.',
        },
      ),
    );
  }
}
