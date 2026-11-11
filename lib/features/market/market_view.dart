import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/formatting/money_formatter.dart';
import 'package:crypto_tracker/domain/model/market_coin.dart';
import 'package:crypto_tracker/domain/model/market_listing.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart';
import 'package:crypto_tracker/features/market/cubit/market_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Renders [MarketState] and forwards the user's intents to [MarketCubit].
///
/// It knows nothing about routes: opening a coin is [onOpenCoin], wired by
/// the page. Widget tests pump it with a mocked Cubit, one state per test.
class MarketView extends StatelessWidget {
  const MarketView({super.key, required this.onOpenCoin});

  final ValueChanged<String> onOpenCoin;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MarketCubit>().state;
    final cubit = context.read<MarketCubit>();
    final listing = switch (state) {
      MarketReady(:final listing) => listing,
      _ => null,
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          if (listing != null) _PauseButton(paused: listing.isPaused),
          SortMenu(
            selected: listing?.sort ?? SortOption.rank,
            onSelected: listing == null ? null : cubit.sortChanged,
          ),
        ],
      ),
      body: switch (state) {
        MarketLoading() => const LoadingView(message: 'Loading the market…'),
        MarketError(:final message) => ErrorView(
          message: message,
          onRetry: cubit.load,
        ),
        MarketReady(:final listing) => _MarketList(
          listing: listing,
          onOpenCoin: onOpenCoin,
        ),
      },
    );
  }
}

/// Pauses or resumes the live prices. Content that moves by itself must be
/// pausable where it's shown (WCAG 2.2.2, "Pause, Stop, Hide"), not only in
/// Settings.
class _PauseButton extends StatelessWidget {
  const _PauseButton({required this.paused});

  final bool paused;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: paused ? 'Resume live prices' : 'Pause live prices',
      icon: Icon(
        paused ? Icons.play_circle_outline : Icons.pause_circle_outline,
      ),
      onPressed: () => context.read<MarketCubit>().setPaused(paused: !paused),
    );
  }
}

/// The search field, a line saying what's shown, and the rows.
class _MarketList extends StatefulWidget {
  const _MarketList({required this.listing, required this.onOpenCoin});

  final MarketListing listing;
  final ValueChanged<String> onOpenCoin;

  @override
  State<_MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<_MarketList> {
  // Owned here, so it survives every new state (each tick is one) and the
  // field keeps its text and cursor. It's the *typed* text; the listing's
  // query is the settled one, a little behind it.
  late final _search = TextEditingController(text: widget.listing.query);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MarketCubit>();
    final MarketListing(:rows, :query, :sort, :currency, :rate, :isPaused) =
        widget.listing;
    final money = MoneyFormatter(currency, rate: rate);
    final theme = Theme.of(context);
    // One scroll view for everything, the search field included: at large
    // text sizes a fixed header (the field, the summary, the Paused chip)
    // would leave no room for the list, or not fit at all.
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.medium,
            AppSpacing.xSmall,
            AppSpacing.medium,
            AppSpacing.xSmall,
          ),
          sliver: SliverToBoxAdapter(
            child: AppSearchField(
              controller: _search,
              hintText: 'Search coins',
              onChanged: cubit.queryChanged,
              onCleared: () => cubit.queryChanged(''),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          sliver: SliverToBoxAdapter(
            // A Wrap: the chip moves under the summary when the line is
            // full, instead of squeezing it.
            child: Wrap(
              spacing: AppSpacing.xSmall,
              runSpacing: AppSpacing.xxSmall,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Read out when it changes while searching, so a
                // screen-reader user hears how many coins match without
                // leaving the field. Not while browsing: a tick never
                // changes it.
                Semantics(
                  liveRegion: query.isNotEmpty,
                  child: Text(
                    _summary(rows.length, query, sort.label),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (isPaused) const PausedChip(),
              ],
            ),
          ),
        ),
        if (rows.isEmpty)
          SliverFillRemaining(
            child: EmptyStateView(
              icon: Icons.search_off,
              title: 'No coins match “$query”',
              message: 'Try a name like “Bitcoin” or a symbol like “BTC”.',
            ),
          )
        else
          SliverList.builder(
            itemCount: rows.length,
            itemBuilder: (context, index) => _row(rows[index], money),
          ),
      ],
    );
  }

  Widget _row(MarketCoin row, MoneyFormatter money) {
    final MarketCoin(:coin, :quote, :direction, :isWatched) = row;
    return CoinRow(
      // Keyed by coin: a re-sort moves rows (and their flash state) instead
      // of rebuilding them, and a tick updates a row in place.
      key: ValueKey(coin.id),
      rank: coin.rank,
      symbol: coin.symbol,
      name: coin.name,
      price: money.price(quote.priceUsd),
      change24hPercent: quote.change24hPercent,
      sparkline: coin.sparkline7d,
      direction: direction,
      tick: quote.updatedAt,
      onTap: () => widget.onOpenCoin(coin.id),
      trailing: WatchStar(
        coinName: coin.name,
        isWatched: isWatched,
        onPressed: () => _toggleWatch(coin.id),
      ),
    );
  }

  /// Stars or unstars a coin. Success needs nothing here: the star fills
  /// when the pipeline says so. A failure is said.
  Future<void> _toggleWatch(String coinId) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await context.read<MarketCubit>().toggleWatch(coinId);
    if (result case Err(:final exception)) {
      showAppSnackBar(messenger, exception.message);
    }
  }

  static String _summary(int count, String query, String sortLabel) {
    final noun = query.isEmpty
        ? (count == 1 ? 'coin' : 'coins')
        : (count == 1 ? 'match' : 'matches');
    return '$count $noun · by ${sortLabel.toLowerCase()}';
  }
}
