import 'package:rxdart/rxdart.dart';

/// The search query, settled: what the market list is filtered by.
extension SettledQuery on Stream<String> {
  /// Each keystroke restarts a wait of [delay]; only a query that survives
  /// it goes through. An empty query (the field cleared) goes through at
  /// once, and a query equal to the last one (after trimming) is dropped.
  ///
  /// Built from `switchMap`: every new query *switches* to a fresh timer,
  /// cancelling the previous one, which is what a debounce is. Unlike
  /// `debounceTime`, it can treat an empty query differently, so clearing
  /// the field shows every coin without waiting (Correctness Rule 5).
  Stream<String> settled(Duration delay) => map((query) => query.trim())
      .switchMap(
        (query) =>
            query.isEmpty ? Stream.value(query) : TimerStream(query, delay),
      )
      .distinct();
}
