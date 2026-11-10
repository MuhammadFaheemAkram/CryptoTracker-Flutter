import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_coin.freezed.dart';

/// One row of a market list: a coin with its current quote.
///
/// Rows are *derived*, never edited: the list is rebuilt from the coins and
/// the quotes whenever either changes (the one rule). [direction] (Phase 3)
/// and [isWatched] (Phase 4) join as their streams arrive.
@freezed
abstract class MarketCoin with _$MarketCoin {
  const factory MarketCoin({
    required Coin coin,
    required Quote quote,

    /// Which way the price moved on the last tick.
    @Default(PriceDirection.flat) PriceDirection direction,
    @Default(false) bool isWatched,
  }) = _MarketCoin;
}
