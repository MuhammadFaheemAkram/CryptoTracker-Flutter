# Security Policy

## Supported Versions

CryptoTracker is a learning/reference project. Security fixes are applied to the latest `main` only.

| Version | Supported |
|---------|:---------:|
| `main`  | ✅ |

## Reporting a Vulnerability

Please **do not** open a public issue for security problems.

Instead, email **muhammadfaheem004@gmail.com** with:

- a description of the issue and its impact;
- steps to reproduce (a proof of concept if possible);
- any suggested remediation.

You can expect an acknowledgement within a few business days.

## What the App Holds

- **No network at all.** The market is simulated on the device from bundled JSON: there's no backend, no account, no API key, and the app makes no requests. It doesn't ask for the Android INTERNET permission in release builds.
- **The prices are not real market data.** Never use them for a financial decision; the app says so in Settings → About.
- **The database** (drift / SQLite, in the app's documents directory) holds only the user's watchlist (coin ids and when they were starred) and holdings (coin, amount, buy price, date).
- **Preferences** (`SharedPreferencesWithCache`) hold the currency, the update interval, whether live prices are paused, and the appearance.

The practical attack surface is small. Reports about data-handling concerns or dependency issues are still very welcome.
