import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/watched_coin.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_watchlist_rows_use_case.dart';
import 'package:crypto_tracker/domain/usecase/watchlist_use_cases.dart';
import 'package:crypto_tracker/features/watchlist/cubit/watchlist_cubit.dart';
import 'package:crypto_tracker/features/watchlist/cubit/watchlist_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_market_repository.dart';
import '../../helpers/fakes/fake_settings_repository.dart';
import '../../helpers/fakes/fake_watchlist_repository.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/result_matchers.dart';

void main() {
  late FakeMarketRepository market;
  late FakeSettingsRepository settings;
  late FakeWatchlistRepository watchlist;
  late WatchlistCubit cubit;
  late List<WatchlistState> states;

  Future<void> start({Result<MarketSeed>? result}) async {
    market = FakeMarketRepository(result: result);
    settings = FakeSettingsRepository();
    watchlist = FakeWatchlistRepository(['solana', 'bitcoin']);
    cubit = WatchlistCubit(
      LoadMarketUseCase(market),
      ObserveWatchlistRowsUseCase(
        ObservePriceMovesUseCase(market),
        watchlist,
        settings,
      ),
      RemoveFromWatchlistUseCase(watchlist),
      RestoreWatchedCoinUseCase(watchlist),
    );
    states = [];
    cubit.stream.listen(states.add);
    await cubit.load();
    await pumpEventQueue();
  }

  tearDown(() async {
    await cubit.close();
    await (market.dispose(), settings.dispose(), watchlist.dispose()).wait;
  });

  List<String> ids() => switch (cubit.state) {
    WatchlistReady(:final listing) => [
      for (final row in listing.rows) row.coin.id,
    ],
    final state => fail('not ready: $state'),
  };

  test('loads, then shows the starred coins in their order', () async {
    await start();

    expect(states.first, const WatchlistState.loading());
    expect(ids(), ['solana', 'bitcoin']);
  });

  test('remove: the row leaves when the table says so; Undo brings it back '
      'to its place', () async {
    await start();

    final removed = await cubit.remove('solana');
    await pumpEventQueue();
    expect(removed, isOk(isA<WatchedCoin>()));
    expect(ids(), ['bitcoin']);

    await cubit.restore((removed as Ok<WatchedCoin?>).value!);
    await pumpEventQueue();
    expect(ids(), ['solana', 'bitcoin']);
  });

  test('a removal that can\'t be saved says why; the row stays', () async {
    await start();
    watchlist.failWrites = true;

    expect(await cubit.remove('solana'), isErrOf<StorageException>());
    await pumpEventQueue();

    expect(ids(), ['solana', 'bitcoin']);
  });

  test('a failure shows the error; "Try again" goes live', () async {
    await start(result: const Err(NetworkException()));
    expect(cubit.state, isA<WatchlistError>());

    market.result = Ok(smallMarket());
    await cubit.load();
    await pumpEventQueue();

    expect(cubit.state, isA<WatchlistReady>());
  });

  test('close: nothing after it', () async {
    await start();
    await cubit.close();
    final before = states.length;

    await watchlist.toggle('ethereum');
    await pumpEventQueue();

    expect(states, hasLength(before));
  });

  test('closed while the seed was on its way: it never subscribes', () async {
    market = FakeMarketRepository();
    settings = FakeSettingsRepository();
    watchlist = FakeWatchlistRepository();
    cubit = WatchlistCubit(
      LoadMarketUseCase(market),
      ObserveWatchlistRowsUseCase(
        ObservePriceMovesUseCase(market),
        watchlist,
        settings,
      ),
      RemoveFromWatchlistUseCase(watchlist),
      RestoreWatchedCoinUseCase(watchlist),
    );
    final loading = cubit.load();
    await cubit.close();

    await expectLater(loading, completes);
    await watchlist.toggle('bitcoin');
    await pumpEventQueue();
    expect(cubit.state, const WatchlistState.loading());
  });
}
