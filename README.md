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
| 2 | Models, the bundled seed and a static Market (sort, search) | ⏳ Next |
| 3 | **Live prices with Dart streams:** the `PriceTicker`, the five-input pipeline, debounce, `scan` flashes, the price history | ⬜ |
| 4 | Watchlist (drift v1) and Coin Detail with a hand-drawn live chart | ⬜ |
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
| **Streams** | **Dart `Stream` + `rxdart`** | `BehaviorSubject`, `combineLatest`, `debounceTime`, `scan`, `switchMap` | 3 |
| Database | `drift` | The watchlist and holdings, observed as streams | 4 |
| Charts | `CustomPainter` | Hand-drawn sparkline, line chart and donut | 3–5 |

The rest arrive with their phase (`freezed`, `json_serializable`, `intl`, `shared_preferences`, `clock`, `package_info_plus`; tests: `bloc_test`, `fake_async`, `async`'s `StreamQueue`).

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
├── main.dart                     # configureDependencies(), runApp
├── app/                          # CryptoTrackerApp (MaterialApp.router, themes)
├── core/
│   ├── design_system/            # AppTheme, AppColors (up/down/flat + flashes), tokens, widgets/
│   ├── formatting/               # PercentFormatter (money formatters in Phase 2)
│   └── navigation/               # typed routes, the router, the Close fallback
├── domain/model/                 # PriceDirection (pure Dart)
├── di/                           # injection.dart (+ the generated config)
└── features/
    ├── shell/                    # the 4-tab NavigationBar
    └── market/ watchlist/ portfolio/ settings/ coin_detail/ holding_form/   # placeholders for now
test/                             # mirrors lib/; helpers/ (pump helpers, the app harness, contrast)
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

## 🧪 Testing

- **The design system:**
  - every text color (up, down, flat, body, secondary) reaches WCAG AA on every surface it sits on, including both flashes, in both themes;
  - `CoinBadge`'s letters reach AA on every hue (white or black, whichever contrasts more);
  - `CoinRow` is one button for screen readers, stacks above 130 % text, and cuts a long name, never the price.
- **Formatting:** the sign and the arrow always agree (checked across every rounding boundary from −3 % to +3 %).
- **Navigation:** the tabs, a coin above them, the holding form as a full-screen dialog, deep links with Close, encoded ids, not found.
- **The accessibility tour:** every screen, light and dark, at 200 % text.
- **Architecture rules:** the domain and the formatters are plain Dart; the design system knows no screens; screens never reach the data layer; `getIt` only where the conventions allow it.

**144 tests** after Phase 1.

---

## 📚 Docs

- [Phase 1 summary](docs/PHASE_1_SUMMARY.md): the foundation, the market colors and their contrast, `CoinBadge` and `CoinRow`, the routes

`docs/STREAM_PIPELINES.md` (every pipeline as a marble diagram, with a Flow ↔ Combine ↔ Dart table) arrives with Phase 3.

---

## 📸 Screenshots

Phase 6 collects them.

---

## 🗺️ Roadmap

Phases 2–6 above. Later: a real price feed (a WebSocket) behind the same stream, price alerts, transactions instead of holdings.

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
