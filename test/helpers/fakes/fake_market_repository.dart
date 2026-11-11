import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../fixtures.dart';

/// A [MarketRepository] that answers [result] (the small market by
/// default), after [gate] if one is set, and whose quotes move only when the
/// test says ([emitQuotes]). It counts its loads.
class FakeMarketRepository implements MarketRepository {
  FakeMarketRepository({Result<MarketSeed>? result})
    : result = result ?? Ok(smallMarket());

  Result<MarketSeed> result;
  Completer<void>? gate;
  int loads = 0;

  final _quotes = BehaviorSubject<Map<String, Quote>>();

  @override
  Future<Result<MarketSeed>> loadMarket() async {
    loads++;
    await gate?.future;
    if (result case Ok(:final value) when !_quotes.hasValue) {
      _quotes.add(value.quotes); // the seed's quotes, as the ticker does
    }
    return result;
  }

  @override
  Stream<Map<String, Quote>> get quotes => _quotes.stream;

  /// A tick: the next snapshot of the market.
  void emitQuotes(Map<String, Quote> quotes) => _quotes.add(quotes);

  /// The current snapshot (after a successful load).
  Map<String, Quote> get currentQuotes => _quotes.value;

  Future<void> dispose() => _quotes.close();
}
