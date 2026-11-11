/// The app's error vocabulary.
///
/// Every failure that can reach the UI is one of these types, and each
/// carries a user-facing [message], so screens render a small, stable set of
/// error states instead of raw exceptions.
///
/// `sealed` lets the compiler check that a `switch` over an [AppException]
/// handles every subtype.
sealed class AppException implements Exception {
  const AppException(this.message);

  /// Copy that is safe to show to the user.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The (fake) market service couldn't be reached.
final class NetworkException extends AppException {
  const NetworkException()
    : super("Couldn't load the market. Check your connection and try again.");
}

/// The market's data could not be decoded: malformed JSON, a wrong type, or
/// a value that breaks the app's rules (a price that isn't a positive
/// number, say).
final class DataFormatException extends AppException {
  const DataFormatException()
    : super("The market's data looks damaged. Please try again.");
}

/// A change couldn't be saved on the device (the watchlist, a holding).
final class StorageException extends AppException {
  const StorageException()
    : super("Couldn't save that change. Please try again.");
}

/// Anything unexpected that isn't one of the cases above.
final class UnknownException extends AppException {
  const UnknownException() : super('Something went wrong. Please try again.');
}
