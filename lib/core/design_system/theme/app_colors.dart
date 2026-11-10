import 'package:material_ui/material_ui.dart';

/// The market's colors: the ones Material's [ColorScheme] has no slot for.
///
/// A [ThemeExtension] travels inside [ThemeData], so the light and dark
/// variants switch automatically (and animate via [lerp]) when the theme
/// changes. Widgets ask for an *intent* (`up`, `down`) instead of hard-coding
/// a green or a red.
///
/// Two kinds of token:
/// - [up], [down], [flat]: text and icon colors (a price change, an arrow).
///   They sit on the page, on cards, and on either flash, so each must reach
///   WCAG AA (4.5:1) on all of them, in both themes. A row can flash red
///   while its 24 h change is still green, so both colors must read on
///   both flashes.
/// - [upFlash], [downFlash]: the background a row flashes when its price
///   ticks up or down. The row's ordinary text must stay readable on them.
///
/// Color is never the only signal: a change always has an arrow and a sign
/// too (Correctness Rule 13). All of this is checked by a test.
@immutable
final class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.up,
    required this.down,
    required this.flat,
    required this.upFlash,
    required this.downFlash,
  });

  /// A price or a change going up.
  final Color up;

  /// A price or a change going down.
  final Color down;

  /// No change (or too small to show).
  final Color flat;

  /// A row's background for a moment after its price ticks up.
  final Color upFlash;

  /// A row's background for a moment after its price ticks down.
  final Color downFlash;

  static const light = AppColors(
    up: Color(0xFF146C2E),
    down: Color(0xFFB3261E),
    flat: Color(0xFF51565E),
    upFlash: Color(0xFFD1F1D7),
    downFlash: Color(0xFFFCE1DF),
  );

  static const dark = AppColors(
    up: Color(0xFF86D993),
    down: Color(0xFFFF9C92),
    flat: Color(0xFFB9BEC6),
    upFlash: Color(0xFF1E3B24),
    downFlash: Color(0xFF4A1F1C),
  );

  @override
  AppColors copyWith({
    Color? up,
    Color? down,
    Color? flat,
    Color? upFlash,
    Color? downFlash,
  }) {
    return AppColors(
      up: up ?? this.up,
      down: down ?? this.down,
      flat: flat ?? this.flat,
      upFlash: upFlash ?? this.upFlash,
      downFlash: downFlash ?? this.downFlash,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      up: Color.lerp(up, other.up, t)!,
      down: Color.lerp(down, other.down, t)!,
      flat: Color.lerp(flat, other.flat, t)!,
      upFlash: Color.lerp(upFlash, other.upFlash, t)!,
      downFlash: Color.lerp(downFlash, other.downFlash, t)!,
    );
  }
}

/// Shorthand for `Theme.of(context).extension<AppColors>()!`.
extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
