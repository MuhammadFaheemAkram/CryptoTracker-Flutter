import 'dart:async';
import 'dart:developer' as developer;

import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/network/market_api.dart';
import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/data/mapper/market_mappers.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';

/// The market's data, behind [MarketRepository].
///
/// The seed is loaded **once** for the app's lifetime: the coins and rates
/// don't change, and the prices move on the [PriceTicker], not by
/// reloading. So the first success is kept, every later call answers from
/// memory, and the seed's quotes become the ticker's first snapshot.
@LazySingleton(as: MarketRepository)
class MarketRepositoryImpl implements MarketRepository {
  MarketRepositoryImpl(this._api, this._clock, this._ticker);

  final MarketApi _api;
  final Clock _clock;
  final PriceTicker _ticker;

  @override
  Stream<Map<String, Quote>> get quotes => _ticker.quotes;

  MarketSeed? _seed;

  /// The load in flight, shared by every caller until it finishes (two
  /// screens opening at once start one load, not two).
  Future<Result<MarketSeed>>? _loading;

  @override
  Future<Result<MarketSeed>> loadMarket() async {
    if (_seed case final seed?) return Ok(seed);
    return _loading ??= _load().whenComplete(() => _loading = null);
  }

  Future<Result<MarketSeed>> _load() async {
    try {
      // Both requests at once: the screen waits for the slower one, not
      // for the sum.
      final (coins, rates) = await (
        _api.getCoins(),
        _api.getExchangeRates(),
      ).wait;
      final at = _clock.now().toUtc();
      final seed = MarketSeed(
        coins: [for (final dto in coins) dto.toCoin()]
          ..sort((a, b) => a.rank.compareTo(b.rank)),
        quotes: {for (final dto in coins) dto.id: dto.toQuote(at: at)},
        rates: rates.toDomain(),
      );
      if (seed.quotes.length != coins.length) {
        throw const DataFormatException(); // two coins share an id
      }
      _ticker.seed(seed);
      return Ok(_seed = seed);
    } on ParallelWaitError<
      (Object?, Object?),
      (AsyncError?, AsyncError?)
    > catch (error) {
      // `.wait` on a record wraps the failure; report the first one.
      final (coinsError, ratesError) = error.errors;
      final failure = (coinsError ?? ratesError)!;
      return _failure(failure.error, failure.stackTrace);
    } on Exception catch (error, stackTrace) {
      return _failure(error, stackTrace);
    }
  }

  /// An exception becomes an [AppException] the screen can show. An
  /// `Error` (a programming mistake) is rethrown, so tests still see it.
  Result<MarketSeed> _failure(Object error, StackTrace stackTrace) {
    switch (error) {
      case AppException():
        return Err(error);
      // Malformed JSON, or a field of the wrong type (`checked: true` names
      // it): the data is damaged.
      case FormatException() || CheckedFromJsonException():
        developer.log(
          'Damaged market data',
          error: error,
          name: 'MarketRepository',
        );
        return const Err(DataFormatException());
      case Exception():
        developer.log(
          'Unexpected failure loading the market',
          error: error,
          name: 'MarketRepository',
        );
        return const Err(UnknownException());
      default:
        Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
