import 'dart:math' as math;

import 'package:crypto_tracker/domain/model/chart_range.dart';
import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_detail.freezed.dart';

/// Everything a coin's page shows, as the coin-detail pipeline derives it
/// on every change of any input (a tick, a star, the currency, the chart's
/// range).
///
/// The live stats are getters, computed from the current quote, so they can
/// never disagree with the price on the same screen (Correctness Rule 9).
@freezed
abstract class CoinDetail with _$CoinDetail {
  const factory CoinDetail({
    required Coin coin,
    required Quote quote,

    /// Which way the price moved on the last tick: the header's flash.
    @Default(PriceDirection.flat) PriceDirection direction,

    /// The prices seen since launch, oldest first.
    @Default(<PricePoint>[]) List<PricePoint> livePoints,

    /// The highest price seen since launch.
    double? highestSeenUsd,
    @Default(false) bool isWatched,
    @Default(ChartRange.live) ChartRange range,
    required Currency currency,

    /// Units of [currency] per dollar.
    required double rate,

    /// The user paused live prices: nothing is moving.
    @Default(false) bool isPaused,
  }) = _CoinDetail;

  const CoinDetail._();

  /// Market cap at the *current* price: circulating supply × price. The
  /// seed's market cap would freeze at launch while the price moves on.
  double get marketCapUsd => coin.circulatingSupply * quote.priceUsd;

  /// The higher of the seed's all-time high and the highest price seen
  /// since: a simulated rally past the record raises it. The current price
  /// counts too, so the high is never below the price beside it, even for
  /// the instant before the history records the tick.
  double get allTimeHighUsd => math.max(
    coin.allTimeHighUsd,
    math.max(highestSeenUsd ?? quote.priceUsd, quote.priceUsd),
  );

  /// The chart's prices, oldest first, for the chosen [range].
  List<double> get chartPoints => switch (range) {
    ChartRange.live => [for (final point in livePoints) point.priceUsd],
    ChartRange.sevenDays => coin.sparkline7d,
  };
}
