import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

// The flash: a tint that fades over 600 ms after a *tick*, and only then.
void main() {
  Widget row({
    required Object? tick,
    PriceDirection direction = PriceDirection.up,
    String price = r'$100.00',
  }) => ListView(
    children: [
      CoinRow(
        rank: 1,
        symbol: 'btc',
        name: 'Bitcoin',
        price: price,
        change24hPercent: 1,
        direction: direction,
        tick: tick,
      ),
    ],
  );

  /// The row's background right now (`null`: none).
  Color? tint(WidgetTester tester) {
    final ink = tester.widget<Ink>(
      find.descendant(of: find.byType(CoinRow), matching: find.byType(Ink)),
    );
    return (ink.decoration as BoxDecoration?)?.color;
  }

  testWidgets('the first build doesn\'t flash', (tester) async {
    await tester.pumpThemed(row(tick: 1));

    expect(tint(tester), isNull);
  });

  testWidgets('a tick up flashes the up tint, fading out over 600 ms', (
    tester,
  ) async {
    await tester.pumpThemed(row(tick: 1));

    await tester.pumpThemed(row(tick: 2));
    expect(tint(tester), AppColors.light.upFlash);

    await tester.pump(const Duration(milliseconds: 300));
    expect(tint(tester)!.a, closeTo(0.5, 0.05));

    await tester.pump(const Duration(milliseconds: 300));
    expect(tint(tester)?.a ?? 0, closeTo(0, 0.01), reason: 'faded out');

    await tester.pumpAndSettle();
    expect(tint(tester), isNull, reason: 'no background left at all');
  });

  testWidgets('a tick down flashes the down tint', (tester) async {
    await tester.pumpThemed(row(tick: 1, direction: PriceDirection.down));

    await tester.pumpThemed(row(tick: 2, direction: PriceDirection.down));

    expect(tint(tester), AppColors.light.downFlash);
  });

  testWidgets('a rebuild without a new tick (a re-sort, a search, a new '
      'currency) doesn\'t flash', (tester) async {
    await tester.pumpThemed(row(tick: 1));

    await tester.pumpThemed(row(tick: 1, price: '€92.00'));

    expect(tint(tester), isNull);
  });

  testWidgets('a tick that didn\'t move the price doesn\'t flash', (
    tester,
  ) async {
    await tester.pumpThemed(row(tick: 1, direction: PriceDirection.flat));

    await tester.pumpThemed(row(tick: 2, direction: PriceDirection.flat));

    expect(tint(tester), isNull);
  });

  testWidgets('a new tick restarts the fade', (tester) async {
    await tester.pumpThemed(row(tick: 1));
    await tester.pumpThemed(row(tick: 2));
    await tester.pump(const Duration(milliseconds: 500));

    await tester.pumpThemed(row(tick: 3));

    expect(tint(tester), AppColors.light.upFlash);
  });

  group('reduced motion', () {
    Widget reduced(Widget child) => MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: child,
    );

    testWidgets('nothing flashes', (tester) async {
      await tester.pumpThemed(reduced(row(tick: 1)));

      await tester.pumpThemed(reduced(row(tick: 2)));

      expect(tint(tester), isNull);
    });

    testWidgets('the price changes at once, no cross-fade', (tester) async {
      await tester.pumpThemed(reduced(row(tick: 1)));

      await tester.pumpThemed(reduced(row(tick: 2, price: r'$101.00')));
      await tester.pump();

      expect(find.text(r'$100.00'), findsNothing);
      expect(find.text(r'$101.00'), findsOneWidget);
    });
  });

  testWidgets('the price cross-fades to its new value', (tester) async {
    await tester.pumpThemed(row(tick: 1));

    await tester.pumpThemed(row(tick: 2, price: r'$101.00'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text(r'$100.00'), findsOneWidget, reason: 'fading out');
    expect(find.text(r'$101.00'), findsOneWidget, reason: 'fading in');

    await tester.pumpAndSettle();
    expect(find.text(r'$100.00'), findsNothing);
  });

  testWidgets('a screen reader hears the new price once, as part of the row', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpThemed(row(tick: 1));

    await tester.pumpThemed(row(tick: 2, price: r'$101.00'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.bySemanticsLabel(RegExp(r'\$101\.00')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp(r'\$100\.00')), findsNothing);
    handle.dispose();
  });

  testWidgets('the row is not a live region: ticks don\'t interrupt a screen '
      'reader (Correctness Rule 13)', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpThemed(row(tick: 1));

    expect(
      tester.getSemantics(find.bySemanticsLabel(RegExp('^Bitcoin'))),
      isNot(matchesSemantics(isLiveRegion: true)),
    );
    handle.dispose();
  });
}
