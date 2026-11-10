import 'package:json_annotation/json_annotation.dart';

part 'exchange_rates_dto.g.dart';

/// The exchange rates as the service sends them: units of each currency per
/// one unit of [base].
@JsonSerializable()
class ExchangeRatesDto {
  const ExchangeRatesDto({required this.base, required this.rates});

  factory ExchangeRatesDto.fromJson(Map<String, Object?> json) =>
      _$ExchangeRatesDtoFromJson(json);

  /// Always "USD" here (the mapper checks).
  final String base;

  /// By ISO 4217 code: `{"EUR": 0.92, …}`.
  final Map<String, double> rates;

  Map<String, Object?> toJson() => _$ExchangeRatesDtoToJson(this);
}
