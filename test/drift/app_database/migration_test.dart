// The template came from `drift_dev make-migrations` (Phase 5); the data
// test below replaces its placeholder.
import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  group('every upgrade path ends at the latest exported schema', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      for (final toVersion in versions.skip(i + 1)) {
        test('v$fromVersion → v$toVersion', () async {
          final schema = await verifier.schemaAt(fromVersion);
          final database = AppDatabase(schema.newConnection());
          await verifier.migrateAndValidate(database, toVersion);
          await database.close();
        });
      }
    }
  });

  // A watchlist from Phase 4 survives the update unchanged, and the new
  // holdings table starts empty.
  test('v1 → v2 keeps the watchlist, and adds empty holdings', () async {
    // Snapshots hold raw SQL values: dates as ISO-8601 text (§11.108).
    final first = DateTime.utc(2026, 11, 10, 9).toIso8601String();
    final second = DateTime.utc(2026, 11, 10, 10).toIso8601String();

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) => batch.insertAll(oldDb.watchItems, [
        v1.WatchItemsData(coinId: 'bitcoin', addedAt: first),
        v1.WatchItemsData(coinId: 'solana', addedAt: second),
      ]),
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.watchItems).get(), [
          v2.WatchItemsData(coinId: 'bitcoin', addedAt: first),
          v2.WatchItemsData(coinId: 'solana', addedAt: second),
        ]);
        expect(await newDb.select(newDb.holdings).get(), isEmpty);
      },
    );
  });

  test('after the update, the app reads the old watchlist and saves a '
      'holding', () async {
    final schema = await verifier.schemaAt(1);
    final old = v1.DatabaseAtV1(schema.newConnection());
    await old
        .into(old.watchItems)
        .insert(
          v1.WatchItemsData(
            coinId: 'bitcoin',
            addedAt: DateTime.utc(2026, 11, 10, 9).toIso8601String(),
          ),
        );
    await old.close();

    final database = AppDatabase(schema.newConnection());
    addTearDown(database.close);
    final id = await database.portfolioDao.add(
      coinId: 'bitcoin',
      amount: 0.5,
      buyPriceUsd: 60000,
      at: DateTime.utc(2026, 11, 11),
    );

    final watched = await database.watchlistDao.watchAll().first;
    expect(watched.single.addedAt, DateTime.utc(2026, 11, 10, 9));
    expect((await database.portfolioDao.find(id))?.amount, 0.5);
  });
}
