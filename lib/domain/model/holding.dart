import 'package:freezed_annotation/freezed_annotation.dart';

part 'holding.freezed.dart';

/// An amount of a coin the user owns, and what it cost.
///
/// Money is in US dollars, like every amount below the UI: a buy price
/// typed in euros is converted when it's saved (Correctness Rule 2).
@freezed
abstract class Holding with _$Holding {
  const factory Holding({
    required int id,
    required String coinId,
    required double amount,

    /// The price paid for one coin, in dollars.
    required double buyPriceUsd,
    required DateTime createdAt,
  }) = _Holding;
}
