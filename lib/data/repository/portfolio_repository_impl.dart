import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/common/guard_write.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/core/database/daos/portfolio_dao.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/repository/portfolio_repository.dart';
import 'package:injectable/injectable.dart';

/// The holdings in drift. Like the watchlist, the repository only writes and
/// hands out live queries: the Portfolio re-values itself when the table
/// changes, whichever screen changed it (the form, a coin's page, Undo).
@LazySingleton(as: PortfolioRepository)
class PortfolioRepositoryImpl implements PortfolioRepository {
  const PortfolioRepositoryImpl(this._dao, this._clock);

  final PortfolioDao _dao;
  final Clock _clock;

  @override
  Stream<List<Holding>> watchHoldings() =>
      _dao.watchAll().map((rows) => [for (final row in rows) _toHolding(row)]);

  @override
  Future<Holding?> find(int id) async => switch (await _dao.find(id)) {
    final row? => _toHolding(row),
    null => null,
  };

  @override
  Future<Result<int>> add({
    required String coinId,
    required double amount,
    required double buyPriceUsd,
  }) => guardWrite(
    'Adding a holding of $coinId',
    () => _dao.add(
      coinId: coinId,
      amount: amount,
      buyPriceUsd: buyPriceUsd,
      at: _clock.now().toUtc(),
    ),
  );

  @override
  Future<Result<bool>> update(
    int id, {
    required double amount,
    required double buyPriceUsd,
  }) => guardWrite(
    'Updating holding $id',
    () => _dao.change(id, amount: amount, buyPriceUsd: buyPriceUsd),
  );

  @override
  Future<Result<Holding?>> remove(int id) => guardWrite(
    'Removing holding $id',
    () async => switch (await _dao.remove(id)) {
      final row? => _toHolding(row),
      null => null,
    },
  );

  @override
  Future<Result<void>> restore(Holding holding) => guardWrite(
    'Restoring holding ${holding.id}',
    () => _dao.restore(
      HoldingRow(
        id: holding.id,
        coinId: holding.coinId,
        amount: holding.amount,
        buyPriceUsd: holding.buyPriceUsd,
        createdAt: holding.createdAt,
      ),
    ),
  );

  static Holding _toHolding(HoldingRow row) => Holding(
    id: row.id,
    coinId: row.coinId,
    amount: row.amount,
    buyPriceUsd: row.buyPriceUsd,
    createdAt: row.createdAt,
  );
}
