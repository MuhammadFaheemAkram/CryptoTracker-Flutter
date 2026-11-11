import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/watched_coin.dart';
import 'package:crypto_tracker/domain/model/watchlist_listing.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_watchlist_rows_use_case.dart';
import 'package:crypto_tracker/domain/usecase/watchlist_use_cases.dart';
import 'package:crypto_tracker/features/watchlist/cubit/watchlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Drives the Watchlist tab: one subscription to the watchlist pipeline,
/// and the two writes the tab makes (remove, and Undo).
///
/// Like the Market's Cubit, it keeps no rows of its own: a removal writes
/// the table, and the row leaves the list when drift's query says so.
@injectable
class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit(
    this._loadMarket,
    this._observeRows,
    this._remove,
    this._restore,
  ) : super(const WatchlistState.loading());

  final LoadMarketUseCase _loadMarket;
  final ObserveWatchlistRowsUseCase _observeRows;
  final RemoveFromWatchlistUseCase _remove;
  final RestoreWatchedCoinUseCase _restore;

  StreamSubscription<WatchlistListing>? _subscription;

  /// Set the moment [close] starts. `isClosed` turns true only at its end,
  /// after its awaits: a seed arriving in between must not subscribe.
  bool _closing = false;

  /// Loads the market's seed (shared with the Market tab: one load), then
  /// follows the watchlist. "Try again" after a failure.
  Future<void> load() async {
    if (_subscription != null) return;
    emit(const WatchlistState.loading());
    final result = await _loadMarket();
    if (_closing) return;
    switch (result) {
      case Ok(:final value):
        _subscription = _observeRows(value)
            .listen((listing) => emit(WatchlistState.ready(listing)));
      case Err(:final exception):
        emit(WatchlistState.error(exception.message));
    }
  }

  /// Unstars [coinId] (a swipe, or its star). `Ok` carries what Undo puts
  /// back.
  Future<Result<WatchedCoin?>> remove(String coinId) => _remove(coinId);

  /// Undo: [coin] goes back in its place (the same starred time).
  Future<Result<void>> restore(WatchedCoin coin) => _restore(coin);

  @override
  Future<void> close() async {
    _closing = true;
    await _subscription?.cancel();
    return super.close();
  }
}
