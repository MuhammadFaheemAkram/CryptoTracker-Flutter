import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/domain/pipeline/market_rows.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/features/market/cubit/market_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Drives the Market screen: loads the seed once, then derives the list from
/// it, the query and the sort.
///
/// Phase 2 is the **static** market: the rows are recomputed by
/// [buildMarketRows] whenever the query or the sort changes, synchronously,
/// with no debounce. Phase 3 replaces the recomputing with a stream
/// pipeline (`combineLatest` of the live quotes, the debounced query, the
/// sort, the currency, the watchlist), and this Cubit only subscribes.
///
/// A Cubit, not a Bloc: its intents are plain method calls, and there is no
/// stream of events to shape.
@injectable
class MarketCubit extends Cubit<MarketState> {
  MarketCubit(this._loadMarket) : super(const MarketState.loading());

  final LoadMarketUseCase _loadMarket;

  MarketSeed? _seed;
  String _query = '';
  SortOption _sort = SortOption.rank;

  /// The first load, and "Try again". Ignored once the market is loaded.
  Future<void> load() async {
    if (_seed != null) return;
    emit(const MarketState.loading());
    final result = await _loadMarket();
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        _seed = value;
        _emitRows();
      case Err(:final exception):
        emit(MarketState.error(exception.message));
    }
  }

  void queryChanged(String query) {
    _query = query;
    _emitRows();
  }

  void sortChanged(SortOption sort) {
    _sort = sort;
    _emitRows();
  }

  void _emitRows() {
    final seed = _seed;
    if (seed == null) return; // still loading, or failed: nothing to show
    emit(
      MarketState.ready(
        rows: buildMarketRows(
          coins: seed.coins,
          quotes: seed.quotes,
          query: _query,
          sort: _sort,
        ),
        query: _query,
        sort: _sort,
      ),
    );
  }
}
