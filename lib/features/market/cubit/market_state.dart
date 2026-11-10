import 'package:crypto_tracker/domain/model/market_coin.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
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

  /// The list, as [query] and [sort] derive it. [rows] is empty when
  /// nothing matches the query (the seed itself is never empty).
  const factory MarketState.ready({
    required List<MarketCoin> rows,
    required String query,
    required SortOption sort,
  }) = MarketReady;
}
