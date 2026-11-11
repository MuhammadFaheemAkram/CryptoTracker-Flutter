import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/core/database/daos/portfolio_dao.dart';
import 'package:crypto_tracker/data/repository/portfolio_repository_impl.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/database.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/result_matchers.dart';

class _MockDao extends Mock implements PortfolioDao {}

void main() {
  late AppDatabase database;
  late PortfolioRepositoryImpl repository;

  setUp(() {
    database = newTestDatabase();
    repository = PortfolioRepositoryImpl(
      database.portfolioDao,
      Clock.fixed(DateTime(2026, 11, 11, 11, 41)), // local
    );
  });
  tearDown(() => database.close());

  Future<int> add({double amount = 0.5, double price = 60000}) async {
    final result = await repository.add(
      coinId: 'bitcoin',
      amount: amount,
      buyPriceUsd: price,
    );
    return (result as Ok<int>).value;
  }

  test('a new holding, stamped by the clock in UTC', () async {
    final id = await add();

    expect(
      await repository.find(id),
      Holding(
        id: id,
        coinId: 'bitcoin',
        amount: 0.5,
        buyPriceUsd: 60000,
        createdAt: DateTime(2026, 11, 11, 11, 41).toUtc(),
      ),
    );
    expect(await repository.find(id + 1), isNull);
  });

  test('the holdings, live', () async {
    final id = await add();

    expect((await repository.watchHoldings().first).single.id, id);
  });

  test('an edit; Ok(false) when the holding is gone', () async {
    final id = await add();

    expect(await repository.update(id, amount: 2, buyPriceUsd: 1), isOk(true));
    expect((await repository.find(id))?.amount, 2);
    expect(
      await repository.update(id + 1, amount: 2, buyPriceUsd: 1),
      isOk(false),
    );
  });

  test('remove, then restore: the same holding, the same id', () async {
    final id = await add();

    final removed = await repository.remove(id);
    expect(removed, isOk(isA<Holding>()));
    expect(await repository.watchHoldings().first, isEmpty);

    await repository.restore((removed as Ok<Holding?>).value!);
    expect(await repository.find(id), removed.value);
    expect(await repository.remove(id + 1), isOk(isNull));
  });

  test('a value the table refuses is "Couldn\'t save that change"', () async {
    expect(
      await repository.add(coinId: 'bitcoin', amount: 0, buyPriceUsd: 1),
      isErrOf<StorageException>(),
    );
  });

  group('a failing database', () {
    late _MockDao dao;

    setUp(() {
      dao = _MockDao();
      repository = PortfolioRepositoryImpl(dao, Clock.fixed(testNow));
      registerFallbackValue(
        HoldingRow(
          id: 1,
          coinId: 'x',
          amount: 1,
          buyPriceUsd: 1,
          createdAt: testNow,
        ),
      );
    });

    test('every write fails as a result, never a throw', () async {
      when(
        () => dao.add(
          coinId: any(named: 'coinId'),
          amount: any(named: 'amount'),
          buyPriceUsd: any(named: 'buyPriceUsd'),
          at: any(named: 'at'),
        ),
      ).thenThrow(Exception('disk full'));
      when(
        () => dao.change(
          any(),
          amount: any(named: 'amount'),
          buyPriceUsd: any(named: 'buyPriceUsd'),
        ),
      ).thenThrow(Exception('disk full'));
      when(() => dao.remove(any())).thenThrow(Exception('disk full'));
      when(() => dao.restore(any())).thenThrow(Exception('disk full'));

      expect(
        await repository.add(coinId: 'a', amount: 1, buyPriceUsd: 1),
        isErrOf<StorageException>(),
      );
      expect(
        await repository.update(1, amount: 1, buyPriceUsd: 1),
        isErrOf<StorageException>(),
      );
      expect(await repository.remove(1), isErrOf<StorageException>());
      expect(
        await repository.restore(
          Holding(
            id: 1,
            coinId: 'a',
            amount: 1,
            buyPriceUsd: 1,
            createdAt: testNow,
          ),
        ),
        isErrOf<StorageException>(),
      );
    });

    test('a bug (an Error) is not swallowed', () async {
      when(() => dao.remove(any())).thenThrow(StateError('a bug'));

      await expectLater(repository.remove(1), throwsA(isA<StateError>()));
    });
  });
}
