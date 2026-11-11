import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// `flutter_test` runs this around every test file under `test/`.
///
/// Every test starts with empty, in-memory preferences: the real
/// `SharedPreferencesWithCache` runs on top of them (so the settings code
/// under test is the app's own), and nothing leaks from one test to the
/// next or touches the machine's disk.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });
  await testMain();
}
