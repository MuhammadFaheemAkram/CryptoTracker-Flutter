/// The currencies prices can be shown in.
///
/// Every value in the app is stored in US dollars. A currency only matters
/// at the edges: when a value is formatted for display, and (Phase 5) when a
/// buy price typed in it is converted back to dollars. See [ExchangeRates].
enum Currency {
  usd('USD', r'$', 2),
  eur('EUR', '€', 2),
  gbp('GBP', '£', 2),
  jpy('JPY', '¥', 0);

  const Currency(this.code, this.symbol, this.decimals);

  /// The ISO 4217 code, also the key in `exchange_rates.json`.
  final String code;

  final String symbol;

  /// Decimals for an ordinary price (yen has none). Prices under one unit
  /// show significant digits instead (see `MoneyFormatter`).
  final int decimals;
}
