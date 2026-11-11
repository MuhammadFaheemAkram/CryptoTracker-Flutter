import 'dart:async';

import 'package:async/async.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/market_listing.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/domain/usecase/observe_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

import '../../helpers/fakes/fake_market_repository.dart';
import '../../helpers/fakes/fake_settings_repository.dart';
import '../../helpers/fakes/fake_watchlist_repository.dart';
import '../../helpers/fixtures.dart';

// The showcase pipeline with StreamQueue (async's counterpart of Turbine):
// each `next` is the next listing, in order. The debounce is zero here: it
// has tests of its own.
void main() {
  late FakeMarketRepository market;
  late FakeSettingsRepository settings;
  late BehaviorSubject<String> query;
  late BehaviorSubject<SortOption> sort;
  late FakeWatchlistRepository watchlist;
  late StreamQueue<MarketListing> listings;

  /// Set when a test takes the rest of the queue as a plain stream (and
  /// cancels it itself).
  var queueTaken = false;

  setUp(() async {
    market = FakeMarketRepository();
    settings = FakeSettingsRepository();
    await market.loadMarket();
    query = BehaviorSubject.seeded('');
    sort = BehaviorSubject.seeded(SortOption.rank);
    watchlist = FakeWatchlistRepository();
    listings = StreamQueue(
      ObserveMarketUseCase(
        ObservePriceMovesUseCase(market),
        settings,
        watchlist,
      )(smallMarket(), query: query, sort: sort, debounce: Duration.zero),
    );
  });

  tearDown(() async {
    // `immediate`: a test that failed waiting for a listing must not hang
    // the run here, on the request still pending.
    if (!queueTaken) await listings.cancel(immediate: true);
    queueTaken = false;
    await (query.close(), sort.close(), watchlist.dispose()).wait;
    await (market.dispose(), settings.dispose()).wait;
  });

  List<String> ids(MarketListing listing) => [
    for (final row in listing.rows) row.coin.id,
  ];

  test('the first listing arrives at once: every input has a value', () async {
    final first = await listings.next;

    expect(ids(first), ['bitcoin', 'ethereum', 'tether', 'solana']);
    expect(first.query, '');
    expect(first.sort, SortOption.rank);
    expect(first.currency, Currency.usd);
    expect(first.rate, 1);
    expect(first.isPaused, isFalse);
    expect(
      first.rows.every((row) => row.direction == PriceDirection.flat),
      isTrue,
    );
  });

  test('a tick: new prices and their directions, in one listing', () async {
    await listings.next;
    final quotes = market.currentQuotes;

    market.emitQuotes({
      ...quotes,
      'solana': quotes['solana']!.copyWith(priceUsd: 160),
    });
    final next = await listings.next;

    final solana = next.rows.firstWhere((row) => row.coin.id == 'solana');
    expect(solana.quote.priceUsd, 160);
    expect(solana.direction, PriceDirection.up);
  });

  test('a query filters', () async {
    await listings.next;

    query.add('teth');

    expect(ids(await listings.next), ['tether']);
  });

  test('a sort re-orders', () async {
    await listings.next;

    sort.add(SortOption.change24h);

    expect(ids(await listings.next), [
      'solana',
      'bitcoin',
      'tether',
      'ethereum',
    ]);
  });

  test('a currency: the listing carries it and its rate', () async {
    await listings.next;

    await settings.update((s) => s.copyWith(currency: Currency.jpy));
    final next = await listings.next;

    expect(next.currency, Currency.jpy);
    expect(next.rate, 151.2);
  });

  test('pausing: the listing says so', () async {
    await listings.next;

    await settings.update((s) => s.copyWith(livePricesPaused: true));

    expect((await listings.next).isPaused, isTrue);
  });

  test('the watchlist marks its coins', () async {
    await listings.next;

    await watchlist.toggle('ethereum');
    final next = await listings.next;

    expect(
      [
        for (final row in next.rows)
          if (row.isWatched) row.coin.id,
      ],
      ['ethereum'],
    );
  });

  test('a setting the market doesn\'t use (the theme) derives nothing; the '
      'same sort again neither', () async {
    await listings.next;
    final extra = <MarketListing>[];
    queueTaken = true;
    final rest = listings.rest.listen(extra.add);

    await settings.update((s) => s.copyWith(themeMode: AppThemeMode.dark));
    sort.add(SortOption.rank);
    await pumpEventQueue();

    expect(extra, isEmpty);
    await rest.cancel();
  });

  test('combineLatest, not zip: three changes in a row, each derived from '
      'the latest of everything', () async {
    await listings.next;

    sort.add(SortOption.price);
    final bySort = await listings.next;
    query.add('e');
    final byQuery = await listings.next;

    expect(ids(bySort), ['bitcoin', 'ethereum', 'solana', 'tether']);
    expect(ids(byQuery), ['ethereum', 'tether'], reason: 'still by price');
    expect(byQuery.sort, SortOption.price);
  });
}
