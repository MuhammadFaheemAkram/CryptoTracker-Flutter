import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/portfolio_valuation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_listing.freezed.dart';

/// What the portfolio pipeline emits: the valuation, and how to show it.
@freezed
abstract class PortfolioListing with _$PortfolioListing {
  const factory PortfolioListing({
    required PortfolioValuation valuation,
    required Currency currency,

    /// Units of [currency] per dollar.
    required double rate,

    /// The user paused live prices: nothing is moving.
    required bool isPaused,
  }) = _PortfolioListing;
}
