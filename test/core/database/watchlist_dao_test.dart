import 'package:async/async.dart';
import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/core/database/daos/watchlist_dao.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/database.dart';

void main() {
  late AppDatabase database;
  late WatchlistDao dao;
  final t0 = DateTime.utc(2026, 11, 10, 9);

  setUp(() {
    database = newTestDatabase();
    dao = database.watchlistDao;
  });
  tearDown(() => database.close());

  List<String> idsOf(List<WatchItemRow> rows) => [
    for (final row in rows) row.coinId,
  ];

  test('lists the starred coins oldest first, ties by id', () async {
    await dao.add('solana', t0.add(const Duration(minutes: 2)));
    await dao.add('ethereum', t0);
    await dao.add('bitcoin', t0);

    expect(idsOf(await dao.watchAll().first), [
      'bitcoin',
      'ethereum',
      'solana',
    ]);
  });

  test('a date reads back as the same UTC instant', () async {
    await dao.add('bitcoin', t0);

    final row = (await dao.watchAll().first).single;

    expect(row.addedAt, t0);
    expect(row.addedAt.isUtc, isTrue);
  });

  test('starring a coin again keeps its first time (and its place)', () async {
    await dao.add('bitcoin', t0);
    await dao.add('ethereum', t0.add(const Duration(minutes: 1)));

    await dao.add('bitcoin', t0.add(const Duration(hours: 1)));

    final rows = await dao.watchAll().first;
    expect(idsOf(rows), ['bitcoin', 'ethereum']);
    expect(rows.first.addedAt, t0);
  });

  test('the list is live: every write emits the new list', () async {
    final lists = StreamQueue(dao.watchAll());
    addTearDown(() => lists.cancel(immediate: true));
    expect(idsOf(await lists.next), isEmpty);

    await dao.add('bitcoin', t0);
    expect(idsOf(await lists.next), ['bitcoin']);

    await dao.remove('bitcoin');
    expect(idsOf(await lists.next), isEmpty);
  });

  test('whether one coin is starred is live too', () async {
    final starred = StreamQueue(dao.watchContains('bitcoin'));
    addTearDown(() => starred.cancel(immediate: true));
    expect(await starred.next, isFalse);

    await dao.add('bitcoin', t0);
    expect(await starred.next, isTrue);

    await dao.remove('bitcoin');
    expect(await starred.next, isFalse);
  });

  test('remove returns the removed row (for Undo), or null', () async {
    await dao.add('bitcoin', t0);

    final removed = await dao.remove('bitcoin');

    expect(removed?.coinId, 'bitcoin');
    expect(removed?.addedAt, t0);
    expect(await dao.remove('bitcoin'), isNull);
  });

  test('restore puts a row back in its old place', () async {
    await dao.add('bitcoin', t0);
    await dao.add('ethereum', t0.add(const Duration(minutes: 1)));
    final removed = await dao.remove('bitcoin');

    await dao.restore(removed!);

    expect(idsOf(await dao.watchAll().first), ['bitcoin', 'ethereum']);
  });

  test('Undo after the coin was starred again keeps the newer star, '
      'without an error', () async {
    await dao.add('bitcoin', t0);
    final removed = await dao.remove('bitcoin');
    await dao.add('bitcoin', t0.add(const Duration(hours: 1))); // again

    await dao.restore(removed!);

    final rows = await dao.watchAll().first;
    expect(rows.single.addedAt, t0.add(const Duration(hours: 1)));
  });

  test('an empty coin id is refused by the table (CHECK)', () async {
    // A plain insert fails…
    await expectLater(
      database
          .into(database.watchItems)
          .insert(WatchItemsCompanion.insert(coinId: '', addedAt: t0)),
      throwsA(isA<Exception>()),
    );
    // …and `add`'s INSERT OR IGNORE skips the row (SQLite's OR IGNORE
    // covers CHECK failures too): nothing is stored either way.
    await dao.add('', t0);
    expect(await dao.watchAll().first, isEmpty);
  });
}
