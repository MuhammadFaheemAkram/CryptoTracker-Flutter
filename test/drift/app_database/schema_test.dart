import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

// The exported schemas (drift_schemas/) are what the next migration starts
// from: if the tables changed without a new export, that migration would be
// tested against a schema no user has. This keeps the latest one equal to
// what the app creates on a fresh install. (drift's validator compares
// tables and columns, not CHECK constraints: the DAO tests cover those.)
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('a fresh install creates exactly the latest exported schema', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final latest = GeneratedHelper.versions.last;
    final schema = await verifier.schemaAt(latest);
    final database = AppDatabase(schema.newConnection());
    addTearDown(database.close);

    expect(latest, database.schemaVersion);
    await verifier.migrateAndValidate(database, latest);
  });
}
