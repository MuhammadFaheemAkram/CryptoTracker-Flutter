# Data Model

What CryptoTracker knows, where each piece lives, and what is deliberately **not** kept.

---

## The rule for money

**Every amount below the UI is in US dollars**, as a `double`.
- A currency is a **rate** applied at the edges:
  - when a value is formatted (`MoneyFormatter(currency, rate:)`);
  - when a typed buy price is saved (divided by the rate).
- Changing the currency therefore changes no stored value; a test checks that the portfolio's valuation is *equal* before and after, with only the rate different.
- `double` is acceptable for a simulated display app. A real ledger would store integer minor units (cents, satoshis) or use a decimal type (see the [roadmap](ROADMAP.md)).

---

## Domain models (`lib/domain/model/`, freezed, plain Dart)

### The market
| Model | Holds | Notes |
|---|---|---|
| `Coin` | id, symbol, name, rank, market cap, 24 h volume, circulating and total supply, all-time high, `isStablecoin`, 24 points of 7-day sparkline | What doesn't tick. From the seed. `totalSupply` is `null` for no maximum ("Unlimited") |
| `Quote` | coinId, `priceUsd`, **`open24hUsd`**, `updatedAt` | `change24hPercent` is **derived**: `(price / open24h − 1) × 100`, never accumulated tick by tick (Correctness Rule 1) |
| `MarketSeed` | the coins (rank order), their first quotes, the rates | Loaded once per launch |
| `ExchangeRates` | units of each `Currency` per dollar | Fixed demo rates: EUR 0.92, GBP 0.79, JPY 151.2 |
| `Currency` | USD, EUR, GBP, JPY: code, symbol, decimals | Yen has no decimals |
| `PriceSnapshot` | every quote + which way each moved | One per tick, from one `scan` (no glitch) |
| `PricePoint` | at, priceUsd | The Live chart's points |
| `PriceDirection` | up, down, flat | `ofChange` treats a change that rounds to 0.00 % as flat |

### What the pipelines emit
| Model | Holds |
|---|---|
| `MarketCoin` | coin, quote, direction, isWatched: one row |
| `MarketListing` | the rows, and the query, sort, currency, rate and pause that shaped them |
| `WatchlistListing` | the starred rows (starred order), currency, rate, pause |
| `CoinDetail` | coin, quote, direction, live points, highest seen, starred, chart range, currency, rate, pause; getters: **market cap** = circulating × price now, **all-time high** = max(seed, seen, now), `chartPoints` |
| `PortfolioPosition` | holding, coin, quote, direction; getters: value, cost, profit, profit %, open value, 24 h change |
| `Allocation` | label, symbol (null for "Other"), value, **basis points** (shares sum to exactly 10 000) |
| `PortfolioValuation` | positions, allocations, totals (value, cost, P/L and %, 24 h and %) |
| `PortfolioListing` | the valuation, currency, rate, pause |

### What the user keeps
| Model | Holds | Stored in |
|---|---|---|
| `WatchedCoin` | coinId, addedAt | drift `watch_items` |
| `Holding` | id, coinId, amount, `buyPriceUsd`, createdAt | drift `holdings` |
| `AppSettings` | currency, interval (1 / 2 / 5 s), `livePricesPaused`, theme mode | preferences |

### Other
`ChartRange` (Live, 7 days), `SortOption` (rank, price, 24 h, name), `TickInterval`, `AppThemeMode`, `AppInfo` (name, version, build), `DecimalInputError` (why a typed number can't be saved).

---

## The seed (`assets/json/`)

- **`coins_seed.json`:** the iOS edition's 32 coins.
  - Prices come **as strings**, as many market APIs send them.
  - Each has a 24-point 7-day sparkline and the all-time high, plus `is_stablecoin` (USDT, USDC, DAI).
  - The mappers reject a price that isn't a positive number, a change at or below −100 %, a blank name, a duplicate id. One damaged record fails the load, and the Market offers "Try again".
- **`exchange_rates.json`:** per dollar; USD must be 1 and every currency must have a rate.

---

## The database (drift, `lib/core/database/`)

One `AppDatabase` (`crypto_tracker.sqlite` in the app's documents directory, opened in a background isolate by `drift_flutter`). Dates are stored as ISO-8601 text.

### v1 (Phase 4): the watchlist
```sql
CREATE TABLE watch_items (
  coin_id  TEXT NOT NULL PRIMARY KEY CHECK (length(coin_id) > 0),
  added_at TEXT NOT NULL
);
```
- `WatchlistDao`:
  - `watchAll()` (oldest first, ties by id) and `watchContains(id)`: live queries;
  - `add` (INSERT OR IGNORE: a second star keeps the first time and the place);
  - `remove` (returns the row, in a transaction);
  - `restore` (the same row: Undo puts it back in its place).

### v2 (Phase 5): the holdings
```sql
CREATE TABLE holdings (
  id            INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  coin_id       TEXT    NOT NULL CHECK (length(coin_id) > 0),
  amount        REAL    NOT NULL CHECK (amount > 0),
  buy_price_usd REAL    NOT NULL CHECK (buy_price_usd > 0),
  created_at    TEXT    NOT NULL
);
```
- `PortfolioDao`:
  - `watchAll()` (live) and `find(id)`;
  - `add`;
  - `change` (**one `UPDATE`**, so no read-modify-write a tick could slip into);
  - `remove` (returns the row);
  - `restore` (the same row and **the same id**: AUTOINCREMENT never reuses an id, so Undo can't collide).
- **Plain inserts, never OR IGNORE:** SQLite's OR IGNORE also skips a row that fails a `CHECK`, so a bad holding would silently not be saved. The `CHECK`s back up the form's validation (Correctness Rule 11).

### The migration (v1 → v2)
- `make-migrations` exported each schema (`drift_schemas/app_database/drift_schema_v1.json`, `…_v2.json`) and generated `app_database.steps.dart`.
- `stepByStep(from1To2: createTable(holdings))`: the watchlist is untouched, and the holdings start empty.
- **Tested** (`test/drift/app_database/`):
  - every upgrade path ends at the latest exported schema;
  - a v1 watchlist survives with its order and its dates (`testWithDataIntegrity`);
  - after the upgrade the app reads it and saves a holding;
  - a fresh install creates exactly the latest schema.
- It also ran for real on the simulator over the Phase 4 install, and the starred coins survived.

---

## Preferences (`SharedPreferencesWithCache`, `lib/core/storage/`)

| Key | Values | Default |
|---|---|---|
| `settings.currency` | `usd` `eur` `gbp` `jpy` | `usd` |
| `settings.interval` | `oneSecond` `twoSeconds` `fiveSeconds` | `twoSeconds` |
| `settings.livePricesPaused` | `true` / `false` | `false` |
| `settings.themeMode` | `system` `light` `dark` | `system` |

- **Read before the first frame** (`@preResolve`), so the theme and the currency never flash.
- An unknown stored value falls back to the default.
- **Only changed keys are written.**

---

## What is NOT persisted, and why

| Not stored | Why |
|---|---|
| **Prices** (quotes) | The market is simulated: it starts again from the seed at every launch, as a fake server would. Storing a random walk would only make it look real |
| **The price history and highs** | They're "since launch" by definition: the Live chart and the all-time high raised by the session |
| **The seed** | It's bundled with the app; reading it again is cheaper than caching it |
| **A conversion at purchase** | The rates are fixed; a real app would store the rate used when a holding was bought |

Nothing leaves the device: there is no network code, and the release build asks for no network permission.
