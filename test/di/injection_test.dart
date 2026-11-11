import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/network/fake_market_api.dart';
import 'package:crypto_tracker/core/network/market_api.dart';
import 'package:crypto_tracker/core/prices/price_history.dart';
import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/core/prices/ticker_scheduler.dart';
import 'package:crypto_tracker/data/repository/market_repository_impl.dart';
import 'package:crypto_tracker/data/repository/settings_repository_impl.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:crypto_tracker/domain/repository/settings_repository.dart';
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(configureDependencies);
  tearDown(getIt.reset);

  test('the composition root picks the fake service and the real '
      'repositories', () {
    expect(getIt<MarketApi>(), isA<FakeMarketApi>());
    expect(getIt<MarketRepository>(), isA<MarketRepositoryImpl>());
    expect(getIt<SettingsRepository>(), isA<SettingsRepositoryImpl>());
  });

  test('one ticker, one history, one scheduler, one repository each: '
      'app-wide singletons', () {
    expect(getIt<PriceTicker>(), same(getIt<PriceTicker>()));
    expect(getIt<PriceHistory>(), same(getIt<PriceHistory>()));
    expect(getIt<TickerScheduler>(), same(getIt<TickerScheduler>()));
    expect(getIt<MarketRepository>(), same(getIt<MarketRepository>()));
  });

  test('each screen gets its own Cubit', () async {
    final a = getIt<MarketCubit>();
    final b = getIt<MarketCubit>();
    expect(a, isNot(same(b)));
    await (a.close(), b.close()).wait;
  });

  test(
    'the settings are ready before the first frame (read synchronously)',
    () {
      expect(getIt<SettingsRepository>().current.livePricesPaused, isFalse);
    },
  );

  test(
    'the real graph loads the bundled market and seeds the ticker',
    () async {
      final result = await getIt<MarketRepository>().loadMarket();

      expect(result, isA<Ok<MarketSeed>>());
      expect((result as Ok<MarketSeed>).value.coins, hasLength(32));
      expect(getIt<PriceTicker>().quotes.value, hasLength(32));
    },
  );
}
