# Changelog

All notable changes to this project are documented here. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project follows [Conventional Commits](https://www.conventionalcommits.org/).

## [0.6.0] — 2026-11-14 — Phase 6: Settings + Documentation & CI

### Added
- **Settings:**
  - Currency (a radio list), Live prices (the same setting as the Market's Pause), Update every (1 s / 2 s / 5 s), Appearance (System / Light / Dark);
  - About: the name and version (`package_info_plus`), "Prices are simulated, not real market data.", the open-source licenses.
- **`SettingsCubit` above the router:** it starts from the stored settings, so the first frame has the chosen theme and currency.
- **Docs:** ARCHITECTURE, DATA_MODEL, TESTING, LEARNING_NOTES, INTERVIEW_NOTES, ROADMAP, SCREENSHOTS, STREAM_PIPELINES (final), the Phase 6 summary.
- **Open-source files:** CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, this CHANGELOG, the GitHub issue and PR templates.
- Tests for the Settings (the Cubit, the screen, a stored dark theme on the first frame, a currency converting every tab, a new interval's pace) and for the release manifest asking for no network.

### Changed
- The iOS launch screen follows the device's appearance (it was always white, a flash in dark mode).

## [0.5.0] — 2026-11-11 — Phase 5: Portfolio with Live Valuation

### Added
- **drift v2:** a `holdings` table (`CHECK`s, AUTOINCREMENT ids); the v1 → v2 migration from `make-migrations`, tested on every path and with data.
- **The live valuation:** `combineLatest3(ticks, holdings, currency)` → `valuePortfolio` (value, cost, P/L, the 24 h change from `open24h`); the allocation as the top 5 coins and "Other", in basis points that add up to exactly 100.00 %.
- **The Portfolio tab:** totals, the donut and its legend, rows that flash on ticks; edit, swipe (or a screen reader's Remove) with Undo restoring the same id.
- **The holding form:** a searchable coin picker; the buy price in the chosen currency (stored in dollars; suggested from the price now, as precise as a shown price); validation as you type; a live preview; a discard question.

### Fixed
- Digits typed on Arabic and Persian keyboards were dropped by the number fields.

## [0.4.0] — 2026-11-11 — Phase 4: Watchlist + Coin Detail + Charts

### Added
- **drift v1:** the watchlist (`watch_items`), the single source of truth for every star; the schema exported and checked.
- **The Watchlist tab:** starred coins in the order starred, live; remove with a swipe (which waits for the write) or the star, with Undo.
- **A coin's page:** `combineLatest6` (its own moves, history, highest price, the star, the settings, the chart's range); a flashing header; live stats (market cap from the price, an all-time high raised by any price seen); `PriceLineChart` (Live | 7 days) with its trend in words.

### Fixed
- A Cubit closed while its seed was loading could subscribe after closing (Phase 3's Market Cubit too).

## [0.3.0] — 2026-11-11 — Phase 3: Live Prices with Dart Streams

### Added
- **The engine:** `PriceTicker` (a `BehaviorSubject`, one timer, restarts without a jump), `RandomWalk` (stablecoins barely move, a pull back to the start), `PriceHistory` (a bounded `scan`), `TickerScheduler` + `LiveTicker` (interval, Pause and the app's lifecycle).
- **The pipelines:** price moves (`scan`, no glitch), the settled search (`switchMap` + a timer, an empty query at once), the market (`combineLatest5`).
- **The Market goes live:** flashes on each tick, cross-fading prices, Pause / Resume and a Paused chip; settings stored in `SharedPreferencesWithCache`.
- `docs/STREAM_PIPELINES.md`.

## [0.2.0] — 2026-11-10 — Phase 2: Models + Fake Seed + Static Market

### Added
- The domain models (a 24 h change **derived** from the price 24 h ago), the bundled 32-coin seed and fixed exchange rates, checked mappers, a repository that loads once.
- `MoneyFormatter` (per currency; four significant digits under one unit; compact amounts), the `Sparkline`, the search field and sort menu.
- The static Market: search, sort, loading, error and no-match states.

## [0.1.0] — 2026-11-10 — Phase 1: Foundation

### Added
- The project (Flutter 3.47.6 via FVM, `material_ui`, strict analysis), CI and the MIT license.
- The design system: market colors checked for contrast in both themes and over the flashes, `CoinBadge`, `PriceChangeBadge`, `CoinRow`.
- Typed routes: the four-tab shell, a coin and the holding form above it, deep links with a Close fallback, a not-found page.
