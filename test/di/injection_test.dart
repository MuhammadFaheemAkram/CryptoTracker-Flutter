import 'package:crypto_tracker/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(getIt.reset);

  test('the composition root builds', () {
    // Empty until Phase 2 registers the market's data layer; building it
    // must already work, since main() calls it.
    expect(configureDependencies, returnsNormally);
  });
}
