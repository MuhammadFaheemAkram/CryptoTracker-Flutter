import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/portfolio_listing.dart';
import 'package:crypto_tracker/domain/pipeline/portfolio_valuation.dart';
import 'package:crypto_tracker/domain/pipeline/price_display.dart';
import 'package:crypto_tracker/domain/repository/portfolio_repository.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// The portfolio, valued live.
///
/// ```
/// snapshots ──────────────┐   (one per tick, with directions)
/// holdings (drift) ───────┼─ combineLatest3 ─▶ valuePortfolio ─▶ PortfolioListing
/// settings ─ priceDisplay ┘   (currency, paused)
/// ```
///
/// The three reasons to re-value, one pipeline: a tick (prices moved), a
/// holding added, edited or removed (the table changed), or another
/// currency. The valuation is in dollars; the listing carries the rate.
@injectable
class ObservePortfolioUseCase {
  const ObservePortfolioUseCase(this._moves, this._portfolio, this._settings);

  final ObservePriceMovesUseCase _moves;
  final PortfolioRepository _portfolio;
  final SettingsRepository _settings;

  Stream<PortfolioListing> call(MarketSeed seed) => Rx.combineLatest3(
    _moves(),
    _portfolio.watchHoldings(),
    _settings.watch().priceDisplay(),
    (snapshot, holdings, display) => PortfolioListing(
      valuation: valuePortfolio(
        coins: seed.coins,
        holdings: holdings,
        quotes: snapshot.quotes,
        directions: snapshot.directions,
      ),
      currency: display.currency,
      rate: seed.rates.rateFor(display.currency),
      isPaused: display.paused,
    ),
  );
}
