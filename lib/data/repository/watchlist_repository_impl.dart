import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/common/guard_write.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/core/database/daos/watchlist_dao.dart';
import 'package:crypto_tracker/domain/model/watched_coin.dart';
import 'package:crypto_tracker/domain/repository/watchlist_repository.dart';
import 'package:injectable/injectable.dart';

/// The watchlist in drift.
///
/// The repository only writes. Every screen *observes* the table: a star on
/// the Market reaches the Watchlist tab and the coin's page by itself,
/// through drift's `watch()` streams, with no screen telling another.
@LazySingleton(as: WatchlistRepository)
class WatchlistRepositoryImpl implements WatchlistRepository {
  const WatchlistRepositoryImpl(this._dao, this._clock);

  final WatchlistDao _dao;
  final Clock _clock;

  @override
  Stream<List<String>> watchIds() =>
      _dao.watchAll().map((rows) => [for (final row in rows) row.coinId]);

  @override
  Stream<bool> watchContains(String coinId) => _dao.watchContains(coinId);

  @override
  Future<Result<bool>> toggle(String coinId) =>
      guardWrite('Toggling $coinId', () async {
        if (await _dao.remove(coinId) != null) return false;
        await _dao.add(coinId, _clock.now().toUtc());
        return true;
      });

  @override
  Future<Result<WatchedCoin?>> remove(String coinId) =>
      guardWrite('Removing $coinId', () async {
        final row = await _dao.remove(coinId);
        return row == null
            ? null
            : WatchedCoin(coinId: row.coinId, addedAt: row.addedAt);
      });

  @override
  Future<Result<void>> restore(WatchedCoin coin) => guardWrite(
    'Restoring ${coin.coinId}',
    () =>
        _dao.restore(WatchItemRow(coinId: coin.coinId, addedAt: coin.addedAt)),
  );
}
