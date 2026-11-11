import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:crypto_tracker/domain/pipeline/portfolio_valuation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  var nextId = 1;
  Holding holding(String coinId, double amount, double buyPrice) => Holding(
    id: nextId++,
    coinId: coinId,
    amount: amount,
    buyPriceUsd: buyPrice,
    createdAt: testNow,
  );

  group('Correctness Rule 10: the portfolio maths', () {
    // 2 coins: A at 100 (24 h ago 80), B at 50 (24 h ago 50).
    final coins = [coin('a', name: 'A'), coin('b', rank: 2, name: 'B')];
    final quotes = {
      'a': Quote(
        coinId: 'a',
        priceUsd: 100,
        open24hUsd: 80,
        updatedAt: testNow,
      ),
      'b': Quote(coinId: 'b', priceUsd: 50, open24hUsd: 50, updatedAt: testNow),
    };

    test('value = amount × price, cost = amount × buy price', () {
      final valuation = valuePortfolio(
        coins: coins,
        holdings: [holding('a', 2, 60), holding('b', 4, 75)],
        quotes: quotes,
      );

      final [a, b] = valuation.positions;
      expect(a.valueUsd, 200);
      expect(a.costUsd, 120);
      expect(a.profitUsd, 80);
      expect(a.profitPercent, closeTo(66.667, 0.001));
      expect(b.profitUsd, -100);
      expect(b.profitPercent, closeTo(-33.333, 0.001));
      expect(valuation.totalValueUsd, 400);
      expect(valuation.totalCostUsd, 420);
      expect(valuation.totalProfitUsd, -20);
      expect(valuation.totalProfitPercent, closeTo(-4.762, 0.001));
    });

    test('the 24 h change comes from the price 24 h ago (open24h)', () {
      final valuation = valuePortfolio(
        coins: coins,
        holdings: [holding('a', 2, 60), holding('b', 4, 75)],
        quotes: quotes,
      );

      // A: 2 × (100 − 80) = 40 on an open of 160 + 200 = 360.
      expect(valuation.change24hUsd, 40);
      expect(valuation.change24hPercent, closeTo(11.111, 0.001));
      expect(valuation.positions.last.change24hUsd, 0);
    });

    test('P/L % is 0 when the cost is 0', () {
      final position = valuePortfolio(
        coins: coins,
        holdings: [holding('a', 1, 0)],
        quotes: quotes,
      ).positions.single;

      expect(position.costUsd, 0);
      expect(position.profitPercent, 0);
    });

    test('no holdings: everything 0, no allocation', () {
      final valuation = valuePortfolio(
        coins: coins,
        holdings: const [],
        quotes: quotes,
      );

      expect(valuation.positions, isEmpty);
      expect(valuation.allocations, isEmpty);
      expect(valuation.totalValueUsd, 0);
      expect(valuation.totalProfitPercent, 0);
      expect(valuation.change24hPercent, 0);
    });

    test('a holding the market can\'t value is left out', () {
      final valuation = valuePortfolio(
        coins: coins,
        holdings: [holding('gone', 1, 1), holding('a', 1, 100)],
        quotes: {...quotes}..remove('b'),
      );

      expect(valuation.positions.single.coin.id, 'a');
      expect(valuation.totalValueUsd, 100);
    });

    test('positions keep the holdings\' order, with their directions', () {
      final valuation = valuePortfolio(
        coins: coins,
        holdings: [holding('b', 1, 1), holding('a', 1, 1)],
        quotes: quotes,
        directions: {'a': PriceDirection.up},
      );

      expect([for (final p in valuation.positions) p.coin.id], ['b', 'a']);
      expect(valuation.positions.first.direction, PriceDirection.flat);
      expect(valuation.positions.last.direction, PriceDirection.up);
    });
  });

  group('the allocation', () {
    List<Coin> market(int n) => [
      for (var i = 1; i <= n; i++) coin('c$i', rank: i, name: 'Coin $i'),
    ];
    Map<String, Quote> pricedAt(int n, double price) => {
      for (var i = 1; i <= n; i++) 'c$i': quote('c$i', price),
    };

    test('one slice per coin: several holdings of one coin add up', () {
      final allocations = valuePortfolio(
        coins: market(2),
        holdings: [
          holding('c1', 1, 1),
          holding('c2', 1, 1),
          holding('c1', 2, 1),
        ],
        quotes: pricedAt(2, 10),
      ).allocations;

      expect([for (final a in allocations) a.label], ['Coin 1', 'Coin 2']);
      expect(allocations.first.valueUsd, 30);
      expect([for (final a in allocations) a.basisPoints], [7500, 2500]);
    });

    test('the top 5 by value, then "Other" for the rest', () {
      final allocations = valuePortfolio(
        coins: market(8),
        holdings: [
          for (var i = 1; i <= 8; i++) holding('c$i', i.toDouble(), 1),
        ],
        quotes: pricedAt(8, 1),
      ).allocations;

      expect(
        [for (final a in allocations) a.label],
        ['Coin 8', 'Coin 7', 'Coin 6', 'Coin 5', 'Coin 4', otherLabel],
      );
      expect(allocations.last.symbol, isNull);
      expect(allocations.last.valueUsd, 1 + 2 + 3);
    });

    test('exactly 5 coins: no "Other"', () {
      final allocations = valuePortfolio(
        coins: market(5),
        holdings: [for (var i = 1; i <= 5; i++) holding('c$i', 1, 1)],
        quotes: pricedAt(5, 1),
      ).allocations;

      expect(allocations, hasLength(5));
      expect(allocations.map((a) => a.label), isNot(contains(otherLabel)));
    });

    test('shares add up to exactly 100.00 %, the remainder on the largest '
        'slice', () {
      // Thirds: 3333 + 3333 + 3333 = 9999; the largest (by rank, on a
      // tie) takes the missing hundredth.
      final allocations = valuePortfolio(
        coins: market(3),
        holdings: [for (var i = 1; i <= 3; i++) holding('c$i', 1, 1)],
        quotes: pricedAt(3, 1),
      ).allocations;

      expect([for (final a in allocations) a.basisPoints], [3334, 3333, 3333]);
    });

    test('the sum holds for awkward values, whichever way rounding goes', () {
      for (final amounts in [
        [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
        [7.0, 7.0, 7.0, 3.0, 3.0, 3.0],
        [0.0001, 1000.0, 0.333, 0.667, 2.5],
        [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0],
      ]) {
        final n = amounts.length;
        final allocations = valuePortfolio(
          coins: market(n),
          holdings: [
            for (var i = 0; i < n; i++) holding('c${i + 1}', amounts[i], 1),
          ],
          quotes: pricedAt(n, 1),
        ).allocations;

        expect(
          allocations.fold(0, (sum, a) => sum + a.basisPoints),
          10000,
          reason: '$amounts',
        );
      }
    });

    test('"Other" takes the remainder when it is the largest slice', () {
      // Five small coins at 1 each, then nine at 1 each in "Other" (9 of
      // 14). 1/14 rounds to 714 each: 5 × 714 + 6429 = 9999, so Other
      // gets the extra point.
      final allocations = allocate(
        valuePortfolio(
          coins: market(14),
          holdings: [for (var i = 1; i <= 14; i++) holding('c$i', 1, 1)],
          quotes: pricedAt(14, 1),
        ).positions,
      );

      expect(allocations.last.label, otherLabel);
      expect(allocations.last.basisPoints, 6430);
      expect(allocations.first.basisPoints, 714);
    });

    test('equal values: ordered by rank', () {
      final allocations = valuePortfolio(
        coins: market(3),
        holdings: [
          holding('c3', 1, 1),
          holding('c1', 1, 1),
          holding('c2', 1, 1),
        ],
        quotes: pricedAt(3, 1),
      ).allocations;

      expect(
        [for (final a in allocations) a.label],
        ['Coin 1', 'Coin 2', 'Coin 3'],
      );
    });
  });
}
