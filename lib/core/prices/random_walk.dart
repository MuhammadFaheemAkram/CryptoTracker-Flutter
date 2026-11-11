import 'dart:math' as math;

import 'package:injectable/injectable.dart';

/// How a simulated price moves on each tick: a small random step, pulled
/// gently back towards where it started (Correctness Rule 3).
///
/// - **The step:** up to ±1.5 % for a coin (the native editions' walk), up
///   to ±0.05 % for a stablecoin, which is pegged to a dollar and barely
///   moves.
/// - **The pull:** 2 % of the distance back to the starting price per tick.
///   A pure random walk wanders without limit, so after an hour BTC could
///   be at half its price; with the pull, prices stay plausible however
///   long the app runs (a mean-reverting walk).
/// - **The floor:** a price never reaches zero.
///
/// The randomness is injected, so a test with a seeded [math.Random] gets
/// the same prices every time (Correctness Rule 15).
@lazySingleton
class RandomWalk {
  RandomWalk(this._random);

  final math.Random _random;

  static const coinStep = 0.015;
  static const stablecoinStep = 0.0005;
  static const pull = 0.02;
  static const floorUsd = 0.000001;

  /// The next price after [priceUsd], for a coin that started at
  /// [anchorUsd].
  double next({
    required double priceUsd,
    required double anchorUsd,
    required bool isStablecoin,
  }) {
    final step = isStablecoin ? stablecoinStep : coinStep;
    final shock = (_random.nextDouble() * 2 - 1) * step;
    final reversion = pull * (anchorUsd - priceUsd) / priceUsd;
    return math.max(priceUsd * (1 + shock + reversion), floorUsd);
  }
}
