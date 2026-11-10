import 'package:crypto_tracker/core/design_system/large_text.dart';
import 'package:crypto_tracker/core/design_system/theme/app_spacing.dart';
import 'package:crypto_tracker/core/design_system/widgets/coin_badge.dart';
import 'package:crypto_tracker/core/design_system/widgets/price_change_badge.dart';
import 'package:crypto_tracker/core/formatting/percent_formatter.dart';
import 'package:material_ui/material_ui.dart';

/// One coin in a list (the Market, the Watchlist): rank, badge, name and
/// symbol, the price and its 24 h change.
///
/// It only renders: the caller formats [price] (in the chosen currency) and
/// decides what a tap does. Later phases add the flash when the price ticks,
/// the 7-day sparkline and the watchlist star (as [trailing]).
///
/// For a screen reader, the row is one button that says everything
/// ("Bitcoin, BTC, rank 1, $67,240.50, Up 2.41%"); the [trailing] control
/// keeps a node of its own.
class CoinRow extends StatelessWidget {
  const CoinRow({
    super.key,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24hPercent,
    this.onTap,
    this.trailing,
  });

  /// The coin's market-cap rank (1 for the largest).
  final int rank;
  final String symbol;
  final String name;

  /// The price, already formatted for the chosen currency.
  final String price;

  /// The change over 24 h, in percent.
  final double change24hPercent;

  final VoidCallback? onTap;

  /// A control at the end of the row (the watchlist star).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final upperSymbol = symbol.toUpperCase();
    final label =
        '$name, $upperSymbol, rank $rank, $price, '
        '${PercentFormatter.describeChange(change24hPercent)}';
    final trailing = this.trailing;
    return Row(
      children: [
        Expanded(
          // One node with one label and one tap: the InkWell's own
          // semantics are replaced, not doubled.
          child: Semantics(
            button: onTap != null,
            label: label,
            onTap: onTap,
            excludeSemantics: true,
            child: InkWell(
              onTap: onTap,
              excludeFromSemantics: true,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: AppSpacing.medium,
                  end: trailing == null ? AppSpacing.medium : 0,
                  top: AppSpacing.small,
                  bottom: AppSpacing.small,
                ),
                child: context.prefersStackedLayout
                    ? _Stacked(row: this, symbol: upperSymbol)
                    : _SideBySide(row: this, symbol: upperSymbol),
              ),
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// The usual layout: the name on the left, the price on the right.
class _SideBySide extends StatelessWidget {
  const _SideBySide({required this.row, required this.symbol});

  final CoinRow row;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            '${row.rank}',
            textAlign: TextAlign.end,
            style: _tabular(theme.textTheme.bodySmall)
                .copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        CoinBadge(symbol: row.symbol),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                row.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                symbol,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(row.price, style: _tabular(theme.textTheme.titleMedium)),
            PriceChangeBadge(
              percent: row.change24hPercent,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

/// Large text (above 130 %): everything under the name, so a long price
/// never squeezes the name to a few letters. The rank joins the symbol.
class _Stacked extends StatelessWidget {
  const _Stacked({required this.row, required this.symbol});

  final CoinRow row;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CoinBadge(symbol: row.symbol),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(row.name, style: theme.textTheme.titleMedium),
              Text(
                '#${row.rank} · $symbol',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(row.price, style: _tabular(theme.textTheme.titleMedium)),
              PriceChangeBadge(
                percent: row.change24hPercent,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Every digit as wide as the others, so a ticking price doesn't jitter.
TextStyle _tabular(TextStyle? style) => (style ?? const TextStyle()).copyWith(
  fontFeatures: const [FontFeature.tabularFigures()],
);
