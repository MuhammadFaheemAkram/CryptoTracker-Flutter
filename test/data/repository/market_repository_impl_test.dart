import 'dart:async';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/prices/price_history.dart';
import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/core/prices/random_walk.dart';
import 'package:crypto_tracker/data/repository/market_repository_impl.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../helpers/fakes/scripted_market_api.dart';
import '../../helpers/fixtures.dart';

void main() {
  late ScriptedMarketApi api;
  late PriceTicker ticker;
  late PriceHistory history;
  late MarketRepositoryImpl repository;

  PriceTicker newTicker() =>
      PriceTicker(RandomWalk(Random(7)), Clock.fixed(testNow));

  setUp(() {
    ticker = newTicker();
    addTearDown(ticker.dispose);
    api = ScriptedMarketApi(
      coins: [
        coinDto(id: 'ethereum', symbol: 'eth', name: 'Ethereum', rank: 2),
        coinDto(),
      ],
    );
    history = PriceHistory(ticker);
    addTearDown(history.dispose);
    repository = MarketRepositoryImpl(
      api,
      Clock.fixed(testNow),
      ticker,
      history,
    );
  });

  MarketSeed seedOf(Result<MarketSeed> result) => switch (result) {
    Ok(:final value) => value,
    Err(:final exception) => fail('expected a seed, got $exception'),
  };

  Matcher failsWith<T extends AppException>() =>
      isA<Err<MarketSeed>>().having((e) => e.exception, 'exception', isA<T>());

  test('loads the coins in rank order, their quotes and the rates', () async {
    final seed = seedOf(await repository.loadMarket());

    expect(seed.coins.map((c) => c.id), ['bitcoin', 'ethereum']);
    expect(seed.quotes.keys, unorderedEquals(['bitcoin', 'ethereum']));
    expect(seed.quotes['bitcoin']!.priceUsd, 67240.5);
    expect(seed.quotes['bitcoin']!.updatedAt, testNow);
    expect(seed.rates, testRates);
  });

  test('the seed\'s quotes become the ticker\'s first snapshot', () async {
    expect(ticker.quotes.hasValue, isFalse);

    final seed = seedOf(await repository.loadMarket());

    expect(ticker.quotes.value, seed.quotes);
    expect(await repository.quotes.first, seed.quotes);
  });

  test('a failed load leaves the ticker unseeded', () async {
    api.failure = const NetworkException();
    await repository.loadMarket();

    expect(ticker.quotes.hasValue, isFalse);
  });

  test('asks for the coins and the rates at the same time', () async {
    api.gate = Completer<void>();

    final loading = repository.loadMarket();
    await pumpEventQueue();
    expect((api.coinCalls, api.rateCalls), (1, 1));

    api.gate!.complete();
    expect(await loading, isA<Ok<MarketSeed>>());
  });

  test('loads once: later calls answer from memory', () async {
    final first = seedOf(await repository.loadMarket());
    final second = seedOf(await repository.loadMarket());

    expect(second, same(first));
    expect(api.coinCalls, 1);
  });

  test('calls made while it loads share the one load', () async {
    api.gate = Completer<void>();

    final a = repository.loadMarket();
    final b = repository.loadMarket();
    api.gate!.complete();

    expect(seedOf(await a), same(seedOf(await b)));
    expect(api.coinCalls, 1);
  });

  test('after a failure, the next call tries again ("Try again")', () async {
    api.failure = const NetworkException();
    expect(await repository.loadMarket(), failsWith<NetworkException>());

    api.failure = null;
    expect(await repository.loadMarket(), isA<Ok<MarketSeed>>());
    expect(api.coinCalls, 2);
  });

  group('every failure becomes a message the screen can show', () {
    test('the service unreachable', () async {
      api.failure = const NetworkException();
      expect(await repository.loadMarket(), failsWith<NetworkException>());
    });

    test('malformed JSON', () async {
      api.failure = const FormatException('bad');
      expect(await repository.loadMarket(), failsWith<DataFormatException>());
    });

    test('a field of the wrong type', () async {
      api.failure = CheckedFromJsonException({}, 'rank', 'CoinDto', 'not int');
      expect(await repository.loadMarket(), failsWith<DataFormatException>());
    });

    test('a value that breaks the rules (a price of zero)', () async {
      api.coins = [coinDto(price: '0')];
      expect(await repository.loadMarket(), failsWith<DataFormatException>());
    });

    test('two coins with one id', () async {
      api.coins = [coinDto(), coinDto(rank: 2)];
      expect(await repository.loadMarket(), failsWith<DataFormatException>());
    });

    test('damaged rates', () async {
      api.rates = ratesDto(base: 'EUR');
      expect(await repository.loadMarket(), failsWith<DataFormatException>());
    });

    test('anything else unexpected', () async {
      api.failure = Exception('surprise');
      expect(await repository.loadMarket(), failsWith<UnknownException>());
    });
  });

  test('a programming mistake (an Error) is not swallowed', () async {
    api.coins = [coinDto(sparkline: const [])];
    // A sanity check that the empty sparkline itself is valid data…
    expect(await repository.loadMarket(), isA<Ok<MarketSeed>>());

    final brokenTicker = newTicker();
    addTearDown(brokenTicker.dispose);
    final brokenHistory = PriceHistory(brokenTicker);
    addTearDown(brokenHistory.dispose);
    final broken = MarketRepositoryImpl(
      _ErrorApi(),
      Clock.fixed(testNow),
      brokenTicker,
      brokenHistory,
    );
    await expectLater(broken.loadMarket(), throwsA(isA<StateError>()));
  });
}

class _ErrorApi extends ScriptedMarketApi {
  @override
  Future<List<Never>> getCoins() async => throw StateError('a bug');
}
