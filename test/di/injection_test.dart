import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/network/fake_market_api.dart';
import 'package:crypto_tracker/core/network/market_api.dart';
import 'package:crypto_tracker/data/repository/market_repository_impl.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(configureDependencies);
  tearDown(getIt.reset);

  test('the composition root picks the fake service and the real '
      'repository', () {
    expect(getIt<MarketApi>(), isA<FakeMarketApi>());
    expect(getIt<MarketRepository>(), isA<MarketRepositoryImpl>());
  });

  test('the service and the repository are app-wide singletons; each screen '
      'gets its own Cubit', () async {
    expect(getIt<MarketRepository>(), same(getIt<MarketRepository>()));

    final a = getIt<MarketCubit>();
    final b = getIt<MarketCubit>();
    expect(a, isNot(same(b)));
    await (a.close(), b.close()).wait;
  });

  test('the real graph loads the bundled market', () async {
    final result = await getIt<MarketRepository>().loadMarket();

    expect(result, isA<Ok<MarketSeed>>());
    expect((result as Ok<MarketSeed>).value.coins, hasLength(32));
  });
}
