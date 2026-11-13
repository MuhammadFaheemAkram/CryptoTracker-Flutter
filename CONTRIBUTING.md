# Contributing to CryptoTracker

Thanks for your interest! This is a learning-focused reference project: the Flutter edition of CryptoTracker, a **Dart streams showcase** (the Android edition shows Kotlin Flow, the iOS edition Combine). Contributions that improve clarity, correctness or teaching value are especially welcome, above all anything that makes a pipeline easier to understand.

## Ground Rules

- Be respectful. See the [Code of Conduct](CODE_OF_CONDUCT.md).
- **The one rule:** one `PriceTicker` owns the live quotes. Every price on every screen is **derived** from it by a stream pipeline. No screen keeps its own copy of a price, and no list is patched by hand.
- **Keep the architecture intact:**
  - layers: Widget → Cubit → UseCase → Repository → the ticker / the fake API / drift / preferences;
  - `domain/` stays plain Dart (no Flutter, no Bloc, no get_it, no JSON);
  - screens never import `data/`, `core/network` or `core/database`;
  - only `PriceTicker` runs a periodic timer, and only `core/prices` moves prices;
  - `getIt` only in `main.dart`, `app/`, `di/` and Page widgets.
- **Streams:**
  - a pipeline's logic lives in a **pure function** inside the combiner (`buildMarketRows`, `valuePortfolio`), tested without streams;
  - inputs are narrowed and `distinct` before they're combined;
  - a Cubit owns its inputs (seeded subjects) and **one** subscription, cancels it in `close()`, and sets its `_closing` flag first;
  - money is US dollars below the UI; a currency applies only at the edges.
- **UI:** import `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`.
- **Dependencies:** keep them few and mainstream, and explain each new one in the README's tech stack.

`test/architecture/architecture_test.dart` checks most of these.

## Development Setup

- Install [FVM](https://fvm.app), then run `fvm install`. It reads `.fvmrc`, which pins Flutter 3.47.6.
- iOS needs Xcode. Android needs the Android SDK and Java 17+ (Android Studio's bundled JDK works).
- Get the packages with `fvm flutter pub get`, then start the app with `fvm flutter run`. The market is simulated: no network, no API key.
- After changing annotated code (injectable, freezed, json_serializable, drift, typed routes), regenerate it:

  ```bash
  fvm dart run build_runner build
  ```

  Generated files are committed, and CI fails if they are stale.
- **Changing the database schema:**
  1. Bump `schemaVersion` in `lib/core/database/app_database.dart`.
  2. Run `fvm dart run drift_dev make-migrations`. It exports the new version to `drift_schemas/` and regenerates the steps and the migration test.
  3. Write the new step in `stepByStep`.
  4. Add a data test in `test/drift/app_database/migration_test.dart` for anything that moves data.

## Coding Conventions

- **Analysis:** `fvm dart analyze` must report **no issues** (infos included).
- **Formatting:** `fvm dart format .` (the tall style).
- **One Cubit per screen**, its state a freezed sealed union, rendered with an exhaustive `switch`.
- **Accessibility:**
  - every tappable is at least 48 × 48 and has a label;
  - text contrast meets WCAG AA in both themes, including over the flash tints;
  - color is never the only signal (▲/▼ and signs);
  - ticking prices aren't live regions;
  - above 130 % text (`context.prefersStackedLayout`), side-by-side controls stack.

  The accessibility tour (`test/app/accessibility_tour_test.dart`) checks this, so add new screens and states to it.
- **Comments** explain *why* (an operator choice, a trap), not what the code obviously does.

## Commits

This project uses **[Conventional Commits](https://www.conventionalcommits.org/)**:

```
<type>(<scope>): <message>
```

Examples: `feat(market): add a volume sort`, `test(prices): cover a restart mid-tick`, `docs(streams): explain the portfolio pipeline`.

## Pull Requests

1. Fork the repository and create a topic branch.
2. Make sure `fvm dart analyze`, `fvm dart format --output=none --set-exit-if-changed .` and `fvm flutter test` all pass.
3. Update the documentation where relevant: a new or changed pipeline goes into `docs/STREAM_PIPELINES.md` with its marble diagram.
4. Open a PR with a clear description of the change and its motivation.

## Tests

- **Pure functions first:** the pipeline pieces, the formatters, the walk (seeded).
- **Streams:** `StreamQueue` (the Turbine of Dart) for the order of emissions; `fakeAsync` for time. Some rxdart operators need real time in tests (see [docs/TESTING.md](docs/TESTING.md)).
- **Fakes over mocks** for repositories (`test/helpers/fakes/`); `mocktail` and `bloc_test`'s `MockCubit` for view tests.
- **The real stack:** `pumpCryptoTracker(tester, …)` builds the app on the real DI graph with drift and the preferences in memory.
- **Every async wait is bounded,** and a `StreamQueue` is cancelled with `immediate: true` in `tearDown`.
