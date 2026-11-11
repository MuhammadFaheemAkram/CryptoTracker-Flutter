import 'dart:math';

import 'package:crypto_tracker/core/prices/random_walk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a coin moves at most ±1.5 % a step (when at its anchor)', () {
    final walk = RandomWalk(Random(1));
    for (var i = 0; i < 2000; i++) {
      final next = walk.next(
        priceUsd: 100,
        anchorUsd: 100,
        isStablecoin: false,
      );
      expect(next, inInclusiveRange(98.5, 101.5));
    }
  });

  test('a stablecoin moves at most ±0.05 % a step', () {
    final walk = RandomWalk(Random(2));
    for (var i = 0; i < 2000; i++) {
      final next = walk.next(priceUsd: 1, anchorUsd: 1, isStablecoin: true);
      expect(next, inInclusiveRange(0.9995, 1.0005));
    }
  });

  test('the same seed walks the same path (reproducible tests)', () {
    List<double> path(int seed) {
      final walk = RandomWalk(Random(seed));
      var price = 100.0;
      return [
        for (var i = 0; i < 20; i++)
          price = walk.next(
            priceUsd: price,
            anchorUsd: 100,
            isStablecoin: false,
          ),
      ];
    }

    expect(path(9), path(9));
    expect(path(9), isNot(path(10)));
  });

  test('a price far from where it started is pulled back towards it', () {
    final walk = RandomWalk(Random(3));
    // At twice the anchor, the pull (−1 %) outweighs the noise on average.
    var sum = 0.0;
    for (var i = 0; i < 2000; i++) {
      sum += walk.next(priceUsd: 200, anchorUsd: 100, isStablecoin: false);
    }
    expect(sum / 2000, closeTo(198, 0.3));
  });

  test('over a long session, prices stay plausible (mean-reverting)', () {
    final walk = RandomWalk(Random(4));
    var price = 100.0;
    for (var i = 0; i < 20000; i++) {
      price = walk.next(priceUsd: price, anchorUsd: 100, isStablecoin: false);
    }
    // A pure random walk of 20,000 steps of ±1.5 % strays by an order of
    // magnitude; this one stays within a few percent of its anchor.
    expect(price, inInclusiveRange(80, 120));
  });

  test('a price never reaches zero', () {
    final walk = RandomWalk(Random(5));
    expect(
      walk.next(priceUsd: 1e-7, anchorUsd: 1e-7, isStablecoin: false),
      greaterThanOrEqualTo(RandomWalk.floorUsd),
    );
  });
}
