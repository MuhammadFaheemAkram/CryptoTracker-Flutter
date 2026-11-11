import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/domain/model/quote.dart';

/// How many points each coin's history keeps: about a minute at one tick a
/// second, five at one every five.
const priceHistoryCapacity = 60;

/// [history] with one more point per coin from [quotes], each coin's list
/// capped at [capacity] (the oldest points drop off).
///
/// The step of a `scan` over the ticker: the accumulator is the history so
/// far, each snapshot adds a point. A bounded buffer, so a long session
/// never grows memory. A quote stamped no later than the coin's last point
/// (the same snapshot again) adds nothing.
///
/// Pure, and it never mutates [history]: it returns new lists, so a
/// listener holding the old history still sees the old history.
Map<String, List<PricePoint>> appendSnapshot(
  Map<String, List<PricePoint>> history,
  Map<String, Quote> quotes, {
  int capacity = priceHistoryCapacity,
}) {
  final next = {...history};
  for (final MapEntry(key: id, value: quote) in quotes.entries) {
    final points = history[id] ?? const <PricePoint>[];
    if (points.isNotEmpty && !quote.updatedAt.isAfter(points.last.at)) {
      continue;
    }
    final kept = points.length >= capacity
        ? points.sublist(points.length - capacity + 1)
        : points;
    next[id] = List.unmodifiable([
      ...kept,
      PricePoint(at: quote.updatedAt, priceUsd: quote.priceUsd),
    ]);
  }
  return next;
}
