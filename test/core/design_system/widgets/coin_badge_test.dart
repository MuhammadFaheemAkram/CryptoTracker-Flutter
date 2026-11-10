import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/contrast.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('colorFor', () {
    test('the same symbol always gets the same color, whatever its case', () {
      expect(CoinBadge.colorFor('btc'), CoinBadge.colorFor('BTC'));
      expect(CoinBadge.colorFor('eth'), CoinBadge.colorFor('eth'));
    });

    test('is stable across runs and platforms (FNV-1a, not hashCode)', () {
      // Pinned: if the hash changes, every coin's badge changes color.
      expect(CoinBadge.colorFor('BTC'), CoinBadge.colorFor('BTC'));
      final hue = HSLColor.fromColor(CoinBadge.colorFor('BTC')).hue;
      expect(hue, closeTo(_fnvHue('BTC'), 0.5));
    });

    test('spreads coins over the color wheel', () {
      const symbols = [
        'BTC',
        'ETH',
        'USDT',
        'BNB',
        'SOL',
        'USDC',
        'XRP',
        'DOGE',
        'ADA',
        'SHIB',
        'AVAX',
        'TRX',
      ];
      final hues = {
        for (final symbol in symbols)
          (HSLColor.fromColor(CoinBadge.colorFor(symbol)).hue / 30).floor(),
      };
      // Twelve coins land in at least six of the twelve 30° sectors.
      expect(hues.length, greaterThanOrEqualTo(6));
    });
  });

  group('foregroundOn', () {
    test('the letters meet AA (4.5:1) on every hue', () {
      for (var hue = 0; hue < 360; hue++) {
        final background = HSLColor.fromAHSL(
          1,
          hue.toDouble(),
          0.55,
          0.42,
        ).toColor();
        final foreground = CoinBadge.foregroundOn(background);
        expect(
          contrast(foreground, background),
          greaterThanOrEqualTo(4.5),
          reason: 'hue $hue',
        );
      }
    });

    test('the better of white and black always reaches 4.5:1, even at the '
        'worst luminance', () {
      for (var gray = 0; gray <= 255; gray++) {
        final background = Color.fromARGB(255, gray, gray, gray);
        expect(
          contrast(CoinBadge.foregroundOn(background), background),
          greaterThanOrEqualTo(4.5),
          reason: 'gray $gray',
        );
      }
    });
  });

  testWidgets('shows the symbol in capitals, at most four letters', (
    tester,
  ) async {
    await tester.pumpThemed(
      const Column(
        children: [
          CoinBadge(symbol: 'btc'),
          CoinBadge(symbol: 'matic1'),
        ],
      ),
    );

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('MATI'), findsOneWidget);
  });

  testWidgets('letters only shrink to fit, never grow: a short symbol is '
      'not blown up to fill the circle', (tester) async {
    // One letter: the shortest symbol, so the one `contain` would enlarge
    // most (the test font's square glyphs make "OP" fill it exactly).
    await tester.pumpThemed(const Center(child: CoinBadge(symbol: 'x')));

    // getRect is the painted size (it follows the FittedBox's scaling);
    // getSize is the text's own size before it.
    final painted = tester.getRect(find.text('X')).height;
    final natural = tester.getSize(find.text('X')).height;
    expect(painted, lessThanOrEqualTo(natural + 0.01));
  });

  testWidgets('keeps its size at large text, and screen readers skip it', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    final handle = tester.ensureSemantics();

    await tester.pumpThemed(const Center(child: CoinBadge(symbol: 'usdt')));

    expect(tester.getSize(find.byType(CoinBadge)), const Size.square(40));
    expect(tester.takeException(), isNull);
    expect(find.bySemanticsLabel('USDT'), findsNothing);
    handle.dispose();
  });
}

/// The hue the badge should have, computed independently (FNV-1a 32-bit).
double _fnvHue(String value) {
  var hash = 0x811C9DC5;
  for (final unit in value.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xFFFFFFFF;
  }
  return (hash % 360).toDouble();
}
