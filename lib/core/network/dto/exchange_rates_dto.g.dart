// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'exchange_rates_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRatesDto _$ExchangeRatesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ExchangeRatesDto', json, ($checkedConvert) {
      final val = ExchangeRatesDto(
        base: $checkedConvert('base', (v) => v as String),
        rates: $checkedConvert(
          'rates',
          (v) => (v as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ExchangeRatesDtoToJson(ExchangeRatesDto instance) =>
    <String, dynamic>{'base': instance.base, 'rates': instance.rates};
