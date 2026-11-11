import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/core/database/tables/holdings.dart';
import 'package:drift/drift.dart';

part 'portfolio_dao.g.dart';

/// The holdings' queries. [watchAll] is live: the Portfolio re-values on
/// every write, as on every tick.
///
/// Writes use plain inserts and updates, never OR IGNORE: SQLite's OR
/// IGNORE also skips a row that fails a `CHECK` (conventions §11.124), and
/// a holding that silently wasn't saved would be worse than an error.
@DriftAccessor(tables: [Holdings])
class PortfolioDao extends DatabaseAccessor<AppDatabase>
    with _$PortfolioDaoMixin {
  PortfolioDao(super.attachedDatabase);

  /// Every holding, oldest first (ties by id).
  Stream<List<HoldingRow>> watchAll() =>
      (select(holdings)..orderBy([
            (row) => OrderingTerm.asc(row.createdAt),
            (row) => OrderingTerm.asc(row.id),
          ]))
          .watch();

  /// One holding, for the edit form; `null` if there's none with [id].
  Future<HoldingRow?> find(int id) =>
      (select(holdings)..where((row) => row.id.equals(id))).getSingleOrNull();

  /// A new holding; its id.
  Future<int> add({
    required String coinId,
    required double amount,
    required double buyPriceUsd,
    required DateTime at,
  }) => into(holdings).insert(
    HoldingsCompanion.insert(
      coinId: coinId,
      amount: amount,
      buyPriceUsd: buyPriceUsd,
      createdAt: at,
    ),
  );

  /// Changes a holding's amount and buy price in **one statement** (no
  /// read-modify-write a tick could slip into). Whether it existed.
  Future<bool> change(
    int id, {
    required double amount,
    required double buyPriceUsd,
  }) async {
    final changed = await (update(holdings)..where((row) => row.id.equals(id)))
        .write(
          HoldingsCompanion(
            amount: Value(amount),
            buyPriceUsd: Value(buyPriceUsd),
          ),
        );
    return changed > 0;
  }

  /// Removes a holding; the row it removed, for Undo (`null` if none).
  Future<HoldingRow?> remove(int id) => transaction(() async {
    final row = await find(id);
    if (row != null) {
      await (delete(holdings)..where((r) => r.id.equals(id))).go();
    }
    return row;
  });

  /// Undo: the same row again, with its id and its time, so it returns to
  /// its place.
  Future<void> restore(HoldingRow row) => into(holdings).insert(row);
}
