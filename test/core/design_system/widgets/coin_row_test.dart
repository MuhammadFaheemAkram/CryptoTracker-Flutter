import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Widget bitcoin({
    VoidCallback? onTap,
    Widget? trailing,
    String? name,
    List<double>? sparkline,
  }) => ListView(
    children: [
      CoinRow(
        rank: 1,
        symbol: 'btc',
        name: name ?? 'Bitcoin',
        price: r'$67,240.50',
        change24hPercent: 2.41,
        sparkline: sparkline,
        onTap: onTap,
        trailing: trailing,
      ),
    ],
  );

  testWidgets('shows the badge, name, rank with symbol, price and change', (
    tester,
  ) async {
    await tester.pumpThemed(bitcoin());

    expect(find.byType(CoinBadge), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('#1 · BTC'), findsOneWidget);
    expect(find.text(r'$67,240.50'), findsOneWidget);
    expect(find.text('+2.41%'), findsOneWidget);
  });

  group('the sparkline', () {
    const week = [1.0, 2.0, 1.5, 3.0];

    testWidgets('shows between the name and the price on a phone', (
      tester,
    ) async {
      tester.usePhoneSurface();
      await tester.pumpThemed(bitcoin(sparkline: week));

      final line = tester.getCenter(find.byType(Sparkline));
      expect(line.dx, greaterThan(tester.getCenter(find.text('Bitcoin')).dx));
      expect(line.dx, lessThan(tester.getCenter(find.text(r'$67,240.50')).dx));
    });

    testWidgets('keeps its place next to the watchlist star on a phone', (
      tester,
    ) async {
      tester.usePhoneSurface(); // 390 wide: the narrower of today's phones
      await tester.pumpThemed(
        CoinRow(
          rank: 1,
          symbol: 'btc',
          name: 'Bitcoin',
          price: r'$67,240.50',
          change24hPercent: 2.41,
          sparkline: week,
          trailing: WatchStar(
            coinName: 'Bitcoin',
            isWatched: false,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(Sparkline), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('is left out on a row too narrow for it', (tester) async {
      tester.view
        ..physicalSize = const Size(320 * 3, 800 * 3)
        ..devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpThemed(bitcoin(sparkline: week));

      expect(find.byType(Sparkline), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('is left out at large text', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      tester.usePhoneSurface();

      await tester.pumpThemed(bitcoin(sparkline: week));

      expect(find.byType(Sparkline), findsNothing);
    });

    testWidgets('is not part of what a screen reader hears', (tester) async {
      final handle = tester.ensureSemantics();
      tester.usePhoneSurface();
      await tester.pumpThemed(bitcoin(sparkline: week, onTap: () {}));

      expect(
        find.bySemanticsLabel(r'Bitcoin, BTC, rank 1, $67,240.50, Up 2.41%'),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  testWidgets('a tap anywhere on it calls onTap', (tester) async {
    var taps = 0;
    await tester.pumpThemed(bitcoin(onTap: () => taps++));

    await tester.tap(find.text('Bitcoin'));
    await tester.tap(find.text(r'$67,240.50'));

    expect(taps, 2);
  });

  testWidgets('a screen reader hears one button that says everything', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpThemed(bitcoin(onTap: () {}));

    final row = find.bySemanticsLabel(
      r'Bitcoin, BTC, rank 1, $67,240.50, Up 2.41%',
    );
    expect(row, findsOneWidget);
    expect(
      tester.getSemantics(row),
      matchesSemantics(
        label: r'Bitcoin, BTC, rank 1, $67,240.50, Up 2.41%',
        isButton: true,
        hasTapAction: true,
      ),
    );
    // Nothing inside it is read twice.
    expect(find.bySemanticsLabel('Bitcoin'), findsNothing);
    expect(find.bySemanticsLabel('Up 2.41%'), findsNothing);
    handle.dispose();
  });

  testWidgets('without onTap it reads as text, not a button', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpThemed(bitcoin());

    final row = find.bySemanticsLabel(RegExp('^Bitcoin, BTC'));
    expect(tester.getSemantics(row), isNot(matchesSemantics(isButton: true)));
    handle.dispose();
  });

  testWidgets('the trailing control keeps its own node and its own tap', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var rowTaps = 0;
    var starTaps = 0;
    await tester.pumpThemed(
      bitcoin(
        onTap: () => rowTaps++,
        trailing: IconButton(
          tooltip: 'Add to watchlist',
          icon: const Icon(Icons.star_outline),
          onPressed: () => starTaps++,
        ),
      ),
    );

    // An IconButton's tooltip is its semantic tooltip, on a node of its own.
    expect(
      tester.getSemantics(find.byTooltip('Add to watchlist')),
      matchesSemantics(
        tooltip: 'Add to watchlist',
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    await tester.tap(find.byTooltip('Add to watchlist'));

    expect((starTaps, rowTaps), (1, 0));
    handle.dispose();
  });

  group('large text', () {
    testWidgets('above 130 % everything goes under the name', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      tester.usePhoneSurface();

      await tester.pumpThemed(bitcoin());

      expect(find.text('#1 · BTC'), findsOneWidget);
      final name = tester.getTopLeft(find.text('Bitcoin'));
      final price = tester.getTopLeft(find.text(r'$67,240.50'));
      expect(price.dy, greaterThan(name.dy));
      expect(price.dx, name.dx);
    });

    testWidgets('a long name at 200 % wraps instead of overflowing', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      tester.usePhoneSurface();

      await tester.pumpThemed(
        bitcoin(
          name: 'Wrapped Liquid Staked Ether Total Value Locked',
          trailing: IconButton(
            tooltip: 'Add to watchlist',
            icon: const Icon(Icons.star_outline),
            onPressed: () {},
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('side by side, a long name is cut short, never the price', (
      tester,
    ) async {
      tester.usePhoneSurface();

      await tester.pumpThemed(
        bitcoin(name: 'Wrapped Liquid Staked Ether Total Value Locked'),
      );

      expect(tester.takeException(), isNull);
      final price = tester.widget<Text>(find.text(r'$67,240.50'));
      expect(price.overflow, isNull);
      expect(
        tester.widget<Text>(find.textContaining('Wrapped')).overflow,
        TextOverflow.ellipsis,
      );
    });
  });

  testWidgets('meets the tap-target, label and contrast guidelines, light '
      'and dark, at 200 %', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    tester.usePhoneSurface();
    final handle = tester.ensureSemantics();

    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      await tester.pumpThemed(
        bitcoin(
          onTap: () {},
          trailing: IconButton(
            tooltip: 'Add to watchlist',
            icon: const Icon(Icons.star_outline),
            onPressed: () {},
          ),
        ),
        theme: theme,
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
    handle.dispose();
  });
}
