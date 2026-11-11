import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/pipeline/price_directions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  final before = {
    'a': quote('a', 100),
    'b': quote('b', 50),
    'c': quote('c', 1),
  };

  test('the first snapshot has nothing to compare with: nothing moved', () {
    expect(directionsBetween(null, before), isEmpty);
  });

  test('up, down, and an unchanged price left out (flat)', () {
    final after = {
      'a': quote('a', 101),
      'b': quote('b', 49),
      'c': quote('c', 1),
    };

    expect(directionsBetween(before, after), {
      'a': PriceDirection.up,
      'b': PriceDirection.down,
    });
  });

  test('a coin new in the snapshot is flat', () {
    final after = {...before, 'd': quote('d', 7)};

    expect(directionsBetween(before, after), isNot(contains('d')));
  });

  test('the same snapshot again: nothing moved (a paused market)', () {
    expect(directionsBetween(before, before), isEmpty);
  });
}
