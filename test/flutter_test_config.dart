import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// `flutter_test` runs this around every test file under `test/`.
///
/// Every test starts with empty, in-memory preferences: the real
/// `SharedPreferencesWithCache` runs on top of them (so the settings code
/// under test is the app's own), and nothing leaks from one test to the
/// next or touches the machine's disk. The app's name and version are
/// answered too (Settings → About).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    // The composition root reads the app's name and version before the
    // first frame; there's no platform to answer in a test.
    PackageInfo.setMockInitialValues(
      appName: 'CryptoTracker',
      packageName: 'co.bitfuse.flutter.cryptotracker',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });
  await testMain();
}
