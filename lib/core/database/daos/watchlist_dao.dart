import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/core/database/tables/watch_items.dart';
import 'package:drift/drift.dart';

part 'watchlist_dao.g.dart';

/// The watchlist's queries. `watch…` methods are streams: drift re-runs the
/// query after every write to the table and emits the new result, so every
/// screen showing the watchlist updates by itself.
@DriftAccessor(tables: [WatchItems])
class WatchlistDao extends DatabaseAccessor<AppDatabase>
    with _$WatchlistDaoMixin {
  WatchlistDao(super.attachedDatabase);

  /// Every starred coin, oldest first (ties by id, §11.60).
  Stream<List<WatchItemRow>> watchAll() =>
      (select(watchItems)..orderBy([
            (item) => OrderingTerm.asc(item.addedAt),
            (item) => OrderingTerm.asc(item.coinId),
          ]))
          .watch();

  /// Whether [coinId] is starred, live.
  Stream<bool> watchContains(String coinId) =>
      (select(watchItems)..where((item) => item.coinId.equals(coinId)))
          .watchSingleOrNull()
          .map((row) => row != null);

  /// Stars [coinId] at [at]. Starring it again keeps its first time (and
  /// its place in the list).
  Future<void> add(String coinId, DateTime at) => into(watchItems).insert(
    WatchItemsCompanion.insert(coinId: coinId, addedAt: at),
    mode: InsertMode.insertOrIgnore,
  );

  /// Puts [row] back exactly as it was (Undo): the same time, so the same
  /// place in the list.
  Future<void> restore(WatchItemRow row) =>
      into(watchItems).insert(row, mode: InsertMode.insertOrIgnore);

  /// Unstars [coinId]; the row it removed, for Undo (`null` if it wasn't
  /// starred).
  Future<WatchItemRow?> remove(String coinId) => transaction(() async {
    final row = await (select(
      watchItems,
    )..where((item) => item.coinId.equals(coinId))).getSingleOrNull();
    if (row != null) {
      await (delete(
        watchItems,
      )..where((item) => item.coinId.equals(coinId))).go();
    }
    return row;
  });
}
