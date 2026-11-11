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

/// [highs] raised by [quotes]: each coin's highest price seen so far.
///
/// The other step of the history's `scan`. Unlike the points, a high is
/// never dropped: it covers the whole session, so the all-time high a coin's
/// page shows can't fall when an old point leaves the buffer (Correctness
/// Rule 9). Returns [highs] itself when nothing rose, so a listener comparing
/// by identity sees no change.
Map<String, double> raiseHighs(
  Map<String, double> highs,
  Map<String, Quote> quotes,
) {
  Map<String, double>? next;
  for (final MapEntry(key: id, value: quote) in quotes.entries) {
    final high = highs[id];
    if (high == null || quote.priceUsd > high) {
      (next ??= {...highs})[id] = quote.priceUsd;
    }
  }
  return next == null ? highs : Map.unmodifiable(next);
}
