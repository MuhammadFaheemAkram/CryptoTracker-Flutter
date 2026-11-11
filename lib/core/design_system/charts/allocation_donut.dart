import 'dart:math' as math;

import 'package:crypto_tracker/core/design_system/theme/app_spacing.dart';
import 'package:crypto_tracker/core/formatting/percent_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// One slice of the donut, and its line in the legend.
@immutable
class DonutSlice {
  const DonutSlice({
    required this.label,
    required this.basisPoints,
    required this.color,
  });

  final String label;

  /// Its share, in hundredths of a percent; a donut's slices add up to
  /// 10 000.
  final int basisPoints;
  final Color color;

  @override
  bool operator ==(Object other) =>
      other is DonutSlice &&
      other.label == label &&
      other.basisPoints == basisPoints &&
      other.color == color;

  @override
  int get hashCode => Object.hash(label, basisPoints, color);
}

/// How a portfolio is split: a ring of [slices], largest first, clockwise
/// from the top.
///
/// For a screen reader it's one node that lists the slices in words
/// ("Allocation by value: Bitcoin 52.37%, …"); the [AllocationLegend]
/// beside it shows the same in text, so it's excluded there and nothing
/// is read twice. Color is never the only signal: every slice is named,
/// with its share, in the legend.
class AllocationDonut extends StatelessWidget {
  const AllocationDonut({super.key, required this.slices, this.size = 132});

  final List<DonutSlice> slices;
  final double size;

  /// What a screen reader says.
  static String describe(List<DonutSlice> slices) =>
      'Allocation by value: '
      '${[for (final slice in slices) '${slice.label} ${PercentFormatter.formatShare(slice.basisPoints)}'].join(', ')}';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: describe(slices),
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size.square(size),
            painter: DonutPainter(
              slices: slices,
              gapColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints [slices] as arcs of a ring, with a thin [gapColor] line between
/// two slices so neighbours of similar colors stay apart.
class DonutPainter extends CustomPainter {
  const DonutPainter({required this.slices, required this.gapColor});

  final List<DonutSlice> slices;
  final Color gapColor;

  /// The ring's thickness, as a share of the radius.
  static const thickness = 0.36;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold(0, (sum, slice) => sum + slice.basisPoints);
    if (total <= 0) return;
    final radius = size.shortestSide / 2;
    final stroke = radius * thickness;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius - stroke / 2,
    );
    var start = -math.pi / 2; // twelve o'clock
    for (final slice in slices) {
      final sweep = slice.basisPoints / total * 2 * math.pi;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = slice.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke,
      );
      start += sweep;
    }
    if (slices.length < 2) return;
    // The gaps: a radial line at each boundary.
    final gap = Paint()
      ..color = gapColor
      ..strokeWidth = 2;
    var angle = -math.pi / 2;
    for (final slice in slices) {
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        rect.center + direction * (radius - stroke),
        rect.center + direction * radius,
        gap,
      );
      angle += slice.basisPoints / total * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(DonutPainter oldDelegate) =>
      oldDelegate.gapColor != gapColor ||
      !listEquals(oldDelegate.slices, slices);
}

/// The donut's key: a swatch, the label and the share, one line per slice.
/// Hidden from screen readers: the donut already said all of it.
class AllocationLegend extends StatelessWidget {
  const AllocationLegend({super.key, required this.slices});

  final List<DonutSlice> slices;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExcludeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final slice in slices)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxSmall),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: slice.color,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 12),
                  ),
                  const SizedBox(width: AppSpacing.xSmall),
                  Expanded(
                    child: Text(
                      slice.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xSmall),
                  Text(
                    PercentFormatter.formatShare(slice.basisPoints),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
