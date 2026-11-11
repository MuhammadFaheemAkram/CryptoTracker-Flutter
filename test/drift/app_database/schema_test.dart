import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;

// The exported schema (drift_schemas/) is what Phase 5's migration starts
// from: if the tables changed without a new export, the v1 → v2 migration
// would be tested against a schema no user has. This keeps the two equal.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('the app creates exactly the exported v1 schema', () async {
    final schema = await verifier.schemaAt(1);
    final database = AppDatabase(schema.newConnection());
    addTearDown(database.close);

    await verifier.migrateAndValidate(database, 1);
  });

  test('a row written at v1 reads back in the app (dates as text)', () async {
    final schema = await verifier.schemaAt(1);
    final old = v1.DatabaseAtV1(schema.newConnection());
    // Snapshots hold raw SQL values: the date is ISO-8601 text (§11.108).
    await old
        .into(old.watchItems)
        .insert(
          v1.WatchItemsData(
            coinId: 'bitcoin',
            addedAt: DateTime.utc(2026, 11, 10, 9, 41).toIso8601String(),
          ),
        );
    await old.close();

    final database = AppDatabase(schema.newConnection());
    addTearDown(database.close);
    final rows = await database.select(database.watchItems).get();

    expect(rows.single.coinId, 'bitcoin');
    expect(rows.single.addedAt, DateTime.utc(2026, 11, 10, 9, 41));
  });
}
