import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_valuation.freezed.dart';

/// One holding, valued at its coin's current quote. Everything is in
/// dollars, and derived (Correctness Rule 10).
@freezed
abstract class PortfolioPosition with _$PortfolioPosition {
  const factory PortfolioPosition({
    required Holding holding,
    required Coin coin,
    required Quote quote,

    /// Which way the price moved on the last tick: the row's flash.
    @Default(PriceDirection.flat) PriceDirection direction,
  }) = _PortfolioPosition;

  const PortfolioPosition._();

  /// What it's worth now: amount × price.
  double get valueUsd => holding.amount * quote.priceUsd;

  /// What it cost: amount × buy price.
  double get costUsd => holding.amount * holding.buyPriceUsd;

  double get profitUsd => valueUsd - costUsd;

  /// Profit against cost, in percent; 0 when it cost nothing (a holding
  /// can't, but the rule holds anyway).
  double get profitPercent => costUsd == 0 ? 0 : profitUsd / costUsd * 100;

  /// What it was worth 24 h ago: amount × the price then (`open24hUsd`).
  double get openValueUsd => holding.amount * quote.open24hUsd;

  /// The change in value over 24 h.
  double get change24hUsd => valueUsd - openValueUsd;
}

/// A slice of the allocation donut: one coin, or "Other".
@freezed
abstract class Allocation with _$Allocation {
  const factory Allocation({
    /// The coin's name, or "Other".
    required String label,

    /// `null` for "Other".
    String? symbol,
    required double valueUsd,

    /// Its share in hundredths of a percent (5237 = 52.37 %). Whole numbers
    /// so the shares add up to **exactly** 100 %.
    required int basisPoints,
  }) = _Allocation;
}

/// The whole portfolio, valued at one snapshot of the market.
@freezed
abstract class PortfolioValuation with _$PortfolioValuation {
  const factory PortfolioValuation({
    /// One per holding, oldest first.
    required List<PortfolioPosition> positions,

    /// By value, largest first: the top coins, then "Other".
    required List<Allocation> allocations,
    required double totalValueUsd,
    required double totalCostUsd,
    required double totalProfitUsd,
    required double totalProfitPercent,
    required double change24hUsd,
    required double change24hPercent,
  }) = _PortfolioValuation;
}
