# Phase 5 — Portfolio with Live Valuation

## Phase Goal

Turn the live market into the user's money:
- **holdings stored on the device** (drift **v2**), with the database's **first migration**, generated and tested with data;
- **a valuation that is always derived:** one pipeline (`combineLatest3`) re-values the portfolio on a tick, on a holding change and on a currency change, through one pure function;
- **an allocation that adds up:** the top 5 coins and "Other", in shares that sum to exactly 100.00 %;
- **the holding form:** new or edit, from the Portfolio or a coin's page, the buy price in the chosen currency (suggested from the price now), validation as you type, a live preview, and a question before discarding changes.

Both new pipelines are drawn in **[STREAM_PIPELINES.md](STREAM_PIPELINES.md)** (§10, §11).

---

## What Was Implemented

- **Database v2** (`core/database/`):
  - `Holdings` (`id INTEGER PRIMARY KEY AUTOINCREMENT`, `coin_id`, `amount`, `buy_price_usd`, `created_at`), with `CHECK`s that the amount and the price are positive and the coin id isn't empty;
  - `PortfolioDao`: `watchAll` (oldest first, ties by id), `find`, `add`, `change` (one `UPDATE`), `remove` (returns the row), `restore` (the same row, the same id). Plain inserts, never OR IGNORE (§11.124);
  - `schemaVersion` 2 with `stepByStep(from1To2: createTable(holdings))`, from `make-migrations`; `drift_schema_v2.json` exported.
- **Domain:**
  - `Holding`; `PortfolioPosition` (value, cost, profit, profit %, 24 h change, all getters); `Allocation` (basis points); `PortfolioValuation`; `PortfolioListing`;
  - `valuePortfolio` and `allocate` (pure);
  - `parseDecimalInput`, `normalizeDigits`, `formatDecimalInput`, `suggestedPriceInput` (pure);
  - `PortfolioRepository` and its use cases (Find, Add, Update, Remove, Restore), `ObservePortfolioUseCase`, `ObserveCoinPriceUseCase`, `CurrentSettingsUseCase`.
- **Data:** `PortfolioRepositoryImpl` (times from the clock in UTC; writes through `guardWrite`; reads plain).
- **Cubits:**
  - `PortfolioCubit` (load, remove, restore; the close guard);
  - `HoldingFormCubit` (`@factoryParam coinId`, `@factoryParam holdingId`): the coin as a `BehaviorSubject` `switchMap`ped to its live price; the suggestion rules; validation; euros in, dollars stored; not found; a `failures` stream for one-off messages.
- **Screens:**
  - **Portfolio:**
    - the total value, P/L and 24 h change (signed money and percent, in words for a screen reader);
    - the allocation donut and its legend (stacked at large text);
    - a row per holding (`PositionTile`: amount, cost, value, P/L), flashing on ticks;
    - tap to edit; swipe to remove (waiting for the write) with Undo, or a **Remove** action for screen readers;
    - the Add button, and "Add your first holding" when empty.
  - **Holding form:**
    - the coin (a searchable picker sheet; fixed when editing);
    - the amount and the buy price per coin (in the currency, with "Now $…" under it);
    - errors as you type and every one after Save;
    - "Worth now / Cost / P/L" live;
    - Save in the app bar;
    - "Discard changes?" on Close, and on a link's Close.
- **Design system:** `AllocationDonut` / `DonutPainter` / `AllocationLegend`, `PositionTile`, `ValueChange`; `MoneyFormatter.signedPrice` / `describeSignedPrice` / `coinAmount`; `PercentFormatter.formatShare`.
- **Tests:** **615** (483 after Phase 4).

---

## Stream Concepts Demonstrated

| Operator / idea | Where | Why |
|---|---|---|
| `combineLatest3` with a database query as an input | the portfolio | A tick, a table change and a currency change are all "an input changed" |
| A pure function inside the combiner | `valuePortfolio` | The maths is tested without streams; the stream only decides *when* |
| `switchMap` on a user's choice | the form's chosen coin | Choosing another coin cancels the old coin's prices at once (`flatMap` would mix them) |
| `map` + `distinct` per coin | `ObserveCoinPriceUseCase` | Another coin's tick emits nothing |
| A broadcast stream for one-off messages | `HoldingFormCubit.failures` | An error to show once isn't state to keep (a rebuild would show it again) |
| The same valuation, a new rate | a currency change | Money stays in dollars; only the edge converts |

---

## Flutter / Dart Concepts Demonstrated

- **drift migrations:**
  - `make-migrations` → `app_database.steps.dart`, `stepByStep`;
  - exported schemas per version;
  - `SchemaVerifier.migrateAndValidate` for every upgrade path;
  - `testWithDataIntegrity` (an old watchlist survives, holdings start empty).
- **injectable** with **two** `@factoryParam`s (`param1`, `param2`, both nullable).
- **Forms without `Form`:**
  - controllers owned by the view and synced when the Cubit fills a field;
  - `TextInputFormatter.withFunction` to normalise digits before filtering;
  - `InputDecorator` for a picker field that looks like the text fields.
- **`PopScope`** with `onPopInvokedWithResult`, plus a confirmed link Close.
- **`showModalBottomSheet`** returning a value (the picker).
- **Semantics:**
  - `customSemanticsActions` (Remove);
  - one-sentence labels for gains and losses ("plus $3,620.25");
  - a chart described once, its legend excluded.
- **`CustomPainter`:** a donut of arcs with radial gaps; `shouldRepaint` with `listEquals` over value-equal slices.

---

## Data Flow

```
Save on the form (new, from Solana's page)
  → HoldingFormCubit.save: amount 10, price 148.92 (USD) → AddHoldingUseCase
  → PortfolioRepositoryImpl.add → guardWrite → PortfolioDao.add (INSERT into holdings)
  → the page shows "Added 10 SOL to your portfolio" and pops back to Solana
  → drift re-runs watchHoldings() → combineLatest3 → valuePortfolio → the Portfolio tab has it

each tick
  → PriceTicker → snapshot (scan) → combineLatest3 → valuePortfolio
  → new totals, rows (flashing), donut shares

swipe a holding
  → confirmDismiss: PortfolioCubit.remove(id) (DELETE, returns the row)
  → Undo → restore(row): INSERT with the same id → back in its place
```

---

## Important Files Added

| File | What |
|---|---|
| `lib/core/database/tables/holdings.dart`, `daos/portfolio_dao.dart`, `app_database.steps.dart` | drift v2 |
| `drift_schemas/app_database/drift_schema_v2.json` | The exported v2 schema |
| `lib/domain/pipeline/portfolio_valuation.dart` | `valuePortfolio`, `allocate` |
| `lib/domain/validation/decimal_input.dart` | Typed numbers, digits, suggestions |
| `lib/domain/usecase/observe_portfolio_use_case.dart`, `portfolio_use_cases.dart`, `observe_coin_price_use_case.dart` | Pipelines and writes |
| `lib/data/repository/portfolio_repository_impl.dart` | Holdings over drift |
| `lib/features/portfolio/…`, `lib/features/holding_form/…` | Cubits, states, views, pages, the picker |
| `lib/core/design_system/charts/allocation_donut.dart`, `widgets/position_tile.dart`, `widgets/value_change.dart` | Shared UI |
| `test/drift/app_database/migration_test.dart` | Every upgrade path, and v1 → v2 with data |

---

## Important Types Added

- `Holdings` / `HoldingRow`, `PortfolioDao`
- `Holding`, `PortfolioPosition`, `Allocation`, `PortfolioValuation`, `PortfolioListing`, `DecimalInputError`
- `PortfolioRepository`, `ObservePortfolioUseCase`, `ObserveCoinPriceUseCase`, `CurrentSettingsUseCase`, Find/Add/Update/Remove/RestoreHolding
- `PortfolioCubit` / `PortfolioState`, `HoldingFormCubit` / `HoldingFormState` / `HoldingForm`
- `AllocationDonut`, `DonutSlice`, `DonutPainter`, `AllocationLegend`, `PositionTile`, `ValueChange`, `CoinPicker`

---

## Folder Structure Changes

```
lib/core/database/          + tables/holdings.dart, daos/portfolio_dao.dart, app_database.steps.dart
lib/domain/validation/      new: decimal_input.dart
lib/features/portfolio/     placeholder → cubit/, view, page
lib/features/holding_form/  placeholder → cubit/, view, page, coin_picker.dart
drift_schemas/              + drift_schema_v2.json
test/drift/                 + migration_test.dart, generated/schema_v2.dart
```

---

## Android / iOS Comparison

| Concept | Android | iOS | Flutter (this app) |
|---|---|---|---|
| Holdings storage | Room | SwiftData | drift v2, `CHECK`s backing the form's rules |
| Schema change | a Room migration | a versioned schema | `make-migrations` + `stepByStep`, tested per path and with data |
| Valuation | `combine(quotes, holdings, currency)` | `CombineLatest3` | `Rx.combineLatest3` → pure `valuePortfolio` |
| Allocation | a donut | a donut | a donut + legend, top 5 + Other, shares in basis points summing to 100.00 % |
| Portfolio 24 h | — | a header 24 h change | from `open24h`, never accumulated |
| Holding entry | a dialog | a sheet | a full-screen form route (also from Coin Detail), validated, with a discard check |
| Buy price currency | USD | USD | the chosen currency, stored in USD (Rule 2) |
| Remove | swipe + Snackbar | swipe + undo | `confirmDismiss` + Undo, and a screen reader's **Remove** action |

---

## Interview Notes

- **"How do you make percentages add up to 100?"**
  - Work in whole units (basis points), round each, and give the remainder to the largest slice, where it shows least.
  - Floats summing to 1.0 aren't a guarantee; integers are.
- **"How do you test a database migration?"**
  - Export a schema per version.
  - Check every upgrade path ends at the latest schema (`migrateAndValidate`).
  - Write data with the *old* schema's classes and read it back after the upgrade (`testWithDataIntegrity`). Snapshots hold raw SQL values (dates as text).
- **"Why `switchMap` for the form's price?"** When the user picks another coin, the old coin's price stream must stop at once; `flatMap` would let a late tick of the old coin value the new one.
- **"Where does the currency conversion happen?"**
  - At the edges only: typed → divided by the rate on save; shown → multiplied as it's formatted.
  - Everything in between is dollars, so a currency change is a new rate, not new data.
- **"How do you make swipe-to-delete accessible?"** Add a custom semantics action ("Remove") that does the same thing; a swipe gesture can't be performed by every user.
- **"How do you keep a form from losing work?"**
  - Compare against the starting values (a suggestion isn't a change).
  - `PopScope(canPop: !dirty)` catches Back and Close.
  - A link's Close asks too.

---

## Learning Checklist

- ✅ drift v2: a new table, `CHECK`s, AUTOINCREMENT ids, a one-statement update
- ✅ `make-migrations`, `stepByStep`, migration tests per path and with data
- ✅ `combineLatest3` over a tick, a table and a setting; a pure valuation
- ✅ An allocation in basis points that sums to exactly 100 %
- ✅ `switchMap` on a user's choice; one-off messages on a broadcast stream
- ✅ A validated, currency-aware form with a discard check; two `@factoryParam`s
- ✅ Accessibility: a Remove action, gains in words, a described donut
- □ Settings: currency, interval and appearance on screen; the release check (Phase 6)

---

## Future Improvements

- Holdings are positions, not transactions: buys and sells with realised P/L would be a `transactions` table (a v3 migration) and a different valuation.
- A currency's rate is fixed for the demo; a real app would store the rate used at purchase as well.
- `double` is fine for a simulated display app; a real ledger would store integer minor units or a decimal type.
- The coin picker could show each coin's price and the holdings already owned.

---

## Notes on This Phase

- **The simulator caught:**
  - **its keyboard types Arabic-Indic digits (١٢٣),** and the field's ASCII-only filter dropped every one: the amount stayed empty, so no number could be entered. Digits from Arabic and Persian keyboards (and the Arabic decimal separator) are now mapped to ASCII, in the field and in the parser, and tested (§11.126);
  - **the suggested buy price had the random walk's full precision** ("69762.39175474"). Suggestions are now as precise as a shown price ("69762.39"; four significant digits under one unit; none for yen);
  - **a holding's row wrapped "0.5 BTC · cost" mid-phrase.** The amount and the cost now have a line each;
  - the empty coin field was shorter than the text fields below it.
- **Tests caught:**
  - the form looked up the `ScaffoldMessenger` in `initState` (an inherited lookup there asserts); it now looks it up when a failure arrives;
  - the tour's 18 000-pixel-tall surface can't be rasterized when a dialog opens over a page (the page transition snapshots the page beneath), so that stop uses a phone-height surface (§11.127);
  - a `.first` finder throws instead of matching nothing (§11.128).
- **Seen on the simulator** (iPhone 17 Pro, light, dark, AX3):
  - the v1 → v2 migration ran on the device and kept the watchlist, in order;
  - a holding added with the picker and the Arabic keypad was valued at once, and stayed after a relaunch;
  - two holdings showed the donut with its gap and shares adding to 100 %;
  - a swipe removed Solana and Undo put it back with the same cost;
  - editing showed the stored values with the coin fixed, and Close asked before discarding;
  - at AX3 the totals, the donut, the rows and the form all fit.
- **Builds:** the Android debug APK and the iOS simulator app.
- **Mutation checks:**
  - 63 rules broken on purpose, one at a time, each against the **whole suite**;
  - **59 caught on the first pass; 3 more after new tests:**
    - *Leading zeros counted as digits:* no test typed a number with many leading zeros. "0000000000001" is now accepted as 1.
    - *The portfolio ignoring Pause:* the pipeline test never paused. It now does, and the listing says so.
    - *The form's close race:* after the seed, the success path checks the flag again, so the first check only guards the *error* path. A test now closes the form while a *failing* load is held at a gate and released mid-close.
  - **One equivalent:** *ties not ordered by id.* `id` is SQLite's rowid, so rows tied on time come back in id order anyway. The explicit `ORDER BY` stays as the guarantee.
  - **A CHECK, by hand with codegen** (the script doesn't regenerate drift's code): dropping the amount's `CHECK` is caught by three DAO tests.

| Area | Mutations | Notes |
|---|---:|---|
| Table, DAO and migration | 5 | ties by id (equivalent); an edit that changed nothing; `remove` returns the row; Undo keeps the id; the migration creates the table |
| Repository | 2 | UTC times; an edit keeps the price |
| Valuation | 6 | value at the price now; P/L % with a zero cost; 24 h from `open24h`; P/L % and 24 h % on the right base; positions flash |
| Allocation | 6 | one slice per coin; ties by rank; the remainder kept; on the largest slice; "Other" only past 5; 5 slices |
| Typed numbers and suggestions | 9 | a comma; 8 decimals; 12 digits; leading zeros; zero refused; Persian digits; the Arabic separator; the currency's decimals; 4 significant digits |
| Formatting | 4 | zero unsigned; the typographic minus; 8-decimal amounts; shares to the hundredth |
| Pipeline | 3 | the rate; the pause; directions |
| Cubits | 13 | both close races; euros stored as dollars; an edit shown in euros; an edit's coin fixed; a typed price kept; the suggestion filled once; `switchMap`; a holding gone meanwhile; a save failure said; a suggestion isn't a change; empty isn't an error yet; the cost at the rate |
| Views | 10 | a failed swipe slides back; Undo; the Remove action; prices converted; the Paused chip; Back and a link's Close ask; other scripts' digits; the suggestion shown; the saved form leaves |
| Design system | 4 | the donut described; the legend not read twice; the Remove action; gains in green |
| The cost line | 1 | the row shows what it cost |
