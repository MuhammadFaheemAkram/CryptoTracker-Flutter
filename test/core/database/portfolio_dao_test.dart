import 'package:async/async.dart';
import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/core/database/daos/portfolio_dao.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/database.dart';

void main() {
  late AppDatabase database;
  late PortfolioDao dao;
  final t0 = DateTime.utc(2026, 11, 11, 9);

  setUp(() {
    database = newTestDatabase();
    dao = database.portfolioDao;
  });
  tearDown(() => database.close());

  Future<int> add(
    String coinId, {
    double amount = 1,
    double price = 100,
    DateTime? at,
  }) =>
      dao.add(coinId: coinId, amount: amount, buyPriceUsd: price, at: at ?? t0);

  List<int> idsOf(List<HoldingRow> rows) => [for (final row in rows) row.id];

  test('add returns the new id; find reads it back', () async {
    final id = await add('bitcoin', amount: 0.5, price: 60000);

    final row = await dao.find(id);
    expect(row?.coinId, 'bitcoin');
    expect(row?.amount, 0.5);
    expect(row?.buyPriceUsd, 60000);
    expect(row?.createdAt, t0);
    expect(await dao.find(id + 1), isNull);
  });

  test('lists oldest first, ties by id', () async {
    final late = await add('a', at: t0.add(const Duration(hours: 1)));
    final first = await add('b');
    final second = await add('c');

    expect(idsOf(await dao.watchAll().first), [first, second, late]);
  });

  test('the list is live', () async {
    final lists = StreamQueue(dao.watchAll());
    addTearDown(() => lists.cancel(immediate: true));
    expect(await lists.next, isEmpty);

    final id = await add('bitcoin');
    expect(idsOf(await lists.next), [id]);

    await dao.change(id, amount: 2, buyPriceUsd: 50);
    expect((await lists.next).single.amount, 2);
  });

  test(
    'an edit changes amount and price, nothing else; false if gone',
    () async {
      final id = await add('bitcoin'); // 1 at 100

      expect(await dao.change(id, amount: 3, buyPriceUsd: 90), isTrue);

      final row = await dao.find(id);
      expect((row?.amount, row?.buyPriceUsd), (3, 90));
      expect((row?.coinId, row?.createdAt), ('bitcoin', t0));
      expect(await dao.change(id + 1, amount: 1, buyPriceUsd: 1), isFalse);
    },
  );

  test('remove returns the row; restore brings back the same id, in its '
      'place', () async {
    final first = await add('a');
    final second = await add('b');

    final removed = await dao.remove(first);
    expect(removed?.id, first);
    expect(await dao.remove(first), isNull);

    await dao.restore(removed!);
    expect(idsOf(await dao.watchAll().first), [first, second]);
  });

  test('ids are never reused (AUTOINCREMENT): Undo can\'t collide', () async {
    final first = await add('a');
    await dao.remove(first);

    expect(await add('b'), greaterThan(first));
  });

  group('the CHECKs refuse what the form would (Correctness Rule 11)', () {
    for (final (what, write) in [
      ('a zero amount', () => add('a', amount: 0)),
      ('a negative amount', () => add('a', amount: -1)),
      ('a zero price', () => add('a', price: 0)),
      ('a negative price', () => add('a', price: -5)),
      ('an empty coin id', () => add('')),
    ]) {
      test(what, () async {
        await expectLater(write(), throwsA(isA<Exception>()));
        expect(await dao.watchAll().first, isEmpty);
      });
    }

    test('an edit too', () async {
      final id = await add('a');
      await expectLater(
        dao.change(id, amount: 0, buyPriceUsd: 1),
        throwsA(isA<Exception>()),
      );
      expect((await dao.find(id))?.amount, 1);
    });
  });
}
