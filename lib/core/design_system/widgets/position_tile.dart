import 'package:crypto_tracker/core/design_system/large_text.dart';
import 'package:crypto_tracker/core/design_system/theme/app_colors.dart';
import 'package:crypto_tracker/core/design_system/theme/app_spacing.dart';
import 'package:crypto_tracker/core/design_system/widgets/coin_badge.dart';
import 'package:crypto_tracker/core/design_system/widgets/price_flash.dart';
import 'package:crypto_tracker/core/formatting/percent_formatter.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:flutter/semantics.dart';
import 'package:material_ui/material_ui.dart';

/// One holding in the Portfolio: the coin, how much of it, what it cost,
/// what it's worth now, and the profit or loss.
///
/// It only renders: the caller formats every amount (in the chosen
/// currency). Like a coin's row it flashes on each tick ([direction],
/// [tick]) and its value cross-fades.
///
/// For a screen reader it's one button that says everything, with a
/// **Remove** action ([onRemove]): a swipe alone can't be performed by
/// everyone, a custom action can.
class PositionTile extends StatelessWidget {
  const PositionTile({
    super.key,
    required this.symbol,
    required this.name,
    required this.amount,
    required this.value,
    required this.cost,
    required this.profit,
    required this.profitInWords,
    required this.profitPercent,
    this.direction = PriceDirection.flat,
    this.tick,
    this.onTap,
    this.onRemove,
  });

  final String symbol;
  final String name;

  /// "0.5 BTC".
  final String amount;

  /// What it's worth now: "$33,620.25".
  final String value;

  /// What it cost: "$30,000.00".
  final String cost;

  /// Signed: "+$3,620.25".
  final String profit;

  /// [profit] for a screen reader: "plus $3,620.25".
  final String profitInWords;
  final double profitPercent;
  final PriceDirection direction;
  final Object? tick;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final label =
        '$name, $amount, worth $value, cost $cost, '
        '$profitInWords, ${PercentFormatter.describeChange(profitPercent)}';
    return PriceFlash(
      direction: direction,
      tick: tick,
      child: Semantics(
        button: onTap != null,
        label: label,
        onTap: onTap,
        customSemanticsActions: {
          const CustomSemanticsAction(label: 'Remove'): ?onRemove,
        },
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          excludeFromSemantics: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            child: context.prefersStackedLayout
                ? _Stacked(tile: this)
                : _SideBySide(tile: this),
          ),
        ),
      ),
    );
  }
}

class _SideBySide extends StatelessWidget {
  const _SideBySide({required this.tile});

  final PositionTile tile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CoinBadge(symbol: tile.symbol),
        const SizedBox(width: AppSpacing.small),
        Expanded(child: _Holding(tile: tile)),
        const SizedBox(width: AppSpacing.small),
        Flexible(
          child: _Worth(tile: tile, alignment: CrossAxisAlignment.end),
        ),
      ],
    );
  }
}

/// Large text: everything under the name, so the figures never squeeze it.
class _Stacked extends StatelessWidget {
  const _Stacked({required this.tile});

  final PositionTile tile;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CoinBadge(symbol: tile.symbol),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Holding(tile: tile),
              _Worth(tile: tile, alignment: CrossAxisAlignment.start),
            ],
          ),
        ),
      ],
    );
  }
}

/// The name, then "0.5 BTC", then "Cost $30,000.00": one fact per line,
/// so a long cost never wraps in the middle of a phrase (seen on the
/// simulator with "0.5 BTC · cost" on one line and the cost on the next).
class _Holding extends StatelessWidget {
  const _Holding({required this.tile});

  final PositionTile tile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tile.name,
          maxLines: context.prefersStackedLayout ? null : 1,
          overflow: context.prefersStackedLayout ? null : TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium,
        ),
        for (final line in [tile.amount, 'Cost ${tile.cost}'])
          Text(
            line,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
      ],
    );
  }
}

/// What it's worth (cross-fading on each tick), then the profit or loss,
/// signed and colored.
class _Worth extends StatelessWidget {
  const _Worth({required this.tile, required this.alignment});

  final PositionTile tile;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final color = switch (PriceDirection.ofChange(tile.profitPercent)) {
      PriceDirection.up => colors.up,
      PriceDirection.down => colors.down,
      PriceDirection.flat => colors.flat,
    };
    final start = alignment == CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        // One line, always: it shrinks rather than wrap mid-number.
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: start
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.centerEnd,
          child: AnimatedPrice(
            tile.value,
            style: theme.textTheme.titleMedium,
            alignment: start
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.centerEnd,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: start
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.centerEnd,
          child: Text(
            '${tile.profit} '
            '(${PercentFormatter.formatChange(tile.profitPercent)})',
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}
