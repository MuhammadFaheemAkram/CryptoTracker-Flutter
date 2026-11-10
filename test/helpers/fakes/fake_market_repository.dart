import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';

import '../fixtures.dart';

/// A [MarketRepository] that answers [result] (the small market by
/// default), after [gate] if one is set. It counts its loads.
class FakeMarketRepository implements MarketRepository {
  FakeMarketRepository({Result<MarketSeed>? result})
    : result = result ?? Ok(smallMarket());

  Result<MarketSeed> result;
  Completer<void>? gate;
  int loads = 0;

  @override
  Future<Result<MarketSeed>> loadMarket() async {
    loads++;
    await gate?.future;
    return result;
  }
}
