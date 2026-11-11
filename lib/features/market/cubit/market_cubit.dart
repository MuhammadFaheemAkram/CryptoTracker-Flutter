import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_listing.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/settings_use_cases.dart';
import 'package:crypto_tracker/features/market/cubit/market_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// Drives the Market screen: the bridge between a stream pipeline and the
/// screen's state.
///
/// It owns only the market's **inputs** from this screen, the query and the
/// sort (each a `BehaviorSubject`: seeded, so the pipeline's first listing
/// arrives at once), and one **subscription** to the pipeline
/// ([ObserveMarketUseCase]) that turns every listing into a state. It never
/// computes a row itself, and never keeps a price: it's the Dart version of
/// a ViewModel collecting a Flow into a `StateFlow`.
///
/// A Cubit, not a Bloc: the search debounce is an operator on the query
/// stream, combined with four other streams; Bloc's event transformers
/// would only add events around it.
@injectable
class MarketCubit extends Cubit<MarketState> {
  MarketCubit(
    this._loadMarket,
    this._observeMarket,
    this._setPaused, {
    @ignoreParam this.debounce = searchDebounce,
  }) : super(const MarketState.loading());

  final LoadMarketUseCase _loadMarket;
  final ObserveMarketUseCase _observeMarket;
  final SetLivePricesPausedUseCase _setPaused;

  /// How long typing must pause. Tests that type in real time shorten it.
  final Duration debounce;

  final _query = BehaviorSubject<String>.seeded('');
  final _sort = BehaviorSubject<SortOption>.seeded(SortOption.rank);
  StreamSubscription<MarketListing>? _subscription;

  /// Loads the seed, then follows the live market. "Try again" after a
  /// failure; ignored once the market is live.
  Future<void> load() async {
    if (_subscription != null) return;
    emit(const MarketState.loading());
    final result = await _loadMarket();
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        _subscription = _observeMarket(
          value,
          query: _query,
          sort: _sort,
          debounce: debounce,
        ).listen((listing) => emit(MarketState.ready(listing)));
      case Err(:final exception):
        emit(MarketState.error(exception.message));
    }
  }

  /// Each keystroke. The pipeline waits for typing to settle.
  void queryChanged(String query) => _query.add(query);

  void sortChanged(SortOption sort) => _sort.add(sort);

  /// Stops or restarts the live prices (the app bar's button: moving content
  /// must be pausable, WCAG 2.2.2).
  Future<void> setPaused({required bool paused}) => _setPaused(paused: paused);

  /// Nothing is emitted after this: the subscription goes first, then the
  /// inputs close.
  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await (_query.close(), _sort.close()).wait;
    return super.close();
  }
}
