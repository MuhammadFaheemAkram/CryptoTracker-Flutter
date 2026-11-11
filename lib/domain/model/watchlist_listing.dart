import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/market_coin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist_listing.freezed.dart';

/// What the watchlist pipeline emits: the starred coins' rows, in the order
/// they were starred, and how to show their prices.
@freezed
abstract class WatchlistListing with _$WatchlistListing {
  const factory WatchlistListing({
    required List<MarketCoin> rows,
    required Currency currency,

    /// Units of [currency] per dollar.
    required double rate,

    /// The user paused live prices: nothing is moving.
    required bool isPaused,
  }) = _WatchlistListing;
}
