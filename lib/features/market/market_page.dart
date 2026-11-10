import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart';
import 'package:crypto_tracker/features/market/market_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// The Market tab's entry point: creates the [MarketCubit], starts the
/// load, and turns the view's callbacks into typed routes.
///
/// The tab shell keeps this page alive while the user visits other tabs, so
/// the search, the sort and the scroll position are still there on return.
class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MarketCubit>()..load(),
      child: MarketView(
        onOpenCoin: (coinId) =>
            CoinDetailRoute(coinId: coinId).push<void>(context),
      ),
    );
  }
}
