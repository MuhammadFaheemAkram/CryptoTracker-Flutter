# Interview notes

Questions this project can answer, with short answers and where to look. Grouped from "explain the basics" to "what went wrong".

---

## Streams basics

**`Future` or `Stream`?**
- A `Future` is one answer (the seed, loaded once). A `Stream` is a value over time (prices, settings, what the user types).
- Everything that changes while you look at it is a stream here; everything that doesn't is a `Future`.

**Single-subscription vs broadcast? Hot vs cold?**
- Single-subscription: one listener, ever, usually cold (the work starts when you listen). Broadcast: any number of listeners, each seeing only what comes after it joins.
- Hot produces whether anyone listens or not (the ticker); cold starts per listener (each use case's pipeline).

**Why a `BehaviorSubject` for the prices?**
- A screen opened a minute into the session must see the prices *now*. A broadcast stream would leave it blank until the next tick.
- A `BehaviorSubject` replays its latest value and has a synchronous `.value`: Kotlin's `StateFlow`, Combine's `CurrentValueSubject`.

**`combineLatest` or `zip`?**
- `zip` pairs the n-th values: the 3rd tick with the 3rd keystroke.
- A derived list needs the *latest* of everything whenever anything changes: `combineLatest`.

## Stream design

**What's a glitch, and how do you avoid it?**
- Two streams derived from one source and recombined arrive one after the other, so one emission mixes new and old (new prices with last tick's directions).
- Derive both in one step: one `scan` emits a `PriceSnapshot` with quotes *and* directions. A test checks one state per tick.

**How do you debounce a search but clear it instantly?**
- `switchMap` each query to a `TimerStream(query, 300 ms)`, or to `Stream.value('')` for an empty one, then `distinct`.
- The switch cancels a pending timer, so a cleared field never shows an old search 300 ms later. `debounceTime` can't treat one value differently.

**How do you stop a coin's page rebuilding on every coin's tick?**
- Narrow before combining: `map` the snapshot to this coin's quote, then `distinct`. `combineLatest` only re-derives when one of *its* inputs changes.

**How do you stop work in the background?**
- A stream of "foreground" (`AppLifecycleListener.onHide` / `onShow`), `switchMap`ped to the settings' interval or to nothing, then `distinct`, then one `listen` that starts or stops the ticker.

**Why `switchMap` for the holding form's price, not `flatMap`?**
- Picking another coin must drop the old coin's price stream at once; with `flatMap` a late tick of the old coin would value the new one. A mutation test proves it.

**Where does the business logic live, if everything is a stream?**
- In pure functions inside the combiners (`buildMarketRows`, `valuePortfolio`, `allocate`). The stream decides *when*; the function decides *what*. Each is tested without streams.

## State management

**Why Cubits and not Blocs?**
- The interesting logic (debounce, combining, switching) is in the streams. Events would only wrap method calls without adding anything. The project's rule: Cubit by default, Bloc when events carry their own transformations.

**What does a Cubit own here?**
- Its screen's inputs (seeded subjects: the query, the sort, the chart range, the chosen coin) and **one** subscription to its pipeline. It never computes a row and never keeps a price.

**How do you make sure a Cubit never emits after `close()`?**
- Cancel the subscription in `close()`.
- `isClosed` only turns true when `close()` finishes, after its awaits; data that lands in between (the seed) would subscribe after the cancel. A `_closing` flag set first in `close()` closes that window. A test closes each Cubit mid-load.

**How does the theme apply from the first frame?**
- The preferences open before `runApp` (`@preResolve`). `SettingsCubit` starts from `repository.current` (synchronous), so the first `MaterialApp` build already has the theme. A test starts the app with a stored dark theme and checks the first frame.

## Data and persistence

**How does a star on one screen update another?**
- Nobody tells the other screen. The star is a drift write; the Market row, the coin's page and the Watchlist each observe a query, and drift re-runs it after the write.

**How do you test a database migration?**
- Export a schema per version (`make-migrations`).
- Check that every upgrade path ends at the latest schema.
- Write data with the *old* schema's classes and read it back after the upgrade (`testWithDataIntegrity`).
- Here it also ran for real on the simulator over the previous install.

**Why are the prices not stored?**
- They're simulated: the market starts again from the seed at each launch, as a fake server would. Only the user's choices (stars, holdings, settings) are kept.

**Why does Undo restore the same id?**
- `AUTOINCREMENT` never reuses an id, so putting the removed row back with its id can't collide. The row returns to its place, and anything keyed by the id still points at it.

## Money

**How do you make percentages add up to 100?**
- Work in whole units (basis points), round each, and give the remainder to the largest slice, where it shows least. Floats summing to 1.0 aren't a guarantee; integers are.

**Where does currency conversion happen?**
- At the edges only: a typed buy price is divided by the rate on save; a value is multiplied as it's formatted. A currency change is a new rate, not new data.

**Why derive the 24 h change instead of updating it each tick?**
- Adding each tick's movement to the change drifts further from the truth with every tick (both native specs did). Keeping the price 24 h ago and computing `(price / open − 1) × 100` is exact after any number of ticks; a test runs 500.

## Accessibility

**How do you make live prices accessible?**
- No live regions: a ticking price doesn't announce itself; a screen reader reads the current value when focused.
- Moving content can be paused where it's shown (the Market's Pause, WCAG 2.2.2).
- Color is never the only signal (▲/▼ and signs); flashes and cross-fades stop with reduced motion.

**How do you make swipe-to-delete accessible?**
- Add a custom semantics action ("Remove") that does the same thing.

**What did the simulator find that tests didn't?**
- Its keyboard typed Arabic-Indic digits, which an ASCII-only filter dropped: no number could be entered. Digits are normalised now.
- At the largest text a price wrapped mid-number; it shrinks to fit now.

## Testing

**How do you test streams?**
- Pure functions for the logic; `StreamQueue` for the order of emissions; `fakeAsync` for time.
- Know the limits: rxdart's `switchMap` waits for a cancel future that completes in the root zone, so those cases run in real time.

**How do you know your tests test anything?**
- Mutation passes: break a rule on purpose and run the whole suite. A surviving mutation is a missing test, or proof that code is redundant.
- Here 260 mutations across six phases. Survivors led to new tests, and to dead code removed.

## What went wrong (and was fixed)

- **A Cubit could emit after close** if its seed landed during `close()`'s awaits: found by a test in Phase 4, in three Cubits.
- **A failed swipe re-added an already-dismissed row** (an assertion): the swipe now waits for the write.
- **A failing stream test hung the whole run** in `tearDown`: `StreamQueue.cancel(immediate: true)`.
- **The ticks came but the chart stayed empty, in a test only:** a singleton built inside `runAsync` listens in the root zone.
- **The release build started slowly** on a loaded emulator; another app's release build took the same time, so it was the machine, not the app.
