// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoinDetail {

 Coin get coin; Quote get quote;/// Which way the price moved on the last tick: the header's flash.
 PriceDirection get direction;/// The prices seen since launch, oldest first.
 List<PricePoint> get livePoints;/// The highest price seen since launch.
 double? get highestSeenUsd; bool get isWatched; ChartRange get range; Currency get currency;/// Units of [currency] per dollar.
 double get rate;/// The user paused live prices: nothing is moving.
 bool get isPaused;
/// Create a copy of CoinDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinDetailCopyWith<CoinDetail> get copyWith => _$CoinDetailCopyWithImpl<CoinDetail>(this as CoinDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CoinDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinDetail&&(identical(other.coin, _this.coin) || other.coin == _this.coin)&&(identical(other.quote, _this.quote) || other.quote == _this.quote)&&(identical(other.direction, _this.direction) || other.direction == _this.direction)&&const DeepCollectionEquality().equals(other.livePoints, _this.livePoints)&&(identical(other.highestSeenUsd, _this.highestSeenUsd) || other.highestSeenUsd == _this.highestSeenUsd)&&(identical(other.isWatched, _this.isWatched) || other.isWatched == _this.isWatched)&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.rate, _this.rate) || other.rate == _this.rate)&&(identical(other.isPaused, _this.isPaused) || other.isPaused == _this.isPaused));
}


@override
int get hashCode {
  final _this = this as CoinDetail;
  return Object.hash(runtimeType,_this.coin,_this.quote,_this.direction,const DeepCollectionEquality().hash(_this.livePoints),_this.highestSeenUsd,_this.isWatched,_this.range,_this.currency,_this.rate,_this.isPaused);
}

@override
String toString() {
  final _this = this as CoinDetail;
  return 'CoinDetail(coin: ${_this.coin}, quote: ${_this.quote}, direction: ${_this.direction}, livePoints: ${_this.livePoints}, highestSeenUsd: ${_this.highestSeenUsd}, isWatched: ${_this.isWatched}, range: ${_this.range}, currency: ${_this.currency}, rate: ${_this.rate}, isPaused: ${_this.isPaused})';
}


}

/// @nodoc
abstract mixin class $CoinDetailCopyWith<$Res>  {
  factory $CoinDetailCopyWith(CoinDetail value, $Res Function(CoinDetail) _then) = _$CoinDetailCopyWithImpl;
@useResult
$Res call({
 Coin coin, Quote quote, PriceDirection direction, List<PricePoint> livePoints, double? highestSeenUsd, bool isWatched, ChartRange range, Currency currency, double rate, bool isPaused
});


$CoinCopyWith<$Res> get coin;$QuoteCopyWith<$Res> get quote;

}
/// @nodoc
class _$CoinDetailCopyWithImpl<$Res>
    implements $CoinDetailCopyWith<$Res> {
  _$CoinDetailCopyWithImpl(this._self, this._then);

  final CoinDetail _self;
  final $Res Function(CoinDetail) _then;

/// Create a copy of CoinDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coin = null,Object? quote = null,Object? direction = null,Object? livePoints = null,Object? highestSeenUsd = freezed,Object? isWatched = null,Object? range = null,Object? currency = null,Object? rate = null,Object? isPaused = null,}) {
  return _then(CoinDetail(
coin: null == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as Coin,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as PriceDirection,livePoints: null == livePoints ? _self.livePoints : livePoints // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,highestSeenUsd: freezed == highestSeenUsd ? _self.highestSeenUsd : highestSeenUsd // ignore: cast_nullable_to_non_nullable
as double?,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ChartRange,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CoinDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoinCopyWith<$Res> get coin {
  
  return $CoinCopyWith<$Res>(_self.coin, (value) {
    return _then(_self.copyWith(coin: value));
  });
}/// Create a copy of CoinDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res> get quote {
  
  return $QuoteCopyWith<$Res>(_self.quote, (value) {
    return _then(_self.copyWith(quote: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoinDetail].
extension CoinDetailPatterns on CoinDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoinDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoinDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoinDetail value)  $default,){
final _that = this;
switch (_that) {
case _CoinDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoinDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CoinDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Coin coin,  Quote quote,  PriceDirection direction,  List<PricePoint> livePoints,  double? highestSeenUsd,  bool isWatched,  ChartRange range,  Currency currency,  double rate,  bool isPaused)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoinDetail() when $default != null:
return $default(_that.coin,_that.quote,_that.direction,_that.livePoints,_that.highestSeenUsd,_that.isWatched,_that.range,_that.currency,_that.rate,_that.isPaused);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Coin coin,  Quote quote,  PriceDirection direction,  List<PricePoint> livePoints,  double? highestSeenUsd,  bool isWatched,  ChartRange range,  Currency currency,  double rate,  bool isPaused)  $default,) {final _that = this;
switch (_that) {
case _CoinDetail():
return $default(_that.coin,_that.quote,_that.direction,_that.livePoints,_that.highestSeenUsd,_that.isWatched,_that.range,_that.currency,_that.rate,_that.isPaused);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Coin coin,  Quote quote,  PriceDirection direction,  List<PricePoint> livePoints,  double? highestSeenUsd,  bool isWatched,  ChartRange range,  Currency currency,  double rate,  bool isPaused)?  $default,) {final _that = this;
switch (_that) {
case _CoinDetail() when $default != null:
return $default(_that.coin,_that.quote,_that.direction,_that.livePoints,_that.highestSeenUsd,_that.isWatched,_that.range,_that.currency,_that.rate,_that.isPaused);case _:
  return null;

}
}

}

/// @nodoc


class _CoinDetail extends CoinDetail {
  const _CoinDetail({required this.coin, required this.quote, this.direction = PriceDirection.flat,  List<PricePoint> livePoints = const <PricePoint>[], this.highestSeenUsd, this.isWatched = false, this.range = ChartRange.live, required this.currency, required this.rate, this.isPaused = false}): _livePoints = livePoints,super._();
  

@override final  Coin coin;
@override final  Quote quote;
/// Which way the price moved on the last tick: the header's flash.
@override@JsonKey() final  PriceDirection direction;
/// The prices seen since launch, oldest first.
 final  List<PricePoint> _livePoints;
/// The prices seen since launch, oldest first.
@override@JsonKey() List<PricePoint> get livePoints {
  if (_livePoints is EqualUnmodifiableListView) return _livePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_livePoints);
}

/// The highest price seen since launch.
@override final  double? highestSeenUsd;
@override@JsonKey() final  bool isWatched;
@override@JsonKey() final  ChartRange range;
@override final  Currency currency;
/// Units of [currency] per dollar.
@override final  double rate;
/// The user paused live prices: nothing is moving.
@override@JsonKey() final  bool isPaused;

/// Create a copy of CoinDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinDetailCopyWith<_CoinDetail> get copyWith => __$CoinDetailCopyWithImpl<_CoinDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoinDetail&&(identical(other.coin, coin) || other.coin == coin)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.direction, direction) || other.direction == direction)&&const DeepCollectionEquality().equals(other.livePoints, _livePoints)&&(identical(other.highestSeenUsd, highestSeenUsd) || other.highestSeenUsd == highestSeenUsd)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched)&&(identical(other.range, range) || other.range == range)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused));
}


@override
int get hashCode {
    return Object.hash(runtimeType,coin,quote,direction,const DeepCollectionEquality().hash(_livePoints),highestSeenUsd,isWatched,range,currency,rate,isPaused);
}

@override
String toString() {
    return 'CoinDetail(coin: $coin, quote: $quote, direction: $direction, livePoints: $livePoints, highestSeenUsd: $highestSeenUsd, isWatched: $isWatched, range: $range, currency: $currency, rate: $rate, isPaused: $isPaused)';
}


}

/// @nodoc
abstract mixin class _$CoinDetailCopyWith<$Res> implements $CoinDetailCopyWith<$Res> {
  factory _$CoinDetailCopyWith(_CoinDetail value, $Res Function(_CoinDetail) _then) = __$CoinDetailCopyWithImpl;
@override @useResult
$Res call({
 Coin coin, Quote quote, PriceDirection direction, List<PricePoint> livePoints, double? highestSeenUsd, bool isWatched, ChartRange range, Currency currency, double rate, bool isPaused
});


@override $CoinCopyWith<$Res> get coin;@override $QuoteCopyWith<$Res> get quote;

}
/// @nodoc
class __$CoinDetailCopyWithImpl<$Res>
    implements _$CoinDetailCopyWith<$Res> {
  __$CoinDetailCopyWithImpl(this._self, this._then);

  final _CoinDetail _self;
  final $Res Function(_CoinDetail) _then;

/// Create a copy of CoinDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coin = null,Object? quote = null,Object? direction = null,Object? livePoints = null,Object? highestSeenUsd = freezed,Object? isWatched = null,Object? range = null,Object? currency = null,Object? rate = null,Object? isPaused = null,}) {
  return _then(_CoinDetail(
coin: null == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as Coin,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as PriceDirection,livePoints: null == livePoints ? _self._livePoints : livePoints // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,highestSeenUsd: freezed == highestSeenUsd ? _self.highestSeenUsd : highestSeenUsd // ignore: cast_nullable_to_non_nullable
as double?,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ChartRange,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CoinDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoinCopyWith<$Res> get coin {
  
  return $CoinCopyWith<$Res>(_self.coin, (value) {
    return _then(_self.copyWith(coin: value));
  });
}/// Create a copy of CoinDetail
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
