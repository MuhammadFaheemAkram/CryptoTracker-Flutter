import 'package:crypto_tracker/core/formatting/percent_formatter.dart';
import 'package:crypto_tracker/domain/model/chart_range.dart';

/// Puts a price chart into words: what a screen reader says for it, and the
/// line under it.
abstract final class ChartFormatter {
  /// "Up 1.20% over the last 60 updates", "Down 3.05% over 7 days", from
  /// the first point to the last. `null` with fewer than two points: there
  /// is no trend yet ("Collecting prices…", Correctness Rule 16).
  static String? describeTrend(List<double> points, ChartRange range) {
    if (points.length < 2 || points.first == 0) return null;
    final change = (points.last / points.first - 1) * 100;
    final span = switch (range) {
      ChartRange.live => 'over the last ${points.length} updates',
      ChartRange.sevenDays => 'over 7 days',
    };
    return '${PercentFormatter.describeChange(change)} $span';
  }
}
