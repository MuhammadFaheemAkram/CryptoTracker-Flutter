# Architecture

CryptoTracker is a small app with one big idea: **every price on every screen comes out of a stream pipeline that starts at one ticker.** The architecture exists to keep that true as the app grows.

This document is the map. [STREAM_PIPELINES.md](STREAM_PIPELINES.md) draws each pipeline; [DATA_MODEL.md](DATA_MODEL.md) describes what flows through them.

---

## The one rule

```
One PriceTicker owns the live quotes: a stream that always has a current value.
Every price on every screen is DERIVED from it, by a stream pipeline.
No screen keeps its own copy of a price, and no list is patched by hand.
```

Three consequences shape the code:
- **Lists are recomputed, never edited.** A tick, a keystroke, a star, a holding saved or a currency change is a new value of some input; the pipeline re-derives the whole list from the latest of every input.
- **The pure part is a function.** Each pipeline's combiner calls a plain function (`buildMarketRows`, `buildWatchlistRows`, `valuePortfolio`), tested without any stream.
- **Writes and reads go different ways.** A screen *writes* through a use case (star, add a holding, change a setting) and never updates itself: it *reads* the change back through its pipeline, from the table or the settings it observes.

---

## Layers

```
Widget (View)            renders a state with an exhaustive switch; calls the Cubit's intents
   ▲ state                    │ intents (search, sort, star, save, a setting)
Cubit                    owns its screen's inputs (seeded subjects) and ONE subscription
   ▲ Stream<…>                │
Use case                 builds a pipeline (combineLatest, scan, switchMap, distinct)
   ▲                          │  and calls the pure functions in domain/pipeline
Repository (contract)    domain/repository: Futures for one-off answers, Streams for live ones
   ▲                          │
Data / core              PriceTicker · PriceHistory (core/prices)
                         FakeMarketApi + checked DTOs (core/network)
                         drift: watch_items, holdings (core/database)
                         SharedPreferencesWithCache (core/storage)
```

| Layer | Folder | May import | Never imports |
|---|---|---|---|
| App | `lib/app/` | everything | — |
| Features (screens) | `lib/features/<feature>/` | domain, design system, formatting, navigation | `data/`, `core/network`, `core/database` |
| Design system | `lib/core/design_system/` | formatting, domain models | features, routes |
| Formatting | `lib/core/formatting/` | domain models | Flutter, `material_ui` |
| Domain | `lib/domain/` | Dart, rxdart, freezed, injectable | Flutter, Bloc, get_it, JSON |
| Data | `lib/data/` | domain, core | features |
| Core services | `lib/core/prices`, `network`, `database`, `storage` | domain | features |
| DI | `lib/di/` | everything (the composition root) | — |

`test/architecture/architecture_test.dart` enforces the rules the analyzer can't: these imports, `getIt` only in `main.dart`, `app/`, `di/` and Pages, **only `PriceTicker` runs a periodic timer**, and only `core/prices` makes up prices.

---

## The pieces

### The price engine (`core/prices/`)
- **`PriceTicker`:** a hot `BehaviorSubject<Map<String, Quote>>`.
  - It's seeded once from the market's seed.
  - `start(interval)` cancels any timer before starting one, so a restart has no jump and no second timer.
  - Each tick moves every quote one `RandomWalk` step, stamped with the injected `Clock`.
- **`RandomWalk`:** up to ±1.5 % a step (stablecoins ±0.05 %), pulled 2 % back towards the starting price, with a floor. It takes an injected `Random`, so every test is reproducible.
- **`PriceHistory`:** an eager singleton with two `scan`s over the ticker: the last 60 points per coin (the Live chart), and the highest price per coin (the all-time high), from launch.
- **`TickerScheduler` + `LiveTicker`:** the app's lifecycle (`AppLifecycleListener`) and the settings decide whether the ticker runs, and at what interval. `switchMap` on "foreground", then `distinct`, then start or stop.

### Repositories (`data/`, contracts in `domain/repository/`)
- **`MarketRepository`:**
  - `loadMarket()` (a `Future`: the seed, loaded once, a load in flight shared, retried after a failure);
  - `quotes`, `history(id)`, `highestPrice(id)` (streams).
- **`WatchlistRepository`** and **`PortfolioRepository`:** live queries out (`watchIds`, `watchHoldings`), writes in (`toggle`, `remove`, `restore`, `add`, `update`). Every write goes through `guardWrite`: an `Exception` becomes "Couldn't save that change", an `Error` (a bug) is rethrown.
- **`SettingsRepository`:** `current` (synchronous: the preferences open before `runApp`), `watch()`, `update`.

### Use cases (`domain/usecase/`)
One class per action or pipeline:
- `ObserveMarketUseCase` (`combineLatest5`);
- `ObservePriceMovesUseCase` (`scan` → one snapshot of quotes and directions per tick);
- `ObserveWatchlistRowsUseCase` (`combineLatest3`), `ObserveCoinDetailUseCase` (`combineLatest6`), `ObservePortfolioUseCase` (`combineLatest3`);
- `ObserveCoinPriceUseCase` (one coin, `distinct`);
- the writes (Toggle, Remove, Restore; Add, Update, Remove, Restore a holding; the four settings).

### Cubits (`features/*/cubit/`)
- One per screen. A Cubit owns only its screen's **inputs** (the Market's query and sort, the coin page's chart range, the form's chosen coin: seeded `BehaviorSubject`s) and **one subscription** to its pipeline, emitting every value as a state.
- It never computes a row and never keeps a price.
- `close()` sets a `_closing` flag first, then cancels: a seed that lands during `close()`'s awaits must not subscribe (found by a test in Phase 4).
- **`SettingsCubit`** is app-wide (a lazy singleton above the router). It starts from the stored settings, so the first frame has the theme.

### Screens (`features/`)
Each feature has a **Page** (creates or finds the Cubit, maps the view's callbacks to typed routes) and a **View** (renders the state; widget tests pump it with a `MockCubit`).

| Feature | Cubit | Pipeline |
|---|---|---|
| Market | `MarketCubit` | `combineLatest5`: snapshots, settled query, sort, price display, watched ids |
| Watchlist | `WatchlistCubit` | `combineLatest3`: snapshots, watched ids, price display |
| Coin detail | `CoinDetailCubit(@factoryParam coinId)` | `combineLatest6`: this coin's move, history, high, starred, price display, range |
| Portfolio | `PortfolioCubit` | `combineLatest3`: snapshots, holdings, price display |
| Holding form | `HoldingFormCubit(@factoryParam coinId, holdingId)` | the chosen coin `switchMap`ped to its price |
| Settings | `SettingsCubit` (app-wide) | the settings, as stored |

### Navigation (`core/navigation/`)
- Typed routes (`go_router_builder`). A `StatefulShellRoute` holds the four tabs, each keeping its state.
- A coin (`/coins/:coinId`) and the holding form (`/holdings/new?coin-id=`, `/holdings/:holdingId/edit`) are root-level, above the tabs: reachable from several tabs, and full-screen dialogs for the form.
- Screens opened by a link get a Close button to where they normally open from.

### Dependency injection (`di/`)
- `get_it` + `injectable`.
- `@preResolve` opens the preferences and reads the app's version before `runApp`.
- One `AppDatabase` (several connections would break drift's change notifications).
- `@factoryParam` for the per-coin and per-holding Cubits.
- Tests swap the edges: drift in memory, preferences in memory, a fixed clock and a seeded random.

---

## Data flow, end to end

```
launch
  main: await configureDependencies()       preferences opened, app info read
  CryptoTrackerApp: SettingsCubit (theme), LiveTicker (lifecycle), the router
  Market tab: MarketCubit.load() → LoadMarketUseCase → MarketRepository.loadMarket()
    FakeMarketApi (bundled JSON, 600 ms) → checked DTOs → mappers → MarketSeed
    → PriceTicker.seed(quotes)  → TickerScheduler starts the timer (every 2 s)

each tick
  PriceTicker ──▶ scan (directions) ──▶ combineLatest5 / 3 / 6 / 3 ──▶ pure functions ──▶ Cubits ──▶ views
             └──▶ PriceHistory (points, highs)

a star
  View → Cubit.toggleWatch → ToggleWatchUseCase → WatchlistRepository → drift (INSERT)
  drift re-runs every watch_items query → the Market row, the coin page and the Watchlist each re-derive

Settings → Euro
  SettingsCubit → UpdateCurrencyUseCase → SettingsRepository (memory, then disk)
  settings.watch() → priceDisplay() (distinct) → every pipeline re-derives with the new rate
```

---

## Decisions worth knowing

| Decision | Why |
|---|---|
| `BehaviorSubject` for the quotes | A screen opened late must see prices now, not at the next tick (up to 5 s) |
| One `scan` for quotes **and** directions | Two derived streams recombined would glitch: new prices with old directions |
| `switchMap` + `TimerStream` for the search, not `debounceTime` | An empty query must pass at once and cancel a pending one |
| Cubits, not Blocs | The interesting logic is in the streams; events would only wrap them |
| Money in US dollars below the UI | A currency is a rate applied at the edges; a currency change re-uses the same values |
| Shares in basis points | Rounded floats don't add up to 100 %; integers with the remainder on the largest slice do |
| drift as the single source of truth for stars and holdings | A write anywhere reaches every screen through its own query |
| Paused is its own setting, not an interval | Resuming returns to the chosen interval; content that moves must be pausable where it's shown (WCAG 2.2.2) |
| No network permission, no network code | The market is simulated; nothing leaves the device |
