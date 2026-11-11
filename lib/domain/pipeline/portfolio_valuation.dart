import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/model/portfolio_valuation.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/quote.dart';

/// How many coins get a slice of their own; the rest share "Other".
const allocationSlices = 5;

/// The label of the slice that groups the smaller coins.
const otherLabel = 'Other';

/// The portfolio, valued at [quotes]: every holding, the totals, the 24 h
/// change and the allocation (Correctness Rule 10).
///
/// Pure: the portfolio pipeline calls it on every tick, every holding
/// change and every currency change, and it's tested without streams.
/// Everything is in dollars; the screen converts.
///
/// A holding whose coin the market doesn't know, or that has no quote, is
/// left out: it can't be valued.
PortfolioValuation valuePortfolio({
  required List<Coin> coins,
  required List<Holding> holdings,
  required Map<String, Quote> quotes,
  Map<String, PriceDirection> directions = const {},
}) {
  final byId = {for (final coin in coins) coin.id: coin};
  final positions = [
    for (final holding in holdings)
      if ((byId[holding.coinId], quotes[holding.coinId]) case (
        final coin?,
        final quote?,
      ))
        PortfolioPosition(
          holding: holding,
          coin: coin,
          quote: quote,
          direction: directions[coin.id] ?? PriceDirection.flat,
        ),
  ];
  var value = 0.0;
  var cost = 0.0;
  var openValue = 0.0;
  for (final position in positions) {
    value += position.valueUsd;
    cost += position.costUsd;
    openValue += position.openValueUsd;
  }
  final profit = value - cost;
  final change = value - openValue;
  return PortfolioValuation(
    positions: positions,
    allocations: allocate(positions),
    totalValueUsd: value,
    totalCostUsd: cost,
    totalProfitUsd: profit,
    totalProfitPercent: cost == 0 ? 0 : profit / cost * 100,
    change24hUsd: change,
    change24hPercent: openValue == 0 ? 0 : change / openValue * 100,
  );
}

/// The donut's slices: each coin's value (several holdings of one coin are
/// one slice), largest first (ties by rank), the top [slices] on their own
/// and the rest as "Other".
///
/// Shares are whole hundredths of a percent, and they add up to exactly
/// 10 000 (100 %): each is rounded, and whatever the rounding lost or
/// gained goes to the largest slice, where it shows least.
List<Allocation> allocate(
  List<PortfolioPosition> positions, {
  int slices = allocationSlices,
}) {
  final byCoin = <String, ({Coin coin, double value})>{};
  for (final position in positions) {
    final id = position.coin.id;
    byCoin[id] = (
      coin: position.coin,
      value: (byCoin[id]?.value ?? 0) + position.valueUsd,
    );
  }
  final ranked = byCoin.values.toList()
    ..sort((a, b) {
      final byValue = b.value.compareTo(a.value);
      return byValue != 0 ? byValue : a.coin.rank.compareTo(b.coin.rank);
    });
  final total = ranked.fold(0.0, (sum, entry) => sum + entry.value);
  if (total <= 0) return const [];

  final top = ranked.take(slices);
  final rest = ranked.skip(slices).fold(0.0, (sum, e) => sum + e.value);
  final parts = <({String label, String? symbol, double value})>[
    for (final entry in top)
      (label: entry.coin.name, symbol: entry.coin.symbol, value: entry.value),
    if (ranked.length > slices) (label: otherLabel, symbol: null, value: rest),
  ];
  final points = [
    for (final part in parts) (part.value / total * 10000).round(),
  ];
  // The largest slice takes the remainder. It's usually the first coin,
  // but "Other" can be larger when it groups many small ones.
  var largest = 0;
  for (var i = 1; i < parts.length; i++) {
    if (parts[i].value > parts[largest].value) largest = i;
  }
  points[largest] += 10000 - points.fold(0, (sum, p) => sum + p);
  return [
    for (final (i, part) in parts.indexed)
      Allocation(
        label: part.label,
        symbol: part.symbol,
        valueUsd: part.value,
        basisPoints: points[i],
      ),
  ];
}
