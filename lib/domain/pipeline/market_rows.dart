import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/market_coin.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';

/// The market list, derived from its inputs: the coins, their quotes, what
/// was searched for and how to sort.
///
/// A pure function, so it's tested without streams or widgets. Phase 3
/// calls it inside `Rx.combineLatest` on every tick, every keystroke (after
/// the debounce) and every sort change: the list is always recomputed from
/// the inputs, never patched (the one rule).
///
/// A coin without a quote is left out: it has no price to show.
List<MarketCoin> buildMarketRows({
  required List<Coin> coins,
  required Map<String, Quote> quotes,
  String query = '',
  SortOption sort = SortOption.rank,
}) {
  final rows = [
    for (final coin in coins)
      if (quotes[coin.id] case final quote? when matchesQuery(coin, query))
        MarketCoin(coin: coin, quote: quote),
  ];
  return rows..sort(_comparators[sort]);
}

/// Whether [coin]'s name or symbol contains [query], ignoring case and the
/// spaces around it (Correctness Rule 5). An empty query matches every coin.
bool matchesQuery(Coin coin, String query) {
  final needle = query.trim().toLowerCase();
  return needle.isEmpty ||
      coin.name.toLowerCase().contains(needle) ||
      coin.symbol.toLowerCase().contains(needle);
}

/// One order per option, each total and stable: equal values fall back to
/// rank, so two coins at the same price never swap places between ticks
/// (Correctness Rule 6).
final Map<SortOption, Comparator<MarketCoin>> _comparators = {
  SortOption.rank: _byRank,
  SortOption.price: (a, b) =>
      _thenRank(b.quote.priceUsd.compareTo(a.quote.priceUsd), a, b),
  SortOption.change24h: (a, b) => _thenRank(
    b.quote.change24hPercent.compareTo(a.quote.change24hPercent),
    a,
    b,
  ),
  SortOption.name: (a, b) => _thenRank(
    a.coin.name.toLowerCase().compareTo(b.coin.name.toLowerCase()),
    a,
    b,
  ),
};

int _byRank(MarketCoin a, MarketCoin b) => a.coin.rank.compareTo(b.coin.rank);

int _thenRank(int order, MarketCoin a, MarketCoin b) =>
    order != 0 ? order : _byRank(a, b);
