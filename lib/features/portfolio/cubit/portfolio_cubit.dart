import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/model/portfolio_listing.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_portfolio_use_case.dart';
import 'package:crypto_tracker/domain/usecase/portfolio_use_cases.dart';
import 'package:crypto_tracker/features/portfolio/cubit/portfolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Drives the Portfolio tab: one subscription to the valuation pipeline,
/// and the tab's own writes (remove, and Undo).
///
/// It never values a holding itself, and never keeps a price: each tick,
/// each change to the table and each currency change comes out of the
/// pipeline as a new valuation.
@injectable
class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit(
    this._loadMarket,
    this._observePortfolio,
    this._remove,
    this._restore,
  ) : super(const PortfolioState.loading());

  final LoadMarketUseCase _loadMarket;
  final ObservePortfolioUseCase _observePortfolio;
  final RemoveHoldingUseCase _remove;
  final RestoreHoldingUseCase _restore;

  StreamSubscription<PortfolioListing>? _subscription;

  /// Set the moment [close] starts. `isClosed` turns true only at its end,
  /// after its awaits: a seed arriving in between must not subscribe.
  bool _closing = false;

  /// Loads the market's seed (one load, shared with the other tabs), then
  /// follows the valuation. "Try again" after a failure.
  Future<void> load() async {
    if (_subscription != null) return;
    emit(const PortfolioState.loading());
    final result = await _loadMarket();
    if (_closing) return;
    switch (result) {
      case Ok(:final value):
        _subscription = _observePortfolio(value)
            .listen((listing) => emit(PortfolioState.ready(listing)));
      case Err(:final exception):
        emit(PortfolioState.error(exception.message));
    }
  }

  /// Removes a holding (a swipe, or the screen reader's Remove). `Ok`
  /// carries what Undo puts back.
  Future<Result<Holding?>> remove(int id) => _remove(id);

  /// Undo: [holding] back, with its id, in its place.
  Future<Result<void>> restore(Holding holding) => _restore(holding);

  @override
  Future<void> close() async {
    _closing = true;
    await _subscription?.cancel();
    return super.close();
  }
}
