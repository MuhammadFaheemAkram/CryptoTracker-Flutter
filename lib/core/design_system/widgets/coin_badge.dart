import 'package:material_ui/material_ui.dart';

/// A coin's badge: its symbol in a colored circle.
///
/// The app needs no network and no image assets: every coin gets a badge
/// whose color is derived from its symbol, the same on every launch and on
/// every device. It's decorative (the row next to it names the coin), so
/// screen readers skip it.
class CoinBadge extends StatelessWidget {
  const CoinBadge({super.key, required this.symbol, this.size = 40});

  /// The coin's ticker symbol, e.g. "btc". Shown in capitals, at most four
  /// letters.
  final String symbol;

  /// The circle's diameter in logical pixels.
  final double size;

  /// The badge's background for [symbol].
  ///
  /// The hue comes from a hash of the symbol. It's FNV-1a rather than
  /// `String.hashCode`, which Dart doesn't promise to keep stable across
  /// versions or platforms: BTC must look the same everywhere. Saturation
  /// and lightness are fixed, so badges differ in hue only.
  static Color colorFor(String symbol) {
    final hue = (_fnv1a(symbol.toUpperCase()) % 360).toDouble();
    return HSLColor.fromAHSL(1, hue, 0.55, 0.42).toColor();
  }

  /// The text color on [background]: white or black, whichever contrasts
  /// more.
  ///
  /// Whatever the background, the better of the two reaches about 4.58:1
  /// (they tie at a luminance of 0.179), so a badge's letters always meet
  /// WCAG AA. It must be *pure* black: with a near-black such as #111 the
  /// tie drops to 4.35:1. A test checks every hue.
  static Color foregroundOn(Color background) {
    final luminance = background.computeLuminance();
    final onWhite = 1.05 / (luminance + 0.05);
    final onBlack = (luminance + 0.05) / 0.05;
    return onWhite >= onBlack ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final background = colorFor(symbol);
    final upper = symbol.toUpperCase();
    final label = upper.length > 4 ? upper.substring(0, 4) : upper;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: Padding(
            padding: EdgeInsets.all(size * 0.16),
            // A fixed-size circle: its letters keep one size, shrinking
            // only when four don't fit (`scaleDown`: never growing, so "OP"
            // isn't twice the size of "BTC"), and never growing with the
            // text setting (the name beside it grows).
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  color: foregroundOn(background),
                  fontWeight: FontWeight.w700,
                  fontSize: size * 0.34,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 32-bit FNV-1a over the string's UTF-16 code units.
int _fnv1a(String value) {
  var hash = 0x811C9DC5;
  for (final unit in value.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash;
}
