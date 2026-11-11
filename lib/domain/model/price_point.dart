import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_point.freezed.dart';

/// One price in a coin's history: what it was, and when.
@freezed
abstract class PricePoint with _$PricePoint {
  const factory PricePoint({required DateTime at, required double priceUsd}) =
      _PricePoint;
}
