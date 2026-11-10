// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'coin_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinDto _$CoinDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'CoinDto',
  json,
  ($checkedConvert) {
    final val = CoinDto(
      id: $checkedConvert('id', (v) => v as String),
      symbol: $checkedConvert('symbol', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      marketCapRank: $checkedConvert(
        'market_cap_rank',
        (v) => (v as num).toInt(),
      ),
      currentPrice: $checkedConvert('current_price', (v) => v as String),
      priceChangePercentage24h: $checkedConvert(
        'price_change_percentage_24h',
        (v) => (v as num).toDouble(),
      ),
      marketCap: $checkedConvert('market_cap', (v) => v as String),
      totalVolume: $checkedConvert('total_volume', (v) => v as String),
      circulatingSupply: $checkedConvert(
        'circulating_supply',
        (v) => v as String,
      ),
      totalSupply: $checkedConvert('total_supply', (v) => v as String?),
      allTimeHigh: $checkedConvert('all_time_high', (v) => v as String),
      sparkline7d: $checkedConvert(
        'sparkline_7d',
        (v) => (v as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      ),
      isStablecoin: $checkedConvert(
        'is_stablecoin',
        (v) => v as bool? ?? false,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'marketCapRank': 'market_cap_rank',
    'currentPrice': 'current_price',
    'priceChangePercentage24h': 'price_change_percentage_24h',
    'marketCap': 'market_cap',
    'totalVolume': 'total_volume',
    'circulatingSupply': 'circulating_supply',
    'totalSupply': 'total_supply',
    'allTimeHigh': 'all_time_high',
    'sparkline7d': 'sparkline_7d',
    'isStablecoin': 'is_stablecoin',
  },
);

Map<String, dynamic> _$CoinDtoToJson(CoinDto instance) => <String, dynamic>{
  'id': instance.id,
  'symbol': instance.symbol,
  'name': instance.name,
  'market_cap_rank': instance.marketCapRank,
  'current_price': instance.currentPrice,
  'price_change_percentage_24h': instance.priceChangePercentage24h,
  'market_cap': instance.marketCap,
  'total_volume': instance.totalVolume,
  'circulating_supply': instance.circulatingSupply,
  'total_supply': instance.totalSupply,
  'all_time_high': instance.allTimeHigh,
  'sparkline_7d': instance.sparkline7d,
  'is_stablecoin': instance.isStablecoin,
};
