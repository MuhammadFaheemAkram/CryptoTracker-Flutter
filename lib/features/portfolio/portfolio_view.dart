import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/formatting/money_formatter.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/model/portfolio_listing.dart';
import 'package:crypto_tracker/domain/model/portfolio_valuation.dart';
import 'package:crypto_tracker/features/portfolio/cubit/portfolio_cubit.dart';
import 'package:crypto_tracker/features/portfolio/cubit/portfolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Renders [PortfolioState]: the totals, the allocation and the holdings,
/// all live.
class PortfolioView extends StatelessWidget {
  const PortfolioView({
    super.key,
    required this.onAddHolding,
    required this.onEditHolding,
  });

  final VoidCallback onAddHolding;
  final ValueChanged<int> onEditHolding;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PortfolioCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio')),
      floatingActionButton: state is PortfolioReady
          ? FloatingActionButton.extended(
              onPressed: onAddHolding,
              icon: const Icon(Icons.add),
              label: const Text('Add holding'),
            )
          : null,
      body: switch (state) {
        PortfolioLoading() => const LoadingView(
          message: 'Loading the portfolio…',
        ),
        PortfolioError(:final message) => ErrorView(
          message: message,
          onRetry: context.read<PortfolioCubit>().load,
        ),
        PortfolioReady(:final listing)
            when listing.valuation.positions.isEmpty =>
          const EmptyStateView(
            icon: Icons.pie_chart_outline,
            title: 'Add your first holding',
            message:
                'Enter a coin you own and what you paid: its value and '
                'profit move with every price tick.',
          ),
        PortfolioReady(:final listing) => _Portfolio(
          listing: listing,
          onEditHolding: onEditHolding,
        ),
      },
    );
  }
}

class _Portfolio extends StatefulWidget {
  const _Portfolio({required this.listing, required this.onEditHolding});

  final PortfolioListing listing;
  final ValueChanged<int> onEditHolding;

  @override
  State<_Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<_Portfolio> {
  /// Holdings swiped away whose removal the pipeline hasn't reported yet
  /// (as on the Watchlist): a dismissed row must leave the tree at once,
  /// the table answers a moment later.
  final _swiped = <int>{};

  @override
  void didUpdateWidget(_Portfolio old) {
    super.didUpdateWidget(old);
    final listed = {
      for (final position in widget.listing.valuation.positions)
        position.holding.id,
    };
    _swiped.retainWhere(listed.contains);
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioListing(:valuation, :currency, :rate, :isPaused) =
        widget.listing;
    final money = MoneyFormatter(currency, rate: rate);
    final positions = [
      for (final position in valuation.positions)
        if (!_swiped.contains(position.holding.id)) position,
    ];
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          sliver: SliverToBoxAdapter(
            child: _Summary(
              valuation: valuation,
              money: money,
              isPaused: isPaused,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          sliver: SliverToBoxAdapter(
            child: _Allocation(allocations: valuation.allocations),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.medium,
            AppSpacing.large,
            AppSpacing.medium,
            AppSpacing.xSmall,
          ),
          sliver: SliverToBoxAdapter(
            child: Semantics(
              header: true,
              child: Text(
                'Holdings (${positions.length})',
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: positions.length,
          itemBuilder: (context, index) => _row(positions[index], money),
        ),
        // Room for the Add button, so it never covers the last row.
        const SliverToBoxAdapter(child: SizedBox(height: 96)),
      ],
    );
  }

  Widget _row(PortfolioPosition position, MoneyFormatter money) {
    final PortfolioPosition(:holding, :coin, :quote, :direction) = position;
    return Dismissible(
      key: ValueKey(holding.id),
      direction: DismissDirection.endToStart,
      background: const _RemoveBackground(),
      // The swipe waits for the write: a removal that fails slides back.
      confirmDismiss: (_) => _remove(position),
      onDismissed: (_) => setState(() => _swiped.add(holding.id)),
      child: PositionTile(
        symbol: coin.symbol,
        name: coin.name,
        amount: _amount(holding, position),
        value: money.price(position.valueUsd),
        cost: money.price(position.costUsd),
        profit: money.signedPrice(position.profitUsd),
        profitInWords: money.describeSignedPrice(position.profitUsd),
        profitPercent: position.profitPercent,
        direction: direction,
        tick: quote.updatedAt,
        onTap: () => widget.onEditHolding(holding.id),
        // The screen reader's way to remove (a swipe isn't one).
        onRemove: () => unawaited(_remove(position)),
      ),
    );
  }

  static String _amount(Holding holding, PortfolioPosition position) =>
      '${MoneyFormatter.coinAmount(holding.amount)} '
      '${position.coin.symbol.toUpperCase()}';

  /// Removes a holding, then offers Undo; says why if it couldn't.
  /// Whether it was removed.
  Future<bool> _remove(PortfolioPosition position) async {
    final cubit = context.read<PortfolioCubit>();
    final messenger = ScaffoldMessenger.of(context);
    switch (await cubit.remove(position.holding.id)) {
      case Ok(value: final removed?):
        showAppSnackBar(
          messenger,
          '${_amount(removed, position)} removed',
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => unawaited(_undo(cubit, messenger, removed)),
          ),
        );
        return true;
      case Ok():
        return true; // already gone
      case Err(:final exception):
        showAppSnackBar(messenger, exception.message);
        return false;
    }
  }

  static Future<void> _undo(
    PortfolioCubit cubit,
    ScaffoldMessengerState messenger,
    Holding removed,
  ) async {
    if (await cubit.restore(removed) case Err(:final exception)) {
      showAppSnackBar(messenger, exception.message);
    }
  }
}

/// The totals: what everything is worth, the profit or loss, and the 24 h
/// change, all live.
class _Summary extends StatelessWidget {
  const _Summary({
    required this.valuation,
    required this.money,
    required this.isPaused,
  });

  final PortfolioValuation valuation;
  final MoneyFormatter money;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = money.price(valuation.totalValueUsd);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Total value, $total',
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total value',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              // One line, always: it shrinks rather than wrap mid-number.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: AnimatedPrice(
                  total,
                  style: theme.textTheme.headlineMedium,
                  alignment: AlignmentDirectional.centerStart,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xSmall),
        ValueChange(
          label: 'P/L',
          semanticLabel: 'Profit and loss',
          money: money.signedPrice(valuation.totalProfitUsd),
          moneyInWords: money.describeSignedPrice(valuation.totalProfitUsd),
          percent: valuation.totalProfitPercent,
        ),
        const SizedBox(height: AppSpacing.xxSmall),
        ValueChange(
          label: '24 h',
          semanticLabel: 'Over 24 hours',
          money: money.signedPrice(valuation.change24hUsd),
          moneyInWords: money.describeSignedPrice(valuation.change24hUsd),
          percent: valuation.change24hPercent,
        ),
        if (isPaused) ...[
          const SizedBox(height: AppSpacing.xSmall),
          const PausedChip(),
        ],
      ],
    );
  }
}

/// The donut and its legend, side by side (stacked at large text).
class _Allocation extends StatelessWidget {
  const _Allocation({required this.allocations});

  final List<Allocation> allocations;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final slices = [
      for (final allocation in allocations)
        DonutSlice(
          label: allocation.label,
          basisPoints: allocation.basisPoints,
          // A coin's slice has its badge's color; "Other" is neutral.
          color: switch (allocation.symbol) {
            final symbol? => CoinBadge.colorFor(symbol),
            null => scheme.outline,
          },
        ),
    ];
    final title = Semantics(
      header: true,
      child: Text('Allocation', style: Theme.of(context).textTheme.titleMedium),
    );
    final donut = AllocationDonut(slices: slices);
    final legend = AllocationLegend(slices: slices);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: AppSpacing.small),
        if (context.prefersStackedLayout) ...[
          Center(child: donut),
          const SizedBox(height: AppSpacing.medium),
          legend,
        ] else
          Row(
            children: [
              donut,
              const SizedBox(width: AppSpacing.large),
              Expanded(child: legend),
            ],
          ),
      ],
    );
  }
}

/// What a swipe uncovers: the removal, with a word as well as an icon.
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
