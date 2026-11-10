// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_seed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketSeed {

/// In rank order.
 List<Coin> get coins;/// The first quote of every coin, by coin id.
 Map<String, Quote> get quotes; ExchangeRates get rates;
/// Create a copy of MarketSeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketSeedCopyWith<MarketSeed> get copyWith => _$MarketSeedCopyWithImpl<MarketSeed>(this as MarketSeed, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MarketSeed;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketSeed&&const DeepCollectionEquality().equals(other.coins, _this.coins)&&const DeepCollectionEquality().equals(other.quotes, _this.quotes)&&(identical(other.rates, _this.rates) || other.rates == _this.rates));
}


@override
int get hashCode {
  final _this = this as MarketSeed;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.coins),const DeepCollectionEquality().hash(_this.quotes),_this.rates);
}

@override
String toString() {
  final _this = this as MarketSeed;
  return 'MarketSeed(coins: ${_this.coins}, quotes: ${_this.quotes}, rates: ${_this.rates})';
}


}

/// @nodoc
abstract mixin class $MarketSeedCopyWith<$Res>  {
  factory $MarketSeedCopyWith(MarketSeed value, $Res Function(MarketSeed) _then) = _$MarketSeedCopyWithImpl;
@useResult
$Res call({
 List<Coin> coins, Map<String, Quote> quotes, ExchangeRates rates
});




}
/// @nodoc
class _$MarketSeedCopyWithImpl<$Res>
    implements $MarketSeedCopyWith<$Res> {
  _$MarketSeedCopyWithImpl(this._self, this._then);

  final MarketSeed _self;
  final $Res Function(MarketSeed) _then;

/// Create a copy of MarketSeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coins = null,Object? quotes = null,Object? rates = null,}) {
  return _then(MarketSeed(
coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as List<Coin>,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as Map<String, Quote>,rates: null == rates ? _self.rates : rates // ignore: cast_nullable_to_non_nullable
as ExchangeRates,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketSeed].
extension MarketSeedPatterns on MarketSeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketSeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketSeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketSeed value)  $default,){
final _that = this;
switch (_that) {
case _MarketSeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketSeed value)?  $default,){
final _that = this;
switch (_that) {
case _MarketSeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Coin> coins,  Map<String, Quote> quotes,  ExchangeRates rates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketSeed() when $default != null:
return $default(_that.coins,_that.quotes,_that.rates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Coin> coins,  Map<String, Quote> quotes,  ExchangeRates rates)  $default,) {final _that = this;
switch (_that) {
case _MarketSeed():
return $default(_that.coins,_that.quotes,_that.rates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Coin> coins,  Map<String, Quote> quotes,  ExchangeRates rates)?  $default,) {final _that = this;
switch (_that) {
case _MarketSeed() when $default != null:
return $default(_that.coins,_that.quotes,_that.rates);case _:
  return null;

}
}

}

/// @nodoc


class _MarketSeed implements MarketSeed {
  const _MarketSeed({required  List<Coin> coins, required  Map<String, Quote> quotes, required this.rates}): _coins = coins,_quotes = quotes;
  

/// In rank order.
 final  List<Coin> _coins;
/// In rank order.
@override List<Coin> get coins {
  if (_coins is EqualUnmodifiableListView) return _coins;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coins);
}

/// The first quote of every coin, by coin id.
 final  Map<String, Quote> _quotes;
/// The first quote of every coin, by coin id.
@override Map<String, Quote> get quotes {
  if (_quotes is EqualUnmodifiableMapView) return _quotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_quotes);
}

@override final  ExchangeRates rates;

/// Create a copy of MarketSeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketSeedCopyWith<_MarketSeed> get copyWith => __$MarketSeedCopyWithImpl<_MarketSeed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketSeed&&const DeepCollectionEquality().equals(other.coins, _coins)&&const DeepCollectionEquality().equals(other.quotes, _quotes)&&(identical(other.rates, rates) || other.rates == rates));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_coins),const DeepCollectionEquality().hash(_quotes),rates);
}

@override
String toString() {
    return 'MarketSeed(coins: $coins, quotes: $quotes, rates: $rates)';
}


}

/// @nodoc
abstract mixin class _$MarketSeedCopyWith<$Res> implements $MarketSeedCopyWith<$Res> {
  factory _$MarketSeedCopyWith(_MarketSeed value, $Res Function(_MarketSeed) _then) = __$MarketSeedCopyWithImpl;
@override @useResult
$Res call({
 List<Coin> coins, Map<String, Quote> quotes, ExchangeRates rates
});




}
/// @nodoc
class __$MarketSeedCopyWithImpl<$Res>
    implements _$MarketSeedCopyWith<$Res> {
  __$MarketSeedCopyWithImpl(this._self, this._then);

  final _MarketSeed _self;
  final $Res Function(_MarketSeed) _then;

/// Create a copy of MarketSeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coins = null,Object? quotes = null,Object? rates = null,}) {
  return _then(_MarketSeed(
coins: null == coins ? _self._coins : coins // ignore: cast_nullable_to_non_nullable
as List<Coin>,quotes: null == quotes ? _self._quotes : quotes // ignore: cast_nullable_to_non_nullable
as Map<String, Quote>,rates: null == rates ? _self.rates : rates // ignore: cast_nullable_to_non_nullable
as ExchangeRates,
  ));
}


}

// dart format on
