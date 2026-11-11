import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/watched_coin.dart';

/// The coins the user starred, stored on the device and observed live.
abstract interface class WatchlistRepository {
  /// The starred coins' ids, in the order they were starred: the current
  /// list at once, then after every change.
  Stream<List<String>> watchIds();

  /// Whether [coinId] is starred, live.
  Stream<bool> watchContains(String coinId);

  /// Stars [coinId] if it isn't, unstars it if it is. `Ok(true)`: it's
  /// starred now.
  Future<Result<bool>> toggle(String coinId);

  /// Unstars [coinId]. `Ok` carries what was removed, for Undo (`null` if
  /// it wasn't starred).
  Future<Result<WatchedCoin?>> remove(String coinId);

  /// Undo: puts [coin] back where it was (the same starred time).
  Future<Result<void>> restore(WatchedCoin coin);
}
