import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/formatting/chart_formatter.dart';
import 'package:crypto_tracker/core/formatting/money_formatter.dart';
import 'package:crypto_tracker/core/formatting/percent_formatter.dart';
import 'package:crypto_tracker/domain/model/chart_range.dart';
import 'package:crypto_tracker/domain/model/coin_detail.dart';
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_cubit.dart';
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Renders [CoinDetailState]: the live price, the chart, the stats.
class CoinDetailView extends StatelessWidget {
  const CoinDetailView({
    super.key,
    required this.onAddToPortfolio,
    required this.onBrowseMarket,
    this.leading,
  });

  final VoidCallback onAddToPortfolio;
  final VoidCallback onBrowseMarket;

  /// The app bar's leading button: Close, when the page was opened by a
  /// link and there's nothing to go back to.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CoinDetailCubit>().state;
    final cubit = context.read<CoinDetailCubit>();
    return Scaffold(
      appBar: AppBar(
        leading: leading,
        title: Text(switch (state) {
          CoinDetailReady(:final detail) => detail.coin.name,
          CoinDetailNotFound() => 'Coin not found',
          _ => 'Coin',
        }),
        actions: [
          if (state case CoinDetailReady(:final detail))
            WatchStar(
              coinName: detail.coin.name,
              isWatched: detail.isWatched,
              onPressed: () => _toggleWatch(context),
            ),
        ],
      ),
      body: switch (state) {
        CoinDetailLoading() => const LoadingView(message: 'Loading the coin…'),
        CoinDetailError(:final message) => ErrorView(
          message: message,
          onRetry: cubit.load,
        ),
        CoinDetailNotFound() => EmptyStateView(
          icon: Icons.search_off,
          title: 'Coin not found',
          message: 'There’s no coin “${cubit.coinId}” in the market.',
          action: FilledButton.tonal(
            onPressed: onBrowseMarket,
            child: const Text('Browse the market'),
          ),
        ),
        CoinDetailReady(:final detail) => _Detail(
          detail: detail,
          onAddToPortfolio: onAddToPortfolio,
        ),
      },
    );
  }

  static Future<void> _toggleWatch(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await context.read<CoinDetailCubit>().toggleWatch();
    if (result case Err(:final exception)) {
      showAppSnackBar(messenger, exception.message);
    }
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.detail, required this.onAddToPortfolio});

  final CoinDetail detail;
  final VoidCallback onAddToPortfolio;

  @override
  Widget build(BuildContext context) {
    final money = MoneyFormatter(detail.currency, rate: detail.rate);
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.large),
      children: [
        _Header(detail: detail, money: money),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.medium),
              _Chart(detail: detail, money: money),
              const SizedBox(height: AppSpacing.large),
              _Stats(detail: detail, money: money),
              const SizedBox(height: AppSpacing.large),
              FilledButton.icon(
                onPressed: onAddToPortfolio,
                icon: const Icon(Icons.add),
                label: const Text('Add to portfolio'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The badge, the live price and its 24 h change: flashing on each tick,
/// like the coin's row.
class _Header extends StatelessWidget {
  const _Header({required this.detail, required this.money});

  final CoinDetail detail;
  final MoneyFormatter money;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final CoinDetail(:coin, :quote, :direction, :isPaused) = detail;
    final price = money.price(quote.priceUsd);
    final change = PercentFormatter.describeChange(quote.change24hPercent);
    return PriceFlash(
      direction: direction,
      tick: quote.updatedAt,
      child: Semantics(
        container: true,
        label:
            '${coin.name}, ${coin.symbol.toUpperCase()}, rank ${coin.rank}, '
            '$price, $change in 24 hours',
        excludeSemantics: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.medium,
            AppSpacing.medium,
            AppSpacing.medium,
            AppSpacing.small,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoinBadge(symbol: coin.symbol, size: 48),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${coin.rank} · ${coin.symbol.toUpperCase()}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    // One line, always: at large text a price this big
                    // would wrap mid-number ("$68,322.2 / 1", seen at
                    // AX3), so it shrinks to fit instead.
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: AnimatedPrice(
                        price,
                        style: theme.textTheme.headlineMedium,
                        alignment: AlignmentDirectional.centerStart,
                      ),
                    ),
                    Wrap(
                      spacing: AppSpacing.xSmall,
                      runSpacing: AppSpacing.xxSmall,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        PriceChangeBadge(
                          percent: quote.change24hPercent,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          'in 24 h',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (isPaused) const PausedChip(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Live | 7 days, the chart, and its trend in words.
class _Chart extends StatelessWidget {
  const _Chart({required this.detail, required this.money});

  final CoinDetail detail;
  final MoneyFormatter money;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final points = detail.chartPoints;
    final summary = ChartFormatter.describeTrend(points, detail.range);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<ChartRange>(
          segments: [
            for (final range in ChartRange.values)
              ButtonSegment(value: range, label: Text(range.label)),
          ],
          selected: {detail.range},
          showSelectedIcon: false,
          // Stacked at large text, like every side-by-side control: two
          // labels this big don't fit in half a phone's width.
          direction: context.prefersStackedLayout
              ? Axis.vertical
              : Axis.horizontal,
          onSelectionChanged: (selection) =>
              context.read<CoinDetailCubit>().rangeChanged(selection.single),
        ),
        const SizedBox(height: AppSpacing.medium),
        PriceLineChart(
          points: points,
          summary: summary,
          formatValue: money.price,
        ),
        if (summary != null) ...[
          const SizedBox(height: AppSpacing.xSmall),
          // Already part of the chart's label: not read twice.
          ExcludeSemantics(
            child: Text(
              summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// The coin's figures, two to a row (one at large text).
class _Stats extends StatelessWidget {
  const _Stats({required this.detail, required this.money});

  final CoinDetail detail;
  final MoneyFormatter money;

  @override
  Widget build(BuildContext context) {
    final coin = detail.coin;
    final symbol = coin.symbol.toUpperCase();
    final totalSupply = coin.totalSupply;
    final tiles = [
      StatTile(label: 'Market cap', value: money.compact(detail.marketCapUsd)),
      StatTile(label: 'Volume 24 h', value: money.compact(coin.volume24hUsd)),
      StatTile(
        label: 'Circulating supply',
        value:
            '${MoneyFormatter.compactNumber(coin.circulatingSupply)} $symbol',
      ),
      StatTile(
        label: 'Total supply',
        value: totalSupply == null
            ? 'Unlimited'
            : '${MoneyFormatter.compactNumber(totalSupply)} $symbol',
      ),
      StatTile(
        label: 'All-time high',
        value: money.price(detail.allTimeHighUsd),
      ),
    ];
    final columns = context.prefersStackedLayout ? 1 : 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stats', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xSmall),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = AppSpacing.xSmall;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final tile in tiles) SizedBox(width: width, child: tile),
              ],
            );
          },
        ),
      ],
    );
  }
}
