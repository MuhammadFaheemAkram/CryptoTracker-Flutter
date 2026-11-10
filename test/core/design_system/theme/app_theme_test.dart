import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/contrast.dart';

double hueOf(Color color) => HSLColor.fromColor(color).hue;

void main() {
  group('AppTheme', () {
    test('builds Material 3 light and dark themes from the seed', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();

      expect(light.useMaterial3, isTrue);
      expect(light.colorScheme.brightness, Brightness.light);
      expect(dark.colorScheme.brightness, Brightness.dark);
    });

    test('the primary color stays close to the seed (fidelity)', () {
      final primary = HSLColor.fromColor(AppTheme.light().colorScheme.primary);
      final seed = HSLColor.fromColor(AppTheme.seedColor);

      expect((primary.hue - seed.hue).abs(), lessThan(10));
      expect(primary.saturation, greaterThanOrEqualTo(seed.saturation * 0.8));
    });

    test('the seed is neither green nor red: those mean up and down', () {
      final hue = hueOf(AppTheme.seedColor);

      expect(hue, isNot(inInclusiveRange(80, 170)));
      expect(hue < 20 || hue > 340, isFalse);
    });

    test('registers the matching AppColors for each brightness', () {
      expect(AppTheme.light().extension<AppColors>(), same(AppColors.light));
      expect(AppTheme.dark().extension<AppColors>(), same(AppColors.dark));
    });

    test('list rows keep their icon level with the title at large text', () {
      expect(
        AppTheme.light().listTileTheme.titleAlignment,
        ListTileTitleAlignment.titleHeight,
      );
    });
  });

  group('AppColors', () {
    List<Color> tokens(AppColors c) => [
      c.up,
      c.down,
      c.flat,
      c.upFlash,
      c.downFlash,
    ];

    test('lerp interpolates every token', () {
      final mid = AppColors.light.lerp(AppColors.dark, 0.5);

      final (light, dark) = (tokens(AppColors.light), tokens(AppColors.dark));
      expect(tokens(mid), [
        for (var i = 0; i < light.length; i++)
          Color.lerp(light[i], dark[i], 0.5),
      ]);
    });

    test('lerp towards a missing extension keeps the current colors', () {
      expect(AppColors.light.lerp(null, 0.5), same(AppColors.light));
    });

    test('copyWith replaces only the given tokens', () {
      const purple = Color(0xFF7B1FA2);
      final copy = AppColors.light.copyWith(down: purple);

      expect(copy.down, purple);
      expect(copy.up, AppColors.light.up);
      expect(copy.flat, AppColors.light.flat);
      expect(copy.upFlash, AppColors.light.upFlash);
      expect(copy.downFlash, AppColors.light.downFlash);
    });

    for (final (name, colors) in [
      ('light', AppColors.light),
      ('dark', AppColors.dark),
    ]) {
      test('$name: up is green and down is red, in text and in flashes', () {
        for (final green in [colors.up, colors.upFlash]) {
          expect(hueOf(green), inInclusiveRange(90, 160));
        }
        for (final red in [colors.down, colors.downFlash]) {
          final hue = hueOf(red);
          expect(hue < 20 || hue > 340, isTrue, reason: '$hue');
        }
      });

      test('$name: flat is a gray, not a third hue', () {
        expect(HSLColor.fromColor(colors.flat).saturation, lessThan(0.15));
      });
    }

    testWidgets('context.appColors reads the current theme', (tester) async {
      late AppColors colors;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: Builder(
            builder: (context) {
              colors = context.appColors;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(colors, same(AppColors.dark));
    });
  });

  // WCAG contrast checks, so a color tweak can't silently make a price
  // unreadable. Each text color must reach AA (4.5:1) on everything it can
  // sit on: the page, a card, a filled surface, and both flashes (a row can
  // flash red while its 24 h change is still green).
  group('Contrast in both themes', () {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      final name = theme.colorScheme.brightness.name;
      final colors = theme.extension<AppColors>()!;
      final scheme = theme.colorScheme;
      final backgrounds = {
        'the page': scheme.surface,
        'a card': scheme.surfaceContainerLow,
        'a filled surface': scheme.surfaceContainerHighest,
        'an up flash': colors.upFlash,
        'a down flash': colors.downFlash,
      };
      final texts = {
        'up': colors.up,
        'down': colors.down,
        'flat': colors.flat,
        'body text': scheme.onSurface,
        'secondary text': scheme.onSurfaceVariant,
      };

      for (final MapEntry(key: text, value: foreground) in texts.entries) {
        for (final MapEntry(key: surface, value: background)
            in backgrounds.entries) {
          test('$name: $text on $surface meets AA (4.5:1)', () {
            expect(contrast(foreground, background), greaterThanOrEqualTo(4.5));
          });
        }
      }

      test('$name: a flash is visible against the page', () {
        // A tint, not a contrast requirement: different enough to notice.
        expect(contrast(colors.upFlash, scheme.surface), greaterThan(1.1));
        expect(contrast(colors.downFlash, scheme.surface), greaterThan(1.1));
      });
    }
  });
}
