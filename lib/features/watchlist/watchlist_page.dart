import 'package:crypto_tracker/core/navigation/app_routes.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/features/watchlist/cubit/watchlist_cubit.dart';
import 'package:crypto_tracker/features/watchlist/watchlist_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// The Watchlist tab's entry point: creates the [WatchlistCubit] and turns
/// the view's callbacks into typed routes.
class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WatchlistCubit>()..load(),
      child: WatchlistView(
        onOpenCoin: (coinId) =>
            CoinDetailRoute(coinId: coinId).push<void>(context),
        onBrowseMarket: () => const MarketRoute().go(context),
      ),
    );
  }
}
