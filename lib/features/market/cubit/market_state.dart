import 'package:crypto_tracker/domain/model/market_listing.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_state.freezed.dart';

/// What the Market screen shows. A `sealed` union, so the view's `switch`
/// must handle every case.
@freezed
sealed class MarketState with _$MarketState {
  /// The seed is on its way (the first launch, or "Try again").
  const factory MarketState.loading() = MarketLoading;

  /// The seed couldn't be loaded; [message] says why, the view offers
  /// "Try again".
  const factory MarketState.error(String message) = MarketError;

  /// The live market, as the pipeline last derived it: the rows, and the
  /// query, sort, currency and pause that shaped them. Its rows are empty
  /// when nothing matches the query.
  const factory MarketState.ready(MarketListing listing) = MarketReady;
}
