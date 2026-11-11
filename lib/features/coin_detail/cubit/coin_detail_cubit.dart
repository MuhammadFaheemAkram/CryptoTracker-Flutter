import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/chart_range.dart';
import 'package:crypto_tracker/domain/model/coin_detail.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_coin_detail_use_case.dart';
import 'package:crypto_tracker/domain/usecase/watchlist_use_cases.dart';
import 'package:crypto_tracker/features/coin_detail/cubit/coin_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// Drives one coin's page.
///
/// The coin's id is a **factory parameter** (`@factoryParam`): the page
/// hands it to the service locator as `param1`, and injectable passes it
/// alongside the injected use cases. Each page gets its own Cubit.
///
/// Its one input from the screen is the chart's range (a seeded
/// `BehaviorSubject`, like the Market's query and sort); everything else
/// comes from the pipeline ([ObserveCoinDetailUseCase]).
@injectable
class CoinDetailCubit extends Cubit<CoinDetailState> {
  CoinDetailCubit(
    @factoryParam this.coinId,
    this._loadMarket,
    this._observeDetail,
    this._toggleWatch,
  ) : super(const CoinDetailState.loading());

  final String coinId;
  final LoadMarketUseCase _loadMarket;
  final ObserveCoinDetailUseCase _observeDetail;
  final ToggleWatchUseCase _toggleWatch;

  final _range = BehaviorSubject<ChartRange>.seeded(ChartRange.live);
  StreamSubscription<CoinDetail>? _subscription;

  /// Set the moment [close] starts. `isClosed` turns true only at its end,
  /// after its awaits: a seed arriving in between must not subscribe.
  bool _closing = false;

  /// Loads the market's seed (one load, shared with the tabs), finds the
  /// coin, then follows it. "Try again" after a failure.
  Future<void> load() async {
    if (_subscription != null) return;
    emit(const CoinDetailState.loading());
    final result = await _loadMarket();
    if (_closing) return;
    switch (result) {
      case Ok(value: final seed):
        final coin = seed.coins.where((coin) => coin.id == coinId).firstOrNull;
        if (coin == null) return emit(const CoinDetailState.notFound());
        _subscription = _observeDetail(
          coin,
          rates: seed.rates,
          range: _range,
        ).listen((detail) => emit(CoinDetailState.ready(detail)));
      case Err(:final exception):
        emit(CoinDetailState.error(exception.message));
    }
  }

  /// Live | 7 days.
  void rangeChanged(ChartRange range) => _range.add(range);

  /// The star in the app bar. The filled star comes back through the
  /// pipeline, from the table. `Err` if it couldn't be saved.
  Future<Result<bool>> toggleWatch() => _toggleWatch(coinId);

  @override
  Future<void> close() async {
    _closing = true;
    await _subscription?.cancel();
    await _range.close();
    return super.close();
  }
}
