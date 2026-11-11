import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_cubit.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_state.dart';
import 'package:crypto_tracker/features/holding_form/holding_form_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// The holding form, a full-screen dialog: a new holding (of [coinId], from
/// a coin's page), or an existing one ([holdingId]).
///
/// Saved, it closes and says what it did; opened by a link (nothing
/// underneath), it goes to the Portfolio instead.
class HoldingFormPage extends StatelessWidget {
  const HoldingFormPage({super.key, this.holdingId, this.coinId});

  /// The holding being edited; `null` for a new one.
  final int? holdingId;

  /// The coin a new holding starts with.
  final String? coinId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<HoldingFormCubit>(param1: coinId, param2: holdingId)..load(),
      child: BlocListener<HoldingFormCubit, HoldingFormState>(
        listenWhen: (_, state) => state is HoldingFormSaved,
        listener: (context, state) {
          if (state case HoldingFormSaved(:final message)) {
            showAppSnackBar(ScaffoldMessenger.of(context), message);
            _leave(context);
          }
        },
        child: HoldingFormView(
          isEditing: holdingId != null,
          onCloseWithoutBack: () => const PortfolioRoute().go(context),
        ),
      ),
    );
  }

  static void _leave(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      const PortfolioRoute().go(context);
    }
  }
}
