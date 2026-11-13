# Testing

```bash
fvm flutter test                                   # everything (about 20 s)
fvm flutter test test/domain                       # one area
fvm flutter test --plain-name "the 24 h change"    # one test by name
```

**636 tests**, all on the host (no device needed). CI runs them on every push, after checking that the generated code is current, the format and the analyzer.

---

## What is tested, and how

| Area | Folder | How |
|---|---|---|
| Pure pipeline pieces | `test/domain/pipeline`, `validation` | Plain functions, no streams: `buildMarketRows` (search × sort, ties), `directionsBetween`, `appendSnapshot`, `raiseHighs`, `buildWatchlistRows`, `valuePortfolio`, `allocate` (shares summing to 100.00 % whichever way rounding goes), `parseDecimalInput` |
| Formatting | `test/core/formatting` | Every currency, tiny and huge numbers, signs agreeing with arrows (checked across every rounding boundary from −3 % to +3 %), shares, chart summaries |
| The price engine | `test/core/prices` | `fakeAsync`: the ticker's intervals, a restart with one timer and no jump, the 24 h change still exact after 500 ticks; the walk seeded (bounds, stablecoins, the pull back, the floor); the history's cap and highs; the scheduler (interval, pause, background) |
| Pipelines | `test/domain/usecase` | `StreamQueue` (the Turbine of Dart): each input changes, and the next value is checked. Market (5 inputs), price moves (one snapshot per tick), the watchlist, a coin's page (another coin's tick never rebuilds it), the portfolio (a tick, a holding, a currency) |
| Data | `test/data`, `test/core/network`, `test/core/storage` | Mappers that reject damaged data; repositories on the real fake API at zero latency; the settings data source over in-memory preferences (only changed keys written) |
| The database | `test/core/database`, `test/drift` | drift in memory: the DAOs (order, Undo to the same place and id, `CHECK`s), live queries; the schemas and the v1 → v2 migration with data |
| Cubits | `test/features/*/…_cubit_test.dart` | Real use cases over fakes; states recorded in order; **closed while loading** (each Cubit) |
| Views | `test/features/*/…_view_test.dart`, `test/core/design_system` | `MockCubit`, one state per test; flashes only on new ticks and never with reduced motion; semantics (labels, the Remove action, a described chart); large text (310 %) |
| Flows | `test/features/*/…_flow_test.dart`, `test/core/navigation` | The real DI graph with drift and preferences in memory: search → a coin → star → the Watchlist; add, edit, remove a holding with Undo; Settings converting every tab; deep links |
| The accessibility tour | `test/app/accessibility_tour_test.dart` | Every screen and state, light and dark, at 200 % text: tap targets, labels, text contrast (over the flash tints too) |
| Architecture | `test/architecture` | Import rules between layers; one periodic timer; `getIt` only where allowed |
| DI | `test/di` | The real composition root resolves; singletons are single; factory parameters reach their Cubits |
| Platform | `test/platform` | The Android release manifest asks for no network |

---

## Helpers (`test/helpers/`)

- **`pumpCryptoTracker(tester, …)`** (`app_harness.dart`): the whole app on the real DI graph, optionally on a deep link, with:
  - live prices **paused** unless `livePrices: true` (a ticking market never lets `pumpAndSettle` settle, and a periodic timer left running fails a test);
  - `stored:` preferences from an earlier session; `marketApi:` a failing or gated fake service.
- **`tapAndWrite`, `write`, `settleRealAsync`:** a database write runs on the real event loop, then the screens settle (see the traps below).
- **`scrollTo`:** scrolls a target fully into view (not just built).
- **Fakes** (`fakes/`): `FakeMarketRepository` (quotes move when the test says), `FakeWatchlistRepository`, `FakePortfolioRepository`, `FakeSettingsRepository`, `ScriptedMarketApi`. Every fake can fail its writes.
- **`fixtures.dart`:** `testNow`, `coin(…)`, `quote(…)`, `testRates`, `smallMarket()` (Bitcoin, Ethereum, Tether, Solana).
- **`result_matchers.dart`:** `isOk(value)`, `isErrOf<E>()`.
- **`contrast.dart`:** WCAG contrast ratios for the color tests.
- **`flutter_test_config.dart`:** fresh in-memory preferences and a mocked app version for every test.

---

## Traps, and what the tests do about them

These cost real time to find; each is in the conventions file with a number.

| Trap | What happens | What the tests do |
|---|---|---|
| Streams created outside `fakeAsync` (§11.122) | Their timers don't run on the fake clock | Create every stream, subject and fake **inside** `fakeAsync` |
| rxdart's `switchMap` in fake time (§11.122) | It waits for the previous inner stream's `cancel()`, whose future completes in the root zone, which fake time never runs | Those Cubit tests run in **real time** with a short injected debounce (40 ms); widget tests alternate `runAsync(pumpEventQueue)` and `pump` |
| A drift query's `.first` in fake time (§11.27) | It never completes (its cancel never finishes) | Read the database inside `tester.runAsync` |
| Two drift writes in one `runAsync` (§11.95) | The second waits forever on a database the screens hold | One write per `tester.write` |
| A singleton built inside `runAsync` (§11.123) | Its listener is in the root zone: ticks happen, but the history never records in fake time | Give the real loop a turn after fake-time ticks |
| `StreamQueue.cancel()` with a pending `next` (§11.129) | A failing test hangs the whole run in `tearDown` | `cancel(immediate: true)` |
| A `.first` finder with no match (§11.128) | It throws instead of matching nothing | Scroll to a finder that matches one widget on its own |
| A very tall tour surface under a dialog (§11.127) | The page snapshot can't be rasterized | Phone height for those stops |

---

## Mutation checks

Every phase ended with a mutation pass: rules broken on purpose, one at a time, each against the **whole suite**. A mutation that survived was either a missing test (written, then the mutation run again) or proved equivalent (and its dead code removed where there was any).

| Phase | Mutations | First pass | After new tests |
|---|---:|---:|---|
| 1 | 28 | 26 | all |
| 2 | 37 | 35 | all but 1 equivalent |
| 3 | 44 | 40 | all |
| 4 | 57 | 52 | all but 1 equivalent (dead code removed) |
| 5 | 63 | 59 | all but 1 equivalent |
| 6 | 31 | 31 | (nothing survived) |

Phase 6 broke the Settings, and every key Correctness Rule once more, against the finished suite.

---

## Writing a new test

- **A new rule?** Start with the pure function. Only the order and timing of emissions need a stream test.
- **A new pipeline input?** A `StreamQueue` test: change that input alone, and expect exactly one new value.
- **A new screen or state?** A view test with `MockCubit`, and a stop in the accessibility tour.
- **Something that touches the database from a screen?** A flow test with `tapAndWrite`.
- **Bound every wait.** A test that can hang will, on CI, at the worst time.
