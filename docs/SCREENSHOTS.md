# Screenshots

Taken on the iPhone 17 Pro simulator (iOS 26.5) and the Pixel 10 Pro emulator (Android, API 36, a **release** build), in Phase 6. The prices are simulated, so every screenshot shows different numbers from the last.

---

## A tick, caught mid-flash

The market ticks every 2 seconds. For 600 ms after a tick, each row that moved is tinted green or red and fades back, while its price cross-fades to the new value.

| Mid-flash | A moment later |
|:-:|:-:|
| <img src="screenshots/market-flash.png" width="280" alt="The Market a moment after a tick: rows tinted green or red, prices cross-fading"> | <img src="screenshots/market-light.png" width="280" alt="The Market between ticks: 32 coins with sparklines, prices and 24 h changes"> |

---

## Light

| Market | A coin | Watchlist |
|:-:|:-:|:-:|
| <img src="screenshots/market-light.png" width="240" alt="The Market"> | <img src="screenshots/coin-light.png" width="240" alt="Bitcoin's page: the live price, the Live chart with its high and low and its trend in words, the stats"> | <img src="screenshots/watchlist-light.png" width="240" alt="The Watchlist: Solana and Bitcoin, in the order they were starred"> |

| Portfolio | Holding form | Settings |
|:-:|:-:|:-:|
| <img src="screenshots/portfolio-light.png" width="240" alt="The Portfolio: total value, P/L, 24 h change, the allocation donut and the holdings"> | <img src="screenshots/holding-form-light.png" width="240" alt="Editing a holding: the fixed coin, the amount, the buy price and a live worth-now preview"> | <img src="screenshots/settings-light.png" width="240" alt="Settings: currency, live prices and the update interval"> |

---

## Dark

| Market (mid-flash) | A coin | Portfolio |
|:-:|:-:|:-:|
| <img src="screenshots/market-dark.png" width="240" alt="The Market in dark mode, caught mid-flash"> | <img src="screenshots/coin-dark.png" width="240" alt="Solana's page in dark mode"> | <img src="screenshots/portfolio-dark.png" width="240" alt="The Portfolio in dark mode"> |

---

## Large text (iOS AX3, dark)

Above 130 % text, side-by-side layouts stack: each row puts its price under the name, the totals wrap, the donut sits above its legend.

| Market | Portfolio |
|:-:|:-:|
| <img src="screenshots/market-dark-large-text.png" width="260" alt="The Market at AX3 text: each row stacked"> | <img src="screenshots/portfolio-dark-large-text.png" width="260" alt="The Portfolio at AX3 text"> |

---

## Android (release build)

| Market |
|:-:|
| <img src="screenshots/android-release-market.png" width="260" alt="The Market on the Pixel 10 Pro emulator, from a release build"> |

The release APK was installed with its data cleared and launched cold. The market loaded and ticked. It asks for no network permission (a test checks the manifest).
