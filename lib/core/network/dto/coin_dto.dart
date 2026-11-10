import 'package:json_annotation/json_annotation.dart';

part 'coin_dto.g.dart';

/// One coin as the market service sends it (the iOS edition's
/// `coins_seed.json`, with `is_stablecoin` added).
///
/// Money and supplies arrive as **strings** ("67240.50"), as many real
/// market APIs send them to avoid floating-point surprises in JSON. The
/// mapper parses and checks them; a DTO only mirrors the wire format.
@JsonSerializable()
class CoinDto {
  const CoinDto({
    required this.id,
    required this.symbol,
    required this.name,
    required this.marketCapRank,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.allTimeHigh,
    required this.sparkline7d,
    this.isStablecoin = false,
  });

  factory CoinDto.fromJson(Map<String, Object?> json) =>
      _$CoinDtoFromJson(json);

  final String id;
  final String symbol;
  final String name;
  final int marketCapRank;
  final String currentPrice;

  // A digit after the last word: `field_rename: snake` would write
  // `price_change_percentage24h`.
  @JsonKey(name: 'price_change_percentage_24h')
  final double priceChangePercentage24h;
  final String marketCap;
  final String totalVolume;
  final String circulatingSupply;

  /// `null` when the coin has no maximum supply.
  final String? totalSupply;
  final String allTimeHigh;

  @JsonKey(name: 'sparkline_7d')
  final List<double> sparkline7d;
  final bool isStablecoin;

  Map<String, Object?> toJson() => _$CoinDtoToJson(this);
}
