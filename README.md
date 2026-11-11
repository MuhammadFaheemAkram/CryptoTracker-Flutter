# 📈 CryptoTracker (Flutter)

[![Flutter CI](https://github.com/MuhammadFaheemAkram/CryptoTracker-Flutter/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/MuhammadFaheemAkram/CryptoTracker-Flutter/actions/workflows/flutter-ci.yml)
![Flutter 3.47.6](https://img.shields.io/badge/Flutter-3.47.6-02569B?logo=flutter)
![Dart 3.13](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

A live crypto market tracker, and the portfolio's **Dart Streams showcase**.

Prices move on a simulated ticker, and every screen is a **stream pipeline** over it:
- a market list derived from five inputs (`combineLatest`);
- a debounced search;
- green and red flashes from comparing each price with the last (`scan`);
- a bounded price history for the charts;
- a portfolio whose value and P/L recompute on every tick.

It's the Flutter counterpart of the Android edition's **Kotlin Flow** showcase and the iOS edition's **Combine** showcase.

> **Prices are simulated.** They start from a bundled snapshot of 32 coins and move by a random walk on your device. Nothing here is real market data or financial advice.

---

## 🔁 The one rule

```
One PriceTicker owns the live quotes: a stream that always has a current value.
Every price on every screen is DERIVED from it, by a stream pipeline:
    quotes ─┬─ combineLatest(query, sort, currency, watchlist) ─▶ market rows
            ├─ scan(previous, next) ─▶ up / down / flat per coin ─▶ the flashes
            ├─ scan(bounded buffer) ─▶ price history ─▶ the charts
            └─ combineLatest(holdings, currency) ─▶ the live portfolio valuation
No screen keeps its own copy of a price, and no list is patched by hand.
```

---

## ⏱️ How the simulated ticker works

- **It starts from the seed:** 32 coins with real-looking prices, loaded once at launch.
- **Each tick:**
  - every price takes one step of a random walk: up to ±1.5 % (±0.05 % for stablecoins), pulled 2 % back towards where it started, so a long session stays plausible;
  - a tick comes every 2 seconds by default (1, 2 or 5 in Settings, Phase 6).
- **The 24 h change is derived, never accumulated:**
  - each quote keeps the price 24 h ago from the seed;
  - the change is always `(price / open − 1) × 100`, however many ticks there have been (both native specs add each tick's movement to it, which drifts).
- **It stops when nobody can see it:**
  - in the background (`AppLifecycleListener`), and when the user pauses it (the Market's Pause button: moving content must be pausable, WCAG 2.2.2);
  - it carries on from the same prices when it resumes.
- **It's a `BehaviorSubject`:** a screen opened mid-session gets the current prices at once, then every tick.

The details, with diagrams: [STREAM_PIPELINES.md](docs/STREAM_PIPELINES.md).

---

## 📋 Project Status

Built in **strict, reviewable phases**. Each phase ends with:
- a building app (Android and iOS);
- a clean analyzer and passing tests;
- a mutation pass;
- a summary doc in [`docs/`](docs/);
- exactly one commit.

| Phase | Scope | Status |
|------:|-------|:------:|
| 1 | Foundation: the project, the design system (market colors, `CoinBadge`, `CoinRow`), typed routes and the 4-tab shell, CI | ✅ Done |
| 2 | Models, the bundled seed and a static Market (sort, search, sparklines) | ✅ Done |
| 3 | **Live prices with Dart streams:** the `PriceTicker`, the five-input pipeline, debounce, `scan` flashes, the price history, Pause | ✅ Done |
| 4 | Watchlist (drift v1) and Coin Detail with a hand-drawn live chart | ⏳ Next |
| 5 | Portfolio with live valuation (drift v2), the allocation donut, the holding form | ⬜ |
| 6 | Settings (currency, interval, appearance), the documentation set, the release check | ⬜ |

---

## ✨ Features (planned scope)

- 📈 **Market:** 32 coins ticking every 1, 2 or 5 seconds (or paused); rows flash green or red; 24 h change with ▲/▼; 7-day sparklines; debounced search; sort by rank, price, change or name.
- ⭐ **Watchlist:** starred coins, persisted, updating live.
- 🪙 **Coin Detail:** live price and 24 h change; market cap (supply × live price), volume, supply, all-time high; a price chart for the live ticks or the last 7 days.
- 💼 **Portfolio:** holdings valued live (value, cost, P/L in money and %), the total and its 24 h change, an allocation donut.
- ⚙️ **Settings:** USD / EUR / GBP / JPY (converted, not just relabelled), the update interval, System / Light / Dark.
- ♿ **Accessible:** color is never the only signal (arrows and signs), ticking prices don't flood screen readers, charts have text summaries, large text and dark mode on every screen.

---

## 🧰 Tech Stack

| Area | Choice | Why | Since |
|------|--------|-----|:-----:|
| Toolchain | Flutter 3.47.6 · Dart 3.13, pinned with [FVM](https://fvm.app) (`.fvmrc`) | Reproducible builds | 1 |
| Platforms | Android · iOS | | 1 |
| UI | [`material_ui`](https://pub.dev/packages/material_ui) | Material 3 as a standalone package | 1 |
| Navigation | `go_router` + `go_router_builder` | Typed routes; each tab keeps its state (`StatefulShellRoute`) | 1 |
| DI | `get_it` + `injectable` | Constructor injection, generated wiring (the Hilt equivalent) | 1 |
| Codegen | `build_runner` | Routes and DI are generated; generated files are committed | 1 |
| State | `flutter_bloc` (Cubits) | Each Cubit subscribes to its pipeline and emits immutable states | 2 |
| Models | `freezed` + `json_serializable` | Immutable models with value equality; checked DTOs | 2 |
| Formatting | `intl` | Prices in each currency, significant digits under one unit, compact amounts | 2 |
| Time | `clock` | An injectable "now" (fixed in tests) | 2 |
| **Streams** | **Dart `Stream` + `rxdart`** | `BehaviorSubject`, `combineLatest5`, `scan`, `switchMap`, `distinct` (see [STREAM_PIPELINES.md](docs/STREAM_PIPELINES.md)) | 3 |
| Preferences | `shared_preferences` (`SharedPreferencesWithCache`) | The settings, read before the first frame | 3 |
| Database | `drift` | The watchlist and holdings, observed as streams | 4 |
| Charts | `CustomPainter` | Hand-drawn sparkline, line chart and donut | 3–5 |

`package_info_plus` arrives with Settings (Phase 6). Tests use `flutter_test`, `bloc_test`, `mocktail`, `fake_async` and `async`'s `StreamQueue` (the Turbine of Dart).

---

## 🏛️ Architecture

Clean layers, with the streams below the widgets:

```
Widget (BlocBuilder)              renders state, calls intents
   ▲  state                 │ intents (search, sort, star)
Cubit                       owns its inputs (a query subject) and one subscription
   ▲  Stream<…>             │
Use case                    builds the pipeline: combineLatest, debounceTime, scan
   ▲                        │
Repository ── PriceTicker (BehaviorSubject: the live quotes)
           ── fake API (the seed, once) · drift (watchlist, holdings) · preferences
```

- **Pure functions** do the work inside the pipelines (`buildMarketRows`, `valuePortfolio`, …), so they're tested without streams.
- **Cubits** cancel their subscriptions in `close()`.

---

## 🗂️ Folder Structure

```
lib/
├── main.dart                     # await configureDependencies() (preferences open), runApp
├── app/                          # CryptoTrackerApp (MaterialApp.router, themes), LiveTicker (lifecycle)
├── core/
│   ├── common/                   # Result, AppException
│   ├── design_system/            # AppTheme, AppColors, tokens, widgets/ (CoinRow, CoinBadge, …), charts/ (Sparkline)
│   ├── formatting/               # MoneyFormatter, PercentFormatter (pure Dart)
│   ├── navigation/               # typed routes, the router, the Close fallback
│   ├── network/                  # MarketApi, FakeMarketApi, AssetJsonLoader, dto/
│   ├── prices/                   # PriceTicker, RandomWalk, PriceHistory, TickerScheduler (the engine)
│   └── storage/                  # SettingsLocalDataSource (SharedPreferencesWithCache)
├── data/                         # mappers (checked), MarketRepositoryImpl (load once, seeds the ticker), settings
├── domain/                       # models, pipeline/ (pure pieces), repository contracts, use cases (the pipelines)
├── di/                           # injection.dart, AppModule
└── features/
    ├── shell/                    # the 4-tab NavigationBar
    ├── market/                   # MarketCubit, MarketState, MarketPage, MarketView
    └── watchlist/ portfolio/ settings/ coin_detail/ holding_form/   # placeholders for now
assets/json/                      # coins_seed.json (the iOS edition's), exchange_rates.json
test/                             # mirrors lib/; helpers/ (fixtures, fakes, the app harness, contrast)
```

---

## ▶️ Running

```bash
fvm install                                  # Flutter 3.47.6, from .fvmrc
fvm flutter pub get
fvm dart run build_runner build              # routes and DI are generated
fvm flutter run
```

Checks, as CI runs them:

```bash
fvm dart format --output=none --set-exit-if-changed .
fvm flutter analyze
fvm flutter test
```

---

## 🌐 The fake market service and the data

- **No backend:**
  - `FakeMarketApi` answers from bundled JSON after 600 ms per request;
  - the repository asks for the coins and the rates at once, so the first screen waits about that long;
  - a real HTTP client could replace it behind `MarketApi` without changing a caller.
- **The seed** is the iOS edition's `coins_seed.json`:
  - 32 coins, with prices sent **as strings**, as many market APIs do;
  - a 24-point 7-day sparkline and the all-time high;
  - plus `is_stablecoin` for USDT, USDC and DAI.
- **`exchange_rates.json`** holds fixed demo rates per dollar.
- **Checked on the way in:**
  - every value is parsed and validated by the mappers (a positive price, a change above −100 %, a rate for every currency);
  - one damaged record fails the load, and the Market offers "Try again".
- **Loaded once:**
  - the repository keeps the first success, shares a load already in flight, and tries again after a failure;
  - from Phase 3 the prices move on the ticker, not by reloading.
- **Money is US dollars** everywhere below the UI. A currency is applied only when a value is formatted (and, from Phase 5, when a buy price is typed).

---

## 🧪 Testing

- **The design system:**
  - every text color (up, down, flat, body, secondary) reaches WCAG AA on every surface it sits on, including both flashes, in both themes;
  - `CoinBadge`'s letters reach AA on every hue (white or black, whichever contrasts more);
  - `CoinRow` is one button for screen readers, stacks above 130 % text, and cuts a long name, never the price.
- **Formatting:** the sign and the arrow always agree (checked across every rounding boundary from −3 % to +3 %); prices under one unit keep four significant digits; every currency converts.
- **The data:** the bundled seed (32 coins, ranks 1–32, exactly three stablecoins); mappers that reject every damaged value; a repository that loads once, shares a load in flight, retries after a failure, and lets bugs through.
- **The streams:**
  - the ticker, the debounce, the history and the scheduler in fake time;
  - the market pipeline with `StreamQueue` (each of its five inputs);
  - one state per tick (no glitch);
  - the 24 h change after 500 ticks is still exact.
- **The Market:**
  - `buildMarketRows` (search × sort, ties by rank);
  - the Cubit on the real pipeline;
  - the view in every state with `MockCubit`;
  - flows on the real DI graph (it ticks; Pause stops it; Resume restarts it);
  - flashes only on new ticks, and none with reduced motion.
- **Navigation:** the tabs, a coin above them, the holding form as a full-screen dialog, deep links with Close, encoded ids, not found.
- **The accessibility tour:** every screen, light and dark, at 200 % text.
- **Architecture rules:** the domain and the formatters are plain Dart; the design system knows no screens; screens never reach the data layer; `getIt` only where the conventions allow it.

**356 tests** after Phase 3.

---

## 📚 Docs

- [Phase 1 summary](docs/PHASE_1_SUMMARY.md): the foundation, the market colors and their contrast, `CoinBadge` and `CoinRow`, the routes
- [Phase 2 summary](docs/PHASE_2_SUMMARY.md): the models (a derived 24 h change), the seed, checked mappers, a repository that loads once, the static Market
- [Phase 3 summary](docs/PHASE_3_SUMMARY.md): the live market, every stream operator in it, Pause, and two fake-time traps

**[STREAM_PIPELINES.md](docs/STREAM_PIPELINES.md):** every pipeline as a marble diagram, why each operator, how they're tested, and the Flow ↔ Combine ↔ Dart table.

---

## 📸 Screenshots

Phase 6 collects them.

---

## 🗺️ Roadmap

Phases 4–6 above. Later: a real price feed (a WebSocket) behind the same stream, price alerts, transactions instead of holdings.

---

## 📱 Same app on other platforms

| Edition | Repo |
|---|---|
| Android (Kotlin, Compose, Flow, Hilt, Room) | [CryptoTracker](https://github.com/MuhammadFaheemAkram/CryptoTracker) |
| iOS (Swift 6, SwiftUI, Combine, SwiftData) | [iCryptoTracker](https://github.com/MuhammadFaheemAkram/iCryptoTracker) |
| **Flutter (this repo)** | CryptoTracker-Flutter |

| Concept | Android | iOS | **Flutter** |
|---|---|---|---|
| Live source | `MutableStateFlow` | `CurrentValueSubject` | **`BehaviorSubject` (rxdart)** |
| Multi-input derivation | `combine` | `CombineLatest4` | **`Rx.combineLatest5`** |
| Debounce | `debounce(300)` | `.debounce(for:)` | **`debounceTime(300 ms)`** |
| Change detection | `scan` | `scan` | **`scan`** |
| View state | ViewModel + `StateFlow` | `@Observable` | **Cubit** |
| Stream tests | Turbine | collected values | **`StreamQueue`, `fake_async`** |
| Persistence | Room | SwiftData | **drift** |
| Charts | Compose Canvas | Swift Charts | **`CustomPainter`** |

---

## 📄 License

[MIT](LICENSE) © 2026 BitFuse
