import 'dart:async';

import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/domain/pipeline/price_history.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// Every coin's recent prices and its highest price, recorded from launch:
/// the live chart's data and the all-time high's.
///
/// Two `scan`s over the ticker, each with its own accumulator:
/// - the **points** so far, and each snapshot appends one per coin
///   ([appendSnapshot], capped at [priceHistoryCapacity]);
/// - the **highs** so far, and each snapshot raises them ([raiseHighs]);
///   they're never capped.
///
/// It starts with the app (an eager singleton) and keeps listening, so a
/// coin's chart has points the first time it's opened, even a minute in.
@singleton
class PriceHistory {
  PriceHistory(PriceTicker ticker) {
    _subscriptions = [
      ticker.quotes
          .scan<Map<String, List<PricePoint>>>(
            (history, quotes, _) => appendSnapshot(history, quotes),
            const {},
          )
          .listen(_history.add),
      ticker.quotes
          .scan<Map<String, double>>(
            (highs, quotes, _) => raiseHighs(highs, quotes),
            const {},
          )
          .listen(_highs.add),
    ];
  }

  final _history = BehaviorSubject<Map<String, List<PricePoint>>>.seeded(
    const {},
  );
  final _highs = BehaviorSubject<Map<String, double>>.seeded(const {});
  late final List<StreamSubscription<Object>> _subscriptions;

  /// [coinId]'s points, oldest first: the history so far at once, then each
  /// time it grows. A tick that didn't touch the coin emits nothing (its
  /// list is the same object, so `distinct` drops it).
  Stream<List<PricePoint>> watch(String coinId) => _history.stream
      .map((history) => history[coinId] ?? const <PricePoint>[])
      .distinct(identical);

  /// [coinId]'s highest price since launch (`null` before its first
  /// quote): the current high at once, then each time it rises.
  Stream<double?> watchHigh(String coinId) =>
      _highs.stream.map((highs) => highs[coinId]).distinct();

  @disposeMethod
  Future<void> dispose() async {
    await [for (final subscription in _subscriptions) subscription.cancel()]
        .wait;
    await (_history.close(), _highs.close()).wait;
  }
}
