import 'package:async/async.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/model/portfolio_listing.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/usecase/observe_portfolio_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_market_repository.dart';
import '../../helpers/fakes/fake_portfolio_repository.dart';
import '../../helpers/fakes/fake_settings_repository.dart';
import '../../helpers/fixtures.dart';

// The portfolio re-values for each of its three reasons: a tick, a change
// to the holdings, and another currency.
void main() {
  late FakeMarketRepository market;
  late FakePortfolioRepository portfolio;
  late FakeSettingsRepository settings;
  late StreamQueue<PortfolioListing> listings;

  setUp(() async {
    market = FakeMarketRepository();
    settings = FakeSettingsRepository();
    portfolio = FakePortfolioRepository([
      Holding(
        id: 1,
        coinId: 'bitcoin',
        amount: 0.5,
        buyPriceUsd: 60000,
        createdAt: testNow,
      ),
    ]);
    await market.loadMarket();
    listings = StreamQueue(
      ObservePortfolioUseCase(
        ObservePriceMovesUseCase(market),
        portfolio,
        settings,
      )(smallMarket()),
    );
  });

  tearDown(() async {
    await listings.cancel(immediate: true);
    await (market.dispose(), portfolio.dispose(), settings.dispose()).wait;
  });

  test('the first valuation arrives at once', () async {
    final first = await listings.next;

    expect(first.valuation.totalValueUsd, 0.5 * 67240.5);
    expect(first.valuation.totalCostUsd, 30000);
    expect(first.currency, Currency.usd);
    expect(first.rate, 1);
    expect(first.isPaused, isFalse);
  });

  test(
    'a tick re-values it, and the position knows which way it went',
    () async {
      await listings.next;

      market.emitQuotes({
        ...market.currentQuotes,
        'bitcoin': quote(
          'bitcoin',
          70000,
        ).copyWith(updatedAt: testNow.add(const Duration(seconds: 1))),
      });
      final next = await listings.next;

      expect(next.valuation.totalValueUsd, 35000);
      expect(next.valuation.positions.single.direction, PriceDirection.up);
    },
  );

  test('a holding added, edited or removed re-values it', () async {
    await listings.next;

    await portfolio.add(coinId: 'ethereum', amount: 2, buyPriceUsd: 3000);
    expect((await listings.next).valuation.positions, hasLength(2));

    await portfolio.update(1, amount: 1, buyPriceUsd: 60000);
    expect((await listings.next).valuation.positions.first.valueUsd, 67240.5);

    await portfolio.remove(1);
    expect(
      (await listings.next).valuation.positions.single.coin.id,
      'ethereum',
    );
  });

  test('another currency: the same dollars, a new rate', () async {
    final before = await listings.next;

    await settings.update((s) => s.copyWith(currency: Currency.eur));
    final after = await listings.next;

    expect(after.currency, Currency.eur);
    expect(after.rate, 0.92);
    expect(after.valuation, before.valuation);
  });

  test('pausing: the listing says so (the Paused chip)', () async {
    await listings.next;

    await settings.update((s) => s.copyWith(livePricesPaused: true));

    expect((await listings.next).isPaused, isTrue);
  });
}
