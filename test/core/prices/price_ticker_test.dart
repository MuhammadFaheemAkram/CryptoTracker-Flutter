import 'dart:math';

import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/core/prices/random_walk.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

// The ticker in fake time: every interval is exact. It's built inside
// fakeAsync, so its timer runs on the fake clock (conventions §11.122).
void main() {
  late PriceTicker ticker;
  late List<Map<String, Quote>> snapshots;

  void start(FakeAsync async) {
    ticker = PriceTicker(RandomWalk(Random(42)), clock);
    snapshots = [];
  }

  void listen(FakeAsync async) {
    ticker.quotes.listen(snapshots.add);
    async.flushMicrotasks();
  }

  test('nothing before the seed, and no ticks either', () {
    fakeAsync((async) {
      start(async);
      listen(async);

      ticker.start(const Duration(seconds: 1));
      async.elapse(const Duration(seconds: 3));

      expect(snapshots, isEmpty);
      ticker.stop();
    });
  });

  test(
    'a new listener gets the current prices at once (a BehaviorSubject)',
    () {
      fakeAsync((async) {
        start(async);
        ticker.seed(smallMarket());

        listen(async);

        expect(snapshots, [smallMarket().quotes]);
        expect(ticker.quotes.value, smallMarket().quotes);
      });
    },
  );

  test('one snapshot per interval, every coin moved', () {
    fakeAsync((async) {
      start(async);
      ticker.seed(smallMarket());
      listen(async);

      ticker.start(const Duration(seconds: 2));
      async.elapse(const Duration(milliseconds: 1999));
      expect(snapshots, hasLength(1));

      async.elapse(const Duration(milliseconds: 1));
      expect(snapshots, hasLength(2));
      for (final id in ['bitcoin', 'ethereum', 'solana']) {
        expect(
          snapshots.last[id]!.priceUsd,
          isNot(snapshots.first[id]!.priceUsd),
        );
      }

      async.elapse(const Duration(seconds: 6));
      expect(snapshots, hasLength(5));
      ticker.stop();
    });
  });

  test("each quote is stamped with the clock's time", () {
    fakeAsync((async) {
      start(async);
      ticker.seed(smallMarket());
      listen(async);
      final started = clock.now();

      ticker.start(const Duration(seconds: 1));
      async.elapse(const Duration(seconds: 1));

      expect(
        snapshots.last['bitcoin']!.updatedAt,
        started.add(const Duration(seconds: 1)).toUtc(),
      );
      ticker.stop();
    });
  });

  test('stop() halts the ticks', () {
    fakeAsync((async) {
      start(async);
      ticker.seed(smallMarket());
      listen(async);
      ticker.start(const Duration(seconds: 1));
      async.elapse(const Duration(seconds: 2));

      ticker.stop();
      async.elapse(const Duration(seconds: 10));

      expect(snapshots, hasLength(3));
      expect(ticker.isRunning, isFalse);
    });
  });

  test('restarting at a new interval keeps one timer, and carries on from '
      'the current prices (no jump)', () {
    fakeAsync((async) {
      start(async);
      ticker.seed(smallMarket());
      listen(async);
      ticker.start(const Duration(seconds: 1));
      async.elapse(const Duration(seconds: 3));
      final before = snapshots.last;

      ticker.start(const Duration(seconds: 5));
      expect(snapshots.last, same(before), reason: 'restarting emits nothing');
      async.elapse(const Duration(seconds: 5));

      expect(snapshots, hasLength(5), reason: 'one timer, not two');
      final ratio =
          snapshots.last['bitcoin']!.priceUsd / before['bitcoin']!.priceUsd;
      expect(ratio, inInclusiveRange(0.98, 1.02), reason: 'one step from it');
      expect(async.periodicTimerCount, 1);
      ticker.stop();
    });
  });

  test('the 24 h change after many ticks is exactly (price / open − 1) × 100 '
      '(derived, never accumulated: Correctness Rule 1)', () {
    fakeAsync((async) {
      start(async);
      final seed = smallMarket();
      ticker.seed(seed);
      listen(async);

      ticker.start(const Duration(seconds: 1));
      async.elapse(const Duration(seconds: 500));
      ticker.stop();

      final bitcoin = snapshots.last['bitcoin']!;
      expect(bitcoin.open24hUsd, seed.quotes['bitcoin']!.open24hUsd);
      expect(
        bitcoin.change24hPercent,
        closeTo((bitcoin.priceUsd / bitcoin.open24hUsd - 1) * 100, 1e-9),
      );
      // Adding each tick's move to the change instead drifts away from it.
      expect(bitcoin.change24hPercent.abs(), lessThan(40));
    });
  });

  test('stablecoins barely move, even after many ticks', () {
    fakeAsync((async) {
      start(async);
      ticker.seed(smallMarket());
      listen(async);

      ticker.start(const Duration(seconds: 1));
      async.elapse(const Duration(seconds: 300));
      ticker.stop();

      expect(snapshots.last['tether']!.priceUsd, closeTo(1.0002, 0.005));
    });
  });

  test('seeded once: a second seed changes nothing (Rule 8)', () {
    fakeAsync((async) {
      start(async);
      ticker.seed(smallMarket());
      listen(async);
      ticker
        ..tick()
        ..seed(smallMarket());
      async.flushMicrotasks();

      expect(snapshots, hasLength(2));
      expect(ticker.quotes.value, isNot(smallMarket().quotes));
    });
  });

  test('every snapshot is read-only', () {
    fakeAsync((async) {
      start(async);
      ticker.seed(smallMarket());

      expect(
        () => ticker.quotes.value.remove('bitcoin'),
        throwsUnsupportedError,
      );
    });
  });

  test('dispose stops the timer and closes the stream', () async {
    final ticker = PriceTicker(RandomWalk(Random(1)), clock)
      ..seed(smallMarket())
      ..start(const Duration(hours: 1));
    var done = false;
    ticker.quotes.listen(null, onDone: () => done = true);

    await ticker.dispose();
    await pumpEventQueue();

    expect(ticker.isRunning, isFalse);
    expect(done, isTrue);
  });
}
