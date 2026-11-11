import 'package:crypto_tracker/domain/model/portfolio_listing.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_state.freezed.dart';

/// What the Portfolio tab shows.
@freezed
sealed class PortfolioState with _$PortfolioState {
  /// The market's seed is on its way (holdings are valued at its prices).
  const factory PortfolioState.loading() = PortfolioLoading;

  /// The market couldn't be loaded; the view offers "Try again".
  const factory PortfolioState.error(String message) = PortfolioError;

  /// The holdings, valued live. Its positions are empty when there are no
  /// holdings ("Add your first holding").
  const factory PortfolioState.ready(PortfolioListing listing) = PortfolioReady;
}
