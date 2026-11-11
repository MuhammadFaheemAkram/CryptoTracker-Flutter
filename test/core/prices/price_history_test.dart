import 'dart:math';

import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/prices/price_history.dart';
import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/core/prices/random_walk.dart';
import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/domain/pipeline/price_history.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('records from launch: a coin opened a minute in already has its '
      'points', () {
    fakeAsync((async) {
      final ticker = PriceTicker(RandomWalk(Random(1)), clock);
      final history = PriceHistory(ticker); // created with the app
      ticker
        ..seed(smallMarket())
        ..start(const Duration(seconds: 1));
      async.elapse(const Duration(seconds: 30));

      final points = <List<PricePoint>>[];
      history.watch('bitcoin').listen(points.add); // opened now
      async.flushMicrotasks();

      expect(points.single, hasLength(31)); // the seed, then 30 ticks
      ticker.stop();
    });
  });

  test('keeps the last 60 points (a bounded buffer)', () {
    fakeAsync((async) {
      final ticker = PriceTicker(RandomWalk(Random(2)), clock);
      final history = PriceHistory(ticker);
      ticker
        ..seed(smallMarket())
        ..start(const Duration(seconds: 1));
      async.elapse(const Duration(seconds: 200));
      ticker.stop();

      late List<PricePoint> points;
      history.watch('ethereum').listen((p) => points = p);
      async.flushMicrotasks();

      expect(points, hasLength(priceHistoryCapacity));
      expect(points.last.priceUsd, ticker.quotes.value['ethereum']!.priceUsd);
    });
  });

  test('a listener gets each new point as it comes', () {
    fakeAsync((async) {
      final ticker = PriceTicker(RandomWalk(Random(3)), clock);
      final history = PriceHistory(ticker);
      ticker.seed(smallMarket());
      async.flushMicrotasks(); // the seed reaches the history
      final lengths = <int>[];
      history.watch('solana').listen((p) => lengths.add(p.length));
      async.flushMicrotasks();

      ticker.tick();
      async.elapse(const Duration(seconds: 1));
      ticker.tick();
      async.flushMicrotasks();

      expect(lengths, [1, 2, 3]);
    });
  });

  test('two snapshots at the same instant count once', () {
    fakeAsync((async) {
      final ticker = PriceTicker(RandomWalk(Random(6)), clock);
      final history = PriceHistory(ticker);
      ticker.seed(smallMarket());
      async.flushMicrotasks();

      ticker
        ..tick()
        ..tick(); // the clock hasn't moved
      async.flushMicrotasks();

      late List<PricePoint> points;
      history.watch('bitcoin').listen((p) => points = p);
      async.flushMicrotasks();
      expect(points, hasLength(2));
    });
  });

  test('a tick that adds nothing for a coin (the same instant) reaches '
      'its listeners as nothing (distinct)', () {
    fakeAsync((async) {
      final ticker = PriceTicker(RandomWalk(Random(7)), clock);
      final history = PriceHistory(ticker);
      ticker.seed(smallMarket());
      async.flushMicrotasks();
      final emitted = <List<PricePoint>>[];
      history.watch('bitcoin').listen(emitted.add);
      async.flushMicrotasks();

      ticker
        ..tick()
        ..tick(); // the clock hasn't moved: no new point
      async.flushMicrotasks();

      expect(emitted, hasLength(2), reason: 'the history, then one tick');
    });
  });

  test('an unknown coin has no points', () {
    fakeAsync((async) {
      final history = PriceHistory(PriceTicker(RandomWalk(Random(4)), clock));
      final points = <List<PricePoint>>[];
      history.watch('nope').listen(points.add);
      async.flushMicrotasks();

      expect(points, [isEmpty]);
    });
  });

  test('dispose stops recording', () async {
    final ticker = PriceTicker(RandomWalk(Random(5)), clock)
      ..seed(smallMarket());
    final history = PriceHistory(ticker);
    await history.dispose();

    expect(ticker.tick, returnsNormally);
    await ticker.dispose();
  });

  group('the highs', () {
    test('a coin\'s high is its highest price since launch, never capped '
        'like the points', () {
      fakeAsync((async) {
        final ticker = PriceTicker(RandomWalk(Random(6)), clock);
        final history = PriceHistory(ticker);
        ticker
          ..seed(smallMarket())
          ..start(const Duration(seconds: 1));
        async.elapse(const Duration(seconds: 90)); // past the 60 points

        final highs = <double?>[];
        final points = <List<PricePoint>>[];
        history.watchHigh('bitcoin').listen(highs.add);
        history.watch('bitcoin').listen(points.add);
        async.flushMicrotasks();

        // Every price ever seen, including those already off the buffer:
        // the high is at least the seed's and every kept point's.
        expect(highs.single, greaterThanOrEqualTo(67240.5));
        expect(
          highs.single,
          greaterThanOrEqualTo(
            points.single.map((p) => p.priceUsd).reduce(max),
          ),
        );
        ticker.stop();
      });
    });

    test('emits again only when it rises', () {
      fakeAsync((async) {
        final ticker = PriceTicker(RandomWalk(Random(7)), clock);
        final history = PriceHistory(ticker); // created with the app
        ticker.seed(smallMarket());
        async.flushMicrotasks();
        final highs = <double?>[];
        history.watchHigh('bitcoin').listen(highs.add);
        async.flushMicrotasks();

        for (var i = 0; i < 20; i++) {
          ticker.tick();
          async.flushMicrotasks();
        }

        expect(highs.first, 67240.5);
        expect(highs.length, greaterThan(1)); // it did rise
        for (var i = 1; i < highs.length; i++) {
          expect(highs[i]!, greaterThan(highs[i - 1]!));
        }
      });
    });

    test('an unknown coin has no high', () {
      fakeAsync((async) {
        final history = PriceHistory(PriceTicker(RandomWalk(Random(8)), clock));
        final highs = <double?>[];
        history.watchHigh('nope').listen(highs.add);
        async.flushMicrotasks();

        expect(highs, [null]);
      });
    });
  });
}
