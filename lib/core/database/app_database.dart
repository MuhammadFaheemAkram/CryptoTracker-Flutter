import 'package:crypto_tracker/core/database/app_database.steps.dart';
import 'package:crypto_tracker/core/database/daos/portfolio_dao.dart';
import 'package:crypto_tracker/core/database/daos/watchlist_dao.dart';
import 'package:crypto_tracker/core/database/tables/holdings.dart';
import 'package:crypto_tracker/core/database/tables/watch_items.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// The app's SQLite database: what the user keeps (the watchlist and the
/// holdings).
///
/// Prices are **not** stored: the market starts from the seed at every
/// launch. Only the user's own choices outlive the app.
///
/// It never imports `material_ui` or the JSON packages: drift exports
/// `Table`, `Column` and `JsonKey`, and those names would clash
/// (conventions §11.1).
@DriftDatabase(
  tables: [WatchItems, Holdings],
  daos: [WatchlistDao, PortfolioDao],
)
class AppDatabase extends _$AppDatabase {
  /// Opens `crypto_tracker.sqlite` in the app's documents directory. Tests
  /// pass an in-memory [executor] instead.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'crypto_tracker'));

  /// A change to the schema bumps this, exports the new version
  /// (`fvm dart run drift_dev make-migrations`) and ships a tested
  /// migration.
  ///
  /// 1. Phase 4: the watchlist.
  /// 2. Phase 5: the holdings.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // A fresh install creates the latest schema directly (`createAll`). An
    // update walks one version at a time: `stepByStep` comes from the
    // generated `app_database.steps.dart`, and each step sees the tables as
    // they were at that version (`schema`), so an old step keeps working
    // however later versions change them.
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // The watchlist stays as it is; the holdings start empty.
        await m.createTable(schema.holdings);
      },
    ),
  );
}
