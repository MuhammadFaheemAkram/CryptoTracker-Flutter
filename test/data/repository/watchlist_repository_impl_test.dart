import 'package:async/async.dart';
import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/core/database/daos/watchlist_dao.dart';
import 'package:crypto_tracker/data/repository/watchlist_repository_impl.dart';
import 'package:crypto_tracker/domain/model/watched_coin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/database.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/result_matchers.dart';

class _MockDao extends Mock implements WatchlistDao {}

void main() {
  setUpAll(
    () => registerFallbackValue(WatchItemRow(coinId: 'x', addedAt: testNow)),
  );

  late AppDatabase database;
  late DateTime now;
  late WatchlistRepositoryImpl repository;

  setUp(() {
    database = newTestDatabase();
    now = testNow;
    repository = WatchlistRepositoryImpl(
      database.watchlistDao,
      Clock(() => now),
    );
  });
  tearDown(() => database.close());

  void later() => now = now.add(const Duration(minutes: 1));

  group('on the database', () {
    test('toggle stars, then unstars: Ok(true), then Ok(false)', () async {
      expect(await repository.toggle('bitcoin'), isOk(true));
      expect(await repository.watchIds().first, ['bitcoin']);

      expect(await repository.toggle('bitcoin'), isOk(false));
      expect(await repository.watchIds().first, isEmpty);
    });

    test('the ids come in the order they were starred', () async {
      await repository.toggle('solana');
      later();
      await repository.toggle('bitcoin');
      later();
      await repository.toggle('ethereum');

      expect(await repository.watchIds().first, [
        'solana',
        'bitcoin',
        'ethereum',
      ]);
    });

    test('starred times come from the clock, in UTC', () async {
      now = DateTime(2026, 11, 10, 11, 41); // local
      await repository.toggle('bitcoin');

      final removed = await repository.remove('bitcoin');

      expect(
        removed,
        isOk(WatchedCoin(coinId: 'bitcoin', addedAt: now.toUtc())),
      );
    });

    test('watchContains follows the stars', () async {
      final starred = StreamQueue(repository.watchContains('bitcoin'));
      addTearDown(() => starred.cancel(immediate: true));
      expect(await starred.next, isFalse);

      await repository.toggle('bitcoin');
      expect(await starred.next, isTrue);
    });

    test('remove, then restore: back in its place', () async {
      await repository.toggle('bitcoin');
      later();
      await repository.toggle('ethereum');

      final removed = await repository.remove('bitcoin');
      expect(await repository.watchIds().first, ['ethereum']);

      later(); // Undo, a little later: the old time comes back, not now
      await repository.restore((removed as Ok<WatchedCoin?>).value!);
      expect(await repository.watchIds().first, ['bitcoin', 'ethereum']);
    });

    test('removing a coin that isn\'t starred is Ok(null)', () async {
      expect(await repository.remove('bitcoin'), isOk(isNull));
    });
  });

  group('a failing write', () {
    late _MockDao dao;

    setUp(() {
      dao = _MockDao();
      repository = WatchlistRepositoryImpl(dao, Clock.fixed(testNow));
    });

    test('an exception becomes "Couldn\'t save that change"', () async {
      when(() => dao.remove(any())).thenThrow(Exception('disk full'));
      when(() => dao.restore(any())).thenThrow(Exception('disk full'));

      expect(await repository.toggle('bitcoin'), isErrOf<StorageException>());
      expect(await repository.remove('bitcoin'), isErrOf<StorageException>());
      expect(
        await repository.restore(
          WatchedCoin(coinId: 'bitcoin', addedAt: testNow),
        ),
        isErrOf<StorageException>(),
      );
      expect(
        const StorageException().message,
        "Couldn't save that change. Please try again.",
      );
    });

    test('an AppException passes through as it is', () async {
      when(() => dao.remove(any())).thenThrow(const UnknownException());

      final result = await repository.remove('bitcoin');

      expect(result, isErrOf<UnknownException>());
    });

    test('a programming mistake (an Error) is not swallowed', () async {
      when(() => dao.remove(any())).thenThrow(StateError('a bug'));

      await expectLater(
        repository.toggle('bitcoin'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
