// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Coin {

 String get id; String get symbol; String get name;/// 1 for the largest market cap. Fixed by the seed.
 int get rank; double get marketCapUsd; double get volume24hUsd; double get circulatingSupply;/// `null` when there is no maximum supply.
 double? get totalSupply; double get allTimeHighUsd;/// Pegged to a fiat currency (USDT, USDC, DAI): it barely moves.
 bool get isStablecoin;/// The last 7 days, oldest first (24 points, from the seed).
 List<double> get sparkline7d;
/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinCopyWith<Coin> get copyWith => _$CoinCopyWithImpl<Coin>(this as Coin, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Coin;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coin&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.marketCapUsd, _this.marketCapUsd) || other.marketCapUsd == _this.marketCapUsd)&&(identical(other.volume24hUsd, _this.volume24hUsd) || other.volume24hUsd == _this.volume24hUsd)&&(identical(other.circulatingSupply, _this.circulatingSupply) || other.circulatingSupply == _this.circulatingSupply)&&(identical(other.totalSupply, _this.totalSupply) || other.totalSupply == _this.totalSupply)&&(identical(other.allTimeHighUsd, _this.allTimeHighUsd) || other.allTimeHighUsd == _this.allTimeHighUsd)&&(identical(other.isStablecoin, _this.isStablecoin) || other.isStablecoin == _this.isStablecoin)&&const DeepCollectionEquality().equals(other.sparkline7d, _this.sparkline7d));
}


@override
int get hashCode {
  final _this = this as Coin;
  return Object.hash(runtimeType,_this.id,_this.symbol,_this.name,_this.rank,_this.marketCapUsd,_this.volume24hUsd,_this.circulatingSupply,_this.totalSupply,_this.allTimeHighUsd,_this.isStablecoin,const DeepCollectionEquality().hash(_this.sparkline7d));
}

@override
String toString() {
  final _this = this as Coin;
  return 'Coin(id: ${_this.id}, symbol: ${_this.symbol}, name: ${_this.name}, rank: ${_this.rank}, marketCapUsd: ${_this.marketCapUsd}, volume24hUsd: ${_this.volume24hUsd}, circulatingSupply: ${_this.circulatingSupply}, totalSupply: ${_this.totalSupply}, allTimeHighUsd: ${_this.allTimeHighUsd}, isStablecoin: ${_this.isStablecoin}, sparkline7d: ${_this.sparkline7d})';
}


}

/// @nodoc
abstract mixin class $CoinCopyWith<$Res>  {
  factory $CoinCopyWith(Coin value, $Res Function(Coin) _then) = _$CoinCopyWithImpl;
@useResult
$Res call({
 String id, String symbol, String name, int rank, double marketCapUsd, double volume24hUsd, double circulatingSupply, double? totalSupply, double allTimeHighUsd, bool isStablecoin, List<double> sparkline7d
});




}
/// @nodoc
class _$CoinCopyWithImpl<$Res>
    implements $CoinCopyWith<$Res> {
  _$CoinCopyWithImpl(this._self, this._then);

  final Coin _self;
  final $Res Function(Coin) _then;

/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? symbol = null,Object? name = null,Object? rank = null,Object? marketCapUsd = null,Object? volume24hUsd = null,Object? circulatingSupply = null,Object? totalSupply = freezed,Object? allTimeHighUsd = null,Object? isStablecoin = null,Object? sparkline7d = null,}) {
  return _then(Coin(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,marketCapUsd: null == marketCapUsd ? _self.marketCapUsd : marketCapUsd // ignore: cast_nullable_to_non_nullable
as double,volume24hUsd: null == volume24hUsd ? _self.volume24hUsd : volume24hUsd // ignore: cast_nullable_to_non_nullable
as double,circulatingSupply: null == circulatingSupply ? _self.circulatingSupply : circulatingSupply // ignore: cast_nullable_to_non_nullable
as double,totalSupply: freezed == totalSupply ? _self.totalSupply : totalSupply // ignore: cast_nullable_to_non_nullable
as double?,allTimeHighUsd: null == allTimeHighUsd ? _self.allTimeHighUsd : allTimeHighUsd // ignore: cast_nullable_to_non_nullable
as double,isStablecoin: null == isStablecoin ? _self.isStablecoin : isStablecoin // ignore: cast_nullable_to_non_nullable
as bool,sparkline7d: null == sparkline7d ? _self.sparkline7d : sparkline7d // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [Coin].
extension CoinPatterns on Coin {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coin() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coin value)  $default,){
final _that = this;
switch (_that) {
case _Coin():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coin value)?  $default,){
final _that = this;
switch (_that) {
case _Coin() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String symbol,  String name,  int rank,  double marketCapUsd,  double volume24hUsd,  double circulatingSupply,  double? totalSupply,  double allTimeHighUsd,  bool isStablecoin,  List<double> sparkline7d)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coin() when $default != null:
return $default(_that.id,_that.symbol,_that.name,_that.rank,_that.marketCapUsd,_that.volume24hUsd,_that.circulatingSupply,_that.totalSupply,_that.allTimeHighUsd,_that.isStablecoin,_that.sparkline7d);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String symbol,  String name,  int rank,  double marketCapUsd,  double volume24hUsd,  double circulatingSupply,  double? totalSupply,  double allTimeHighUsd,  bool isStablecoin,  List<double> sparkline7d)  $default,) {final _that = this;
switch (_that) {
case _Coin():
return $default(_that.id,_that.symbol,_that.name,_that.rank,_that.marketCapUsd,_that.volume24hUsd,_that.circulatingSupply,_that.totalSupply,_that.allTimeHighUsd,_that.isStablecoin,_that.sparkline7d);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String symbol,  String name,  int rank,  double marketCapUsd,  double volume24hUsd,  double circulatingSupply,  double? totalSupply,  double allTimeHighUsd,  bool isStablecoin,  List<double> sparkline7d)?  $default,) {final _that = this;
switch (_that) {
case _Coin() when $default != null:
return $default(_that.id,_that.symbol,_that.name,_that.rank,_that.marketCapUsd,_that.volume24hUsd,_that.circulatingSupply,_that.totalSupply,_that.allTimeHighUsd,_that.isStablecoin,_that.sparkline7d);case _:
  return null;

}
}

}

/// @nodoc


class _Coin implements Coin {
  const _Coin({required this.id, required this.symbol, required this.name, required this.rank, required this.marketCapUsd, required this.volume24hUsd, required this.circulatingSupply, required this.totalSupply, required this.allTimeHighUsd, this.isStablecoin = false,  List<double> sparkline7d = const <double>[]}): _sparkline7d = sparkline7d;
  

@override final  String id;
@override final  String symbol;
@override final  String name;
/// 1 for the largest market cap. Fixed by the seed.
@override final  int rank;
@override final  double marketCapUsd;
@override final  double volume24hUsd;
@override final  double circulatingSupply;
/// `null` when there is no maximum supply.
@override final  double? totalSupply;
@override final  double allTimeHighUsd;
/// Pegged to a fiat currency (USDT, USDC, DAI): it barely moves.
@override@JsonKey() final  bool isStablecoin;
/// The last 7 days, oldest first (24 points, from the seed).
 final  List<double> _sparkline7d;
/// The last 7 days, oldest first (24 points, from the seed).
@override@JsonKey() List<double> get sparkline7d {
  if (_sparkline7d is EqualUnmodifiableListView) return _sparkline7d;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sparkline7d);
}


/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinCopyWith<_Coin> get copyWith => __$CoinCopyWithImpl<_Coin>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coin&&(identical(other.id, id) || other.id == id)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.name, name) || other.name == name)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.marketCapUsd, marketCapUsd) || other.marketCapUsd == marketCapUsd)&&(identical(other.volume24hUsd, volume24hUsd) || other.volume24hUsd == volume24hUsd)&&(identical(other.circulatingSupply, circulatingSupply) || other.circulatingSupply == circulatingSupply)&&(identical(other.totalSupply, totalSupply) || other.totalSupply == totalSupply)&&(identical(other.allTimeHighUsd, allTimeHighUsd) || other.allTimeHighUsd == allTimeHighUsd)&&(identical(other.isStablecoin, isStablecoin) || other.isStablecoin == isStablecoin)&&const DeepCollectionEquality().equals(other.sparkline7d, _sparkline7d));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,symbol,name,rank,marketCapUsd,volume24hUsd,circulatingSupply,totalSupply,allTimeHighUsd,isStablecoin,const DeepCollectionEquality().hash(_sparkline7d));
}

@override
String toString() {
    return 'Coin(id: $id, symbol: $symbol, name: $name, rank: $rank, marketCapUsd: $marketCapUsd, volume24hUsd: $volume24hUsd, circulatingSupply: $circulatingSupply, totalSupply: $totalSupply, allTimeHighUsd: $allTimeHighUsd, isStablecoin: $isStablecoin, sparkline7d: $sparkline7d)';
}


}

/// @nodoc
abstract mixin class _$CoinCopyWith<$Res> implements $CoinCopyWith<$Res> {
  factory _$CoinCopyWith(_Coin value, $Res Function(_Coin) _then) = __$CoinCopyWithImpl;
@override @useResult
$Res call({
 String id, String symbol, String name, int rank, double marketCapUsd, double volume24hUsd, double circulatingSupply, double? totalSupply, double allTimeHighUsd, bool isStablecoin, List<double> sparkline7d
});




}
/// @nodoc
class __$CoinCopyWithImpl<$Res>
    implements _$CoinCopyWith<$Res> {
  __$CoinCopyWithImpl(this._self, this._then);

  final _Coin _self;
  final $Res Function(_Coin) _then;

/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? symbol = null,Object? name = null,Object? rank = null,Object? marketCapUsd = null,Object? volume24hUsd = null,Object? circulatingSupply = null,Object? totalSupply = freezed,Object? allTimeHighUsd = null,Object? isStablecoin = null,Object? sparkline7d = null,}) {
  return _then(_Coin(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,marketCapUsd: null == marketCapUsd ? _self.marketCapUsd : marketCapUsd // ignore: cast_nullable_to_non_nullable
as double,volume24hUsd: null == volume24hUsd ? _self.volume24hUsd : volume24hUsd // ignore: cast_nullable_to_non_nullable
as double,circulatingSupply: null == circulatingSupply ? _self.circulatingSupply : circulatingSupply // ignore: cast_nullable_to_non_nullable
as double,totalSupply: freezed == totalSupply ? _self.totalSupply : totalSupply // ignore: cast_nullable_to_non_nullable
as double?,allTimeHighUsd: null == allTimeHighUsd ? _self.allTimeHighUsd : allTimeHighUsd // ignore: cast_nullable_to_non_nullable
as double,isStablecoin: null == isStablecoin ? _self.isStablecoin : isStablecoin // ignore: cast_nullable_to_non_nullable
as bool,sparkline7d: null == sparkline7d ? _self._sparkline7d : sparkline7d // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
