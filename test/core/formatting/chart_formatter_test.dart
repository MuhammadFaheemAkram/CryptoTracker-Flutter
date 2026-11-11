import 'package:crypto_tracker/core/formatting/chart_formatter.dart';
import 'package:crypto_tracker/domain/model/chart_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the live trend, from the first point to the last', () {
    expect(
      ChartFormatter.describeTrend([100, 90, 101.2], ChartRange.live),
      'Up 1.20% over the last 3 updates',
    );
    expect(
      ChartFormatter.describeTrend([100, 110, 96.95], ChartRange.live),
      'Down 3.05% over the last 3 updates',
    );
  });

  test('the 7-day trend', () {
    expect(
      ChartFormatter.describeTrend([50, 55], ChartRange.sevenDays),
      'Up 10.00% over 7 days',
    );
  });

  test('a line back where it started is unchanged', () {
    expect(
      ChartFormatter.describeTrend([1, 2, 1], ChartRange.live),
      'Unchanged over the last 3 updates',
    );
  });

  test('fewer than two points: no trend yet (Correctness Rule 16)', () {
    expect(ChartFormatter.describeTrend(const [], ChartRange.live), isNull);
    expect(ChartFormatter.describeTrend([42], ChartRange.live), isNull);
  });
}
