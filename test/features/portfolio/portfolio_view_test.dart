import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/model/portfolio_listing.dart';
import 'package:crypto_tracker/domain/pipeline/portfolio_valuation.dart';
import 'package:crypto_tracker/features/portfolio/cubit/portfolio_cubit.dart';
import 'package:crypto_tracker/features/portfolio/cubit/portfolio_state.dart';
import 'package:crypto_tracker/features/portfolio/portfolio_view.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockPortfolioCubit extends MockCubit<PortfolioState>
    implements PortfolioCubit {}

void main() {
  late _MockPortfolioCubit cubit;
  late int added;
  late List<int> edited;

  // Bitcoin: 0.5 bought at $60,000, now $67,240.50. Solana: 10 at $150,
  // now $148.92.
  final bitcoin = Holding(
    id: 1,
    coinId: 'bitcoin',
    amount: 0.5,
    buyPriceUsd: 60000,
    createdAt: testNow,
  );
  final solana = Holding(
    id: 2,
    coinId: 'solana',
    amount: 10,
    buyPriceUsd: 150,
    createdAt: testNow,
  );

  setUpAll(() => registerFallbackValue(bitcoin));

  setUp(() {
    cubit = _MockPortfolioCubit();
    added = 0;
    edited = [];
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.restore(any())).thenAnswer((_) async => const Ok(null));
  });

  PortfolioState ready(
    List<Holding> holdings, {
    Currency currency = Currency.usd,
    bool paused = false,
  }) {
    final market = smallMarket();
    return PortfolioState.ready(
      PortfolioListing(
        valuation: valuePortfolio(
          coins: market.coins,
          holdings: holdings,
          quotes: market.quotes,
        ),
        currency: currency,
        rate: testRates.rateFor(currency),
        isPaused: paused,
      ),
    );
  }

  Future<void> show(WidgetTester tester, PortfolioState state) async {
    when(() => cubit.state).thenReturn(state);
    await tester.pumpScreen(
      BlocProvider<PortfolioCubit>.value(
        value: cubit,
        child: PortfolioView(
          onAddHolding: () => added++,
          onEditHolding: edited.add,
        ),
      ),
    );
  }

  testWidgets('loading: no Add button yet', (tester) async {
    await show(tester, const PortfolioState.loading());

    expect(find.text('Loading the portfolio…'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('an error: "Try again" loads again', (tester) async {
    await show(tester, const PortfolioState.error('No connection.'));

    await tester.tap(find.text('Try again'));

    verify(() => cubit.load()).called(1);
  });

  testWidgets('no holdings: what to do, and the Add button does it', (
    tester,
  ) async {
    await show(tester, ready(const []));

    expect(find.text('Add your first holding'), findsOneWidget);
    await tester.tap(find.text('Add holding'));
    expect(added, 1);
  });

  testWidgets('the totals: value, P/L and 24 h, each signed and in words', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await show(tester, ready([bitcoin, solana]));

    // 33,620.25 + 1,489.20 = 35,109.45; cost 31,500; P/L +3,609.45.
    expect(find.text(r'$35,109.45'), findsOneWidget);
    expect(find.text(r'+$3,609.45'), findsOneWidget);
    expect(find.bySemanticsLabel(r'Total value, $35,109.45'), findsOneWidget);
    expect(
      find.bySemanticsLabel(r'Profit and loss, plus $3,609.45, Up 11.46%'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp(r'^Over 24 hours, plus \$')),
      findsOneWidget,
    );
    expect(find.byType(PausedChip), findsNothing);
    semantics.dispose();
  });

  testWidgets('the allocation: the donut says it in words, the legend '
      'shows it', (tester) async {
    final semantics = tester.ensureSemantics();
    await show(tester, ready([bitcoin, solana]));

    expect(
      find.bySemanticsLabel(
        'Allocation by value: Bitcoin 95.76%, Solana 4.24%',
      ),
      findsOneWidget,
    );
    expect(find.text('95.76%'), findsOneWidget);
    expect(find.text('4.24%'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('a row per holding: amount, cost, value and P/L', (tester) async {
    await show(tester, ready([bitcoin, solana]));
    // "Solana" is in the legend too: scroll to the row's own line.
    await tester.scrollUntilVisible(find.text('Cost \$1,500.00'), 200);

    expect(find.text('0.5 BTC'), findsOneWidget);
    expect(find.text('Cost \$30,000.00'), findsOneWidget);
    expect(find.text(r'$33,620.25'), findsOneWidget);
    expect(find.text('+\$3,620.25 (+12.07%)'), findsOneWidget);
    expect(find.text('Cost \$1,500.00'), findsOneWidget);
    expect(find.text('−\$10.80 (−0.72%)'), findsOneWidget);
  });

  testWidgets('figures are in the chosen currency', (tester) async {
    await show(tester, ready([bitcoin], currency: Currency.eur));

    expect(find.text('€30,930.63'), findsWidgets); // 33,620.25 × 0.92
  });

  testWidgets('paused: the chip says so', (tester) async {
    await show(tester, ready([bitcoin], paused: true));

    expect(find.byType(PausedChip), findsOneWidget);
  });

  testWidgets('tapping a holding edits it', (tester) async {
    await show(tester, ready([bitcoin]));

    await tester.tap(find.text('Bitcoin').last);

    expect(edited, [1]);
  });

  testWidgets('a swipe removes it, then Undo puts the same holding back', (
    tester,
  ) async {
    when(() => cubit.remove(any())).thenAnswer((_) async => Ok(bitcoin));
    await show(tester, ready([bitcoin, solana]));
    await tester.scrollUntilVisible(find.byType(PositionTile).first, 200);

    await tester.drag(find.byType(PositionTile).first, const Offset(-500, 0));
    await tester.pumpAndSettle();

    verify(() => cubit.remove(1)).called(1);
    expect(find.text('0.5 BTC removed'), findsOneWidget);
    expect(find.byType(PositionTile), findsOneWidget); // hidden at once

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    verify(() => cubit.restore(bitcoin)).called(1);
  });

  testWidgets('a removal that fails slides back and says why', (tester) async {
    when(() => cubit.remove(any()))
        .thenAnswer((_) async => const Err(StorageException()));
    await show(tester, ready([bitcoin]));
    await tester.scrollUntilVisible(find.byType(PositionTile), 200);

    await tester.drag(find.byType(PositionTile), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.byType(PositionTile), findsOneWidget);
    expect(
      find.text("Couldn't save that change. Please try again."),
      findsOneWidget,
    );
  });

  testWidgets('a screen reader removes with an action, not a swipe', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    when(() => cubit.remove(any())).thenAnswer((_) async => Ok(bitcoin));
    await show(tester, ready([bitcoin]));
    await tester.scrollUntilVisible(find.byType(PositionTile), 200);

    tester.semantics.customAction(
      find.semantics.byLabel(RegExp('^Bitcoin, 0.5 BTC')),
      const CustomSemanticsAction(label: 'Remove'),
    );
    await tester.pumpAndSettle();

    verify(() => cubit.remove(1)).called(1);
    expect(find.text('0.5 BTC removed'), findsOneWidget);
    semantics.dispose();
  });
}
