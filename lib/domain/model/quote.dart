import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote.freezed.dart';

/// A coin's price at one moment.
///
/// It keeps the price **24 h ago** ([open24hUsd]) rather than the 24 h
/// change, and derives the change from it (Correctness Rule 1). Both native
/// specs add each tick's movement to the change itself, which drifts further
/// from the truth with every tick; here the change is always
/// `(price / open − 1) × 100`, however many ticks there have been.
@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required String coinId,
    required double priceUsd,
    required double open24hUsd,
    required DateTime updatedAt,
  }) = _Quote;

  const Quote._();

  /// A quote from a price and its 24 h change, as the market service
  /// reports them: the price 24 h ago is what grew by [change24hPercent] to
  /// reach [priceUsd].
  factory Quote.fromChange({
    required String coinId,
    required double priceUsd,
    required double change24hPercent,
    required DateTime updatedAt,
  }) => Quote(
    coinId: coinId,
    priceUsd: priceUsd,
    open24hUsd: priceUsd / (1 + change24hPercent / 100),
    updatedAt: updatedAt,
  );

  /// The change over 24 h, in percent.
  double get change24hPercent => (priceUsd / open24hUsd - 1) * 100;
}
