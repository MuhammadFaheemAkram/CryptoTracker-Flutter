import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/domain/pipeline/market_rows.dart';
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart';
import 'package:crypto_tracker/features/market/cubit/market_state.dart';
import 'package:crypto_tracker/features/market/market_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockMarketCubit extends MockCubit<MarketState> implements MarketCubit {}

void main() {
  late _MockMarketCubit cubit;
  late List<String> opened;

  setUp(() {
    cubit = _MockMarketCubit();
    opened = [];
    when(() => cubit.load()).thenAnswer((_) async {});
  });

  MarketState ready({String query = '', SortOption sort = SortOption.rank}) {
    final market = smallMarket();
    return MarketState.ready(
      rows: buildMarketRows(
        coins: market.coins,
        quotes: market.quotes,
        query: query,
        sort: sort,
      ),
      query: query,
      sort: sort,
    );
  }

  Future<void> show(WidgetTester tester, MarketState state) async {
    when(() => cubit.state).thenReturn(state);
    tester.usePhoneSurface();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: BlocProvider<MarketCubit>.value(
          value: cubit,
          child: MarketView(onOpenCoin: opened.add),
        ),
      ),
    );
  }

  testWidgets('loading: a spinner, and nothing to sort yet', (tester) async {
    await show(tester, const MarketState.loading());

    expect(find.text('Loading the market…'), findsOneWidget);
    expect(find.byType(AppSearchField), findsNothing);
    final sort = tester.widget<PopupMenuButton<SortOption>>(
      find.byType(PopupMenuButton<SortOption>),
    );
    expect(sort.enabled, isFalse);
  });

  testWidgets('an error: the reason, and "Try again" loads again', (
    tester,
  ) async {
    await show(tester, const MarketState.error("Couldn't load the market."));

    expect(find.text("Couldn't load the market."), findsOneWidget);
    await tester.tap(find.text('Try again'));

    verify(() => cubit.load()).called(1);
  });

  testWidgets('ready: every coin with its price, change and sparkline, and '
      'a line saying what is shown', (tester) async {
    await show(tester, ready());

    expect(find.byType(CoinRow), findsNWidgets(4));
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text(r'$67,240.50'), findsOneWidget);
    expect(find.text('+2.41%'), findsOneWidget);
    expect(find.text('4 coins · by rank'), findsOneWidget);
  });

  testWidgets('rows are in the order of the state', (tester) async {
    await show(tester, ready(sort: SortOption.price));

    final top = [
      for (final name in ['Bitcoin', 'Ethereum', 'Solana', 'Tether'])
        tester.getTopLeft(find.text(name)).dy,
    ];
    expect(top, [...top]..sort());
    expect(find.text('4 coins · by price'), findsOneWidget);
  });

  testWidgets('typing searches; Clear searches for nothing', (tester) async {
    await show(tester, ready());

    await tester.enterText(find.byType(TextField), 'eth');
    verify(() => cubit.queryChanged('eth')).called(1);

    await tester.pump();
    await tester.tap(find.byTooltip('Clear search'));
    verify(() => cubit.queryChanged('')).called(1);
  });

  testWidgets('a search counts its matches, and nothing matching says so', (
    tester,
  ) async {
    await show(tester, ready(query: 'eth'));
    expect(find.text('2 matches · by rank'), findsOneWidget);

    await show(tester, ready(query: ' doge '));
    expect(find.text('No coins match “doge”'), findsOneWidget);
    expect(find.byType(CoinRow), findsNothing);
  });

  testWidgets('the search keeps its text across states', (tester) async {
    await show(tester, ready(query: 'sol'));

    expect(find.widgetWithText(TextField, 'sol'), findsOneWidget);
  });

  testWidgets('the sort menu checks the current order and picks another', (
    tester,
  ) async {
    await show(tester, ready());

    await tester.tap(find.byTooltip('Sort by rank'));
    await tester.pumpAndSettle();
    final rank = tester.widget<CheckedPopupMenuItem<SortOption>>(
      find.widgetWithText(CheckedPopupMenuItem<SortOption>, 'Rank'),
    );
    expect(rank.checked, isTrue);

    await tester.tap(find.text('24h change'));
    await tester.pumpAndSettle();
    verify(() => cubit.sortChanged(SortOption.change24h)).called(1);
  });

  testWidgets('tapping a coin opens it', (tester) async {
    await show(tester, ready());

    await tester.tap(find.text('Solana'));

    expect(opened, ['solana']);
  });
}
