import 'package:crypto_tracker/core/network/asset_json_loader.dart';
import 'package:crypto_tracker/core/network/fake_market_api.dart';
import 'package:crypto_tracker/data/mapper/market_mappers.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final api = FakeMarketApi(AssetJsonLoader(rootBundle));

  group('the bundled seed', () {
    test('has the 32 coins, ranked 1 to 32 with no gaps', () async {
      final coins = await api.getCoins();

      expect(coins, hasLength(32));
      expect(coins.map((c) => c.marketCapRank), [
        for (var r = 1; r <= 32; r++) r,
      ]);
      expect(coins.map((c) => c.id).toSet(), hasLength(32));
      expect(coins.first.symbol, 'btc');
    });

    test('marks exactly the three stablecoins', () async {
      final stablecoins = [
        for (final coin in await api.getCoins())
          if (coin.isStablecoin) coin.symbol,
      ];
      expect(stablecoins, ['usdt', 'usdc', 'dai']);
    });

    test(
      'every coin maps cleanly, with a 7-day sparkline of 24 points',
      () async {
        for (final dto in await api.getCoins()) {
          final coin = dto.toCoin();
          final quote = dto.toQuote(at: testNow);
          expect(coin.sparkline7d, hasLength(24), reason: coin.id);
          expect(
            quote.change24hPercent,
            closeTo(dto.priceChangePercentage24h, 1e-9),
          );
        }
      },
    );

    test('has a rate for every currency', () async {
      final rates = (await api.getExchangeRates()).toDomain();
      for (final currency in Currency.values) {
        expect(rates.rateFor(currency), greaterThan(0));
      }
    });
  });

  test('answers after its latency, not before', () {
    fakeAsync((async) {
      var answered = false;
      api.getExchangeRates().then((_) => answered = true);

      async.elapse(FakeMarketApi.latency - const Duration(milliseconds: 1));
      expect(answered, isFalse);

      // The asset read itself is a real future: let it finish.
      async.elapse(const Duration(milliseconds: 1));
      async.flushMicrotasks();
    });
  });

  test('never throws by default (the toggle is off)', () {
    expect(FakeMarketApi.shouldThrowError, isFalse);
  });
}
