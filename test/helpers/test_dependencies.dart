import 'package:crypto_tracker/core/database/app_database.dart';
import 'package:crypto_tracker/di/injection.dart';

import 'database.dart';

/// The app's real composition root, with its database in memory (closed by
/// `getIt.reset()`). The preferences are already in memory
/// (`flutter_test_config.dart`). Call `getIt.reset()` in `tearDown`.
Future<void> configureTestDependencies() async {
  await configureDependencies();
  getIt
    ..unregister<AppDatabase>()
    ..registerLazySingleton<AppDatabase>(
      newTestDatabase,
      dispose: (database) => database.close(),
    );
}
