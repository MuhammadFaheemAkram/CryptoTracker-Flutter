# Phase 1 — Foundation

## Phase Goal

Lay the ground the live market will run on, before any data exists:
- **a project that builds, checks itself and runs on both platforms:** FVM, strict analysis, codegen, CI, the app ID;
- **a design system that already knows what a market needs:**
  - colors for **up**, **down** and **flat**, and for a row's **flash**, each tested for contrast on everything it can sit on;
  - `CoinBadge` (no images: the app runs offline);
  - `CoinRow`, the row every list will use;
  - `PriceChangeBadge`, where color is never the only signal;
- **navigation:** four tabs that keep their state, a coin above them, and the holding form as a full-screen dialog. Every route is typed, deep links have a way out, and unknown paths get "not found".

No streams yet: Phase 2 brings the data and Phase 3 makes it move. This phase decides *where* each piece will live, so the pipelines have a clean home.

---

## What Was Implemented

- **The project:**
  - `crypto_tracker`, Flutter 3.47.6 via FVM (the global version is untouched);
  - the app ID `co.bitfuse.flutter.cryptotracker` on both platforms (`flutter create` derived `…crypto_tracker` for Android and `…cryptoTracker` for iOS) and the display name "CryptoTracker";
  - `material_ui`; strict analysis (`strict-casts`, `strict-inference`, `strict-raw-types` and extra lints); `build.yaml` (lint headers for generated parts);
  - GitHub Actions CI (codegen up to date, format, analyze, test) and the MIT license.
  - `cupertino_icons` was dropped (nothing uses it). No INTERNET permission is needed: the app loads nothing from the network.
- **Design system** (`core/design_system/`):
  - `AppTheme`: Material 3 from an indigo seed (`fidelity` variant). Deliberately neither green nor red, which mean up and down here.
  - `AppColors` (a `ThemeExtension`): `up`, `down`, `flat`, `upFlash`, `downFlash`, light and dark.
  - Tokens (spacing, radius, icon sizes), `prefersStackedLayout` (the large-text rule), `LoadingView`, `ErrorView`, `EmptyStateView`.
  - **`CoinBadge`:** the symbol in a circle; the color comes from FNV-1a of the symbol, the letters are white or black, whichever contrasts more.
  - **`PriceChangeBadge`:** ▲ +2.41 % / ▼ −1.20 % / 0.00 %, with tabular digits and a spoken label.
  - **`CoinRow`:** rank, badge, name and symbol, price and change. One button for screen readers; stacked above 130 % text; a trailing slot (the star, Phase 4).
- **Formatting** (`core/formatting/`): `PercentFormatter`, signed and two decimals, built from whole hundredths so it rounds exactly as `PriceDirection.ofChange` does.
- **Domain:** `PriceDirection` (up / down / flat), with `ofChange`, which treats a change that rounds to 0.00 % as flat.
- **Navigation** (`core/navigation/`):
  - typed routes: the four-branch shell (`/market`, `/watchlist`, `/portfolio`, `/settings`);
  - `/coins/:coinId`, `/holdings/new?coin-id=…` and `/holdings/:holdingId/edit` (an `int`; full-screen dialogs);
  - `/` redirects to the Market;
  - a not-found page; the Close fallback for screens opened by a link.
- **Screens:** placeholders with their final app bars, wired to each other (Market → a coin → Add to portfolio; Portfolio → Add holding).
- **DI:** `getIt` + `injectable`, empty until Phase 2.
- **144 tests.**

---

## Flutter / Dart Concepts Demonstrated

- **`ThemeExtension`** for meanings Material has no slot for. Widgets ask `context.appColors.up`, and light and dark switch (and animate, via `lerp`) with the theme.
- **Contrast as a test, not a hope:**
  - every text color is checked against every background it can appear on (the page, a card, a filled surface, both flashes) in both themes;
  - the badge's letters are checked for all 360 hues and all 256 grays.
  - Why pure black: white and black tie at a luminance of 0.179, where both give 4.58:1. With a near-black (#111), the tie drops to 4.35:1, below AA.
- **A stable hash:** `String.hashCode` isn't promised to stay the same across Dart versions or platforms, so badge colors use FNV-1a (a few lines, pinned by a test).
- **`FittedBox(fit: BoxFit.scaleDown)`:** the default (`contain`) also *enlarges*, which made "OP" twice the size of "BTC" (seen on the simulator, then pinned by a test).
- **`TextScaler.noScaling`** inside a fixed-size decoration, and `MediaQuery.withNoTextScaling` for the tab bar's labels.
- **Tabular figures** (`FontFeature.tabularFigures()`): every digit equally wide, so a ticking price won't jitter from Phase 3 on.
- **Semantics by design:**
  - `CoinRow` replaces its inner nodes with one labelled button (`Semantics(excludeSemantics:)` + `InkWell(excludeFromSemantics:)`), so nothing is read twice;
  - the trailing control keeps a node of its own;
  - an `IconButton`'s tooltip is a semantic *tooltip*, not a label.
- **Typed routes:**
  - `TypedStatefulShellRoute` (tabs that keep their state);
  - an `int` path parameter (a non-number matches no route);
  - a query parameter (go_router_builder writes its name in kebab-case: `coin-id`);
  - `buildPage` returning a `MaterialPage(fullscreenDialog: true)`;
  - a top-level `redirect`.
- **`ModalRoute.impliesAppBarDismissal`:** whether *this* screen has one below it (not `Navigator.canPop()`, conventions §11.96), for the Close fallback.
- **Dart 3:** exhaustive `switch` expressions with relational patterns (`> 0 => up`), records in tests, null-aware elements (`?trailing`).

---

## Stream Concepts Demonstrated

None yet, on purpose. Phase 1 prepares the places streams will flow through:
- `PriceDirection` exists now because both kinds of direction use it:
  - the 24 h change's arrow (this phase);
  - the per-tick flash, which a `scan` over the ticker will compute in Phase 3.
- The formatters are pure Dart (an architecture test checks this), so the pipelines can format inside a `map` without Flutter.
- The app widget is where the app-level `LiveTicker` will go (start, stop, restart the ticker), above `MaterialApp.router`.

| Coming in | Operators |
|---|---|
| Phase 2 | none: the seed is a `Future`, loaded once |
| Phase 3 | `BehaviorSubject`, `Rx.combineLatest5`, `debounceTime`, `distinct`, `startWith`, `scan`, `switchMap` |
| Phase 4 | drift's `watch()` streams, `combineLatest` for a coin |
| Phase 5 | `Rx.combineLatest3` for the portfolio |

---

## Data Flow

No data yet. Navigation:

```
MarketPage ──push──▶ /coins/:coinId ──push──▶ /holdings/new?coin-id=…   (full-screen dialog)
PortfolioPage ──push──▶ /holdings/new
a deep link ──▶ any of them, with Close (no Back) → the tab it normally opens from
/ ──redirect──▶ /market          anything else ──▶ "Page not found"
```

---

## Important Files Added

| File | Purpose |
|---|---|
| `lib/core/design_system/theme/app_colors.dart` | `up` / `down` / `flat` and the two flashes |
| `lib/core/design_system/theme/app_theme.dart` | Material 3 from the seed |
| `lib/core/design_system/widgets/coin_badge.dart` | The symbol in a deterministic color |
| `lib/core/design_system/widgets/price_change_badge.dart` | ▲/▼, sign, color and a spoken label |
| `lib/core/design_system/widgets/coin_row.dart` | The row every list will use |
| `lib/core/formatting/percent_formatter.dart` | "+2.41%" and "Up 2.41%" |
| `lib/domain/model/price_direction.dart` | Up / down / flat, rounded as shown |
| `lib/core/navigation/app_routes.dart` (+ `.g.dart`) | The typed route tree |
| `lib/core/navigation/app_router.dart` | The router, the root redirect, not found |
| `lib/features/shell/main_shell.dart` | The four tabs |
| `test/core/design_system/theme/app_theme_test.dart` | Every contrast pair, both themes |
| `test/app/accessibility_tour_test.dart` | Every screen at 200 %, light and dark |
| `test/architecture/architecture_test.dart` | The layer rules |

---

## Important Types Added

| Type | Responsibility | Layer |
|---|---|---|
| `AppColors` | The market's colors, as a theme extension | design system |
| `CoinBadge` | An offline, deterministic coin icon | design system |
| `PriceChangeBadge` | A change shown three ways (arrow, sign, color) | design system |
| `CoinRow` | One coin in a list, one node for screen readers | design system |
| `PercentFormatter` | Signed percentages, in text and in words | core/formatting (pure Dart) |
| `PriceDirection` | Up / down / flat | domain |
| `MarketRoute` … `EditHoldingRoute` | Typed destinations | navigation |
| `AppTab`, `MainShell` | The tabs | features/shell |

---

## Folder Structure Changes

```
lib/app/  core/design_system/  core/formatting/  core/navigation/  domain/model/  di/
features/{shell, market, watchlist, portfolio, settings, coin_detail, holding_form}
test/{app, architecture, core, domain, di, helpers}
.github/workflows/flutter-ci.yml  analysis_options.yaml  build.yaml  LICENSE
```

---

## Android / iOS Comparison

| Concept | Android | iOS | Flutter |
|---|---|---|---|
| Market colors | theme colors in Compose | `Theme` | `AppColors` `ThemeExtension`, AA-tested on every background |
| Coin icons | Coil + icon URLs | bundled image names | `CoinBadge`: the symbol, colored by FNV-1a; offline |
| Price-change badge | `PriceChangeBadge` | `PriceChangeBadge` | the same, with ▲/▼ + sign + a spoken label |
| Row | `CoinRow` composable | `CoinRow` view | `CoinRow`, one semantics node, stacked at large text |
| Tabs | bottom nav + Navigation Compose | `TabView` | `StatefulShellRoute.indexedStack` |
| Detail route | `coinDetail/{coinId}` | `Route.coinDetail(id:)` | `CoinDetailRoute` (typed) |
| Add Holding | dialog / bottom sheet | sheet | a full-screen dialog route (also from Coin Detail) |
| DI | Hilt | `AppEnvironment` | `get_it` + `injectable` |
| CI | Phase 6 | Phase 6 | Phase 1 |

---

## Interview Notes

- **"How do you add colors Material doesn't have?"** A `ThemeExtension`: it lives in `ThemeData`, switches with light and dark, and animates through `lerp`. Widgets ask for an intent (`up`), never a hex value.
- **"How do you know your colors are accessible?"**
  - Test them: every foreground against every background it can sit on, in both themes, against WCAG AA.
  - For generated colors, test the rule: for any background, white or black, whichever contrasts more, always reaches 4.58:1.
- **"Why not `String.hashCode` for a stable color?"** Dart doesn't promise it's stable across versions or platforms. FNV-1a is a few lines and always the same.
- **"How do you make a list row accessible?"**
  - One node per row, with a label that says everything and a tap action, and the inner texts excluded so nothing is read twice.
  - Interactive extras (the star) keep their own nodes.
  - Color is never the only signal.
- **"Why a full-screen dialog route instead of a bottom sheet?"** It's a form with a keyboard and validation. A route can be opened from two places (the Portfolio and a coin) and deep-linked, and the dialog gives it Close instead of Back.

---

## Learning Checklist

- ✅ FVM project, strict analysis, codegen, CI
- ✅ A theme extension with contrast-tested market colors
- ✅ A deterministic, offline coin badge with guaranteed letter contrast
- ✅ A row that is one accessible button and adapts to large text
- ✅ Typed routes: shell, root-level detail, full-screen dialogs, int and query parameters, redirect, not found
- ✅ The accessibility tour and architecture rules from day one
- □ The seed, the models and a static market (Phase 2)
- □ Live prices with Dart streams (Phase 3)

---

## Future Improvements

- `CoinRow` gains the flash (Phase 3), the sparkline (Phase 2) and the star (Phase 4).
- Re-tapping the Market tab could scroll its list to the top once there is a list.

---

## Notes on This Phase

- **Seen on the simulator** (iPhone 17 Pro), with a scratch preview of the rows and all 32 badges, never committed:
  - the rows read well in light and dark, and at AX3 they stack (the price under the name, the rank with the symbol);
  - the badges' letters varied wildly in size ("OP" and "FIL" huge, "ATOM" tiny), because `FittedBox` scales *up* by default. Now `scaleDown`, with a test;
  - the placeholders, a coin above the tabs, and the holding form sliding up with Close (and the coin passed from the coin's page);
  - the appearance, text size and status bar were restored afterwards.
- **A design check caught before the tests:** near-black letters (#111) would have broken the badge's contrast guarantee (4.35:1 at worst), so they're pure black.
- **The light up-flash was too faint** (1.10 against the page, under the test's floor), so it's a little greener now; every text color still reaches AA on it.
- **Builds:** the Android debug APK and the iOS simulator app.
- **Mutation checks:**
  - 28 rules broken on purpose, one at a time, each against the **whole suite**;
  - **26 caught on the first pass; the other 2 now are**, each by a test that was there but measured the wrong thing:
    - *Badge letters grown to fit* (`scaleDown` removed): the test compared sizes with `getSize`, which is the text before `FittedBox` scales it. Even with `getRect` (the painted size), "OP" exactly fills the circle in the test font's square glyphs, so it now uses a one-letter symbol and checks that the painted size never exceeds the natural one.
    - *The Close fallback asking the whole stack* (`Navigator.canPop()`): the placeholder coin page never rebuilds itself while covered (a theme change rebuilds only its children). A direct test (`fallback_close_button_test.dart`) now rebuilds a linked page while another covers it. From Phase 4 the coin page rebuilds on every tick, so this is the rule that keeps its Close.
  - The runner reports a mutation that fails to compile separately, so a broken mutation can't pass for a catch; none did.

| Area | Mutations | Notes |
|---|---:|---|
| Direction and formatting | 6 | zero is flat; NaN guarded; the typographic minus; no sign on zero; two padded decimals; the spoken words |
| `CoinBadge` | 5 | case-insensitive color; white or black by contrast; only shrinks; hidden from screen readers; four letters |
| `PriceChangeBadge` | 3 | up and down colors; no arrow when flat; tabular digits |
| `CoinRow` and large text | 5 | read once; a button only with `onTap`; stacks above 130 %; a long name cut short; the 130 % threshold |
| Theme | 4 | up text AA; dark flashes AA; a seed neither green nor red; `fidelity` |
| Navigation | 5 | `/` to the Market; forms as full-screen dialogs; Close on a linked coin; the tab labels don't scale; the Close fallback asks about its own route |
