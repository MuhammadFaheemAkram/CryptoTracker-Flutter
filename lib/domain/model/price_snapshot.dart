import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/quote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_snapshot.freezed.dart';

/// One tick of the market: every quote, and which way each one moved since
/// the tick before.
///
/// The two travel together on purpose. Derived as two streams from the same
/// ticker and recombined, they would arrive one after the other: every tick
/// would emit twice, once with the new prices and the old directions (a
/// "glitch"). One `scan` makes one snapshot per tick (see
/// `ObservePriceMovesUseCase`).
@freezed
abstract class PriceSnapshot with _$PriceSnapshot {
  const factory PriceSnapshot({
    required Map<String, Quote> quotes,

    /// Missing for a coin that didn't move (and for every coin in the first
    /// snapshot): read it with [directionOf].
    required Map<String, PriceDirection> directions,
  }) = _PriceSnapshot;

  const PriceSnapshot._();

  PriceDirection directionOf(String coinId) =>
      directions[coinId] ?? PriceDirection.flat;
}
