import 'dart:developer' as developer;

import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';

/// Runs a write to the device's storage and turns a failure into a
/// [StorageException] the screen can show ("Couldn't save that change").
///
/// Only exceptions are caught (a full disk, a locked database): an `Error`
/// is a bug, and is rethrown so a test still sees it.
Future<Result<T>> guardWrite<T>(String what, Future<T> Function() write) async {
  try {
    return Ok(await write());
  } on AppException catch (exception) {
    return Err(exception);
  } on Exception catch (error, stackTrace) {
    developer.log(
      '$what failed',
      error: error,
      stackTrace: stackTrace,
      name: 'guardWrite',
    );
    return const Err(StorageException());
  }
}
