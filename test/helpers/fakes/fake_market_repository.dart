import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/price_point.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../fixtures.dart';

/// A [MarketRepository] that answers [result] (the small market by
/// default), after [gate] if one is set, and whose quotes move only when the
/// test says ([emitQuotes]). It counts its loads. A coin's history and high
/// are whatever the test sets ([setHistory], [setHigh]).
class FakeMarketRepository implements MarketRepository {
  FakeMarketRepository({Result<MarketSeed>? result})
    : result = result ?? Ok(smallMarket());

  Result<MarketSeed> result;
  Completer<void>? gate;
  int loads = 0;

  final _quotes = BehaviorSubject<Map<String, Quote>>();
  final _history = BehaviorSubject<Map<String, List<PricePoint>>>.seeded(
    const {},
  );
  final _highs = BehaviorSubject<Map<String, double>>.seeded(const {});

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

  @override
  Stream<List<PricePoint>> history(String coinId) => _history.stream
      .map((history) => history[coinId] ?? const <PricePoint>[])
      .distinct(identical);

  @override
  Stream<double?> highestPrice(String coinId) =>
      _highs.stream.map((highs) => highs[coinId]).distinct();

  void setHistory(String coinId, List<PricePoint> points) =>
      _history.add({..._history.value, coinId: points});

  void setHigh(String coinId, double high) =>
      _highs.add({..._highs.value, coinId: high});

  /// A tick: the next snapshot of the market.
  void emitQuotes(Map<String, Quote> quotes) => _quotes.add(quotes);

  /// The current snapshot (after a successful load).
  Map<String, Quote> get currentQuotes => _quotes.value;

  Future<void> dispose() async {
    await (_quotes.close(), _history.close(), _highs.close()).wait;
  }
}
