# Stream pipelines

How CryptoTracker uses Dart streams: every pipeline in the app, drawn as a marble diagram, with the operators it uses and why each one is there.

This is the Flutter counterpart of the Android edition's `FLOW_PIPELINES.md` (Kotlin Flow) and the iOS edition's `COMBINE_PIPELINES.md` (Combine). The [operator table](#flow--combine--dart) at the end maps the three.

> **Final (Phase 6):** the ticker, price moves, the search, the market, the price history and highs, the settings driving the ticker, the watchlist (a drift query as a stream), a coin's page, the portfolio's live valuation, the holding form's price, and **the settings feeding every pipeline**.

---

## The one rule

```
One PriceTicker owns the live quotes: a stream that always has a current value.
Every price on every screen is DERIVED from it, by a stream pipeline.
No screen keeps its own copy of a price, and no list is patched by hand.
```

**`Future` or `Stream`?**
- A `Future` is one answer: the seed is loaded once (`MarketRepository.loadMarket()`).
- A `Stream` is a value over time: the prices, the settings, what the user types. Everything that changes while you look at it is a stream; everything that doesn't is a `Future`.

---

## Vocabulary

| Term | Meaning | Here |
|---|---|---|
| **Single-subscription** stream | One listener, ever. Usually *cold*: the work starts when you listen | `TimerStream`, a `StreamController()` |
| **Broadcast** stream | Any number of listeners; a listener sees only what's emitted after it joins | `StreamController.broadcast()` |
| **Hot** stream | Produces whether or not anyone listens; listeners share it | the ticker |
| **Cold** stream | Starts per listener, when it listens | `Stream.value`, `TimerStream`, each use-case pipeline |
| **`BehaviorSubject`** (rxdart) | A broadcast stream that **remembers its latest value**: a new listener gets it at once, and `.value` reads it synchronously | the ticker, the settings, the Cubit's query and sort |
| **`ValueStream`** | The read-only view of a `BehaviorSubject` | `PriceTicker.quotes` |
| **Query stream** (drift) | A database query's `watch()`: the current result at once, then again after every write to its tables | the watchlist |

**Why a `BehaviorSubject` for the market:**
- A screen that opens a minute into the session (the Watchlist, a coin's page) must see the prices *now*.
- A plain broadcast stream would leave it with nothing until the next tick, up to five seconds.
- The `BehaviorSubject` replays the latest snapshot to each new listener. That makes it Kotlin's `StateFlow` and Combine's `CurrentValueSubject`.

**Reading the diagrams:**
- `──a──b──▶` is a stream over time: `a`, then `b`;
- `|` is the stream ending;
- one row per stream, with time running left to right on the same scale.

---

## 1. The ticker: a hot `BehaviorSubject`

`core/prices/price_ticker.dart`

```
seed(Q0)   start(2 s)         tick        tick        stop()   start(1 s)    tick
   │          │                 │           │           │         │           │
quotes: ──Q0──────────────────Q1──────────Q2───────────────────────────────Q3──▶
          ▲ a new listener here gets Q0 at once; one joining after Q2 gets Q2
```

- **`seed(MarketSeed)`:** the seed's quotes become the first snapshot, once. A second seed is ignored: only a new launch starts the market again.
- **`start(interval)`:** cancels any timer, then `Timer.periodic(interval, tick)`. A restart (a new interval) is one timer and **no jump**: it carries on from the current prices.
- **`tick()`:**
  - every quote moves one step of the `RandomWalk` (±1.5 %, stablecoins ±0.05 %, pulled 2 % back towards the start), stamped with the injected `Clock`;
  - **`open24hUsd` never changes**, so the 24 h change is always `(price / open − 1) × 100`;
  - every snapshot is an unmodifiable map.
- **Hot:** it ticks whether anyone listens or not. That's how the price history records from launch.

Its **lifetime** is decided by a small pipeline of its own, [§6](#6-settings--the-ticker-switchmap).

---

## 2. Price moves: `scan`

`domain/usecase/observe_price_moves_use_case.dart` + `domain/pipeline/price_directions.dart`

```
quotes:     ──Q0────────Q1────────Q2────────▶
scan:       ──(Q0, {})──(Q1, Δ01)──(Q2, Δ12)──▶      Δ = directionsBetween(previous, next)
```

- **A direction compares two snapshots,** so the stream has to *remember* the previous one. `scan` is a fold that emits each step: its accumulator is the last `PriceSnapshot`, and each new set of quotes becomes the next one.
- **The first snapshot has nothing to compare with:** nothing moved, all flat.
- **Why not `pairwise()`?** It waits for two values before emitting anything, so the market would be blank until the second tick.
- **Why quotes and directions travel together:**
  - two streams derived from the same ticker and recombined with `combineLatest` would arrive **one after the other**, the classic *glitch*:

    ```
    quotes:       ──Q1──────────▶
    directions:   ────D1────────▶      (derived from quotes, one step later)
    combineLatest ──(Q1,D0)─(Q1,D1)─▶  ✗ every tick emits twice, once with stale directions
    ```
  - one `scan` makes one snapshot per tick, and a test checks there's exactly one state per tick.

---

## 3. The search: `switchMap` + a timer

`domain/pipeline/settled_query.dart`

```
typed:     ──"s"──"so"──"sol"──────────────""──────▶
trim:      ──"s"──"so"──"sol"──────────────""──────▶
switchMap: ──[t]──[t]───[t·········"sol"]──""──────▶    [t] = TimerStream(300 ms), cancelled by the next query
distinct:  ─────────────────────"sol"──────""──────▶
```

- **Debounce:**
  - `switchMap` switches to a fresh `TimerStream(query, 300 ms)` for every query and **cancels the previous one**;
  - only a query that survives 300 ms of quiet comes out.
- **An empty query (the field cleared) goes through at once:**
  - `Stream.value("")` instead of a timer;
  - it also cancels a query still waiting, so a cleared field never shows an old search 300 ms later.
- **Why not `debounceTime`:** it can't treat one value differently from the others, and a separate "empty" stream merged back in would let a pending query arrive *after* the clear.
- **`distinct`:** "sol" and " sol " are the same search, and recomputing the list for them would waste a frame.

---

## 4. The market: `combineLatest5`

`domain/usecase/observe_market_use_case.dart`

```
snapshots: ──S0───────────────S1──────────────────S2─────▶   (§2, one per tick)
query:     ──""─────────"sol"──────────────────────────────▶   (§3, settled)
sort:      ──rank─────────────────────price───────────────▶   (distinct)
settings:  ──(USD, live)─────────────────────────(EUR, live)─▶   (currency + pause, distinct)
watched:   ──{}──────────────────{eth}─────────────────────▶   (drift query, §8)
           ──────────────────────────────────────────────────
listings:  ──L0─────────L1────L2──────L3──────────L4──L5─▶
               every change of ANY input → buildMarketRows(the latest of each)
```

- **`combineLatest`, not `zip`:**
  - `zip` pairs the *n-th* value of each input: the third tick with the third keystroke;
  - `combineLatest` recomputes from the **latest** of every input whenever any one changes, which is what a derived list is.
- **The first listing arrives at once:** `combineLatest` waits until every input has a value, and here they all do immediately:
  - the ticker and the settings are `BehaviorSubject`s;
  - the Cubit's query and sort are seeded subjects;
  - the watchlist is a drift query, which emits its current result when listened to.
- **Each input is narrowed and `distinct`:**
  - the market takes only `(currency, paused)` from the settings, so a theme change never recomputes it;
  - the same sort chosen again recomputes nothing.
- **The combiner is pure:** `buildMarketRows(coins, quotes, query, sort, directions, watched)` filters (name or symbol, case and spaces ignored), sorts (ties by rank: a stable list between ticks) and marks each row's direction.
- **The output carries its inputs** (`MarketListing`: the query, the sort, the currency and its rate, the pause). The screen therefore always shows the rows next to the query that produced them, never a newer query over older rows.

---

## 5. The price history and highs: two `scan`s

`core/prices/price_history.dart` + `domain/pipeline/price_history.dart`

```
quotes:  ──Q0──Q1──Q2── … ──Q60──Q61──▶
scan:    ──[0]─[0,1]─[0,1,2]─ … ─[1…60]─[2…61]──▶     appendSnapshot(history, quotes), 60 per coin
watch(btc): the current list at once, then each new one (distinct by identity)
```

- **A bounded buffer:** the accumulator is every coin's points. Each snapshot appends one per coin and drops the oldest past 60, so a long session never grows memory.
- **Eager:** `PriceHistory` is an eager singleton that subscribes when the app starts. A coin's chart has a minute of points the first time it opens.
- **The second `scan`, the highs:**

  ```
  quotes:  ──100──105──98──110──104──▶      (one coin)
  scan:    ──100──105──105─110──110──▶      raiseHighs(highs, quotes)
  distinct ──100──105──────110───────▶      watchHigh(btc)
  ```
  - its accumulator is each coin's highest price since launch, and it is **never capped**: the all-time high a coin's page shows can't fall when an old point leaves the 60-point buffer;
  - a snapshot that raises nothing returns the *same* map, so listeners comparing by identity see no change.
- **Immutable steps:**
  - `appendSnapshot` returns new lists and never touches the old ones;
  - an unchanged coin keeps its *same* list object, so `distinct(identical)` drops ticks that didn't touch it;
  - a quote no newer than the last point (the same snapshot again) adds nothing.

---

## 6. Settings → the ticker: `switchMap`

`core/prices/ticker_scheduler.dart` + `app/live_ticker.dart`

```
foreground: ──true────────────────────false────────true──────▶   (AppLifecycleListener: onShow / onHide)
switchMap:    true → settings.map(period)   false → Stream.value(null)
settings:   ──2 s──────1 s──(paused)──────(5 s)────────────────▶
period:     ──2s───────1s───null────────null(bg)───null(paused)──▶
distinct:   ──2s───────1s───null──────────────────────────────▶
effect:       start(2s) start(1s) stop()
```

- **The decision is a stream; its effect is one `listen`:** `null` stops the ticker, a duration (re)starts it.
- **`switchMap` on the foreground:**
  - in the background the scheduler isn't listening to the settings at all;
  - coming back, it switches to them again and gets their current value at once (a `BehaviorSubject`).
- **`distinct`:** a currency change produces the same period and never restarts the timer.
- **Paused is a setting, not an interval:**
  - auto-updating content must be pausable (WCAG 2.2.2), so the Market's app bar has Pause / Resume;
  - resuming returns to the interval the user chose.
- **The widget does the lifecycle, the class does the deciding:** `LiveTicker` feeds `onHide` / `onShow` in, and `TickerScheduler` is tested without widgets. A brief `inactive` (the control centre) keeps prices moving.

---

## 7. Cubits: the bridge to the screen

`features/market/cubit/market_cubit.dart`

```
MarketCubit
  inputs:  _query  = BehaviorSubject.seeded("")      ← queryChanged(text), each keystroke
           _sort   = BehaviorSubject.seeded(rank)    ← sortChanged(option)
  load():  await the seed (a Future) → subscribe: ObserveMarketUseCase(seed, query: _query, sort: _sort)
           each MarketListing → emit(MarketState.ready(listing))
  close(): cancel the subscription, then close the inputs → nothing is emitted after close
```

- **The Cubit owns only its inputs and one subscription.** It never computes a row, and never keeps a price. It's the Dart counterpart of a ViewModel collecting a Flow into a `StateFlow`.
- **Inputs are seeded subjects,** so the pipeline's first listing doesn't wait for a keystroke.
- **Closing while loading:**
  - `close()` sets a flag *first*, because `isClosed` turns true only at the end of `close()`, after its awaits;
  - a seed that lands during those awaits would otherwise subscribe after the cancel and emit into a closed Cubit;
  - every Cubit checks the flag after awaiting the seed, and a test closes each one mid-load.
- **Why a Cubit and not a Bloc:**
  - the debounce is an operator *inside* the pipeline, on a stream combined with four others;
  - Bloc's event transformers would add events around it without adding anything.

### In the widgets

- **`CoinRow` flashes on a new tick only:**
  - it receives the quote's `updatedAt` as `tick` and flashes when that changes;
  - a re-sort, a search or a currency change rebuilds the row with the same tick, and replays nothing;
  - a paused market has no new ticks, so nothing flashes.
- **`ValueKey(coin.id)` on rows:** a re-sort moves rows, and their flash state, instead of rebuilding them.
- **Reduced motion:** with `MediaQuery.disableAnimationsOf`, no flash and no cross-fade. The arrow and the changing number still say what happened.

---

## 8. The watchlist: a database query as a stream

`core/database/daos/watchlist_dao.dart` + `domain/usecase/observe_watchlist_rows_use_case.dart`

```
star (Market row) ─ toggle ─▶ watch_items (drift) ─┐
star (coin page)  ─ toggle ─▶        │             │  every write re-runs the query
swipe / Undo      ─ remove / restore ┘             │
                                                   ▼
watchIds():   ──[sol, btc]──────[sol, btc, eth]──[btc, eth]──▶    ordered by when each was starred
```

- **The table is the source of truth; screens never tell each other.**
  - Every star is a *write*. The Market's row, the coin's page and the Watchlist tab each *observe* a query, and drift re-runs it after each write.
  - The star fills, the row appears, the count changes, each on its own. That's Room's `Flow<List<T>>` and SwiftData's `@Query`.
- **Writes return results, reads are streams:**
  - `toggle` returns `Ok(true)` (now starred), `remove` returns the removed row (what Undo needs), and `restore` puts that row back with its old time, so it returns to its place;
  - a failure is `Err(StorageException)` ("Couldn't save that change"), and the screen says it.
- **The Watchlist tab's pipeline:**

  ```
  snapshots ─────────────────┐   (§2)
  watchIds (drift) ──────────┼─ combineLatest3 ─▶ buildWatchlistRows ─▶ WatchlistListing
  settings ─ priceDisplay ───┘   (currency, paused)
  ```
  The rows come in **starred order**, not by rank. An id the seed doesn't know is skipped.
- **The Market's fifth input:** `watchIds().map(toSet)` feeds `buildMarketRows`, which marks each row's star.
- **A swipe waits for the write.** `Dismissible.confirmDismiss` awaits the removal:
  - a failure slides the row back and says why;
  - only a removal that succeeded dismisses the row, which then stays hidden until the query drops it a moment later. A dismissed widget must leave the tree at once, while the list follows the database.

---

## 9. A coin's page: `combineLatest6`

`domain/usecase/observe_coin_detail_use_case.dart`

```
snapshots ─ map(this coin's quote, direction) ─ distinct ┐   other coins' ticks dropped here
history(id) ─────────────────────────────────────────────┤   (§5, the Live chart)
highestPrice(id) ────────────────────────────────────────┤   (§5, the all-time high)
watchContains(id) (drift) ───────────────────────────────┼─ combineLatest6 ─▶ CoinDetail
settings ─ priceDisplay ─────────────────────────────────┤   (currency, paused)
range ─ distinct ────────────────────────────────────────┘   (Live | 7 days, the Cubit's input)
```

- **Narrow before combining:** the snapshot carries all 32 coins. `map` to this coin, then `distinct`, and a tick that left this coin alone never rebuilds the page.
- **The live stats are getters on the output**, computed from the quote it carries (Correctness Rule 9):
  - market cap = circulating supply × the current price;
  - the all-time high = the highest of the seed's record, the highest price seen and the price itself.

  They can never disagree with the price beside them.
- **The chart's range is an input like any other.** The Cubit owns a seeded `BehaviorSubject<ChartRange>`, as the Market's Cubit owns the query and the sort. Picking "7 days" re-derives the page and patches nothing.
- **No quote, no page:** a snapshot without the coin emits nothing (`whereType`), rather than a page with a hole in it.
- **The Cubit takes the coin's id as a factory parameter** (`@factoryParam`): `getIt<CoinDetailCubit>(param1: id)`, one Cubit per open page.

---

## 10. The portfolio: `combineLatest3`

`domain/usecase/observe_portfolio_use_case.dart` + `domain/pipeline/portfolio_valuation.dart`

```
snapshots ─────────────────┐   (§2: a tick, with directions)
watchHoldings() (drift) ───┼─ combineLatest3 ─▶ valuePortfolio ─▶ PortfolioListing
settings ─ priceDisplay ───┘   (currency, paused)
```

- **Three reasons to re-value, one pipeline:**
  - a tick (prices moved);
  - a holding added, edited or removed (the table changed, from the form, a swipe, Undo or a coin's page);
  - another currency.

  Each arrives as a new value of one input, and `combineLatest` re-derives everything from the latest of all three.
- **The maths is a pure function** (`valuePortfolio`), tested without streams (Correctness Rule 10):
  - value = amount × price; cost = amount × buy price; P/L % = 0 when the cost is 0;
  - the 24 h change uses each quote's `open24hUsd`, never an accumulated drift.
- **The allocation adds up to exactly 100 %:**
  - shares are whole hundredths of a percent (basis points);
  - each is rounded, and the remainder goes to the largest slice;
  - one slice per coin, the top 5, then "Other".
- **Dollars all the way down:** the valuation is in USD, and the listing carries the currency and its rate. A currency change re-emits the *same* valuation with a new rate (a test checks it's equal), and the screen converts as it formats.

---

## 11. The holding form: `switchMap` on the chosen coin

`features/holding_form/cubit/holding_form_cubit.dart`

```
chosen coin:  ──btc───────────────sol──────────────▶   (a BehaviorSubject, the picker writes it)
switchMap:      price(btc)          price(sol)          the btc subscription is cancelled at the switch
prices:       ──67240──67310──67290─148.9──149.2───▶   only the chosen coin's, distinct
form:         "worth now" = amount × the latest price
```

- **`switchMap`, not `flatMap`:** picking Solana must stop Bitcoin's prices at once, or a late Bitcoin tick would value Solana at Bitcoin's price. A mutation (`switchMap` → `flatMap`) is caught by a test that ticks the old coin after the switch.
- **A suggestion, not a moving target:**
  - a new holding's empty buy price takes the coin's price once, rounded as prices are shown ("69762.39", not the walk's "69762.39175474");
  - after that the field stays put while "worth now" follows the ticks;
  - a suggested price is replaced when the coin changes, a typed one never is;
  - a suggestion doesn't count as a change, so closing the form doesn't ask.
- **Currency at the edge:** the buy price is typed in the chosen currency and divided by its rate on save. An edit shows it multiplied back, so €2,760 stays €2,760 (Correctness Rule 2).
- **One-off messages aren't state:** a save that fails ("Couldn't save that change") goes through a broadcast `failures` stream the view listens to, so a rebuild never shows it twice.

---

## 12. The settings: one stream, every pipeline

`domain/pipeline/price_display.dart` + `features/settings/cubit/settings_cubit.dart`

```
Settings tab / the Market's Pause ─ update ─▶ SettingsRepository (a BehaviorSubject, then the disk)
                                                     │ watch()
          ┌──────────────────────────────────────────┼────────────────────────────┐
  priceDisplay(): (currency, paused) ─ distinct      │                   SettingsCubit (themeMode)
          │                                          │                            │ BlocSelector
  Market · Watchlist · a coin · Portfolio    TickerScheduler (§6)          MaterialApp.themeMode
```

- **One source, three kinds of listener:**
  - the price pipelines take `(currency, paused)` through `priceDisplay()`, `distinct`: a theme change never recomputes a list;
  - the scheduler takes the period (or nothing, if paused);
  - the app takes the theme mode through a `BlocSelector`: a currency change never rebuilds `MaterialApp`.
- **From the first frame:** the preferences open before `runApp`, and `SettingsCubit` starts from `repository.current` (synchronous) before it listens, so the first build has the theme and the first listing the currency.
- **A write is read back like any change:** the Settings tab never updates itself. The Live prices switch and the Market's Pause write the same setting, and each shows it from the stream.
- **No new stream code for Settings:** every pipeline already took the settings as an input (the market since Phase 3, the others from the day they were written); Phase 6 only added the controls.

---

## Flow ↔ Combine ↔ Dart

| Idea | Kotlin Flow (Android) | Combine (iOS) | **Dart / rxdart (this app)** |
|---|---|---|---|
| A value over time | `Flow<T>` | `Publisher` | `Stream<T>` |
| One async answer | `suspend fun` | `async` / `Future` | `Future<T>` |
| Current value + updates | `StateFlow` / `MutableStateFlow` | `CurrentValueSubject` | `BehaviorSubject` / `ValueStream` |
| Events, no current value | `SharedFlow` | `PassthroughSubject` | `StreamController.broadcast()` / `PublishSubject` |
| Combine latest values | `combine(a, b, …)` | `CombineLatest` / `combineLatest` | `Rx.combineLatest2…9` |
| Pair n-th values | `zip` | `Zip` | `Rx.zip` |
| Debounce | `debounce(300)` | `debounce(for:scheduler:)` | `debounceTime` (or `switchMap` + `TimerStream`, §3) |
| Switch to the latest inner stream | `flatMapLatest` | `switchToLatest` | `switchMap` |
| Running fold | `scan` / `runningFold` | `scan` | `scan` |
| Drop repeats | `distinctUntilChanged` | `removeDuplicates` | `distinct` |
| Transform | `map` | `map` | `map` |
| Start with | `onStart { emit(x) }` | `prepend` | `startWith` |
| A database query, live | Room `Flow<List<T>>` | SwiftData `@Query` | drift `.watch()` |
| Collect in the UI | `collectAsStateWithLifecycle` | `sink` + `@Observable` | a Cubit's `listen` → `emit` → `BlocBuilder` |
| Cancel | `Job.cancel()` | `AnyCancellable.cancel()` | `StreamSubscription.cancel()` |
| Test | Turbine (`awaitItem()`) | collected values | `StreamQueue` (`next`), `emitsInOrder`, `fakeAsync` |

---

## Testing the pipelines

- **`StreamQueue` (package `async`), the Turbine of Dart:** `await queue.next` is the next value, in order. Used for the market pipeline and the price moves: each input changes, and the next listing is checked.
  - A `tearDown` cancels with `cancel(immediate: true)`. A plain `cancel()` waits for a `next` still pending, so a test that failed waiting for a value would hang the whole run instead of failing.
- **Pure functions first:** `buildMarketRows`, `directionsBetween`, `appendSnapshot`, `RandomWalk` and the formatters are tested without any stream.
- **Fake time (`fakeAsync`):**
  - the ticker's intervals, the debounce's 300 ms and the Cubit's states are exact;
  - the walk's randomness is seeded and the clock is the fake one, so every price path is reproducible.
- **Two traps found while writing them** (conventions §11.122):
  1. **Create everything inside `fakeAsync`.** A stream or timer created outside it doesn't run on its clock: a debounce test built its fakes in `setUp` and never saw its timer fire.
  2. **Cancel futures from broadcast streams complete in the root zone,** which fake time never runs. rxdart's `switchMap` *waits* for the previous inner stream's `cancel()` before listening to the next. So in fake time:
     - typing that replaces a pending query, or the scheduler switching from the settings to the background, stalls;
     - a Cubit's `close()`, which awaits a cancel, never completes.

     It's only the test clock: in the app the future completes at once. Those tests run in real time with a short debounce (40 ms). Widget tests alternate `tester.runAsync(pumpEventQueue)` with `tester.pump()`.
- **drift in tests:**
  - the database is in memory, with `closeStreamsSynchronously` (§11.24);
  - a query stream's `first` hangs in fake time (its cancel never completes, §11.27), so app tests read the database inside `tester.runAsync`, and writes from taps settle on the real loop (`tapAndWrite`, §11.95);
  - the exported schema is checked against the app's tables (`test/drift/`).
- **A singleton created inside `runAsync` listens in the root zone** (§11.123). `PriceHistory` is eager, so it's built when the test configures the app inside `runAsync`. Its `scan` callbacks then run as *real* microtasks, which fake-time pumps never flush: the ticks happen, but the chart stays at one point. A test of the live chart gives the real loop a turn (`tester.runAsync(pumpEventQueue)`). In the app there's one zone and no gap.
- **Widget and app tests:**
  - the app's own tests start with live prices **paused**: a ticking market never lets `pumpAndSettle` settle, and a periodic timer left running fails a test;
  - a test that wants ticks turns them on and pauses before it ends;
  - the accessibility tour checks the market **mid-flash**, so the contrast guideline runs over the real flash tints.

---

## Beyond this project

A real price feed would replace only the ticker's timer behind the same `quotes` stream; price alerts would be one more `scan` over it. More in the [roadmap](ROADMAP.md).
