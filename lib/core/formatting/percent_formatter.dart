import 'package:crypto_tracker/domain/model/price_direction.dart';

/// Formats percentage changes: "+2.41%", "−1.20%", "0.00%".
///
/// Pure Dart, so it's tested without widgets. The money formatters join it
/// in Phase 2 (they need `intl` for currencies and grouping; a signed
/// two-decimal percentage doesn't).
abstract final class PercentFormatter {
  /// The minus sign, U+2212: as wide as the plus sign, so a column of
  /// changes lines up. Screen readers get [describeChange] instead.
  static const minus = '−';

  /// A change with its sign and two decimals. It rounds the way
  /// [PriceDirection.ofChange] does, so the sign and the arrow always agree:
  /// a change that rounds to zero has neither.
  static String formatChange(double percent) {
    if (!percent.isFinite) return '—';
    final hundredths = (percent * 100).round();
    final sign = switch (hundredths) {
      > 0 => '+',
      < 0 => minus,
      _ => '',
    };
    return '$sign${_twoDecimals(hundredths.abs())}%';
  }

  /// The same change in words, for screen readers: "Up 2.41%",
  /// "Down 1.20%", "Unchanged".
  static String describeChange(double percent) {
    if (!percent.isFinite) return 'Change unknown';
    final magnitude = '${_twoDecimals((percent * 100).round().abs())}%';
    return switch (PriceDirection.ofChange(percent)) {
      PriceDirection.up => 'Up $magnitude',
      PriceDirection.down => 'Down $magnitude',
      PriceDirection.flat => 'Unchanged',
    };
  }

  /// A share of a whole, from hundredths of a percent: 5237 → "52.37%".
  /// Whole numbers in, so the shares a screen lists add up to exactly
  /// 100.00% (Correctness Rule 10).
  static String formatShare(int basisPoints) => '${_twoDecimals(basisPoints)}%';

  /// 241 → "2.41". Built from whole hundredths rather than
  /// `toStringAsFixed`, so the rounding is exactly the one above.
  static String _twoDecimals(int hundredths) {
    final whole = hundredths ~/ 100;
    final fraction = (hundredths % 100).toString().padLeft(2, '0');
    return '$whole.$fraction';
  }
}
