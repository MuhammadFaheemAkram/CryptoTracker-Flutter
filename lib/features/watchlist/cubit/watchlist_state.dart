import 'package:crypto_tracker/domain/model/watchlist_listing.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist_state.freezed.dart';

/// What the Watchlist tab shows.
@freezed
sealed class WatchlistState with _$WatchlistState {
  /// The market's seed is on its way (the watchlist's rows need its coins).
  const factory WatchlistState.loading() = WatchlistLoading;

  /// The market couldn't be loaded; the view offers "Try again".
  const factory WatchlistState.error(String message) = WatchlistError;

  /// The starred coins, live. Its rows are empty when nothing is starred.
  const factory WatchlistState.ready(WatchlistListing listing) = WatchlistReady;
}
