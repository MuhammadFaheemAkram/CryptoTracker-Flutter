import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/chart_range.dart';
import 'package:crypto_tracker/domain/model/coin_detail.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_coin_detail_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:crypto_tracker/domain/usecase/watchlist_use_cases.dart';
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_cubit.dart';
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_state.dart';
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
  late CoinDetailCubit cubit;
  late List<CoinDetailState> states;

  Future<void> start(String coinId, {Result<MarketSeed>? result}) async {
    market = FakeMarketRepository(result: result);
    settings = FakeSettingsRepository();
    watchlist = FakeWatchlistRepository();
    cubit = CoinDetailCubit(
      coinId,
      LoadMarketUseCase(market),
      ObserveCoinDetailUseCase(
        ObservePriceMovesUseCase(market),
        market,
        watchlist,
        settings,
      ),
      ToggleWatchUseCase(watchlist),
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

  CoinDetail detail() => switch (cubit.state) {
    CoinDetailReady(:final detail) => detail,
    final state => fail('not ready: $state'),
  };

  test('loads, then follows the coin', () async {
    await start('ethereum');

    expect(states.first, const CoinDetailState.loading());
    expect(detail().coin.id, 'ethereum');
    expect(detail().quote.priceUsd, 3512.18);
  });

  test('an id the market doesn\'t know: not found', () async {
    await start('dogecoin');

    expect(cubit.state, const CoinDetailState.notFound());
  });

  test('a failure shows the error; "Try again" finds the coin', () async {
    await start('ethereum', result: const Err(NetworkException()));
    expect(cubit.state, isA<CoinDetailError>());

    market.result = Ok(smallMarket());
    await cubit.load();
    await pumpEventQueue();

    expect(detail().coin.id, 'ethereum');
  });

  test('the chart\'s range is an input of the pipeline', () async {
    await start('bitcoin');

    cubit.rangeChanged(ChartRange.sevenDays);
    await pumpEventQueue();

    expect(detail().range, ChartRange.sevenDays);
  });

  test('the star: Ok(true), and the page shows it from the table', () async {
    await start('bitcoin');

    expect(await cubit.toggleWatch(), isOk(true));
    await pumpEventQueue();

    expect(detail().isWatched, isTrue);
    expect(watchlist.ids, ['bitcoin']);
  });

  test('a star that can\'t be saved: Err, and nothing changes', () async {
    await start('bitcoin');
    watchlist.failWrites = true;

    expect(await cubit.toggleWatch(), isErrOf<StorageException>());
    await pumpEventQueue();

    expect(detail().isWatched, isFalse);
  });

  test('close: nothing after it, and the range input is closed', () async {
    await start('bitcoin');
    await cubit.close();
    final before = states.length;

    await watchlist.toggle('bitcoin');
    await pumpEventQueue();

    expect(states, hasLength(before));
    expect(() => cubit.rangeChanged(ChartRange.live), throwsStateError);
  });

  test('closed while the seed was on its way: it never subscribes (the seed '
      'lands during close\'s own awaits)', () async {
    market = FakeMarketRepository();
    settings = FakeSettingsRepository();
    watchlist = FakeWatchlistRepository();
    cubit = CoinDetailCubit(
      'bitcoin',
      LoadMarketUseCase(market),
      ObserveCoinDetailUseCase(
        ObservePriceMovesUseCase(market),
        market,
        watchlist,
        settings,
      ),
      ToggleWatchUseCase(watchlist),
    );
    final loading = cubit.load();
    await cubit.close();

    await expectLater(loading, completes);
    await watchlist.toggle('bitcoin'); // would emit, if it had subscribed
    await pumpEventQueue();
    expect(cubit.state, const CoinDetailState.loading());
  });
}
