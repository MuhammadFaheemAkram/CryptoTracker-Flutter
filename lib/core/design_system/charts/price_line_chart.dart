import 'package:crypto_tracker/core/design_system/charts/sparkline.dart';
import 'package:crypto_tracker/core/design_system/theme/app_colors.dart';
import 'package:crypto_tracker/core/design_system/theme/app_spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// A coin's price chart: a line with a soft fill under it, a dot on the
/// latest price, and its high and low written above and below.
///
/// Drawn with a [CustomPainter], like the [Sparkline], and scaled the same
/// way ([SparklinePainter.offsetsFor]): a calm coin doesn't zigzag.
///
/// For a screen reader it's one node that says what the line shows:
/// [summary] ("Up 1.20% over the last 60 updates"), then the low and the
/// high. With fewer than two points there's no line to draw, and it says
/// "Collecting prices…" instead (Correctness Rule 16).
class PriceLineChart extends StatelessWidget {
  const PriceLineChart({
    super.key,
    required this.points,
    required this.summary,
    required this.formatValue,
    this.height = 160,
  });

  /// Oldest first.
  final List<double> points;

  /// The trend in words; `null` with fewer than two points.
  final String? summary;

  /// Formats the high and low labels (a price in the chosen currency).
  final String Function(double value) formatValue;
  final double height;

  static const collectingMessage = 'Collecting prices…';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = this.summary;
    if (points.length < 2 || summary == null) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            collectingMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    var low = points.first;
    var high = points.first;
    for (final point in points) {
      if (point < low) low = point;
      if (point > high) high = point;
    }
    final colors = context.appColors;
    final color = points.last == points.first
        ? colors.flat
        : points.last > points.first
        ? colors.up
        : colors.down;
    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final highLabel = formatValue(high);
    final lowLabel = formatValue(low);
    return Semantics(
      container: true,
      label: '$summary. Low $lowLabel, high $highLabel.',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('High $highLabel', style: labelStyle),
            const SizedBox(height: AppSpacing.xxSmall),
            RepaintBoundary(
              child: CustomPaint(
                size: Size(double.infinity, height),
                painter: PriceLinePainter(
                  points: points,
                  color: color,
                  dotRingColor: theme.colorScheme.surface,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxSmall),
            Text('Low $lowLabel', style: labelStyle),
          ],
        ),
      ),
    );
  }
}

/// Paints [points] as a line over a fill that fades to nothing at the
/// bottom, with a dot on the last point (the price now). Fewer than two
/// points draw nothing.
class PriceLinePainter extends CustomPainter {
  const PriceLinePainter({
    required this.points,
    required this.color,
    required this.dotRingColor,
  });

  final List<double> points;
  final Color color;

  /// The ring around the dot: the background, so the dot stands off the
  /// line.
  final Color dotRingColor;

  /// Room at the top and bottom, so the line's stroke and the dot aren't
  /// clipped at the extremes.
  static const inset = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final area = Size(size.width - inset * 2, size.height - inset * 2);
    final offsets = [
      for (final offset in SparklinePainter.offsetsFor(points, area))
        offset.translate(inset, inset),
    ];
    final line = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (final offset in offsets.skip(1)) {
      line.lineTo(offset.dx, offset.dy);
    }
    final fill = Path.from(line)
      ..lineTo(offsets.last.dx, size.height)
      ..lineTo(offsets.first.dx, size.height)
      ..close();
    canvas
      ..drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.24), color.withValues(alpha: 0)],
          ).createShader(Offset.zero & size),
      )
      ..drawPath(
        line,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      )
      ..drawCircle(offsets.last, 5, Paint()..color = dotRingColor)
      ..drawCircle(offsets.last, 3.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(PriceLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.dotRingColor != dotRingColor ||
      !listEquals(oldDelegate.points, points);
}
