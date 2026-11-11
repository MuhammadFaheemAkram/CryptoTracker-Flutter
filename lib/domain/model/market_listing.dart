import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/market_coin.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_listing.freezed.dart';

/// What the market pipeline emits: the rows, and the inputs that shaped
/// them, so the screen shows exactly what was derived (never a newer query
/// over older rows).
@freezed
abstract class MarketListing with _$MarketListing {
  const factory MarketListing({
    required List<MarketCoin> rows,

    /// The query the rows were filtered by: settled (debounced) and
    /// trimmed.
    required String query,
    required SortOption sort,
    required Currency currency,

    /// Units of [currency] per dollar.
    required double rate,

    /// The user paused live prices: nothing is moving.
    required bool isPaused,
  }) = _MarketListing;
}
