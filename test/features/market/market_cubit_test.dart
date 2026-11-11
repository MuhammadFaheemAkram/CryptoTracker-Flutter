import 'dart:async';

import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/market_listing.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:crypto_tracker/domain/usecase/settings_use_cases.dart';
import 'package:crypto_tracker/domain/usecase/watchlist_use_cases.dart';
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart';
import 'package:crypto_tracker/features/market/cubit/market_state.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_market_repository.dart';
import '../../helpers/fakes/fake_settings_repository.dart';
import '../../helpers/fakes/fake_watchlist_repository.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/result_matchers.dart';

// The Market's Cubit on the real pipeline (ObserveMarketUseCase), with the
// market and the settings faked. Everything runs in fake time, so the
// debounce and every tick are exact.
//
// Everything is also *created* inside `fakeAsync`: streams and timers made
// outside the fake zone don't run on its clock (conventions §11.122).
//
// Two tests run in real time instead, with a short debounce: typing that
// replaces a pending query, and closing. Both make rxdart wait for a
// cancelled subscription's `cancel()` future, which completes in the root
// zone, where fake time never reaches (§11.122).
void main() {
  late FakeMarketRepository market;
  late FakeSettingsRepository settings;
  late FakeWatchlistRepository watchlist;
  late MarketCubit cubit;
  late List<MarketState> states;

  /// Builds the fakes and the Cubit, records its states, and loads it.
  void start(
    FakeAsync async, {
    Result<MarketSeed>? result,
    Completer<void>? gate,
  }) {
    market = FakeMarketRepository(result: result)..gate = gate;
    settings = FakeSettingsRepository();
    watchlist = FakeWatchlistRepository();
    cubit = MarketCubit(
      LoadMarketUseCase(market),
      ObserveMarketUseCase(
        ObservePriceMovesUseCase(market),
        settings,
        watchlist,
      ),
      SetLivePricesPausedUseCase(settings),
      ToggleWatchUseCase(watchlist),
    );
    states = [];
    cubit.stream.listen(states.add);
    unawaited(cubit.load());
    async.flushMicrotasks();
  }

  MarketListing listing() => switch (cubit.state) {
    MarketReady(:final listing) => listing,
    final state => fail('not ready: $state'),
  };

  List<String> ids() => [for (final row in listing().rows) row.coin.id];

  tearDown(() async {
    await market.dispose();
    await settings.dispose();
    await watchlist.dispose();
  });

  test('loads, then shows the live market at once (no waiting for a '
      'tick)', () {
    fakeAsync((async) {
      start(async);

      expect(states.first, const MarketState.loading());
      expect(states, hasLength(2));
      expect(ids(), ['bitcoin', 'ethereum', 'tether', 'solana']);
      expect(listing().query, '');
      expect(listing().sort, SortOption.rank);
      expect(listing().currency, Currency.usd);
      expect(listing().rate, 1);
      expect(listing().isPaused, isFalse);
    });
  });

  test('a tick re-derives the rows: the new prices, and which way each '
      'moved, in one state (no glitch)', () {
    fakeAsync((async) {
      start(async);
      final quotes = market.currentQuotes;

      market.emitQuotes({
        ...quotes,
        'bitcoin': quotes['bitcoin']!.copyWith(priceUsd: 70000),
        'ethereum': quotes['ethereum']!.copyWith(priceUsd: 3400),
      });
      async.flushMicrotasks();

      final rows = {for (final row in listing().rows) row.coin.id: row};
      expect(rows['bitcoin']!.quote.priceUsd, 70000);
      expect(rows['bitcoin']!.direction, PriceDirection.up);
      expect(rows['ethereum']!.direction, PriceDirection.down);
      expect(rows['tether']!.direction, PriceDirection.flat);
      expect(states, hasLength(3));
    });
  });

  test('clearing the search shows every coin at once', () {
    fakeAsync((async) {
      start(async);
      cubit.queryChanged('sol');
      async.elapse(searchDebounce);
      expect(ids(), ['solana']);

      cubit.queryChanged('');
      async.flushMicrotasks();

      expect(ids(), hasLength(4));
    });
  });

  test('sorting applies at once, and keeps the search', () {
    fakeAsync((async) {
      start(async);
      cubit.queryChanged('e');
      async.elapse(searchDebounce);

      cubit.sortChanged(SortOption.price);
      async.flushMicrotasks();

      expect(listing().sort, SortOption.price);
      expect(ids(), ['ethereum', 'tether']);
    });
  });

  test('the same sort again, or the same query with spaces, derives '
      'nothing new', () {
    fakeAsync((async) {
      start(async);
      cubit.queryChanged('sol');
      async.elapse(searchDebounce);
      final before = states.length;

      cubit
        ..sortChanged(SortOption.rank)
        ..queryChanged(' sol ');
      async.elapse(searchDebounce);

      expect(states, hasLength(before));
    });
  });

  test('a new currency: the listing carries it, with its rate', () {
    fakeAsync((async) {
      start(async);

      unawaited(settings.update((s) => s.copyWith(currency: Currency.eur)));
      async.flushMicrotasks();

      expect(listing().currency, Currency.eur);
      expect(listing().rate, 0.92);
    });
  });

  test('pausing: the setting changes, and the listing says so', () {
    fakeAsync((async) {
      start(async);

      unawaited(cubit.setPaused(paused: true));
      async.flushMicrotasks();
      expect(settings.current.livePricesPaused, isTrue);
      expect(listing().isPaused, isTrue);

      unawaited(cubit.setPaused(paused: false));
      async.flushMicrotasks();
      expect(listing().isPaused, isFalse);
    });
  });

  test('a failure shows the error; "Try again" goes live', () {
    fakeAsync((async) {
      start(async, result: const Err(NetworkException()));
      expect(cubit.state, MarketState.error(const NetworkException().message));

      market.result = Ok(smallMarket());
      unawaited(cubit.load());
      async.flushMicrotasks();

      expect(ids(), hasLength(4));
      expect(market.loads, 2);
    });
  });

  test('once live, load() does nothing', () {
    fakeAsync((async) {
      start(async);
      final before = states.length;

      unawaited(cubit.load());
      async.flushMicrotasks();

      expect(states, hasLength(before));
      expect(market.loads, 1);
    });
  });

  test('an answer that arrives after the screen closed is dropped', () {
    fakeAsync((async) {
      start(async, gate: Completer<void>());
      unawaited(cubit.close());
      async.flushMicrotasks();

      market.gate!.complete();
      async.flushMicrotasks();

      expect(cubit.state, const MarketState.loading());
    });
  });

  test('the star writes the watchlist; the filled star comes back through '
      'the pipeline', () {
    fakeAsync((async) {
      start(async);
      Result<bool>? result;

      unawaited(cubit.toggleWatch('ethereum').then((r) => result = r));
      async.flushMicrotasks();

      expect(result, isOk(true));
      expect(watchlist.ids, ['ethereum']);
      expect(
        [
          for (final row in listing().rows)
            if (row.isWatched) row.coin.id,
        ],
        ['ethereum'],
      );
    });
  });

  test('a star that can\'t be saved says why, and stars nothing', () {
    fakeAsync((async) {
      start(async);
      watchlist.failWrites = true;
      Result<bool>? result;

      unawaited(cubit.toggleWatch('ethereum').then((r) => result = r));
      async.flushMicrotasks();

      expect(result, isErrOf<StorageException>());
      expect(listing().rows.any((row) => row.isWatched), isFalse);
    });
  });

  group('in real time', () {
    const debounce = Duration(milliseconds: 40);

    Future<void> startLive() async {
      market = FakeMarketRepository();
      settings = FakeSettingsRepository();
      watchlist = FakeWatchlistRepository();
      cubit = MarketCubit(
        LoadMarketUseCase(market),
        ObserveMarketUseCase(
          ObservePriceMovesUseCase(market),
          settings,
          watchlist,
        ),
        SetLivePricesPausedUseCase(settings),
        ToggleWatchUseCase(watchlist),
        debounce: debounce,
      );
      states = [];
      cubit.stream.listen(states.add);
      await cubit.load();
      await pumpEventQueue();
    }

    test('typing is debounced: each keystroke restarts the wait, and only '
        'the query that survives it filters the list', () async {
      await startLive();
      final before = states.length;

      for (final typed in ['s', 'so', 'sol']) {
        cubit.queryChanged(typed);
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(states, hasLength(before), reason: 'still typing');

      await Future<void>.delayed(debounce * 3);
      expect(states, hasLength(before + 1), reason: 'one search, not three');
      expect(listing().query, 'sol');
      expect(ids(), ['solana']);
    });

    test('clearing the field cancels a query still waiting', () async {
      await startLive();
      cubit.queryChanged('sol');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      cubit.queryChanged('');
      await Future<void>.delayed(debounce * 3);

      expect(ids(), hasLength(4));
      expect(
        states.whereType<MarketReady>().map((s) => s.listing.query),
        isNot(contains('sol')),
      );
    });

    test('closed while the seed was on its way: it never subscribes (the '
        'seed lands during close\'s own awaits)', () async {
      market = FakeMarketRepository();
      settings = FakeSettingsRepository();
      watchlist = FakeWatchlistRepository();
      cubit = MarketCubit(
        LoadMarketUseCase(market),
        ObserveMarketUseCase(
          ObservePriceMovesUseCase(market),
          settings,
          watchlist,
        ),
        SetLivePricesPausedUseCase(settings),
        ToggleWatchUseCase(watchlist),
        debounce: debounce,
      );
      final loading = cubit.load();
      await cubit.close();

      await expectLater(loading, completes);
      market.emitQuotes({...market.currentQuotes});
      await pumpEventQueue();
      expect(cubit.state, const MarketState.loading());
    });

    test('close: nothing after it, and the Cubit is closed', () async {
      await startLive();
      await cubit.close();
      final before = states.length;

      market.emitQuotes({...market.currentQuotes});
      await pumpEventQueue();

      expect(states, hasLength(before));
      expect(cubit.isClosed, isTrue);
    });
  });
}
