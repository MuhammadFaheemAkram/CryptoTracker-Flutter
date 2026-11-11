import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:crypto_tracker/core/navigation/fallback_close_button.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/features/coin_detail/coin_detail_view.dart';
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// One coin, pushed above the tabs: creates its [CoinDetailCubit] (the id
/// is the Cubit's factory parameter) and wires the view's callbacks to
/// typed routes.
class CoinDetailPage extends StatelessWidget {
  const CoinDetailPage({super.key, required this.coinId});

  final String coinId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CoinDetailCubit>(param1: coinId)..load(),
      child: CoinDetailView(
        // Opened by a link, there is nothing to go back to: Close goes to
        // the Market.
        leading: fallbackCloseButton(
          context,
          () => const MarketRoute().go(context),
        ),
        onAddToPortfolio: () =>
            NewHoldingRoute(coinId: coinId).push<void>(context),
        onBrowseMarket: () => const MarketRoute().go(context),
      ),
    );
  }
}
