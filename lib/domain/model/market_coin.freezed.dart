// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_coin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketCoin {

 Coin get coin; Quote get quote;/// Which way the price moved on the last tick.
 PriceDirection get direction; bool get isWatched;
/// Create a copy of MarketCoin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketCoinCopyWith<MarketCoin> get copyWith => _$MarketCoinCopyWithImpl<MarketCoin>(this as MarketCoin, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MarketCoin;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketCoin&&(identical(other.coin, _this.coin) || other.coin == _this.coin)&&(identical(other.quote, _this.quote) || other.quote == _this.quote)&&(identical(other.direction, _this.direction) || other.direction == _this.direction)&&(identical(other.isWatched, _this.isWatched) || other.isWatched == _this.isWatched));
}


@override
int get hashCode {
  final _this = this as MarketCoin;
  return Object.hash(runtimeType,_this.coin,_this.quote,_this.direction,_this.isWatched);
}

@override
String toString() {
  final _this = this as MarketCoin;
  return 'MarketCoin(coin: ${_this.coin}, quote: ${_this.quote}, direction: ${_this.direction}, isWatched: ${_this.isWatched})';
}


}

/// @nodoc
abstract mixin class $MarketCoinCopyWith<$Res>  {
  factory $MarketCoinCopyWith(MarketCoin value, $Res Function(MarketCoin) _then) = _$MarketCoinCopyWithImpl;
@useResult
$Res call({
 Coin coin, Quote quote, PriceDirection direction, bool isWatched
});


$CoinCopyWith<$Res> get coin;$QuoteCopyWith<$Res> get quote;

}
/// @nodoc
class _$MarketCoinCopyWithImpl<$Res>
    implements $MarketCoinCopyWith<$Res> {
  _$MarketCoinCopyWithImpl(this._self, this._then);

  final MarketCoin _self;
  final $Res Function(MarketCoin) _then;

/// Create a copy of MarketCoin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coin = null,Object? quote = null,Object? direction = null,Object? isWatched = null,}) {
  return _then(MarketCoin(
coin: null == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as Coin,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as PriceDirection,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MarketCoin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoinCopyWith<$Res> get coin {
  
  return $CoinCopyWith<$Res>(_self.coin, (value) {
    return _then(_self.copyWith(coin: value));
  });
}/// Create a copy of MarketCoin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res> get quote {
  
  return $QuoteCopyWith<$Res>(_self.quote, (value) {
    return _then(_self.copyWith(quote: value));
  });
}
}


/// Adds pattern-matching-related methods to [MarketCoin].
extension MarketCoinPatterns on MarketCoin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketCoin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketCoin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketCoin value)  $default,){
final _that = this;
switch (_that) {
case _MarketCoin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketCoin value)?  $default,){
final _that = this;
switch (_that) {
case _MarketCoin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Coin coin,  Quote quote,  PriceDirection direction,  bool isWatched)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketCoin() when $default != null:
return $default(_that.coin,_that.quote,_that.direction,_that.isWatched);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Coin coin,  Quote quote,  PriceDirection direction,  bool isWatched)  $default,) {final _that = this;
switch (_that) {
case _MarketCoin():
return $default(_that.coin,_that.quote,_that.direction,_that.isWatched);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Coin coin,  Quote quote,  PriceDirection direction,  bool isWatched)?  $default,) {final _that = this;
switch (_that) {
case _MarketCoin() when $default != null:
return $default(_that.coin,_that.quote,_that.direction,_that.isWatched);case _:
  return null;

}
}

}

/// @nodoc


class _MarketCoin implements MarketCoin {
  const _MarketCoin({required this.coin, required this.quote, this.direction = PriceDirection.flat, this.isWatched = false});
  

@override final  Coin coin;
@override final  Quote quote;
/// Which way the price moved on the last tick.
@override@JsonKey() final  PriceDirection direction;
@override@JsonKey() final  bool isWatched;

/// Create a copy of MarketCoin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketCoinCopyWith<_MarketCoin> get copyWith => __$MarketCoinCopyWithImpl<_MarketCoin>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketCoin&&(identical(other.coin, coin) || other.coin == coin)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched));
}


@override
int get hashCode {
    return Object.hash(runtimeType,coin,quote,direction,isWatched);
}

@override
String toString() {
    return 'MarketCoin(coin: $coin, quote: $quote, direction: $direction, isWatched: $isWatched)';
}


}

/// @nodoc
abstract mixin class _$MarketCoinCopyWith<$Res> implements $MarketCoinCopyWith<$Res> {
  factory _$MarketCoinCopyWith(_MarketCoin value, $Res Function(_MarketCoin) _then) = __$MarketCoinCopyWithImpl;
@override @useResult
$Res call({
 Coin coin, Quote quote, PriceDirection direction, bool isWatched
});


@override $CoinCopyWith<$Res> get coin;@override $QuoteCopyWith<$Res> get quote;

}
/// @nodoc
class __$MarketCoinCopyWithImpl<$Res>
    implements _$MarketCoinCopyWith<$Res> {
  __$MarketCoinCopyWithImpl(this._self, this._then);

  final _MarketCoin _self;
  final $Res Function(_MarketCoin) _then;

/// Create a copy of MarketCoin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coin = null,Object? quote = null,Object? direction = null,Object? isWatched = null,}) {
  return _then(_MarketCoin(
coin: null == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as Coin,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as PriceDirection,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MarketCoin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoinCopyWith<$Res> get coin {
  
  return $CoinCopyWith<$Res>(_self.coin, (value) {
    return _then(_self.copyWith(coin: value));
  });
}/// Create a copy of MarketCoin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res> get quote {
  
  return $QuoteCopyWith<$Res>(_self.quote, (value) {
    return _then(_self.copyWith(quote: value));
  });
}
}

// dart format on
