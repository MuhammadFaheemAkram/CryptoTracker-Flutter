import 'package:crypto_tracker/core/design_system/theme/app_colors.dart';
import 'package:crypto_tracker/core/formatting/percent_formatter.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:material_ui/material_ui.dart';

/// A percentage change: "▲ +2.41%" in the up color, "▼ −1.20%" in the down
/// color, "0.00%" when it rounds to nothing.
///
/// Color is never the only signal: the arrow and the sign say the same
/// thing, for anyone who can't tell green from red (Correctness Rule 13).
/// A screen reader hears it in words ("Up 2.41%").
class PriceChangeBadge extends StatelessWidget {
  const PriceChangeBadge({super.key, required this.percent, this.style});

  /// The change, in percent (2.41 means +2.41 %).
  final double percent;

  /// The text style before the color is applied; `bodyMedium` by default.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final direction = PriceDirection.ofChange(percent);
    final color = switch (direction) {
      PriceDirection.up => colors.up,
      PriceDirection.down => colors.down,
      PriceDirection.flat => colors.flat,
    };
    final textStyle = (style ?? Theme.of(context).textTheme.bodyMedium!)
        .copyWith(
          color: color,
          // Every digit as wide as the others, so a changing number doesn't
          // shift from side to side.
          fontFeatures: const [FontFeature.tabularFigures()],
        );
    final arrow = switch (direction) {
      PriceDirection.up => Icons.arrow_drop_up,
      PriceDirection.down => Icons.arrow_drop_down,
      PriceDirection.flat => null,
    };
    return Semantics(
      label: PercentFormatter.describeChange(percent),
      excludeSemantics: true,
      // A change never wraps or loses digits: in a space too narrow for it
      // (the coin page's header at the largest text), it shrinks to fit.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (arrow != null)
              Icon(
                arrow,
                color: color,
                // Scales with the text, so the arrow keeps up at large sizes.
                size: MediaQuery.textScalerOf(context)
                    .scale((textStyle.fontSize ?? 14) * 1.4),
              ),
            Text(PercentFormatter.formatChange(percent), style: textStyle),
          ],
        ),
      ),
    );
  }
}
