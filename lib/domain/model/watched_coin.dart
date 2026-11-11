import 'package:freezed_annotation/freezed_annotation.dart';

part 'watched_coin.freezed.dart';

/// A starred coin, and when it was starred: its place in the watchlist, and
/// what Undo puts back.
@freezed
abstract class WatchedCoin with _$WatchedCoin {
  const factory WatchedCoin({
    required String coinId,
    required DateTime addedAt,
  }) = _WatchedCoin;
}
