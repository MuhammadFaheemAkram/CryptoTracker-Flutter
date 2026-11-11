import 'package:crypto_tracker/domain/model/price_snapshot.dart';
import 'package:crypto_tracker/domain/pipeline/price_directions.dart';
import 'package:crypto_tracker/domain/repository/market_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// The live market, one [PriceSnapshot] per tick: every quote, and which
/// way each moved since the last tick.
///
/// ```
/// quotes:     ──Q1────────Q2────────Q3──▶
/// scan:       ──(Q1, {})──(Q2, Δ12)──(Q3, Δ23)──▶
/// ```
///
/// A direction compares two snapshots, so the stream has to remember the
/// previous one: that is what `scan` is for. Its accumulator is the last
/// snapshot, and each new set of quotes becomes the next snapshot, with
/// [directionsBetween] the old quotes and the new. The first has nothing
/// to compare with, so nothing moved.
///
/// Why not `pairwise()`? It waits for two values before it emits anything,
/// so the market would show nothing until the second tick.
@injectable
class ObservePriceMovesUseCase {
  const ObservePriceMovesUseCase(this._market);

  final MarketRepository _market;

  Stream<PriceSnapshot> call() => _market.quotes
      .scan<PriceSnapshot?>(
        (previous, quotes, _) => PriceSnapshot(
          quotes: quotes,
          directions: directionsBetween(previous?.quotes, quotes),
        ),
        null,
      )
      .whereType<PriceSnapshot>();
}
