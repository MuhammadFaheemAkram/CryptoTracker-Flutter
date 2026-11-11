import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:crypto_tracker/domain/pipeline/price_history.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  Map<String, Quote> at(int second, double price) => {
    'a': quote(
      'a',
      price,
    ).copyWith(updatedAt: testNow.add(Duration(seconds: second))),
  };

  test('each snapshot adds a point per coin, oldest first', () {
    var history = appendSnapshot(const {}, at(0, 10));
    history = appendSnapshot(history, at(1, 11));

    expect(history['a']!.map((p) => p.priceUsd), [10, 11]);
  });

  test('the oldest points drop off at the capacity', () {
    var history = const <String, List<PricePoint>>{};
    for (var second = 0; second < 10; second++) {
      history = appendSnapshot(
        history,
        at(second, second.toDouble()),
        capacity: 4,
      );
    }

    expect(history['a']!.map((p) => p.priceUsd), [6, 7, 8, 9]);
  });

  test('a quote no newer than the last point adds nothing', () {
    final history = appendSnapshot(const {}, at(5, 10));

    expect(appendSnapshot(history, at(5, 12))['a'], same(history['a']));
    expect(appendSnapshot(history, at(4, 12))['a'], same(history['a']));
  });

  test('never mutates the history it was given', () {
    final first = appendSnapshot(const {}, at(0, 10));
    final firstPoints = first['a'];

    appendSnapshot(first, at(1, 11));

    expect(first['a'], same(firstPoints));
    expect(firstPoints, hasLength(1));
    expect(
      () => firstPoints!.add(PricePoint(at: testNow, priceUsd: 1)),
      throwsUnsupportedError,
    );
  });

  test('the capacity is 60 by default', () {
    expect(priceHistoryCapacity, 60);
  });

  group('raiseHighs', () {
    Map<String, Quote> prices(Map<String, double> byId) => {
      for (final MapEntry(:key, :value) in byId.entries) key: quote(key, value),
    };

    test('the first price of a coin is its high', () {
      expect(raiseHighs(const {}, prices({'a': 10, 'b': 2})), {
        'a': 10,
        'b': 2,
      });
    });

    test('a higher price raises the high; a lower one leaves it', () {
      final highs = raiseHighs(const {}, prices({'a': 10, 'b': 2}));

      expect(raiseHighs(highs, prices({'a': 12, 'b': 1})), {'a': 12, 'b': 2});
    });

    test('nothing rose: the same map comes back (identity)', () {
      final highs = raiseHighs(const {}, prices({'a': 10}));

      expect(raiseHighs(highs, prices({'a': 10})), same(highs));
      expect(raiseHighs(highs, prices({'a': 9})), same(highs));
    });

    test('never mutates the highs it was given', () {
      final highs = {'a': 10.0};

      raiseHighs(highs, prices({'a': 20}));

      expect(highs, {'a': 10});
    });
  });
}
