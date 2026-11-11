import 'package:crypto_tracker/domain/model/market_listing.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/domain/pipeline/market_rows.dart';
import 'package:crypto_tracker/domain/pipeline/price_display.dart';
import 'package:crypto_tracker/domain/pipeline/settled_query.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:crypto_tracker/domain/repository/watchlist_repository.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// How long typing must pause before the market is filtered.
const searchDebounce = Duration(milliseconds: 300);

/// The market list, live: the showcase pipeline.
///
/// ```
/// snapshots ─────────────────────────────────┐   (one per tick, with directions)
/// query ─ trim ─ switchMap(timer) ─ distinct ┤   (settled after 300 ms)
/// sort ─ distinct ───────────────────────────┼─ combineLatest5 ─▶ buildMarketRows ─▶ MarketListing
/// settings ─ priceDisplay ───────────────────┤   (currency, paused)
/// watched ids (drift) ─ toSet ───────────────┘   (the stars)
/// ```
///
/// - **`combineLatest`, not `zip`:** `zip` would pair the n-th tick with the
///   n-th keystroke. `combineLatest` recomputes from the *latest* of each
///   input whenever any one of them changes, which is what a derived list
///   is.
/// - **Every input has a value at once** (the ticker and the settings
///   replay theirs, the Cubit's query and sort are seeded), so the first
///   listing arrives immediately, not at the first tick.
/// - **Each input is `distinct`**, so a currency change doesn't arrive as a
///   "new" sort, and a theme change doesn't reach the market at all.
@injectable
class ObserveMarketUseCase {
  const ObserveMarketUseCase(this._moves, this._settings, this._watchlist);

  final ObservePriceMovesUseCase _moves;
  final SettingsRepository _settings;
  final WatchlistRepository _watchlist;

  /// The listing for [seed]'s coins, for the user's [query] (each
  /// keystroke) and [sort], recomputed on every change of any input.
  Stream<MarketListing> call(
    MarketSeed seed, {
    required Stream<String> query,
    required Stream<SortOption> sort,
    Duration debounce = searchDebounce,
  }) => Rx.combineLatest5(
    _moves(),
    query.settled(debounce),
    sort.distinct(),
    _settings.watch().priceDisplay(),
    _watchlist.watchIds().map((ids) => ids.toSet()),
    (snapshot, query, sort, settings, watched) => MarketListing(
      rows: buildMarketRows(
        coins: seed.coins,
        quotes: snapshot.quotes,
        query: query,
        sort: sort,
        directions: snapshot.directions,
        watched: watched,
      ),
      query: query,
      sort: sort,
      currency: settings.currency,
      rate: seed.rates.rateFor(settings.currency),
      isPaused: settings.paused,
    ),
  );
}
