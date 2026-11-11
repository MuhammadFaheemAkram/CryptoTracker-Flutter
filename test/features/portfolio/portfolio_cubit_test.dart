import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_portfolio_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:crypto_tracker/domain/usecase/portfolio_use_cases.dart';
import 'package:crypto_tracker/features/portfolio/cubit/portfolio_cubit.dart';
import 'package:crypto_tracker/features/portfolio/cubit/portfolio_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_market_repository.dart';
import '../../helpers/fakes/fake_portfolio_repository.dart';
import '../../helpers/fakes/fake_settings_repository.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/result_matchers.dart';

void main() {
  late FakeMarketRepository market;
  late FakeSettingsRepository settings;
  late FakePortfolioRepository portfolio;
  late PortfolioCubit cubit;
  late List<PortfolioState> states;

  Holding holding(int id, String coinId) => Holding(
    id: id,
    coinId: coinId,
    amount: 1,
    buyPriceUsd: 100,
    createdAt: testNow.add(Duration(minutes: id)),
  );

  PortfolioCubit newCubit() => PortfolioCubit(
    LoadMarketUseCase(market),
    ObservePortfolioUseCase(
      ObservePriceMovesUseCase(market),
      portfolio,
      settings,
    ),
    RemoveHoldingUseCase(portfolio),
    RestoreHoldingUseCase(portfolio),
  );

  Future<void> start({Result<MarketSeed>? result}) async {
    market = FakeMarketRepository(result: result);
    settings = FakeSettingsRepository();
    portfolio = FakePortfolioRepository([
      holding(1, 'bitcoin'),
      holding(2, 'solana'),
    ]);
    cubit = newCubit();
    states = [];
    cubit.stream.listen(states.add);
    await cubit.load();
    await pumpEventQueue();
  }

  tearDown(() async {
    await cubit.close();
    await (market.dispose(), settings.dispose(), portfolio.dispose()).wait;
  });

  List<int> ids() => switch (cubit.state) {
    PortfolioReady(:final listing) => [
      for (final p in listing.valuation.positions) p.holding.id,
    ],
    final state => fail('not ready: $state'),
  };

  test('loads, then values the holdings', () async {
    await start();

    expect(states.first, const PortfolioState.loading());
    expect(ids(), [1, 2]);
  });

  test('remove, then Undo: the same holding back in its place', () async {
    await start();

    final removed = await cubit.remove(1);
    await pumpEventQueue();
    expect(ids(), [2]);

    await cubit.restore((removed as Ok<Holding?>).value!);
    await pumpEventQueue();
    expect(ids(), [1, 2]);
  });

  test('a removal that can\'t be saved says why; nothing changes', () async {
    await start();
    portfolio.failWrites = true;

    expect(await cubit.remove(1), isErrOf<StorageException>());
    await pumpEventQueue();
    expect(ids(), [1, 2]);
  });

  test('a failure shows the error; "Try again" goes live', () async {
    await start(result: const Err(NetworkException()));
    expect(cubit.state, isA<PortfolioError>());

    market.result = Ok(smallMarket());
    await cubit.load();
    await pumpEventQueue();

    expect(ids(), [1, 2]);
  });

  test('closed while the seed was on its way: it never subscribes', () async {
    market = FakeMarketRepository();
    settings = FakeSettingsRepository();
    portfolio = FakePortfolioRepository();
    cubit = newCubit();
    final loading = cubit.load();
    await cubit.close();

    await expectLater(loading, completes);
    await portfolio.add(coinId: 'bitcoin', amount: 1, buyPriceUsd: 1);
    await pumpEventQueue();
    expect(cubit.state, const PortfolioState.loading());
  });
}
