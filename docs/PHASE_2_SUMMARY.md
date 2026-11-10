# Phase 2 — Models + Fake Seed + Static Market

## Phase Goal

Give the market its data, and show it, before anything moves:
- **the models:** a `Coin` (what doesn't tick) separate from its `Quote` (what will), money in US dollars, and exchange rates that **convert** rather than relabel;
- **the seed:**
  - the iOS edition's 32 coins, behind a fake service that is slow, can fail, and sends prices as strings, like many real ones;
  - mappers that check every value;
  - a repository that loads it **once**;
- **a static Market:**
  - every coin with its price, 24 h change and 7-day sparkline;
  - search by name or symbol, four sort orders;
  - loading, error ("Try again") and no-match states.

The list is already **derived**: `buildMarketRows(coins, quotes, query, sort)` is a pure function, recomputed on every change. Phase 3 feeds the same function from a stream pipeline, so the only thing that changes then is *where its inputs come from*.

---

## What Was Implemented

- **Domain** (`domain/`, pure Dart):
  - `Coin`, `Quote` (keeps `open24hUsd` and **derives** the 24 h change), `MarketCoin` (a row), `MarketSeed`, `Currency` (code, symbol, decimals), `ExchangeRates` (`fromUsd`, `toUsd`), `SortOption`;
  - `buildMarketRows` and `matchesQuery` (`domain/pipeline/`);
  - the `MarketRepository` contract and `LoadMarketUseCase`.
- **The seed** (`assets/json/`):
  - `coins_seed.json`: the iOS edition's 32 coins (prices as strings, a 24-point 7-day sparkline, the all-time high), with `is_stablecoin` on USDT, USDC and DAI, and the iOS-only `icon_name` removed;
  - `exchange_rates.json`: fixed demo rates per dollar (EUR 0.92, GBP 0.79, JPY 151.2).
- **Network** (`core/network/`):
  - `MarketApi` and `FakeMarketApi` (600 ms per request, the conventions' `shouldThrowError` switch);
  - `AssetJsonLoader` (`loadObject`);
  - checked DTOs: `CoinDto`, `ExchangeRatesDto` (snake_case on the wire).
- **Data** (`data/`):
  - **mappers** that reject anything that would break the app later: a price that isn't a positive number, a −100 % change, a blank name, a missing rate, a base other than USD;
  - **`MarketRepositoryImpl`:**
    - loads coins and rates **at the same time**;
    - keeps the first success;
    - shares a load already in flight;
    - retries after a failure;
    - turns every exception into a message the screen can show, and lets `Error`s (bugs) through.
- **Formatting** (`core/formatting/`): `MoneyFormatter` (intl, `en_US`):
  - prices with the currency's decimals;
  - **four significant digits under one unit** (SHIB $0.0000241, never "$0.00");
  - compact caps and volumes ($1.32T);
  - compact supplies (19.71M);
  - conversion at a rate.
- **Design system:**
  - `Sparkline` (a `CustomPainter` in its own `RepaintBoundary`, colored by its own trend, with a **minimum vertical range of 2 % of the price**);
  - `AppSearchField` (from ConnectHub-Flutter: one labelled control, autocorrect off);
  - `SortMenu`;
  - `CoinRow` gains the sparkline. The rank moved into the symbol line ("#1 · BTC") to leave the name room.
- **The Market** (`features/market/`):
  - `MarketCubit` (load once, `queryChanged`, `sortChanged`, nothing emitted after close);
  - `MarketPage` (provides the Cubit, wires navigation) and `MarketView` (renders it): the search field, "32 coins · by rank", the rows, loading, error and no-match states.
- **DI:** `AppModule` (`Clock`, `AssetBundle`); the API, repository, use case and Cubit are registered by annotation.
- **Packages:** `flutter_bloc`, `freezed` (4.0.1, for `bloc_test` 10), `json_serializable`, `intl`, `clock`; dev: `bloc_test`, `mocktail`, `fake_async`.
- **252 tests.**

---

## Flutter / Dart Concepts Demonstrated

- **freezed** for immutable models with value equality. A **derived getter** on a freezed class (`Quote.change24hPercent`) needs the private constructor `const Quote._()`.
- **json_serializable** with `checked: true` (a wrong type names its field) and `field_rename: snake`:
  - **snake_case doesn't split digits:** `sparkline7d` stays `sparkline7d`, and `priceChangePercentage24h` becomes `price_change_percentage24h`;
  - both need an explicit `@JsonKey(name:)` (conventions §11.120).
- **Validation in the mapper, not the DTO:** the DTO mirrors the wire (strings), and the mapper decides what's acceptable. One damaged record fails the whole load, because half a market is worse than "Try again".
- **Concurrent futures with a record's `.wait`:**
  - `(api.getCoins(), api.getExchangeRates()).wait` runs both and waits for the slower;
  - a failure arrives wrapped in a `ParallelWaitError` whose `errors` is a record of `AsyncError?`. The repository unwraps the first (§11.121).
- **Exceptions vs errors:**
  - `on Exception` becomes a user-facing `AppException`;
  - an `Error` is rethrown with `Error.throwWithStackTrace`, so a programming mistake still fails a test instead of becoming "Something went wrong".
- **A shared in-flight `Future`** (`_loading ??= _load().whenComplete(…)`): two callers, one request.
- **intl:**
  - `NumberFormat.currency` with `minimumFractionDigits` / `maximumFractionDigits` set after construction (significant digits for small prices, trailing zeros dropped);
  - `compactSimpleCurrency` keeps **three significant digits** ($42.2B), whatever `decimalDigits` says.
- **`CustomPainter`:**
  - a pure `offsetsFor` (tested without painting);
  - `shouldRepaint` comparing the data;
  - a `RepaintBoundary`, so a row repainting doesn't repaint its line.
- **`LayoutBuilder`:** the sparkline appears only when the row is wide enough.
- **Page / View split:** the Page creates the Cubit with `getIt` and turns callbacks into routes; the View renders and is tested with `MockCubit`.
- **`ValueKey(coin.id)`** on rows, so a re-sort moves rows instead of rebuilding them in place.
- **`Semantics(liveRegion:)`** on "2 matches · by rank" while searching: a screen-reader user hears the count without leaving the field.

---

## Stream Concepts Demonstrated

Still none, on purpose: the seed is a **one-shot `Future`** (streams are for values that change over time, and the seed doesn't). What Phase 2 prepares:
- **`buildMarketRows` is pure:** inputs → rows, no state. Phase 3 calls it inside `Rx.combineLatest5`, once per change of any input.
- **The Cubit's own output is a stream:** `cubit.stream`, which `bloc_test` collects in order. Phase 3's Cubit subscribes to a pipeline instead of recomputing by hand.
- **`MarketSeed` splits what ticks from what doesn't:**
  - the coins and rates stay;
  - `quotes` becomes the ticker's first snapshot (a `BehaviorSubject` seeded with it).

| Phase 2 (by hand) | Phase 3 (a pipeline) |
|---|---|
| `queryChanged` recomputes at once | the query is a subject, `debounceTime(300 ms)`, `distinct` |
| `sortChanged` recomputes | the sort is a subject, `distinct` |
| quotes from the seed | `ticker.quotes`, a `ValueStream` |
| USD at rate 1 | `settings.currency` with its rate |

---

## Data Flow

```
MarketPage ──getIt──▶ MarketCubit.load()
  → LoadMarketUseCase → MarketRepository.loadMarket()      (once; shared while in flight)
      → (FakeMarketApi.getCoins(), getExchangeRates()).wait  (600 ms, bundled JSON)
      → CoinDto.toCoin() / toQuote(at: clock.now()) / ExchangeRatesDto.toDomain()   (checked)
      → Ok(MarketSeed) | Err(NetworkException / DataFormatException / UnknownException)
  → ready: buildMarketRows(coins, quotes, query, sort) → MarketView → CoinRow × 32

typing / sorting → MarketCubit.queryChanged / sortChanged → buildMarketRows → ready
"Try again"      → MarketCubit.load() → the repository tries again (a failure isn't kept)
```

---

## Important Files Added

| File | Purpose |
|---|---|
| `assets/json/coins_seed.json`, `exchange_rates.json` | The seed |
| `lib/domain/model/coin.dart`, `quote.dart`, `market_coin.dart`, `market_seed.dart`, `currency.dart`, `exchange_rates.dart`, `sort_option.dart` | Models |
| `lib/domain/pipeline/market_rows.dart` | The list, derived: search and sort |
| `lib/core/network/market_api.dart`, `fake_market_api.dart`, `asset_json_loader.dart`, `dto/` | The fake service |
| `lib/data/mapper/market_mappers.dart` | DTO → domain, checked |
| `lib/data/repository/market_repository_impl.dart` | Load once, shared, retried |
| `lib/core/formatting/money_formatter.dart` | Prices, compact amounts, conversion |
| `lib/core/design_system/charts/sparkline.dart` | The 7-day line |
| `lib/core/design_system/widgets/app_search_field.dart`, `sort_menu.dart` | Search and sort controls |
| `lib/features/market/` | `MarketCubit`, `MarketState`, `MarketPage`, `MarketView` |
| `lib/di/app_module.dart` | `Clock`, `AssetBundle` |
| `test/helpers/fixtures.dart`, `fakes/` | A small market, DTO builders, a scripted API, a fake repository |

---

## Important Types Added

| Type | Responsibility | Layer |
|---|---|---|
| `Coin`, `Quote` | What doesn't tick, and what will | domain |
| `MarketCoin` | One derived row | domain |
| `Currency`, `ExchangeRates` | Display currencies; dollars in, dollars out | domain |
| `buildMarketRows` | The list from its inputs | domain/pipeline |
| `MarketRepository` / `MarketRepositoryImpl` | The seed, once | domain / data |
| `MarketApi` / `FakeMarketApi`, `CoinDto`, `ExchangeRatesDto` | The wire | core/network |
| `MoneyFormatter` | Dollars → text, in a currency | core/formatting |
| `Sparkline`, `SparklinePainter` | The 7-day trend | design system |
| `MarketCubit`, `MarketState` | The Market screen | features/market |

---

## Folder Structure Changes

```
assets/json/              + coins_seed.json, exchange_rates.json
lib/core/common/          + result.dart, app_exception.dart
lib/core/network/         + market_api, fake_market_api, asset_json_loader, dto/
lib/core/formatting/      + money_formatter.dart
lib/core/design_system/   + charts/sparkline.dart, widgets/app_search_field.dart, widgets/sort_menu.dart
lib/data/                 + mapper/market_mappers.dart, repository/market_repository_impl.dart
lib/domain/               + model/ (7), pipeline/market_rows.dart, repository/, usecase/
lib/features/market/      cubit/ (MarketCubit, MarketState), market_page.dart, market_view.dart
lib/di/                   + app_module.dart
test/helpers/             + fixtures.dart, fakes/ (scripted API, fake repository), contrast.dart
```

---

## Android / iOS Comparison

| Concept | Android | iOS | Flutter |
|---|---|---|---|
| Seed | hard-coded list | bundled `coins_seed.json` | **the iOS JSON**, + `is_stablecoin`, + `exchange_rates.json` |
| Fake service | `FakeMarketApiService` (600 ms) | `FakeMarketService` (600 ms) | `FakeMarketApi` (600 ms per request, both at once) |
| Money | `Double` | `Decimal` | `double` in USD; converted only at display |
| 24 h change | stored, then accumulated per tick | the same | **derived** from `open24h` |
| Validation | — | `Codable` | checked DTOs + a mapper that rejects bad values |
| Load once | `LoadMarketUseCase` | async/await | `MarketRepository` keeps the first success, shares the load |
| Formatting | `MoneyFormatter` | `MoneyFormatter` | `MoneyFormatter` (intl): significant digits under one unit |
| Sparkline | Canvas | Swift Charts | `CustomPainter`, with a minimum range |
| Screen state | `MarketUiState` (sealed) | `MarketState` (enum) | `MarketState` (freezed union) |

---

## Interview Notes

- **"Why keep the price 24 h ago instead of the 24 h change?"**
  - Because the change is a function of the price. If you store the change and add each tick's movement to it (as both native specs do), it drifts from the truth.
  - Store the open, derive the change, and it's right after any number of ticks.
- **"Where do you validate API data?"**
  - In the mapper, between the DTO (which mirrors the wire) and the domain (which must be valid).
  - A damaged record fails the whole load: showing half a market as if it were the whole one is worse than "Try again".
- **"How do you load two things at once and handle a failure?"**
  - A record of futures, `.wait`.
  - On failure you get a `ParallelWaitError` with an `AsyncError?` per future: report the first, and keep `Error`s (bugs) separate from `Exception`s (things that happen).
- **"How do you stop two screens loading the same thing twice?"** Keep the in-flight `Future` and hand it to every caller until it completes; keep the result if it succeeded, forget it if it failed.
- **"How would you show a price like 0.0000241?"**
  - With significant digits, not fixed decimals: four here, so it never reads $0.00.
  - The formatter sets `minimumFractionDigits` and `maximumFractionDigits` so trailing zeros go.
- **"How do you keep a sparkline honest?"** Give its vertical scale a floor (2 % of the price): otherwise every line stretches to fill its box, and a stablecoin's 0.4 % wobble looks like a crash.

---

## Learning Checklist

- ✅ freezed models with a derived getter; checked DTOs; mapper validation
- ✅ A fake service that's slow and can fail; a repository that loads once, shares and retries
- ✅ `Exception` → message, `Error` → rethrown
- ✅ Concurrent futures with `.wait` and `ParallelWaitError`
- ✅ intl for prices, small prices and compact amounts; conversion at a rate
- ✅ A `CustomPainter` with a pure layout function and `shouldRepaint`
- ✅ A pure derivation (`buildMarketRows`), ready for a stream pipeline
- ✅ Page / View, `bloc_test`, `MockCubit`
- □ Live prices: `BehaviorSubject`, `combineLatest`, debounce, `scan` (Phase 3)

---

## Future Improvements

- Search relevance (an exact symbol first: "eth" finds Ethereum and Tether today, in the chosen order).
- Pull to refresh has nothing to do yet: the seed loads once, and Phase 3's prices move by themselves.

---

## Notes on This Phase

- **Seen on the simulator** (iPhone 17 Pro), light and dark, and AX3:
  - **The stablecoins' sparklines zigzagged** like the volatile coins: each line stretched its own 0.4 % range to the full height. Now a line spans at least 2 % of its price, centred (with tests), and Tether's is nearly flat.
  - The rows, the sort menu (24 h change put Render first), the search ("coin": 6 matches, keeping the sort) and AX3 stacking all worked.
  - The simulator types in an Urdu keyboard layout, so the search text was pasted (`simctl pbcopy`).
- **A row width budget:** a rank column, the sparkline, the price and Phase 4's star would leave a name about 40 points on a phone, so the rank moved into the symbol line.
- **A decision about errors:**
  - the first draft of the repository caught `TypeError` too, which would have hidden bugs as "damaged data";
  - the fake service now turns a malformed record into a `FormatException` itself, and only `Exception`s are caught.
- **intl's compact formats** keep three significant digits ("$42.2B"), whatever `decimalDigits` asks; the formatter documents it, and the tests pin it.
- **Builds:** the Android debug APK and the iOS simulator app.
- **Mutation checks:**
  - 37 rules broken on purpose, one at a time, each against the **whole suite**;
  - **35 caught on the first pass.** Of the other two:
    - *Names sorted case-sensitively:* the test compared "Alpha" and "beta", which sort the same either way. It now compares "alpha" and "Beta" (case-sensitive, 'B' comes first).
    - *Numbers with spaces around them rejected* (the mapper's `.trim()` removed): **equivalent**. `double.tryParse` already ignores surrounding whitespace, so the `.trim()` was redundant; it's gone, and the test now pins `tryParse`'s behaviour.
  - That leaves 36 real mutations, all caught. A mutation of a DTO's default was left out: the default lives in the generated `.g.dart`, so mutating the source alone changes nothing.

| Area | Mutations | Notes |
|---|---:|---|
| Search and sort | 7 | the symbol searched; case and spaces ignored; price and change descending; names ignoring case; ties by rank |
| The model | 2 | the open from the change; the change relative to the open |
| Mappers | 4 | a zero price, a −100 % change, a non-USD base, a damaged sparkline rejected |
| Repository | 7 | loaded once; a load in flight shared; rank order; duplicate ids; malformed JSON is damaged data; both requests at once; `Error`s not swallowed |
| Cubit and view | 5 | load once; nothing after close; Clear resets the search; "matches"; "Try again" |
| Formatting | 4 | four significant digits; trailing zeros dropped; converted at the rate; yen without decimals |
| Sparkline and row | 5 | the minimum range; centred; repaints on new data; hidden on narrow rows; colored by its own trend |
| Fake service and sort menu | 2 | the latency; the menu disabled until there is something to sort |
