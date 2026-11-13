# Learning notes

Every concept in the app, grouped, with where to see it. The phase summaries ([1](PHASE_1_SUMMARY.md) · [2](PHASE_2_SUMMARY.md) · [3](PHASE_3_SUMMARY.md) · [4](PHASE_4_SUMMARY.md) · [5](PHASE_5_SUMMARY.md) · [6](PHASE_6_SUMMARY.md)) tell the story in order; [STREAM_PIPELINES.md](STREAM_PIPELINES.md) draws every pipeline; this page is the index.

---

## Dart streams

| Concept | In one line | Where |
|---|---|---|
| `Future` vs `Stream` | one answer vs a value over time | the seed (`loadMarket`) vs the quotes |
| Single-subscription vs broadcast | one listener ever vs many, each seeing what comes after it joins | `TimerStream` vs `StreamController.broadcast()` (the form's failures) |
| Hot vs cold | produces whether or not anyone listens vs starts per listener | the ticker vs each use case's pipeline |
| `StreamSubscription.cancel()` | stop listening; every Cubit does it in `close()` | every Cubit |
| `async*` / `yield` | not used, on purpose: a `StreamController` or rxdart is clearer for "current value, then changes" (§11.99) | — |

## rxdart

| Operator | What it does | Where |
|---|---|---|
| `BehaviorSubject` / `ValueStream` | remembers its latest value; replays it to new listeners; `.value` reads it now | `PriceTicker`, `PriceHistory`, settings, every Cubit's inputs |
| `Rx.combineLatest3/5/6` | re-derive from the latest of every input when any changes | the market (5), a coin (6), the watchlist and the portfolio (3) |
| `scan` | a fold that emits each step | price directions, the history (bounded), the highs (never capped) |
| `switchMap` | switch to a new inner stream, cancelling the old | the settled search, the scheduler, the form's chosen coin |
| `TimerStream` | one value after a delay | the search's debounce |
| `distinct` | drop repeats (`==`, or `identical`) | every narrowed input; the history per coin |
| `whereType` | drop the values of another type (`null`s) | a coin page without a quote |
| `map` before `combineLatest` | narrow an input so unrelated changes don't re-derive | `priceDisplay()`, a coin's own move |

**Patterns built from those:**
- **One `scan` for values that must arrive together** (quotes and directions): no glitch.
- **Narrow, then `distinct`, then combine:** a theme change never recomputes a price list.
- **Debounce with an instant clear:** `switchMap` to a timer, or to `Stream.value('')`.
- **A side effect at the end of a pipeline:** the scheduler's `listen` starts or stops the ticker.
- **A seeded subject as a screen's input:** the query, the sort, the chart range, the chosen coin.
- **A database query as an input:** drift's `watch()` in `combineLatest`.

## State management (flutter_bloc)

| Concept | Where |
|---|---|
| Cubit (not Bloc): the logic is in the streams, events would only wrap them | every feature |
| A Cubit as the bridge from a pipeline to the screen: one subscription, `listen` → `emit` | `MarketCubit` |
| Sealed freezed states, rendered with an exhaustive `switch` | every `…_state.dart` |
| An app-wide Cubit above the router | `SettingsCubit` |
| A `_closing` flag set first in `close()` | every Cubit |
| One-off messages on a broadcast stream, not in state | `HoldingFormCubit.failures` |
| `BlocSelector` to rebuild on one field | the theme mode in `CryptoTrackerApp` |
| `MockCubit` (bloc_test) for view tests | `test/features/*/…_view_test.dart` |

## Persistence

| Concept | Where |
|---|---|
| drift tables, DAOs, live queries (`watch`) | `core/database/` |
| A transaction that returns a value | `remove` in both DAOs |
| `CHECK` constraints; plain inserts vs OR IGNORE (§11.124) | `holdings.dart`, `portfolio_dao.dart` |
| AUTOINCREMENT ids, so Undo can restore the same id | `holdings` |
| Schema export, `make-migrations`, `stepByStep`, migration tests with data | `drift_schemas/`, `test/drift/` |
| `SharedPreferencesWithCache`, opened before `runApp` | `core/storage/`, `di/app_module.dart` |
| The database as the single source of truth for every screen | the watchlist and the holdings |

## Dependency injection

| Concept | Where |
|---|---|
| `get_it` + `injectable`, the composition root | `di/` |
| `@preResolve` (async before `runApp`) | the preferences, the app's version |
| `@lazySingleton`, `@singleton` (eager), `@injectable` (a new one each time) | repositories, `PriceHistory`, Cubits |
| `@factoryParam` (one or two) | `CoinDetailCubit`, `HoldingFormCubit` |
| `@ignoreParam` (a test-only knob with a default) | `MarketCubit`'s debounce |
| `@disposeMethod` | the ticker, the history, `SettingsCubit` |

## UI and Flutter

| Concept | Where |
|---|---|
| `material_ui` (Material 3 as a package) | everywhere |
| A `ThemeExtension` for colors Material has no slot for | `AppColors` |
| `CustomPainter`: a sparkline, a line chart with a fill, a donut | `core/design_system/charts/` |
| `RepaintBoundary` and `shouldRepaint` on the data | every chart |
| An `Ink` flash that keeps the ripple visible; `AnimatedSwitcher` cross-fades | `PriceFlash`, `AnimatedPrice` |
| Reduced motion (`MediaQuery.disableAnimationsOf`) | the flash and the cross-fade |
| `go_router` typed routes, `StatefulShellRoute`, full-screen dialogs | `core/navigation/` |
| `AppLifecycleListener` | `LiveTicker` |
| `Dismissible.confirmDismiss` (wait for the write) | the Watchlist, the Portfolio |
| `PopScope` with a discard question | the holding form |
| `showModalBottomSheet` returning a value | the coin picker |
| `RadioGroup` (the current radio API) | `CurrencyPicker` |
| `TextInputFormatter.withFunction` (other scripts' digits) | the holding form |
| Large text: `prefersStackedLayout`, `FittedBox(scaleDown)`, vertical `SegmentedButton`s | every screen |
| Semantics: one label per row, custom actions, a described chart, excluded duplicates | `CoinRow`, `PositionTile`, the charts |

## Money and numbers

| Concept | Where |
|---|---|
| Dollars below the UI, a rate at the edges | `MoneyFormatter`, the form |
| A derived 24 h change from `open24h`, never accumulated | `Quote` |
| Significant digits under one unit; compact amounts; per-currency decimals | `MoneyFormatter` |
| Basis points that add up to exactly 100 % | `allocate` |
| Validating typed numbers: decimals, digits, scripts | `parseDecimalInput` |

## Testing

| Concept | Where |
|---|---|
| `StreamQueue` (the Turbine of Dart) | `test/domain/usecase/` |
| `fakeAsync`, and when to test in real time instead | `test/core/prices`, the Cubit tests |
| drift in memory; `runAsync` for database work in widget tests | `test/helpers/` |
| The whole app on the real DI graph | `pumpCryptoTracker` |
| An accessibility tour (targets, labels, contrast) | `test/app/accessibility_tour_test.dart` |
| Architecture rules as tests | `test/architecture/` |
| Mutation passes against the whole suite | [TESTING.md](TESTING.md#mutation-checks) |
