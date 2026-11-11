import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/features/portfolio/cubit/portfolio_cubit.dart';
import 'package:crypto_tracker/features/portfolio/portfolio_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// The Portfolio tab's entry point: creates the [PortfolioCubit] and turns
/// the view's callbacks into typed routes (the holding form, new or edit).
class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PortfolioCubit>()..load(),
      child: PortfolioView(
        onAddHolding: () => const NewHoldingRoute().push<void>(context),
        onEditHolding: (id) =>
            EditHoldingRoute(holdingId: id).push<void>(context),
      ),
    );
  }
}
