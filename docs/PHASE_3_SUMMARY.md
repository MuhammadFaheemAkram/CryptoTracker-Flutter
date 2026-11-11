# Phase 3 — Live Prices with Dart Streams (the showcase)

## Phase Goal

Make the market move, and make every moving part a stream pipeline:
- **one source of live truth:** a `PriceTicker` (`BehaviorSubject`) that ticks on an interval from the seed's prices;
- **the market derived from five inputs** (`combineLatest5`): the ticks, the settled search, the sort, the settings and the watchlist;
- **a debounced search** that clears at once (`switchMap` + a timer);
- **flashes** from comparing each tick with the last (`scan`);
- **a price history** recorded from launch, in a bounded buffer (`scan`);
- **settings** stored on the device, and a ticker that follows them and the app's lifecycle (`switchMap`);
- **Pause / Resume** in the Market (auto-updating content must be pausable).

`buildMarketRows` from Phase 2 didn't change its job: it still derives the list. Only where its inputs come from changed.

Every pipeline is drawn and explained in **[STREAM_PIPELINES.md](STREAM_PIPELINES.md)**.

---

## What Was Implemented

- **The price engine** (`core/prices/`):
  - `RandomWalk`:
    - a step of up to ±1.5 % (stablecoins ±0.05 %);
    - a 2 % pull back towards the starting price (mean-reverting, so long sessions stay plausible);
    - a floor;
    - injected `Random`.
  - `PriceTicker`:
    - a `BehaviorSubject` of every quote;
    - `seed` once, `start` / `stop` / restart with one timer and no jump;
    - unmodifiable snapshots;
    - the price 24 h ago never moves.
  - `PriceHistory`: an eager singleton that `scan`s the ticks into the last 60 points per coin; `watch(coinId)`.
  - `TickerScheduler`: foreground → `switchMap` → the settings' interval, or nothing if paused or in the background → `distinct` → `start` / `stop`.
- **Pure pipeline pieces** (`domain/pipeline/`):
  - `directionsBetween`, `appendSnapshot`;
  - `settled()` (trim → `switchMap` to a `TimerStream`, an empty query at once → `distinct`);
  - `buildMarketRows` gains directions and the watched set.
- **Use cases:** `ObservePriceMovesUseCase` (`scan` → `PriceSnapshot`: quotes and directions together), `ObserveMarketUseCase` (`combineLatest5` → `MarketListing`), `ObserveSettingsUseCase`, `SetLivePricesPausedUseCase`.
- **Settings:**
  - `AppSettings` (currency, interval, `livePricesPaused`, theme mode), `TickInterval` (1 s, 2 s, 5 s), `AppThemeMode`;
  - `SettingsLocalDataSource` over `SharedPreferencesWithCache`, opened before `runApp` with `@preResolve`: unknown values fall back to defaults, and only changed keys are written;
  - `SettingsRepositoryImpl`: a `BehaviorSubject`, applied in memory then stored.
- **App:** `LiveTicker` (an `AppLifecycleListener`: `onHide` stops, `onShow` resumes) around `MaterialApp.router`; `main` awaits the DI root.
- **Market:**
  - `MarketCubit`: query and sort subjects, one subscription, `setPaused`, closes cleanly;
  - `MarketView`:
    - prices in the listing's currency at its rate;
    - **Pause / Resume** in the app bar, and a `PausedChip`;
    - the header scrolls with the list (one `CustomScrollView`).
- **`CoinRow`:** a **flash** (`Ink` tint, 600 ms fade, only on a new tick, not with reduced motion) and a **price cross-fade** (`AnimatedSwitcher`).
- **Packages:** `rxdart`, `shared_preferences`, `meta`; dev: `async` (`StreamQueue`), `shared_preferences_platform_interface`.
- **356 tests.**

---

## Stream Concepts Demonstrated

| Operator / idea | Where | Why |
|---|---|---|
| `BehaviorSubject` / `ValueStream` | ticker, settings, Cubit inputs | a current value for late listeners (`StateFlow`, `CurrentValueSubject`) |
| Hot stream | the ticker | ticks whether or not anyone listens; listeners share it |
| `Timer.periodic` + cancel | `PriceTicker.start` / `stop` | one timer, restarted without a jump |
| `scan` | price moves, price history | a fold that emits each step: remembering the last snapshot, or the last 60 |
| `switchMap` + `TimerStream` | the search | a debounce that cancels, and lets an empty query through at once |
| `distinct` | query, sort, settings, scheduler | a repeat (or an unrelated change) derives nothing |
| `combineLatest5` | the market | recompute from the latest of every input; not `zip` |
| `switchMap` on a `bool` | the scheduler | while in the background, don't listen to the settings at all |
| `whereType` | price moves | drop the `scan`'s empty seed |
| Glitch-free derivation | `PriceSnapshot` | quotes and directions in one value, one emission per tick |
| Subscribe / cancel in a Cubit | `MarketCubit` | the bridge to state; nothing emitted after close |
| `StreamQueue` | tests | Turbine's `awaitItem()` in Dart |

---

## Flutter / Dart Concepts Demonstrated

- **`@preResolve`:** injectable awaits `SharedPreferencesWithCache.create` while the DI root is built, so `main` awaits `configureDependencies()` and the settings are synchronous from the first frame.
- **`AppLifecycleListener`:** `onHide` / `onShow` for "left the screen" and "came back", rather than raw lifecycle states. A brief `inactive` keeps prices moving.
- **`Ink` for a background that animates under a ripple:** the tap's splash paints on the same `Material`, over the tint.
- **`AnimatedSwitcher`** with a `layoutBuilder` that keeps both prices aligned while they cross-fade.
- **`MediaQuery.disableAnimationsOf`:** reduced motion turns off the flash and the cross-fade.
- **`CustomScrollView` with slivers:** the search field and the summary scroll with the list. At 300 % text a fixed header plus the Paused chip overflowed (the tour caught it).
- **`Wrap`** for a summary and a chip that share a line only while they fit.
- **`@ignoreParam`** for a test-only knob on an injectable class (the Cubit's debounce).
- **`@disposeMethod`:** the ticker, the history and the scheduler close their timers and subjects on `getIt.reset()`. It can't be used on a class registered under an interface without a `dispose` (the settings), so that one lives as long as the app.
- **`flutter_test_config.dart`:** every test starts with in-memory preferences.

---

## Data Flow

```
launch: main → await configureDependencies() (preferences open) → runApp
        LiveTicker → TickerScheduler.attach(): foreground ∧ settings → PriceTicker.start(2 s)
Market: MarketCubit.load() → LoadMarketUseCase → MarketRepository.loadMarket() → ticker.seed(seed)
        → ObserveMarketUseCase(seed, query: _query, sort: _sort)
            combineLatest5( moves(scan over ticker.quotes), query.settled(300 ms), sort.distinct(),
                            settings.(currency, paused).distinct(), watched{} )
            → buildMarketRows → MarketListing → emit(ready) → MarketView → CoinRow (flash on a new tick)
tick:   PriceTicker.tick() → quotes → scan → snapshot → combineLatest → one listing → one state
type:   queryChanged → _query → trim → switchMap(timer) → (300 ms) → distinct → combineLatest → listing
pause:  Pause → SetLivePricesPausedUseCase → settings → scheduler → ticker.stop(); listing.isPaused → chip
hide:   AppLifecycleListener.onHide → scheduler → stop; onShow → settings again → start(interval)
```

---

## Important Files Added

| File | Purpose |
|---|---|
| `lib/core/prices/price_ticker.dart` | The live market: a hot `BehaviorSubject` |
| `lib/core/prices/random_walk.dart` | How a price moves |
| `lib/core/prices/price_history.dart` | The last 60 points per coin, from launch |
| `lib/core/prices/ticker_scheduler.dart` | When the ticker runs, and how fast |
| `lib/domain/pipeline/price_directions.dart`, `price_history.dart`, `settled_query.dart` | Pure pieces of the pipelines |
| `lib/domain/usecase/observe_price_moves_use_case.dart`, `observe_market_use_case.dart` | The pipelines |
| `lib/domain/model/price_snapshot.dart`, `market_listing.dart`, `app_settings.dart`, `tick_interval.dart`, `price_point.dart` | Models |
| `lib/core/storage/settings_local_data_source.dart`, `lib/data/repository/settings_repository_impl.dart` | Settings |
| `lib/app/live_ticker.dart` | The app's lifecycle → the scheduler |
| `lib/core/design_system/widgets/paused_chip.dart` | "Paused" |
| `docs/STREAM_PIPELINES.md` | Every pipeline, explained |
| `test/flutter_test_config.dart` | In-memory preferences for every test |

---

## Important Types Added

| Type | Responsibility | Layer |
|---|---|---|
| `PriceTicker` | The one source of live prices | core/prices |
| `RandomWalk` | One step of a simulated price | core/prices |
| `PriceHistory` | Recent prices per coin | core/prices |
| `TickerScheduler` | Start / stop / restart from the settings and the lifecycle | core/prices |
| `PriceSnapshot` | One tick: quotes + directions | domain |
| `MarketListing` | The market pipeline's output | domain |
| `AppSettings`, `TickInterval`, `AppThemeMode` | Preferences | domain |
| `ObservePriceMovesUseCase`, `ObserveMarketUseCase` | The pipelines | domain |
| `SettingsRepository` / `SettingsRepositoryImpl`, `SettingsLocalDataSource` | Settings, stored | domain / data / core |
| `LiveTicker` | Lifecycle → scheduler | app |

---

## Folder Structure Changes

```
lib/app/                + live_ticker.dart
lib/core/prices/        + price_ticker, random_walk, price_history, ticker_scheduler      (new)
lib/core/storage/       + settings_local_data_source                                     (new)
lib/core/design_system/ + widgets/paused_chip.dart
lib/data/repository/    + settings_repository_impl
lib/domain/model/       + price_snapshot, price_point, market_listing, app_settings, tick_interval, app_theme_mode
lib/domain/pipeline/    + price_directions, price_history, settled_query
lib/domain/usecase/     + observe_price_moves, observe_market, settings_use_cases
docs/                   + STREAM_PIPELINES.md
test/                   + flutter_test_config.dart, core/prices/, core/storage/, domain/usecase/
```

---

## Android / iOS Comparison

| Concept | Android (Flow) | iOS (Combine) | Flutter (Dart streams + rxdart) |
|---|---|---|---|
| Live source | `MutableStateFlow` + `while(isActive) delay` | `CurrentValueSubject` + `Timer.publish` | `BehaviorSubject` + `Timer.periodic` |
| The 24 h change | `change + drift × 100` per tick | the same | **derived** from `open24h` |
| Market derivation | `combine(quotes, debounced query, sort, currency)` | `CombineLatest4` | `Rx.combineLatest5` (+ the watchlist), one snapshot per tick |
| Debounce | `debounce(300).distinctUntilChanged()` | `.debounce(for:)` + `removeDuplicates` | `switchMap` + `TimerStream` (empty at once) + `distinct` |
| Direction | `scan` / `runningFold` | `scan` | `scan` into a `PriceSnapshot` (no glitch) |
| Chart data | ticks while the detail is open | the same | `PriceHistory` from launch (last 60) |
| Lifecycle | `SharingStarted.WhileSubscribed`, lifecycle-aware collection | app lifecycle | `AppLifecycleListener` → `TickerScheduler` (`switchMap`) |
| Paused | an interval option | an interval option | **a separate setting** + Pause / Resume in the Market (WCAG 2.2.2) |
| Settings | DataStore | `@AppStorage` | `SharedPreferencesWithCache` (`@preResolve`) |
| Stream tests | Turbine + `runTest` | collected values | `StreamQueue`, `fakeAsync`, real time where rxdart needs it |

---

## Interview Notes

- **"Why a `BehaviorSubject` for prices?"**
  - A screen that starts listening late must see the current prices at once.
  - A `BehaviorSubject` replays its latest value and has a synchronous `.value`, like `StateFlow`. A broadcast stream would leave it blank until the next tick.
- **"`combineLatest` or `zip`?"**
  - `zip` pairs the n-th values: the 3rd tick with the 3rd keystroke.
  - A derived list needs the *latest* of everything whenever anything changes: `combineLatest`.
- **"What's a glitch in reactive programming?"**
  - Two streams derived from one source, recombined, arrive one after the other, so one emission mixes new and old (new prices, old directions).
  - Fix it by deriving both in one step (one `scan` into one value).
- **"How do you debounce search but clear instantly?"**
  - `switchMap` each query to a timer, or to `Stream.value("")` for an empty one.
  - The switch cancels the pending timer, so a cleared field never shows an old search.
- **"How do you stop work in the background?"**
  - A stream of "foreground" `switchMap`ped to either the settings' interval or nothing, then `distinct`, then start / stop.
  - `AppLifecycleListener.onHide` / `onShow` feed it.
- **"How do you test streams?"**
  - Pure functions for the logic; `StreamQueue` for the order of emissions; `fakeAsync` for time.
  - Know its limits: a `cancel()` future from a broadcast stream completes in the root zone, and rxdart's `switchMap` waits for it, so those cases run in real time.

---

## Learning Checklist

- ✅ A hot `BehaviorSubject` ticker: seed once, start / stop / restart, one timer, no jump
- ✅ `scan` for directions and for a bounded history; glitch-free snapshots
- ✅ A `switchMap` debounce with an instant clear; `distinct`
- ✅ `combineLatest5` with narrowed, distinct inputs
- ✅ A scheduler pipeline with a side effect; `AppLifecycleListener`
- ✅ Settings in `SharedPreferencesWithCache`, before the first frame
- ✅ Flashes on new ticks only; reduced motion respected; Pause / Resume (WCAG 2.2.2)
- ✅ `StreamQueue`, `fakeAsync`, and when to test in real time instead
- □ The watchlist (drift streams) and a coin's live page with its chart (Phase 4)

---

## Future Improvements

- The Settings screen (currency, interval, appearance) arrives in Phase 6. Until then the currency is stored but has no control; Pause is in the Market.
- The walk is the native editions' ±1.5 % per tick: lively, even jumpy at 1 s (BTC can move a few percent in a minute). A gentler step would be one constant.
- A real feed (a WebSocket) would replace `PriceTicker`'s timer behind the same `quotes` stream; nothing above it would change.

---

## Notes on This Phase

- **Two fake-time traps,** recorded as conventions §11.122:
  1. **Create streams and timers inside `fakeAsync`.** The Cubit's debounce test built its fakes in `setUp`, outside the fake zone, and the timer never fired on the fake clock.
  2. **A broadcast stream's `cancel()` future completes in the root zone.** rxdart's `switchMap` pauses and waits for the old inner stream's cancel before listening to the next, so in fake time:
     - typing that replaces a pending query stalls;
     - so does the scheduler switching to the background;
     - a Cubit's `close()` (which awaits a cancel) never completes.

     It was confirmed by reading `SwitchMapStreamSink.onData` and by probes. The app is fine; those tests run in real time, and widget tests alternate `runAsync` with `pump`.
- **The tour caught a layout bug:** at 300 % text the Paused chip squeezed the summary into many lines, and the fixed header overflowed. The header now scrolls with the list, and the chip wraps.
- **A design decision:**
  - the native specs list "paused" as a fourth interval; here it's a switch of its own, so Resume returns to the chosen interval;
  - the Market has the button because auto-updating content must be pausable where it's shown (WCAG 2.2.2).
- **Seen on the simulator** (iPhone 17 Pro, light and dark):
  - the market ticks and rows flash and fade;
  - stablecoins move only in the fourth decimal;
  - Pause froze every price for five seconds, with the chip;
  - after going to the home screen and back, the first frame showed the prices from before (nothing ticked in the background), and the next ones moved again.
- **Builds:** the Android debug APK and the iOS simulator app.
- **Mutation checks:**
  - 44 rules broken on purpose, one at a time, each against the **whole suite**;
  - **40 caught on the first pass; the other 4 now are**, by four new checks:
    - *The history not `distinct`:* nothing checked that a tick which adds no point (the same instant) reaches no listener. A test now ticks twice at one instant.
    - *Rows never flashing* (no `tick` passed) and *rows flashing without a direction*: the view test never checked what each `CoinRow` receives. A test now checks Bitcoin's direction and tick after a move, and Ethereum's flat.
    - *Every settings key written:* the test changed the currency, which the mutation writes anyway. A second test changes only the pause, and finds only that key stored.

| Area | Mutations | Notes |
|---|---:|---|
| Random walk and ticker | 10 | the stablecoin step; the pull; the floor; a restart with one timer; no ticks before the seed; seeded once; the open never moves; stablecoins flagged; read-only snapshots; the clock's time |
| Price history | 3 | the cap of 60; a duplicate instant skipped; `distinct` |
| Directions | 3 | the first snapshot flat; up vs down; an unchanged price flat |
| The search | 3 | trimmed; an empty query at once; a repeat dropped |
| The market pipeline | 6 | sort and settings `distinct`; the rate; the pause; directions and the watchlist passed on |
| Scheduler and lifecycle | 4 | the background; the pause; restarts only on a new period; `onHide` wired |
| Flash and cross-fade | 4 | only on a new tick; not with reduced motion; the right tint; no cross-fade with reduced motion |
| Cubit | 2 | the debounce passed on; `close` cancels |
| Market view | 5 | Pause / Resume; the chip; prices converted; each row's tick and direction |
| Settings | 4 | only changed keys written; unknown values defaulted; applied before stored; the same settings not emitted |
