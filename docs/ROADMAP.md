# Roadmap

Ideas for after the six phases, roughly from "smallest change" to "biggest". Each says what it would teach and what it would touch, because the point of this project is the architecture.

---

## Market data

- **A real price feed** (a WebSocket) behind the same `quotes` stream.
  - Only `PriceTicker` changes: it would `add` what the socket sends instead of what the walk makes. Nothing above the repository would know.
  - It teaches reconnecting with backoff, and what a hot stream does while nobody listens.
- **Candlestick charts and more ranges** (1 h, 24 h), with touch scrubbing on the line chart (a `GestureDetector` over the painter, the price at the touched point read aloud).
- **A 7-day chart that moves:** today it's the seed's 24 points. A real API would refresh it, or the history could append to it.

## The user's data

- **Price alerts** ("tell me when BTC crosses $70k"):
  - a drift table of alerts and a pipeline comparing each tick with them (`scan` to fire once per crossing);
  - `flutter_local_notifications`, as in Momentum and Evently.
- **Reordering the watchlist:** a `position` column, a v3 migration and a reorderable list.
- **Several portfolios.**
- **Transactions instead of holdings:** buys and sells, average cost, realised and unrealised P/L. A different valuation function, the same pipeline.
- **The rate at purchase:** store the exchange rate used when a holding was bought, so a cost in euros stays the euros paid.

## Correctness at scale

- **Decimal money:** integer minor units (cents, satoshis) or a decimal package, for a real ledger. `double` is fine for a simulated display app, and the docs say why.
- **Isolates for heavy recomputation:** with thousands of coins, `buildMarketRows` could run in an isolate (`compute`), and the pipeline would `asyncMap` to it.
- **A 7-day history on disk:** a time series that survives restarts, with downsampling.

## Platform

- **App icons and a splash** of the app's own (it still has Flutter's default icon).
- **Home-screen widgets** (a watchlist widget) through `home_widget`.
- **Localization:** the strings through `intl`'s ARB files; the currency formatting already takes a locale.
- **A tablet layout:** the Market and a coin's page side by side.

## Testing

- **Golden tests** of the charts (the sparkline, the line chart, the donut) in both themes.
- **An integration test on a device** (`integration_test`) for the live flows, which the host tests can only drive in fake time.
