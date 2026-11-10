import 'package:clock/clock.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Third-party types the app's classes depend on, which can't carry
/// `injectable` annotations themselves.
@module
abstract class AppModule {
  /// "Now" for every timestamp. Tests replace it with a fixed clock.
  @lazySingleton
  Clock get clock => const Clock();

  /// The app bundle, where the fake market service reads its JSON.
  @lazySingleton
  AssetBundle get assetBundle => rootBundle;
}
