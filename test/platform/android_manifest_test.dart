import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// A release build merges only `src/main`'s manifest (the debug and profile
// ones add INTERNET for development: conventions §11.98). CryptoTracker is
// simulated on the device and makes no requests, so its release build must
// not ask for the network: SECURITY.md promises it.
void main() {
  final manifest = File('android/app/src/main/AndroidManifest.xml')
      .readAsStringSync();

  test('the release build asks for no network permission', () {
    expect(manifest, isNot(contains('android.permission.INTERNET')));
    expect(manifest, isNot(contains('ACCESS_NETWORK_STATE')));
  });

  test('the app is called CryptoTracker on the launcher', () {
    expect(manifest, contains('android:label="CryptoTracker"'));
  });
}
