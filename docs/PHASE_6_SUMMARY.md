# Phase 6 — Settings + Documentation & CI

## Phase Goal

Finish the app and make it a reference:
- **the Settings tab:** currency, live prices, the update interval, the appearance and About, **applied from the first frame**;
- **the documentation set:** the README, the architecture, the data model, the pipelines (final), testing, learning and interview notes, the roadmap, screenshots;
- **the open-source files** and the GitHub templates;
- **proof it ships:** CI simulated from a clean copy, a release build launched on Android, a final mutation pass of the key rules against the whole suite.

Settings needed **no new stream code**: every pipeline already took the settings as an input. Phase 6 added the controls, and checked that each one reaches every screen.

---

## What Was Implemented

- **Settings** (`features/settings/`):
  - `SettingsCubit`: an app-wide lazy singleton, provided above the router. It starts from the stored settings (synchronously), then follows every change: the Market's Pause writes the same setting the Live prices switch shows;
  - `SettingsView`:
    - Currency (`CurrencyPicker`, a `RadioGroup` of four, with names, codes and symbols);
    - Updates (Live prices on or off; Update every 1 s / 2 s / 5 s, choosable while paused);
    - Appearance (System / Light / Dark);
    - About (the name and version, "Prices are simulated, not real market data.", the open-source licenses);
    - the segmented buttons stack at large text;
  - use cases: `UpdateCurrencyUseCase`, `UpdateIntervalUseCase`, `UpdateThemeUseCase`;
  - `AppInfo` (domain), read once before `runApp` with `package_info_plus` (`@preResolve`).
- **The app:** `MaterialApp.router` takes its `themeMode` from `SettingsCubit` through a `BlocSelector` (only the theme rebuilds it).
- **Polish:** the iOS launch screen uses the system background (it was always white, a flash before a dark first frame); the section header "Updates" (it repeated "Live prices").
- **Docs:** `ARCHITECTURE.md`, `DATA_MODEL.md`, `TESTING.md`, `LEARNING_NOTES.md`, `INTERVIEW_NOTES.md`, `ROADMAP.md`, `SCREENSHOTS.md` (with 13 screenshots), `STREAM_PIPELINES.md` (final, with §12: the settings), this summary, the final README.
- **Open-source files:** `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `CHANGELOG.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/ISSUE_TEMPLATE/bug_report.md` and `feature_request.md`.
- **Tests:** **636** (615 after Phase 5).
  - The Settings: use cases, the Cubit (first state, writes, changes from elsewhere, close), the picker, the view, and flows:
    - a stored dark theme on the first frame;
    - Appearance re-theming the app;
    - another currency converting the Market and the Portfolio;
    - Live prices off is the Market's Pause;
    - a new interval's pace.
  - The release manifest asks for no network permission.

---

## Stream Concepts Demonstrated

| Idea | Where | Why |
|---|---|---|
| One settings stream, listened to three ways | price pipelines, the scheduler, the app | Each takes only what it needs: `(currency, paused)`, a period, the theme |
| `BlocSelector` as a `map` + `distinct` for widgets | `CryptoTrackerApp` | A currency change never rebuilds `MaterialApp` |
| Start from the current value, then follow | `SettingsCubit` | `super(current())`, then `listen`: the first frame is right, no flash |
| Writes read back like any change | the Settings tab | The view never updates itself; the stream does |

---

## Flutter / Dart Concepts Demonstrated

- **`RadioGroup`** (the current radio API: the group holds the value, each `RadioListTile` only its own), with checked-state semantics.
- **`SwitchListTile`, `SegmentedButton`** (vertical at large text).
- **`showLicensePage`** with the app's name, version and legalese.
- **`package_info_plus`**, resolved before `runApp`, mocked in `flutter_test_config.dart`.
- **An app-wide Cubit** as a DI singleton (`@lazySingleton` + `@disposeMethod`), provided with `BlocProvider.value` above the router.
- **The native launch screen:** `systemBackgroundColor` in the iOS storyboard; Android's `?android:colorBackground` already follows night mode.
- **Release builds:** a release APK installed, its data cleared, launched cold; its permissions read with `aapt2`.

---

## Data Flow

```
Settings → Euro
  SettingsView → SettingsCubit.currencyChanged → UpdateCurrencyUseCase
  → SettingsRepository.update: the BehaviorSubject first (every listener at once), then the disk (only the changed key)
  → settings.watch()
      → priceDisplay() (distinct) → Market · Watchlist · a coin · Portfolio re-derive with the euro's rate
      → SettingsCubit → the radio shows Euro

launch with a stored dark theme
  main: await configureDependencies()  (preferences opened, app info read)
  → SettingsCubit(super: repository.current) → themeMode dark
  → the first MaterialApp build is dark (and so is the iOS launch screen, if the device is)
```

---

## Important Files Added

| File | What |
|---|---|
| `lib/features/settings/cubit/settings_cubit.dart` | The app-wide settings |
| `lib/features/settings/settings_view.dart`, `settings_page.dart` | The tab |
| `lib/core/design_system/widgets/currency_picker.dart` | The currency radio list |
| `lib/domain/model/app_info.dart` | The name and version |
| `test/features/settings/` | The Cubit, the view, the flows |
| `test/platform/android_manifest_test.dart` | No network permission |
| `docs/ARCHITECTURE.md` … `docs/SCREENSHOTS.md`, `docs/screenshots/` | The documentation set |
| `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `CHANGELOG.md`, `.github/…` | Open-source files |

---

## Important Types Added

- `SettingsCubit` (feature, app-wide), `SettingsView`, `CurrencyPicker` (design system), `AppInfo` (domain)
- `UpdateCurrencyUseCase`, `UpdateIntervalUseCase`, `UpdateThemeUseCase` (domain)

---

## Folder Structure Changes

```
lib/features/settings/        placeholder → cubit/, view, page
.github/                      + PULL_REQUEST_TEMPLATE.md, ISSUE_TEMPLATE/
docs/                         + ARCHITECTURE, DATA_MODEL, TESTING, LEARNING_NOTES, INTERVIEW_NOTES, ROADMAP, SCREENSHOTS, screenshots/
test/platform/                new: the manifest check
```

---

## Android / iOS Comparison

| Concept | Android | iOS | Flutter (this app) |
|---|---|---|---|
| Settings storage | DataStore Preferences | `@AppStorage` | `SharedPreferencesWithCache`, opened before `runApp` |
| The settings | currency, interval, appearance, About | currency, interval, appearance | the same, plus Live prices on or off, and About |
| Paused | an interval option (1 s / 2 s / 5 s / paused) | an interval option | its own switch, the same setting as the Market's Pause, so resuming keeps the interval |
| Currency control | a `CurrencyPicker` component | a `CurrencyPicker` view | `CurrencyPicker`: a `RadioGroup` (four options fit; each announced with its state) |
| A currency change | reformats the lists (`combine` input) | reformats live (`combineLatest` input) | converts every screen (`priceDisplay()` in every pipeline) |
| Settings use cases | ObserveSettings, UpdateCurrency, UpdateInterval, UpdateTheme | the same | the same, plus SetLivePricesPaused |

---

## Interview Notes

- **"How do you avoid a theme flash at launch?"**
  - Read the stored theme before the first frame: the preferences open before `runApp`, and the Cubit starts from the stored value instead of a default.
  - Make the native launch screen follow the device too: it shows before Flutter can know anything.
- **"How does one setting reach every screen?"**
  - It's a stream every pipeline already combines.
  - Each narrows it to what it needs and `distinct`s it, so a theme change never recomputes a price list and a currency change never rebuilds the app.
- **"What does a release build tell you that a debug build doesn't?"**
  - Permissions (debug adds INTERNET for development), startup without the JIT, minification.
  - Here: no network permission, as intended, and a cold start the same as another release app on the same machine.
- **"What did you check before calling it done?"**
  - CI from a clean copy of the commit (generated code current, format, analyze, tests).
  - The release launch.
  - A mutation pass of every key rule against the finished suite.
  - Light, dark and large text on a simulator.

---

## Learning Checklist

- ✅ Settings that apply from the first frame, through one stream
- ✅ `RadioGroup`, `SegmentedButton`, `SwitchListTile`, `showLicensePage`
- ✅ An app-wide Cubit above the router; `BlocSelector`
- ✅ A launch screen that follows the device's appearance
- ✅ A release build launched; permissions checked by a test
- ✅ The documentation set and the open-source files
- ✅ A final mutation pass against the whole suite

---

## Future Improvements

- The app still has Flutter's default icon; an icon and a splash of its own are on the [roadmap](ROADMAP.md).
- The theme chosen *in the app* can't reach the native launch screen (it shows before Flutter runs); only the device's appearance does.
- A "Reset to defaults" in Settings.

---

## Notes on This Phase

- **Seen on the simulator** (iPhone 17 Pro, light, dark, AX3):
  - Japanese yen converted the Market (no decimals) and every Portfolio figure, the buy costs included;
  - Dark re-themed the app at once;
  - after a relaunch the first Flutter frame was already dark and in yen;
  - at AX3 the radio list and the stacked segments fit.
- **Polish found there:**
  - the iOS launch screen was always white (a flash before a dark first frame) and now follows the device (§11.130);
  - the "Live prices" header repeated the switch's title, and is "Updates" now.
- **Release build (Android, Pixel 10 Pro emulator, API 36):**
  - `flutter build apk --release` → install → `pm clear` → launch: the Market loaded and ticked;
  - `aapt2` shows no permission but the app's own, and a test now guards it;
  - a cold start took about 7 s, and so did another Flutter release app (MovieExplorer) on the same emulator, whose load average was 12: the machine, not the app.
- **CI:** simulated from a clean copy of the staged tree (pub get, codegen current, format, analyze, every test).
- **Mutation checks:**
  - 31 rules broken on purpose, one at a time, each against the **whole suite**: **all 31 caught on the first pass**;
  - 15 break the Settings: the first state, following changes, the switch, each write, each control's wiring, About, the version, the dark theme mapping;
  - 16 break the key **Correctness Rules** of the whole app once more against the finished suite (Rules 1–13 and 16: a derived 24 h change, conversion, stablecoins, directions, the search, sorting, cancelling, the restart, live stats, an allocation that adds up, decimals, per-currency formatting, reduced motion, two points for a trend), plus a tick that never flashes.
  - Across the six phases: 260 mutations, each against the whole suite.

| Area | Mutations | Notes |
|---|---:|---|
| Settings | 15 | the stored first state; changes followed; Live prices; dark; each write; each control; About; the version; the interval while paused |
| Correctness Rules | 16 | 1, 2, 3, 4 (twice), 5, 6, 7, 8, 9 (twice), 10, 11, 12, 13, 16 |
