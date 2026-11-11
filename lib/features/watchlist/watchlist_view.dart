import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/formatting/money_formatter.dart';
import 'package:crypto_tracker/domain/model/market_coin.dart';
import 'package:crypto_tracker/domain/model/watched_coin.dart';
import 'package:crypto_tracker/domain/model/watchlist_listing.dart';
import 'package:crypto_tracker/features/watchlist/cubit/watchlist_cubit.dart';
import 'package:crypto_tracker/features/watchlist/cubit/watchlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Renders [WatchlistState]: the starred coins, live, each removable with a
/// swipe or its star, and Undo.
class WatchlistView extends StatelessWidget {
  const WatchlistView({
    super.key,
    required this.onOpenCoin,
    required this.onBrowseMarket,
  });

  final ValueChanged<String> onOpenCoin;
  final VoidCallback onBrowseMarket;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WatchlistCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: switch (state) {
        WatchlistLoading() => const LoadingView(
          message: 'Loading the watchlist…',
        ),
        WatchlistError(:final message) => ErrorView(
          message: message,
          onRetry: context.read<WatchlistCubit>().load,
        ),
        WatchlistReady(:final listing) => _WatchlistList(
          listing: listing,
          onOpenCoin: onOpenCoin,
          onBrowseMarket: onBrowseMarket,
        ),
      },
    );
  }
}

class _WatchlistList extends StatefulWidget {
  const _WatchlistList({
    required this.listing,
    required this.onOpenCoin,
    required this.onBrowseMarket,
  });

  final WatchlistListing listing;
  final ValueChanged<String> onOpenCoin;
  final VoidCallback onBrowseMarket;

  @override
  State<_WatchlistList> createState() => _WatchlistListState();
}

class _WatchlistListState extends State<_WatchlistList> {
  /// Rows swiped away whose removal the pipeline hasn't reported yet.
  ///
  /// A `Dismissible` must leave the tree the moment it's dismissed, but the
  /// row leaves the *list* only when drift's query re-runs, a moment later.
  /// So a dismissed row is hidden here until the listing no longer has it.
  /// The list itself is still the pipeline's: this only hides, never adds.
  final _swiped = <String>{};

  @override
  void didUpdateWidget(_WatchlistList old) {
    super.didUpdateWidget(old);
    final listed = {for (final row in widget.listing.rows) row.coin.id};
    _swiped.retainWhere(listed.contains);
  }

  @override
  Widget build(BuildContext context) {
    final WatchlistListing(:currency, :rate, :isPaused) = widget.listing;
    final rows = [
      for (final row in widget.listing.rows)
        if (!_swiped.contains(row.coin.id)) row,
    ];
    if (rows.isEmpty) {
      return EmptyStateView(
        icon: Icons.star_border,
        title: 'Star coins to watch them here',
        message:
            'Tap the star next to any coin in the Market, and its price '
            'updates here as it moves.',
        action: FilledButton.tonal(
          onPressed: widget.onBrowseMarket,
          child: const Text('Browse the market'),
        ),
      );
    }
    final money = MoneyFormatter(currency, rate: rate);
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.medium,
            AppSpacing.xSmall,
            AppSpacing.medium,
            AppSpacing.xSmall,
          ),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: AppSpacing.xSmall,
              runSpacing: AppSpacing.xxSmall,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${rows.length} ${rows.length == 1 ? 'coin' : 'coins'}'
                  ' · in the order you starred them',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isPaused) const PausedChip(),
              ],
            ),
          ),
        ),
        SliverList.builder(
          itemCount: rows.length,
          itemBuilder: (context, index) => _row(rows[index], money),
        ),
      ],
    );
  }

  Widget _row(MarketCoin row, MoneyFormatter money) {
    final MarketCoin(:coin, :quote, :direction) = row;
    return Dismissible(
      key: ValueKey(coin.id),
      direction: DismissDirection.endToStart,
      background: const _RemoveBackground(),
      // The swipe waits for the write: a removal that fails slides the row
      // back (and says why), so a dismissed row never has to return.
      confirmDismiss: (_) => _remove(row),
      onDismissed: (_) => _hideUntilGone(coin.id),
      child: CoinRow(
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
          isWatched: true,
          onPressed: () => _remove(row),
        ),
      ),
    );
  }

  /// Removes [row]'s coin, then offers Undo; says why if it couldn't.
  /// Whether it was removed.
  Future<bool> _remove(MarketCoin row) async {
    final cubit = context.read<WatchlistCubit>();
    final messenger = ScaffoldMessenger.of(context);
    switch (await cubit.remove(row.coin.id)) {
      case Ok(value: final removed?):
        showAppSnackBar(
          messenger,
          '${row.coin.name} removed from watchlist',
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => unawaited(_undo(cubit, messenger, removed)),
          ),
        );
        return true;
      case Ok():
        return true; // already gone (removed elsewhere a moment before)
      case Err(:final exception):
        showAppSnackBar(messenger, exception.message);
        return false;
    }
  }

  /// Hides a dismissed row until the listing drops it. `onDismissed` only
  /// fires for a row still in the tree, so still listed: had the query
  /// dropped it during the swipe's animation, the `Dismissible` would be
  /// gone, and nothing would be remembered (or hide a coin starred again).
  void _hideUntilGone(String coinId) => setState(() => _swiped.add(coinId));

  static Future<void> _undo(
    WatchlistCubit cubit,
    ScaffoldMessengerState messenger,
    WatchedCoin removed,
  ) async {
    if (await cubit.restore(removed) case Err(:final exception)) {
      showAppSnackBar(messenger, exception.message);
    }
  }
}

/// What a swipe uncovers: the removal, in the error color, with a word as
/// well as an icon.
class _RemoveBackground extends StatelessWidget {
  const _RemoveBackground();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                'Remove',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: scheme.onErrorContainer),
              ),
            ),
            const SizedBox(width: AppSpacing.xSmall),
            Icon(Icons.delete_outline, color: scheme.onErrorContainer),
          ],
        ),
      ),
    );
  }
}
