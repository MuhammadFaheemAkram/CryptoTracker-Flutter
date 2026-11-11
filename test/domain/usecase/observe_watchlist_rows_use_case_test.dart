import 'package:async/async.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/watchlist_listing.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_watchlist_rows_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_market_repository.dart';
import '../../helpers/fakes/fake_settings_repository.dart';
import '../../helpers/fakes/fake_watchlist_repository.dart';
import '../../helpers/fixtures.dart';

void main() {
  late FakeMarketRepository market;
  late FakeSettingsRepository settings;
  late FakeWatchlistRepository watchlist;
  late StreamQueue<WatchlistListing> listings;

  setUp(() async {
    market = FakeMarketRepository();
    settings = FakeSettingsRepository();
    watchlist = FakeWatchlistRepository(['solana', 'bitcoin']);
    await market.loadMarket();
    listings = StreamQueue(
      ObserveWatchlistRowsUseCase(
        ObservePriceMovesUseCase(market),
        watchlist,
        settings,
      )(smallMarket()),
    );
  });

  tearDown(() async {
    await listings.cancel(immediate: true);
    await (market.dispose(), settings.dispose(), watchlist.dispose()).wait;
  });

  List<String> ids(WatchlistListing listing) => [
    for (final row in listing.rows) row.coin.id,
  ];

  test('the first listing arrives at once, in the starred order', () async {
    final first = await listings.next;

    expect(ids(first), ['solana', 'bitcoin']);
    expect(first.currency, Currency.usd);
    expect(first.isPaused, isFalse);
  });

  test('a star anywhere reaches the list (the table is the source)', () async {
    await listings.next;

    await watchlist.toggle('ethereum');
    expect(ids(await listings.next), ['solana', 'bitcoin', 'ethereum']);

    await watchlist.remove('solana');
    expect(ids(await listings.next), ['bitcoin', 'ethereum']);
  });

  test('a tick re-prices the rows, with directions', () async {
    await listings.next;
    final quotes = market.currentQuotes;

    market.emitQuotes({
      ...quotes,
      'bitcoin': quote(
        'bitcoin',
        70000,
      ).copyWith(updatedAt: testNow.add(const Duration(seconds: 1))),
    });
    final next = await listings.next;

    expect(next.rows.last.quote.priceUsd, 70000);
    expect(next.rows.last.direction, PriceDirection.up);
    expect(next.rows.first.direction, PriceDirection.flat);
  });

  test('the currency converts, with its rate', () async {
    await listings.next;

    await settings.update((s) => s.copyWith(currency: Currency.eur));
    final next = await listings.next;

    expect(next.currency, Currency.eur);
    expect(next.rate, 0.92);
  });
}
