import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/quote.dart';

/// Which way each coin moved from [previous] to [next].
///
/// The heart of the `scan` that drives the flashes: a direction only exists
/// between two snapshots, so the pipeline has to remember the last one.
/// - No previous snapshot (the first tick): nothing moved, an empty map.
/// - A coin whose price didn't change, or that is new in [next]: left out
///   (flat).
///
/// Pure, so it's tested without streams.
Map<String, PriceDirection> directionsBetween(
  Map<String, Quote>? previous,
  Map<String, Quote> next,
) {
  if (previous == null) return const {};
  return {
    for (final MapEntry(key: id, value: quote) in next.entries)
      if (previous[id]?.priceUsd case final before?
          when before != quote.priceUsd)
        id: quote.priceUsd > before ? PriceDirection.up : PriceDirection.down,
  };
}
