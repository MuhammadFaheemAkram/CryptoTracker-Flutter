import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/watched_coin.dart';
import 'package:crypto_tracker/domain/repository/watchlist_repository.dart';
import 'package:injectable/injectable.dart';

/// The starred coins' ids, in the order they were starred, live.
@injectable
class ObserveWatchlistUseCase {
  const ObserveWatchlistUseCase(this._watchlist);

  final WatchlistRepository _watchlist;

  Stream<List<String>> call() => _watchlist.watchIds();
}

/// Stars or unstars a coin (the star on a row, on a coin's page).
@injectable
class ToggleWatchUseCase {
  const ToggleWatchUseCase(this._watchlist);

  final WatchlistRepository _watchlist;

  Future<Result<bool>> call(String coinId) => _watchlist.toggle(coinId);
}

/// Removes a coin from the watchlist, keeping what Undo needs.
@injectable
class RemoveFromWatchlistUseCase {
  const RemoveFromWatchlistUseCase(this._watchlist);

  final WatchlistRepository _watchlist;

  Future<Result<WatchedCoin?>> call(String coinId) => _watchlist.remove(coinId);
}

/// Undo: puts a removed coin back in its place.
@injectable
class RestoreWatchedCoinUseCase {
  const RestoreWatchedCoinUseCase(this._watchlist);

  final WatchlistRepository _watchlist;

  Future<Result<void>> call(WatchedCoin coin) => _watchlist.restore(coin);
}
