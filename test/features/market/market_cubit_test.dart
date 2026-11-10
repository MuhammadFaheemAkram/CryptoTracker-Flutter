import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart';
import 'package:crypto_tracker/features/market/cubit/market_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_market_repository.dart';

void main() {
  late FakeMarketRepository market;

  setUp(() => market = FakeMarketRepository());

  MarketCubit build() => MarketCubit(LoadMarketUseCase(market));

  /// The ids a state shows, for short expectations.
  List<String> idsOf(MarketState state) => switch (state) {
    MarketReady(:final rows) => [for (final row in rows) row.coin.id],
    _ => fail('not ready: $state'),
  };

  test('starts loading', () {
    expect(build().state, const MarketState.loading());
  });

  blocTest<MarketCubit, MarketState>(
    'load: loading, then every coin by rank',
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const MarketState.loading(),
      isA<MarketReady>()
          .having((s) => s.query, 'query', '')
          .having((s) => s.sort, 'sort', SortOption.rank)
          .having(idsOf, 'ids', ['bitcoin', 'ethereum', 'tether', 'solana']),
    ],
  );

  blocTest<MarketCubit, MarketState>(
    'a failure: the error, with its message',
    setUp: () => market.result = const Err(NetworkException()),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const MarketState.loading(),
      MarketState.error(const NetworkException().message),
    ],
  );

  blocTest<MarketCubit, MarketState>(
    '"Try again" after a failure loads again',
    setUp: () => market.result = const Err(NetworkException()),
    build: build,
    act: (cubit) async {
      await cubit.load();
      market.result = FakeMarketRepository().result;
      await cubit.load();
    },
    skip: 2,
    expect: () => [const MarketState.loading(), isA<MarketReady>()],
    verify: (_) => expect(market.loads, 2),
  );

  blocTest<MarketCubit, MarketState>(
    'once loaded, load() does nothing (the seed is loaded once)',
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.load();
    },
    expect: () => [const MarketState.loading(), isA<MarketReady>()],
    verify: (_) => expect(market.loads, 1),
  );

  blocTest<MarketCubit, MarketState>(
    'searching narrows the list at once (no debounce until Phase 3)',
    build: build,
    act: (cubit) async {
      await cubit.load();
      cubit.queryChanged('eth');
    },
    skip: 2,
    expect: () => [
      isA<MarketReady>().having((s) => s.query, 'query', 'eth').having(
        idsOf,
        'ids',
        ['ethereum', 'tether'],
      ),
    ],
  );

  blocTest<MarketCubit, MarketState>(
    'nothing matching is a ready state with no rows',
    build: build,
    act: (cubit) async {
      await cubit.load();
      cubit.queryChanged('doge');
    },
    skip: 2,
    expect: () => [isA<MarketReady>().having(idsOf, 'ids', isEmpty)],
  );

  blocTest<MarketCubit, MarketState>(
    'sorting re-derives the list, and keeps the search',
    build: build,
    act: (cubit) async {
      await cubit.load();
      cubit
        ..queryChanged('e')
        ..sortChanged(SortOption.price);
    },
    skip: 3,
    expect: () => [
      isA<MarketReady>().having((s) => s.sort, 'sort', SortOption.price).having(
        idsOf,
        'ids',
        ['ethereum', 'tether'],
      ),
    ],
  );

  blocTest<MarketCubit, MarketState>(
    'a search or a sort before the market loads is kept, and applied when '
    'it arrives',
    setUp: () => market.gate = Completer<void>(),
    build: build,
    act: (cubit) async {
      final loading = cubit.load();
      cubit
        ..queryChanged('sol')
        ..sortChanged(SortOption.name);
      market.gate!.complete();
      await loading;
    },
    expect: () => [
      const MarketState.loading(),
      isA<MarketReady>().having((s) => s.sort, 'sort', SortOption.name).having(
        idsOf,
        'ids',
        ['solana'],
      ),
    ],
  );

  test('an answer after the screen closed is dropped', () async {
    market.gate = Completer<void>();
    final cubit = build();
    final loading = cubit.load();
    await cubit.close();

    market.gate!.complete();
    await expectLater(loading, completes);
  });
}
