import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/domain/model/chart_range.dart';
import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/coin_detail.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/features/coin_detail/coin_detail_view.dart';
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_cubit.dart';
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_state.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockCoinDetailCubit extends MockCubit<CoinDetailState>
    implements CoinDetailCubit {}

void main() {
  setUpAll(() => registerFallbackValue(ChartRange.live));

  late _MockCoinDetailCubit cubit;
  late int addedToPortfolio;
  late int browsed;

  setUp(() {
    cubit = _MockCoinDetailCubit();
    addedToPortfolio = 0;
    browsed = 0;
    when(() => cubit.coinId).thenReturn('bitcoin');
    when(() => cubit.load()).thenAnswer((_) async {});
  });

  // Bitcoin at $67,240.50: 1e7 circulating, 2e7 total, an ATH of $100.
  CoinDetail detail({
    Coin? of,
    List<double> live = const [60000, 61000, 67240.5],
    ChartRange range = ChartRange.live,
    bool watched = false,
    bool paused = false,
    Currency currency = Currency.usd,
  }) => CoinDetail(
    coin:
        of ??
        coin('bitcoin', symbol: 'btc', sparkline7d: const [50000, 67240.5]),
    quote: quote('bitcoin', 67240.5, change: 2.41),
    livePoints: [
      for (final price in live) PricePoint(at: testNow, priceUsd: price),
    ],
    highestSeenUsd: 67240.5,
    isWatched: watched,
    range: range,
    currency: currency,
    rate: testRates.rateFor(currency),
    isPaused: paused,
  );

  Future<void> show(WidgetTester tester, CoinDetailState state) async {
    when(() => cubit.state).thenReturn(state);
    await tester.pumpScreen(
      BlocProvider<CoinDetailCubit>.value(
        value: cubit,
        child: CoinDetailView(
          onAddToPortfolio: () => addedToPortfolio++,
          onBrowseMarket: () => browsed++,
        ),
      ),
    );
  }

  testWidgets('loading', (tester) async {
    await show(tester, const CoinDetailState.loading());

    expect(find.text('Loading the coin…'), findsOneWidget);
    expect(find.byType(WatchStar), findsNothing);
  });

  testWidgets('an error: "Try again" loads again', (tester) async {
    await show(tester, const CoinDetailState.error('No connection.'));

    await tester.tap(find.text('Try again'));

    verify(() => cubit.load()).called(1);
  });

  testWidgets('not found: says which id, and goes to the Market', (
    tester,
  ) async {
    await show(tester, const CoinDetailState.notFound());

    expect(find.widgetWithText(AppBar, 'Coin not found'), findsOneWidget);
    expect(
      find.text('There’s no coin “bitcoin” in the market.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Browse the market'));
    expect(browsed, 1);
  });

  testWidgets('ready: the name as the title, the live price and change, '
      'read as one', (tester) async {
    final semantics = tester.ensureSemantics();
    await show(tester, CoinDetailState.ready(detail()));

    expect(find.widgetWithText(AppBar, 'Bitcoin'), findsOneWidget);
    // The header, and the all-time high (the price is the high here).
    expect(find.text(r'$67,240.50'), findsNWidgets(2));
    expect(find.text('#1 · BTC'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        r'Bitcoin, BTC, rank 1, $67,240.50, Up 2.41% in 24 hours',
      ),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('at the largest text, nothing overflows: the price stays on '
      'one line (it shrinks rather than wrap mid-number), and the ranges '
      'stack', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.1; // iOS AX5
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await show(tester, CoinDetailState.ready(detail()));

    final price = tester.renderObject<RenderParagraph>(
      find.text(r'$67,240.50').first,
    );
    final lineHeight = price.getFullHeightForCaret(
      const TextPosition(offset: 0),
    );
    expect(price.size.height, lessThan(lineHeight * 1.5));
    expect(tester.takeException(), isNull);
    // Live | 7 days stack, as side-by-side controls do at large text.
    expect(
      tester.getTopLeft(find.text('Live')).dy,
      lessThan(tester.getTopLeft(find.text('7 days')).dy),
    );
  });

  testWidgets('the stats are live: market cap from the price, and the '
      'all-time high', (tester) async {
    await show(tester, CoinDetailState.ready(detail()));

    // 1e7 × $67,240.50 = $672B (the seed's $1B is ignored).
    expect(find.text(r'$672B'), findsOneWidget);
    expect(find.text(r'$100M'), findsOneWidget); // volume
    expect(find.text('10M BTC'), findsOneWidget);
    expect(find.text('20M BTC'), findsOneWidget);
    // The price is far above the seed's $100 high: it's the high now.
    expect(
      find.descendant(
        of: find.widgetWithText(StatTile, 'All-time high'),
        matching: find.text(r'$67,240.50'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('no maximum supply reads "Unlimited"', (tester) async {
    final unlimited = coin(
      'bitcoin',
      symbol: 'btc',
    ).copyWith(totalSupply: null);
    await show(tester, CoinDetailState.ready(detail(of: unlimited)));

    expect(find.text('Unlimited'), findsOneWidget);
  });

  testWidgets('figures are in the chosen currency', (tester) async {
    await show(tester, CoinDetailState.ready(detail(currency: Currency.eur)));

    expect(find.text('€61,861.26'), findsWidgets);
  });

  testWidgets('the chart: its trend in words, under it and for a screen '
      'reader', (tester) async {
    final semantics = tester.ensureSemantics();
    await show(tester, CoinDetailState.ready(detail()));

    expect(find.text('Up 12.07% over the last 3 updates'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        RegExp(r'^Up 12\.07% over the last 3 updates\. Low \$60,000\.00'),
      ),
      findsOneWidget,
    );
    expect(find.text('High \$67,240.50'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('one live price so far: "Collecting prices…" (Rule 16)', (
    tester,
  ) async {
    await show(tester, CoinDetailState.ready(detail(live: const [67240.5])));

    expect(find.text(PriceLineChart.collectingMessage), findsOneWidget);
    expect(find.byType(CustomPaint).hitTestable(), findsWidgets);
  });

  testWidgets('7 days: picking it asks the Cubit; the state draws it', (
    tester,
  ) async {
    await show(tester, CoinDetailState.ready(detail()));

    await tester.tap(find.text('7 days'));
    verify(() => cubit.rangeChanged(ChartRange.sevenDays)).called(1);

    await show(
      tester,
      CoinDetailState.ready(detail(range: ChartRange.sevenDays)),
    );
    expect(find.text('Up 34.48% over 7 days'), findsOneWidget);
  });

  testWidgets('the star in the app bar toggles; a failure is said', (
    tester,
  ) async {
    when(() => cubit.toggleWatch())
        .thenAnswer((_) async => const Err(StorageException()));
    await show(tester, CoinDetailState.ready(detail(watched: true)));

    await tester.tap(find.byTooltip('Remove Bitcoin from watchlist'));
    await tester.pumpAndSettle();

    verify(() => cubit.toggleWatch()).called(1);
    expect(
      find.text("Couldn't save that change. Please try again."),
      findsOneWidget,
    );
  });

  testWidgets('paused: the chip says so', (tester) async {
    await show(tester, CoinDetailState.ready(detail(paused: true)));

    expect(find.byType(PausedChip), findsOneWidget);
  });

  testWidgets('Add to portfolio', (tester) async {
    await show(tester, CoinDetailState.ready(detail()));

    await tester.ensureVisible(find.text('Add to portfolio'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to portfolio'));

    expect(addedToPortfolio, 1);
  });
}
