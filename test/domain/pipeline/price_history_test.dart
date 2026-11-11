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
}
