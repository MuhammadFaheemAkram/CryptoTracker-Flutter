import 'package:async/async.dart';
import 'package:crypto_tracker/domain/model/chart_range.dart';
import 'package:crypto_tracker/domain/model/coin_detail.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/domain/usecase/observe_coin_detail_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

import '../../helpers/fakes/fake_market_repository.dart';
import '../../helpers/fakes/fake_settings_repository.dart';
import '../../helpers/fakes/fake_watchlist_repository.dart';
import '../../helpers/fixtures.dart';

void main() {
  late FakeMarketRepository market;
  late FakeSettingsRepository settings;
  late FakeWatchlistRepository watchlist;
  late BehaviorSubject<ChartRange> range;
  late StreamQueue<CoinDetail> details;

  final bitcoin = smallMarket().coins.first;

  setUp(() async {
    market = FakeMarketRepository();
    settings = FakeSettingsRepository();
    watchlist = FakeWatchlistRepository();
    range = BehaviorSubject.seeded(ChartRange.live);
    await market.loadMarket();
    details = StreamQueue(
      ObserveCoinDetailUseCase(
        ObservePriceMovesUseCase(market),
        market,
        watchlist,
        settings,
      )(bitcoin, rates: testRates, range: range),
    );
  });

  tearDown(() async {
    await details.cancel(immediate: true);
    await range.close();
    await (market.dispose(), settings.dispose(), watchlist.dispose()).wait;
  });

  /// The next snapshot, with [changes] applied, one second later.
  var second = 0;
  void tick(Map<String, double> changes) {
    second++;
    market.emitQuotes({
      ...market.currentQuotes,
      for (final MapEntry(:key, :value) in changes.entries)
        key: market.currentQuotes[key]!.copyWith(
          priceUsd: value,
          updatedAt: testNow.add(Duration(seconds: second)),
        ),
    });
  }

  test('the first detail arrives at once: every input has a value', () async {
    final first = await details.next;

    expect(first.coin, bitcoin);
    expect(first.quote.priceUsd, 67240.5);
    expect(first.direction, PriceDirection.flat);
    expect(first.isWatched, isFalse);
    expect(first.range, ChartRange.live);
    expect(first.currency, Currency.usd);
    expect(first.rate, 1);
  });

  test('a tick of this coin: the new price and its direction', () async {
    await details.next;

    tick({'bitcoin': 66000});
    final next = await details.next;

    expect(next.quote.priceUsd, 66000);
    expect(next.direction, PriceDirection.down);
  });

  test("another coin's tick doesn't rebuild the page", () async {
    await details.next;

    tick({'ethereum': 4000}); // filtered out by distinct
    tick({'bitcoin': 68000});

    expect((await details.next).quote.priceUsd, 68000);
  });

  test('the history, the high and the star come through', () async {
    await details.next;

    final points = [
      PricePoint(at: testNow, priceUsd: 1),
      PricePoint(at: testNow, priceUsd: 2),
    ];
    market.setHistory('bitcoin', points);
    expect((await details.next).livePoints, points);

    market.setHigh('bitcoin', 80000);
    expect((await details.next).allTimeHighUsd, 80000);

    await watchlist.toggle('bitcoin');
    expect((await details.next).isWatched, isTrue);
  });

  test('another coin\'s history doesn\'t rebuild the page', () async {
    await details.next;

    market.setHistory('ethereum', [PricePoint(at: testNow, priceUsd: 1)]);
    await watchlist.toggle('bitcoin');

    expect((await details.next).livePoints, isEmpty);
  });

  test('the currency and the range', () async {
    await details.next;

    await settings.update((s) => s.copyWith(currency: Currency.jpy));
    expect((await details.next).rate, 151.2);

    range.add(ChartRange.sevenDays);
    expect((await details.next).range, ChartRange.sevenDays);
  });

  test('the same range again derives nothing', () async {
    await details.next;

    range
      ..add(ChartRange.live)
      ..add(ChartRange.sevenDays);

    expect((await details.next).range, ChartRange.sevenDays);
  });

  test('a snapshot without this coin waits for one', () async {
    await details.next;

    market.emitQuotes({...market.currentQuotes}..remove('bitcoin'));
    tick({});
    market.emitQuotes(smallMarket().quotes);

    // The next detail is the coin back: nothing came out in between.
    expect((await details.next).quote.priceUsd, 67240.5);
  });
}
