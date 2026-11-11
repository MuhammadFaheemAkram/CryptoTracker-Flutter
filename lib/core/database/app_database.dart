import 'package:crypto_tracker/core/database/daos/watchlist_dao.dart';
import 'package:crypto_tracker/core/database/tables/watch_items.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// The app's SQLite database: what the user keeps (the watchlist; the
/// holdings from Phase 5).
///
/// Prices are **not** stored: the market starts from the seed at every
/// launch. Only the user's own choices outlive the app.
///
/// It never imports `material_ui` or the JSON packages: drift exports
/// `Table`, `Column` and `JsonKey`, and those names would clash
/// (conventions §11.1).
@DriftDatabase(tables: [WatchItems], daos: [WatchlistDao])
class AppDatabase extends _$AppDatabase {
  /// Opens `crypto_tracker.sqlite` in the app's documents directory. Tests
  /// pass an in-memory [executor] instead.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'crypto_tracker'));

  /// A change to the schema bumps this, exports the new version
  /// (`fvm dart run drift_dev make-migrations`) and ships a tested
  /// migration.
  ///
  /// 1. The watchlist.
  @override
  int get schemaVersion => 1;
}
