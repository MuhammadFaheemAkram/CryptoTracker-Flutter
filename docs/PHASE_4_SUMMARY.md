# Phase 4 — Watchlist + Coin Detail + Charts

## Phase Goal

Give the live market somewhere to go:
- **a watchlist stored on the device** (drift v1), starred from the Market or a coin's page, where **the table is the only source of truth**: every screen observes a query, none tells another;
- **the Watchlist tab:** the starred coins in the order they were starred, live, removable with a swipe or the star, with Undo;
- **a coin's page:** a six-input pipeline (`combineLatest6`): the live header that flashes, live stats that agree with the price, and a hand-drawn chart (Live | 7 days) with its trend in words;
- **a database that can migrate:** the v1 schema exported, and a test that the app's tables match it.

The market pipeline from Phase 3 didn't change shape: its fifth input, the watched set, was `Stream.value({})`. It's now a drift query.

Both new pipelines are drawn in **[STREAM_PIPELINES.md](STREAM_PIPELINES.md)** (§8, §9).

---

## What Was Implemented

- **The database** (`core/database/`):
  - `WatchItems` (`coin_id TEXT PRIMARY KEY CHECK (length > 0)`, `added_at`), dates stored as ISO-8601 text;
  - `WatchlistDao`:
    - `watchAll()` (oldest first, ties by id) and `watchContains(id)`, both live;
    - `add` (INSERT OR IGNORE, so a second star keeps the first time) and `restore` (Undo, the same row);
    - `remove`, which returns the removed row, in one transaction;
  - `AppDatabase`, one for the app (`drift_flutter`, a background isolate); the schema exported to `drift_schemas/` (v1).
- **Writes:**
  - `guardWrite`: an `Exception` becomes `StorageException` ("Couldn't save that change. Please try again."); an `Error` (a bug) is rethrown;
  - `WatchlistRepository` / `WatchlistRepositoryImpl`: `watchIds`, `watchContains`, `toggle` (`Ok(true)` when now starred), `remove` (`Ok(WatchedCoin)` for Undo), `restore`; times from the injected `Clock`, in UTC;
  - use cases: Observe, Toggle, Remove, Restore.
- **The price history gains highs:** a second `scan` (`raiseHighs`), never capped, so the all-time high can't fall when a point leaves the 60-point buffer. `MarketRepository` gains `history(id)` and `highestPrice(id)`.
- **Pipelines:**
  - `ObserveMarketUseCase`: the watched set from drift as its fifth input;
  - `ObserveWatchlistRowsUseCase`: `combineLatest3(snapshots, watchIds, priceDisplay)` → `buildWatchlistRows` (starred order) → `WatchlistListing`;
  - `ObserveCoinDetailUseCase`: `combineLatest6(this coin's move (distinct), history, high, watched, priceDisplay, range)` → `CoinDetail`;
  - `priceDisplay()`: the settings narrowed to `(currency, paused)` and `distinct`, shared by the three.
- **Models:** `WatchedCoin`, `ChartRange` (Live, 7 days), `WatchlistListing`, `CoinDetail` with live getters: `marketCapUsd` (circulating × price), `allTimeHighUsd` (seed, seen, now), `chartPoints`.
- **Cubits:**
  - `MarketCubit.toggleWatch`;
  - `WatchlistCubit` (load, remove, restore);
  - `CoinDetailCubit` (`@factoryParam coinId`; not found; the range as a seeded `BehaviorSubject`; the star);
  - all three: a `_closing` flag set first in `close()`, so a seed landing mid-close never subscribes.
- **Screens:**
  - Market rows get a **star**;
  - the **Watchlist:**
    - the count and a Paused chip;
    - live rows with filled stars;
    - a swipe (`confirmDismiss` waits for the write; a failure slides back) or the star, then **Undo**;
    - empty: "Star coins to watch them here", with a way to the Market;
  - **a coin's page:**
    - the coin's name and a star in the app bar;
    - a header that flashes (badge, live price, 24 h change, the Paused chip);
    - Live | 7 days;
    - `PriceLineChart`, its trend under it;
    - five `StatTile`s (two columns, one at large text);
    - **Add to portfolio**;
    - loading, error, and "Coin not found".
- **Design system:**
  - `PriceFlash` and `AnimatedPrice` (out of `CoinRow`, shared with the header);
  - `WatchStar`, `StatTile`, `showAppSnackBar` (an Undo bar stays 8 s);
  - `PriceLineChart` (a line, a fading fill, a dot on the price now; high and low labels; one semantic summary; "Collecting prices…" under two points);
  - `ChartFormatter.describeTrend`;
  - `PriceChangeBadge` now shrinks rather than overflow.
- **Packages:** `drift`, `drift_flutter`; dev: `drift_dev`.
- **483 tests** (356 after Phase 3).

---

## Stream Concepts Demonstrated

| Operator / idea | Where | Why |
|---|---|---|
| A **query as a stream** (`watch()`) | `WatchlistDao` | The database pushes each new result after every write: Room's `Flow`, SwiftData's `@Query` |
| **Write, then observe** | every star | Screens never tell each other; the table does, through each one's own query |
| `combineLatest3` | the Watchlist | Ticks × starred ids × currency, re-derived on any change |
| `combineLatest6` | a coin's page | Six inputs, one `CoinDetail`; the range is an input, not a patch |
| `map` + `distinct` **before** combining | the coin's move | Another coin's tick never rebuilds this page |
| A second `scan` | the highs | A running maximum, never capped, identity kept when nothing rose |
| `whereType` | the coin's page | No quote, no emission (rather than a page with a hole) |
| A shared narrowing operator | `priceDisplay()` | One definition of "the settings a price depends on" |
| A seeded `BehaviorSubject` as a screen input | the chart's range | Same pattern as the Market's query and sort |

---

## Flutter / Dart Concepts Demonstrated

- **drift:**
  - tables, a DAO (`@DriftAccessor`), a transaction returning a value, `InsertMode.insertOrIgnore`, a `CHECK`;
  - dates as text;
  - `make-migrations` and `schema generate`, with a `SchemaVerifier` test of v1;
  - an in-memory database in tests.
- **injectable `@factoryParam`:** a Cubit per coin, `getIt<CoinDetailCubit>(param1: id)`.
- **`Dismissible.confirmDismiss`:** an asynchronous decision before a row may leave.
- **`CustomPainter`:**
  - a path, a closed fill path with a `LinearGradient` shader, circles;
  - `shouldRepaint` on the data, with `listEquals`;
  - `RepaintBoundary`.
- **Large text:**
  - `FittedBox(scaleDown)` for a number that must not wrap;
  - `SegmentedButton(direction: vertical)` and one-column tiles past 130 %.
- **Semantics:**
  - `MergeSemantics` (a stat's label and value as one);
  - the chart as one container node with a summary;
  - the visible summary excluded so nothing is read twice.

---

## Data Flow

```
tap ☆ on a Market row
  → MarketCubit.toggleWatch(id) → ToggleWatchUseCase → WatchlistRepositoryImpl.toggle
  → guardWrite → WatchlistDao.add(id, clock.now().toUtc())         (an INSERT into watch_items)
  → drift re-runs every watch_items query:
      Market:     watchIds() → toSet → combineLatest5 → the row's star fills
      Watchlist:  watchIds() → combineLatest3 → the coin appears, last
      Coin page:  watchContains(id) → combineLatest6 → the app bar's star fills

open Bitcoin (from any tab)
  → CoinDetailRoute(coinId: 'bitcoin') → getIt<CoinDetailCubit>(param1: 'bitcoin')
  → load(): the shared seed (no second request) → find the coin (or "not found")
  → combineLatest6 → CoinDetail → the header, the chart (60 points since launch), the stats
  → each tick of Bitcoin (only Bitcoin's) → a new CoinDetail → the header flashes, the chart grows
```

---

## Important Files Added

| File | What |
|---|---|
| `lib/core/database/app_database.dart`, `tables/watch_items.dart`, `daos/watchlist_dao.dart` | drift v1 |
| `drift_schemas/app_database/drift_schema_v1.json` | The exported schema |
| `lib/core/common/guard_write.dart` | Storage failures as a result |
| `lib/data/repository/watchlist_repository_impl.dart` | The watchlist over drift |
| `lib/domain/usecase/observe_watchlist_rows_use_case.dart`, `observe_coin_detail_use_case.dart`, `watchlist_use_cases.dart` | The pipelines and writes |
| `lib/domain/pipeline/watchlist_rows.dart`, `price_display.dart` | Pure pieces |
| `lib/domain/model/coin_detail.dart`, `chart_range.dart`, `watched_coin.dart`, `watchlist_listing.dart` | Models |
| `lib/features/watchlist/…`, `lib/features/coin_detail/…` | Cubits, states, views, pages |
| `lib/core/design_system/charts/price_line_chart.dart` | The chart |
| `lib/core/design_system/widgets/price_flash.dart`, `watch_star.dart`, `stat_tile.dart`, `app_snack_bar.dart` | Shared widgets |
| `lib/core/formatting/chart_formatter.dart` | The trend in words |
| `test/drift/app_database/` | Schema helpers and the v1 check |
| `test/helpers/database.dart`, `test_dependencies.dart`, `result_matchers.dart`, `fakes/fake_watchlist_repository.dart` | Test support |

---

## Important Types Added

- `AppDatabase`, `WatchItems` / `WatchItemRow`, `WatchlistDao`
- `WatchlistRepository`, `WatchedCoin`, `StorageException`
- `ObserveWatchlistRowsUseCase`, `ObserveCoinDetailUseCase`, `ToggleWatchUseCase`, `RemoveFromWatchlistUseCase`, `RestoreWatchedCoinUseCase`
- `WatchlistListing`, `CoinDetail`, `ChartRange`, `PriceDisplay`
- `WatchlistCubit` / `WatchlistState`, `CoinDetailCubit` / `CoinDetailState`
- `PriceLineChart` / `PriceLinePainter`, `PriceFlash`, `AnimatedPrice`, `WatchStar`, `StatTile`, `ChartFormatter`

---

## Folder Structure Changes

```
lib/core/database/            new: AppDatabase, tables/, daos/
lib/core/design_system/       + charts/price_line_chart.dart, widgets/{price_flash, watch_star, stat_tile, app_snack_bar}.dart
lib/features/watchlist/       placeholder → cubit/, view, page
lib/features/coin_detail/     placeholder → cubit/, view, page
drift_schemas/                new: one JSON per schema version
test/drift/                   new: generated schema helpers + the schema test
```

---

## Android / iOS Comparison

| Concept | Android | iOS | Flutter (this app) |
|---|---|---|---|
| Watchlist storage | Room, `Flow<List<WatchItem>>` | SwiftData, `@Query` | drift, `watch()` streams |
| Who updates the star elsewhere | the Flow | the query | the query: every screen observes `watch_items` |
| Detail pipeline | `combine(quote, history, isWatched, currency)` | `CombineLatest4` | `combineLatest6` (+ the high, + the range), per-coin `distinct` |
| Chart data | ticks while the detail is open | the same | `PriceHistory` from launch (last 60) + a running high |
| All-time high | the seed's | the seed's | the seed's, raised by any price seen (Correctness Rule 9) |
| Market cap | the seed's | the seed's | circulating × the live price |
| Chart | Canvas | Swift Charts | `CustomPainter`, with a text summary |
| Remove + Undo | swipe + Snackbar | swipe action + undo | `Dismissible.confirmDismiss` + an 8 s Undo bar |
| Detail ViewModel's argument | `SavedStateHandle` | init parameter | injectable `@factoryParam` |
| Schema evolution | Room auto-migrations | SwiftData versioned schemas | `make-migrations`, exported JSON, `SchemaVerifier` tests |

---

## Interview Notes

- **"How does a star on one screen update another?"**
  - Nobody tells the other screen. The star is a write; each screen observes a query, and drift re-runs it after the write.
  - The database is the single source of truth, the same idea as Room's `Flow` or SwiftData's `@Query`.
- **"Why `confirmDismiss` and not just `onDismissed`?"**
  - A dismissed `Dismissible` must leave the tree at once, but the row leaves the list only when the query answers.
  - Waiting for the write lets a failure slide the row back. Only a removal that succeeded is dismissed, and it stays hidden until the query drops it.
- **"How do you keep a detail page from rebuilding on every tick of every coin?"**
  - Narrow before combining: `map` to this coin's quote, then `distinct`.
  - `combineLatest` only re-derives when one of *its* inputs changes.
- **"How do you pass an argument to something your DI creates?"**
  - injectable's `@factoryParam`: the id travels with the request (`param1`), and the rest is injected.
- **"A Cubit closed while it awaited data, then emitted. Why, and how do you stop it?"**
  - `isClosed` becomes true only when `close()` finishes, after its awaits; the awaited data landed in between and subscribed.
  - A flag set first thing in `close()` closes that window, and a test closes each Cubit mid-load.
- **"How do you test drift?"**
  - In memory, with `closeStreamsSynchronously`; query streams with `StreamQueue`;
  - in widget tests, the database's work runs on the real event loop (`runAsync`);
  - the exported schema checked by `SchemaVerifier`, so the next migration starts from what users have.

---

## Learning Checklist

- ✅ drift: a table with a `CHECK`, a DAO, live queries, a transaction returning a value, insert modes
- ✅ The database as the single source of truth: write, then observe
- ✅ Schema export and a schema test (ready for the v1 → v2 migration)
- ✅ `combineLatest3` / `combineLatest6`, narrowing with `map` + `distinct` before combining
- ✅ A running maximum with `scan`
- ✅ `@factoryParam` Cubits; a close-while-loading guard
- ✅ `confirmDismiss` + Undo
- ✅ A `CustomPainter` chart with a text summary; "Collecting prices…" under two points
- ✅ Large text: `FittedBox(scaleDown)` for numbers, stacked segments and tiles
- □ The portfolio: holdings in drift v2, the migration with data, live valuation, the donut (Phase 5)

---

## Future Improvements

- The Live chart keeps the last 60 updates (about a minute at 1 s). A longer window would only change `priceHistoryCapacity`. A time axis would need labels the native editions don't have either.
- The 7-day chart is the seed's 24 points; it doesn't move with the live price. A real API would refresh it.
- Reordering the watchlist (drag and drop) would add a `position` column: a v2 change with its own migration.
- The chart has no touch scrubbing; a `GestureDetector` over the painter could show the price at a point.

---

## Notes on This Phase

- **The simulator caught four things the tests didn't** (iPhone 17 Pro, light, dark, AX3):
  - **The star cost the sparkline:** a row with a star is about 338 points wide, just under the 340 cut-off, so every sparkline vanished. The cut-off is now 320, with a test of a phone-width row with its star.
  - **An Undo bar of 4 s was too short** to read and reach. Bars with an action stay 8 s (still dismissing themselves; with accessible navigation on, Flutter keeps them).
  - **At AX3 the header price wrapped mid-number** ("$68,322.2 / 1"). It now shrinks to fit on one line; Live | 7 days stack; a test at 310 % checks both.
  - That test then found **`PriceChangeBadge` overflowing** by 24 px at 310 % in the header. The badge now scales down rather than overflow anywhere.
- **Two bugs found by writing tests:**
  - **Closing while loading:** a Cubit closed while its seed was on its way could subscribe after `close()` had cancelled, and later emit into a closed Cubit. This was in Phase 3's `MarketCubit` too. All three Cubits now set a flag first in `close()`.
  - **A failed swipe** brought back a `Dismissible` that had already been dismissed (an assertion). `confirmDismiss` now waits for the write, so a dismissed row never returns.
- **Traps recorded in the conventions:**
  - **§11.123:** a singleton created inside `runAsync` (here the eager `PriceHistory`, built when a test configures the app) listens in the root zone. Its callbacks run as real microtasks that fake-time pumps never flush, so the ticks came but the chart stayed at one point. Tests give the real loop a turn.
  - **§11.124:** SQLite's `INSERT OR IGNORE` also ignores `CHECK` failures, so an invalid row is silently skipped, not refused.
  - **§11.125:** a DAO method named like its table (`watchItems()`) shadows the generated table getter.
- **Seen on the simulator:**
  - stars filled at once on the Market and stayed after a relaunch;
  - the Watchlist kept the starred order; a swipe removed Bitcoin with the bar, and Undo put it back in its place;
  - Bitcoin's page showed a full Live chart (60 updates since launch) with its high and low, and the 7 days;
  - the market cap moved with the price;
  - dark and AX3 read well after the fixes.
- **Builds:** the Android debug APK and the iOS simulator app.
- **Mutation checks:**
  - 57 rules broken on purpose, one at a time, each against the **whole suite**;
  - **52 caught on the first pass.** Of the other five:
    - *Undo after the coin was starred again* (the restore not ignoring an existing row): a new DAO test, where Undo keeps the newer star without an error.
    - *An Undo that fails, silently* and *the Undo bar as short as a message*: a new view test checks both, the 8 s bar and the message.
    - *No CHECK on the id* wasn't a real mutation: the constraint lives in generated code, and the script doesn't re-run codegen. Run by hand with codegen, the DAO's CHECK test catches it. drift's schema validator doesn't compare CHECKs, so the schema test doesn't.
    - *A swiped row always hidden* was **equivalent**: `onDismissed` only fires for a row still in the tree, so still listed. The guard was dead code and is gone; its test stays as a description of the behaviour.
  - **One mutation timed out instead of failing:** *the market ignoring the stars* made a `StreamQueue` test wait for a listing that never came. Its `tearDown` then waited on that pending request, so the run hung. Every stream test's `tearDown` now cancels with `immediate: true`, and the mutation fails in seconds.

| Area | Mutations | Notes |
|---|---:|---|
| Table and DAO | 6 | the CHECK (with codegen); ties by id; a second star keeps the first time; Undo over a newer star; `watchContains`; `remove` returns the row |
| Repository and writes | 5 | toggle unstars; UTC times from the clock; the removed coin's own time; failures as a result; bugs rethrown |
| Highs and history | 4 | identity when nothing rose; never lowered; `distinct`; recorded at all |
| `CoinDetail` and the chart summary | 6 | live market cap; the ATH from what was seen and from the price; 7 days from the seed; two points for a trend; the update count |
| Pipelines | 11 | starred order; rows starred; `priceDisplay` `distinct`; per-coin `distinct`; the rate, star, pause, range and high in the page; the watchlist's rate; the market's stars |
| Cubits | 6 | not found; the close race in all three; the range wired; `close` cancels |
| Views | 11 | the market star (wired, failure said, filled); hidden rows (equivalent, removed); forgotten when dropped; a failed swipe slides back; Undo wired; Undo failure said; one-line price; stacked ranges; "Unlimited" |
| Design system | 8 | the Undo bar's 8 s; the badge never overflows; the chart repaints and is summarised; the sparkline's cut-off; the star's words and shape; a stat read as one |
