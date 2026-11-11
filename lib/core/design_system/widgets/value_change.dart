import 'package:crypto_tracker/core/design_system/theme/app_colors.dart';
import 'package:crypto_tracker/core/design_system/theme/app_spacing.dart';
import 'package:crypto_tracker/core/design_system/widgets/price_change_badge.dart';
import 'package:crypto_tracker/core/formatting/percent_formatter.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:material_ui/material_ui.dart';

/// A labelled gain or loss: "P/L  +$1,234.56  ▲ +4.10%".
///
/// The money is colored like the percentage, and both carry a sign, so
/// color is never the only signal. A screen reader hears one sentence:
/// "Profit and loss, plus $1,234.56, Up 4.10%".
class ValueChange extends StatelessWidget {
  const ValueChange({
    super.key,
    required this.label,
    required this.money,
    required this.moneyInWords,
    required this.percent,
    this.semanticLabel,
    this.style,
  });

  /// Shown: "P/L", "24 h".
  final String label;

  /// Signed: "+$1,234.56".
  final String money;

  /// [money] for a screen reader: "plus $1,234.56".
  final String moneyInWords;
  final double percent;

  /// What a screen reader calls [label] ("Profit and loss" for "P/L").
  final String? semanticLabel;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final textStyle = style ?? theme.textTheme.bodyMedium;
    final color = switch (PriceDirection.ofChange(percent)) {
      PriceDirection.up => colors.up,
      PriceDirection.down => colors.down,
      PriceDirection.flat => colors.flat,
    };
    return Semantics(
      label:
          '${semanticLabel ?? label}, $moneyInWords, '
          '${PercentFormatter.describeChange(percent)}',
      excludeSemantics: true,
      child: Wrap(
        spacing: AppSpacing.xSmall,
        runSpacing: AppSpacing.xxSmall,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            label,
            style: textStyle?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            money,
            style: textStyle?.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          PriceChangeBadge(percent: percent, style: textStyle),
        ],
      ),
    );
  }
}
