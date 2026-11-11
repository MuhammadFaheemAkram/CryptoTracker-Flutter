import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/watched_coin.dart';
import 'package:crypto_tracker/domain/model/watchlist_listing.dart';
import 'package:crypto_tracker/domain/pipeline/watchlist_rows.dart';
import 'package:crypto_tracker/features/watchlist/cubit/watchlist_cubit.dart';
import 'package:crypto_tracker/features/watchlist/cubit/watchlist_state.dart';
import 'package:crypto_tracker/features/watchlist/watchlist_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockWatchlistCubit extends MockCubit<WatchlistState>
    implements WatchlistCubit {}

void main() {
  setUpAll(
    () => registerFallbackValue(WatchedCoin(coinId: 'x', addedAt: testNow)),
  );

  late _MockWatchlistCubit cubit;
  late List<String> opened;
  late int browsed;

  setUp(() {
    cubit = _MockWatchlistCubit();
    opened = [];
    browsed = 0;
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.restore(any())).thenAnswer((_) async => const Ok(null));
  });

  WatchlistState ready(List<String> ids, {bool paused = false}) {
    final market = smallMarket();
    return WatchlistState.ready(
      WatchlistListing(
        rows: buildWatchlistRows(
          coins: market.coins,
          quotes: market.quotes,
          watchedIds: ids,
        ),
        currency: Currency.usd,
        rate: 1,
        isPaused: paused,
      ),
    );
  }

  Future<void> show(WidgetTester tester, WatchlistState state) async {
    when(() => cubit.state).thenReturn(state);
    await tester.pumpScreen(
      BlocProvider<WatchlistCubit>.value(
        value: cubit,
        child: WatchlistView(
          onOpenCoin: opened.add,
          onBrowseMarket: () => browsed++,
        ),
      ),
    );
  }

  WatchedCoin removed(String id) => WatchedCoin(coinId: id, addedAt: testNow);

  testWidgets('loading', (tester) async {
    await show(tester, const WatchlistState.loading());

    expect(find.text('Loading the watchlist…'), findsOneWidget);
  });

  testWidgets('an error: the reason, and "Try again" loads again', (
    tester,
  ) async {
    await show(tester, const WatchlistState.error('No connection.'));

    await tester.tap(find.text('Try again'));

    expect(find.text('No connection.'), findsOneWidget);
    verify(() => cubit.load()).called(1);
  });

  testWidgets('nothing starred: how to star, and a way to the Market', (
    tester,
  ) async {
    await show(tester, ready(const []));

    expect(find.text('Star coins to watch them here'), findsOneWidget);
    await tester.tap(find.text('Browse the market'));
    expect(browsed, 1);
  });

  testWidgets('the starred coins, in their order, each with a filled star', (
    tester,
  ) async {
    await show(tester, ready(['solana', 'bitcoin']));

    expect(
      find.text('2 coins · in the order you starred them'),
      findsOneWidget,
    );
    final solana = tester.getTopLeft(find.text('Solana'));
    final bitcoin = tester.getTopLeft(find.text('Bitcoin'));
    expect(solana.dy, lessThan(bitcoin.dy));
    expect(find.byTooltip('Remove Solana from watchlist'), findsOneWidget);
    expect(find.text(r'$148.92'), findsOneWidget);
    expect(find.byType(PausedChip), findsNothing);
  });

  testWidgets('paused: the chip says so', (tester) async {
    await show(tester, ready(['bitcoin'], paused: true));

    expect(find.text('1 coin · in the order you starred them'), findsOneWidget);
    expect(find.byType(PausedChip), findsOneWidget);
  });

  testWidgets('tapping a coin opens it', (tester) async {
    await show(tester, ready(['bitcoin']));

    await tester.tap(find.text('Bitcoin'));

    expect(opened, ['bitcoin']);
  });

  testWidgets('the star removes, and Undo puts the same coin back', (
    tester,
  ) async {
    when(() => cubit.remove(any()))
        .thenAnswer((_) async => Ok(removed('solana')));
    await show(tester, ready(['solana', 'bitcoin']));

    await tester.tap(find.byTooltip('Remove Solana from watchlist'));
    await tester.pumpAndSettle();

    verify(() => cubit.remove('solana')).called(1);
    expect(find.text('Solana removed from watchlist'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    verify(() => cubit.restore(removed('solana'))).called(1);
  });

  testWidgets('the Undo bar stays long enough to reach (8 s), and an Undo '
      'that fails says why', (tester) async {
    when(() => cubit.remove(any()))
        .thenAnswer((_) async => Ok(removed('solana')));
    when(() => cubit.restore(any()))
        .thenAnswer((_) async => const Err(StorageException()));
    await show(tester, ready(['solana', 'bitcoin']));

    await tester.tap(find.byTooltip('Remove Solana from watchlist'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).duration,
      const Duration(seconds: 8),
    );

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(
      find.text("Couldn't save that change. Please try again."),
      findsOneWidget,
    );
    // A plain message: the usual 4 s.
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).duration,
      const Duration(seconds: 4),
    );
  });

  testWidgets('a swipe hides the row at once, before the list says it\'s '
      'gone', (tester) async {
    when(() => cubit.remove(any()))
        .thenAnswer((_) async => Ok(removed('solana')));
    await show(tester, ready(['solana', 'bitcoin']));

    await tester.drag(find.text('Solana'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    // The state still lists Solana (drift hasn't answered): hidden anyway,
    // or the Dismissible would still be in the tree.
    expect(find.text('Solana'), findsNothing);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('Solana removed from watchlist'), findsOneWidget);
    verify(() => cubit.remove('solana')).called(1);
  });

  testWidgets('a swipe whose removal fails slides the row back, and says '
      'why', (tester) async {
    when(() => cubit.remove(any()))
        .thenAnswer((_) async => const Err(StorageException()));
    await show(tester, ready(['solana', 'bitcoin']));

    await tester.drag(find.text('Solana'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Solana'), findsOneWidget);
    expect(
      find.text("Couldn't save that change. Please try again."),
      findsOneWidget,
    );
  });

  testWidgets('a hidden row is forgotten once the list drops it, so a '
      'coin starred again shows again', (tester) async {
    when(() => cubit.remove(any()))
        .thenAnswer((_) async => Ok(removed('solana')));
    final controller = StreamController<WatchlistState>();
    addTearDown(controller.close);
    whenListen(
      cubit,
      controller.stream,
      initialState: ready(['solana', 'bitcoin']),
    );
    await tester.pumpScreen(
      BlocProvider<WatchlistCubit>.value(
        value: cubit,
        child: WatchlistView(onOpenCoin: opened.add, onBrowseMarket: () {}),
      ),
    );

    await tester.drag(find.text('Solana'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    controller.add(ready(['bitcoin'])); // drift: removed
    await tester.pumpAndSettle();
    controller.add(ready(['bitcoin', 'solana'])); // starred again
    await tester.pumpAndSettle();

    expect(find.text('Solana'), findsOneWidget);
  });

  testWidgets('a row the list dropped during the swipe isn\'t remembered '
      '(drift answered first)', (tester) async {
    final controller = StreamController<WatchlistState>();
    addTearDown(controller.close);
    when(() => cubit.remove(any())).thenAnswer((_) async {
      controller.add(ready(['bitcoin'])); // the list drops it at once
      return Ok(removed('solana'));
    });
    whenListen(
      cubit,
      controller.stream,
      initialState: ready(['solana', 'bitcoin']),
    );
    await tester.pumpScreen(
      BlocProvider<WatchlistCubit>.value(
        value: cubit,
        child: WatchlistView(onOpenCoin: opened.add, onBrowseMarket: () {}),
      ),
    );

    await tester.drag(find.text('Solana'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    controller.add(ready(['bitcoin', 'solana'])); // starred again
    await tester.pumpAndSettle();

    expect(find.text('Solana'), findsOneWidget);
  });
}
