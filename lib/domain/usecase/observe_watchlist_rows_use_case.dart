import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/watchlist_listing.dart';
import 'package:crypto_tracker/domain/pipeline/price_display.dart';
import 'package:crypto_tracker/domain/pipeline/watchlist_rows.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:crypto_tracker/domain/repository/watchlist_repository.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// The Watchlist tab, live.
///
/// ```
/// snapshots ──────────────┐   (one per tick, with directions)
/// watched ids (drift) ────┼─ combineLatest3 ─▶ buildWatchlistRows ─▶ WatchlistListing
/// settings ─ priceDisplay ┘   (currency, paused)
/// ```
///
/// The ids come from a drift query: starring a coin anywhere (a Market row,
/// a coin's page) writes the table, drift re-runs the query, and this list
/// gains the coin with nobody telling it.
@injectable
class ObserveWatchlistRowsUseCase {
  const ObserveWatchlistRowsUseCase(
    this._moves,
    this._watchlist,
    this._settings,
  );

  final ObservePriceMovesUseCase _moves;
  final WatchlistRepository _watchlist;
  final SettingsRepository _settings;

  Stream<WatchlistListing> call(MarketSeed seed) => Rx.combineLatest3(
    _moves(),
    _watchlist.watchIds(),
    _settings.watch().priceDisplay(),
    (snapshot, ids, display) => WatchlistListing(
      rows: buildWatchlistRows(
        coins: seed.coins,
        quotes: snapshot.quotes,
        watchedIds: ids,
        directions: snapshot.directions,
      ),
      currency: display.currency,
      rate: seed.rates.rateFor(display.currency),
      isPaused: display.paused,
    ),
  );
}
