import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:flutter_test/flutter_test.dart';

/// An `Ok` whose value matches [value] (anything, if omitted).
Matcher isOk([Object? value = anything]) =>
    isA<Ok<Object?>>().having((ok) => ok.value, 'value', value);

/// An `Err` carrying an exception of type [E].
Matcher isErrOf<E extends AppException>() =>
    isA<Err<Object?>>().having((err) => err.exception, 'exception', isA<E>());
