import 'package:crypto_tracker/core/design_system/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

/// A tiny line chart of a coin's recent prices: the 7-day trend in a row.
///
/// Drawn with a [CustomPainter] (no chart library: the Android edition draws
/// on Canvas too). It's colored by the trend over its own range (up if the
/// last point is above the first), and it's decorative for screen readers:
/// the row already says the 24 h change, and a line has no words.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.points,
    this.size = const Size(64, 28),
  });

  /// Oldest first.
  final List<double> points;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = points.length < 2 || points.last == points.first
        ? colors.flat
        : points.last > points.first
        ? colors.up
        : colors.down;
    return ExcludeSemantics(
      // Its own layer: a row repainting (a price ticking, from Phase 3)
      // doesn't repaint the line, and the line doesn't repaint the row.
      child: RepaintBoundary(
        child: CustomPaint(
          size: size,
          painter: SparklinePainter(points: points, color: color),
        ),
      ),
    );
  }
}

/// Paints [points] as a line that fills the canvas: the lowest point at the
/// bottom, the highest at the top. Fewer than two points draw nothing.
class SparklinePainter extends CustomPainter {
  const SparklinePainter({required this.points, required this.color});

  final List<double> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final path = Path();
    for (final (index, offset) in offsetsFor(points, size).indexed) {
      index == 0
          ? path.moveTo(offset.dx, offset.dy)
          : path.lineTo(offset.dx, offset.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true,
    );
  }

  /// The smallest height the line is allowed to span, as a share of the
  /// price: a move under 2 % stays visibly small.
  ///
  /// Without it, each line stretches its own low to the bottom and its own
  /// high to the top, so a stablecoin wobbling by 0.4 % zigzags as wildly as
  /// a coin that moved 20 % (seen on the simulator).
  static const minRelativeRange = 0.02;

  /// Where each point lands on a canvas of [size]: evenly spaced across, and
  /// scaled between the lowest and highest point, or over
  /// [minRelativeRange] of the price if the points span less, centred. A
  /// flat line sits in the middle. Pure, so it's tested without painting.
  static List<Offset> offsetsFor(List<double> points, Size size) {
    if (points.length < 2) return const [];
    var low = points.first;
    var high = points.first;
    var sum = 0.0;
    for (final point in points) {
      if (point < low) low = point;
      if (point > high) high = point;
      sum += point;
    }
    final minimum = (sum / points.length).abs() * minRelativeRange;
    final range = high - low;
    final span = range < minimum ? minimum : range;
    // The room the line doesn't use, split above and below it.
    final top = high + (span - range) / 2;
    final step = size.width / (points.length - 1);
    return [
      for (final (index, point) in points.indexed)
        Offset(
          index * step,
          span == 0 ? size.height / 2 : (top - point) / span * size.height,
        ),
    ];
  }

  @override
  bool shouldRepaint(SparklinePainter oldDelegate) =>
      oldDelegate.color != color || !_samePoints(oldDelegate.points, points);

  static bool _samePoints(List<double> a, List<double> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
