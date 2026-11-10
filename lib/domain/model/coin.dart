import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin.freezed.dart';

/// A coin's identity and its fundamentals: what doesn't tick.
///
/// Its live price is a separate [Quote]: the coin is loaded once, the quote
/// changes every second (Phase 3). Money is in US dollars ([Currency]
/// converts it for display).
@freezed
abstract class Coin with _$Coin {
  const factory Coin({
    required String id,
    required String symbol,
    required String name,

    /// 1 for the largest market cap. Fixed by the seed.
    required int rank,
    required double marketCapUsd,
    required double volume24hUsd,
    required double circulatingSupply,

    /// `null` when there is no maximum supply.
    required double? totalSupply,
    required double allTimeHighUsd,

    /// Pegged to a fiat currency (USDT, USDC, DAI): it barely moves.
    @Default(false) bool isStablecoin,

    /// The last 7 days, oldest first (24 points, from the seed).
    @Default(<double>[]) List<double> sparkline7d,
  }) = _Coin;
}
