import 'package:crypto_tracker/domain/model/coin_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_detail_state.freezed.dart';

/// What a coin's page shows.
@freezed
sealed class CoinDetailState with _$CoinDetailState {
  /// The market's seed is on its way (a link opened at launch).
  const factory CoinDetailState.loading() = CoinDetailLoading;

  /// The market couldn't be loaded; the view offers "Try again".
  const factory CoinDetailState.error(String message) = CoinDetailError;

  /// The market has no coin with this id (a mistyped or outdated link).
  const factory CoinDetailState.notFound() = CoinDetailNotFound;

  /// The coin, live.
  const factory CoinDetailState.ready(CoinDetail detail) = CoinDetailReady;
}
