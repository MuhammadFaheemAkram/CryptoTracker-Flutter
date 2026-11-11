// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchlistListing {

 List<MarketCoin> get rows; Currency get currency;/// Units of [currency] per dollar.
 double get rate;/// The user paused live prices: nothing is moving.
 bool get isPaused;
/// Create a copy of WatchlistListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistListingCopyWith<WatchlistListing> get copyWith => _$WatchlistListingCopyWithImpl<WatchlistListing>(this as WatchlistListing, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WatchlistListing;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistListing&&const DeepCollectionEquality().equals(other.rows, _this.rows)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.rate, _this.rate) || other.rate == _this.rate)&&(identical(other.isPaused, _this.isPaused) || other.isPaused == _this.isPaused));
}


@override
int get hashCode {
  final _this = this as WatchlistListing;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.rows),_this.currency,_this.rate,_this.isPaused);
}

@override
String toString() {
  final _this = this as WatchlistListing;
  return 'WatchlistListing(rows: ${_this.rows}, currency: ${_this.currency}, rate: ${_this.rate}, isPaused: ${_this.isPaused})';
}


}

/// @nodoc
abstract mixin class $WatchlistListingCopyWith<$Res>  {
  factory $WatchlistListingCopyWith(WatchlistListing value, $Res Function(WatchlistListing) _then) = _$WatchlistListingCopyWithImpl;
@useResult
$Res call({
 List<MarketCoin> rows, Currency currency, double rate, bool isPaused
});




}
/// @nodoc
class _$WatchlistListingCopyWithImpl<$Res>
    implements $WatchlistListingCopyWith<$Res> {
  _$WatchlistListingCopyWithImpl(this._self, this._then);

  final WatchlistListing _self;
  final $Res Function(WatchlistListing) _then;

/// Create a copy of WatchlistListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rows = null,Object? currency = null,Object? rate = null,Object? isPaused = null,}) {
  return _then(WatchlistListing(
rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<MarketCoin>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchlistListing].
extension WatchlistListingPatterns on WatchlistListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchlistListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchlistListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchlistListing value)  $default,){
final _that = this;
switch (_that) {
case _WatchlistListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchlistListing value)?  $default,){
final _that = this;
switch (_that) {
case _WatchlistListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MarketCoin> rows,  Currency currency,  double rate,  bool isPaused)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchlistListing() when $default != null:
return $default(_that.rows,_that.currency,_that.rate,_that.isPaused);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MarketCoin> rows,  Currency currency,  double rate,  bool isPaused)  $default,) {final _that = this;
switch (_that) {
case _WatchlistListing():
return $default(_that.rows,_that.currency,_that.rate,_that.isPaused);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MarketCoin> rows,  Currency currency,  double rate,  bool isPaused)?  $default,) {final _that = this;
switch (_that) {
case _WatchlistListing() when $default != null:
return $default(_that.rows,_that.currency,_that.rate,_that.isPaused);case _:
  return null;

}
}

}

/// @nodoc


class _WatchlistListing implements WatchlistListing {
  const _WatchlistListing({required  List<MarketCoin> rows, required this.currency, required this.rate, required this.isPaused}): _rows = rows;
  

 final  List<MarketCoin> _rows;
@override List<MarketCoin> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override final  Currency currency;
/// Units of [currency] per dollar.
@override final  double rate;
/// The user paused live prices: nothing is moving.
@override final  bool isPaused;

/// Create a copy of WatchlistListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchlistListingCopyWith<_WatchlistListing> get copyWith => __$WatchlistListingCopyWithImpl<_WatchlistListing>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchlistListing&&const DeepCollectionEquality().equals(other.rows, _rows)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_rows),currency,rate,isPaused);
}

@override
String toString() {
    return 'WatchlistListing(rows: $rows, currency: $currency, rate: $rate, isPaused: $isPaused)';
}


}

/// @nodoc
abstract mixin class _$WatchlistListingCopyWith<$Res> implements $WatchlistListingCopyWith<$Res> {
  factory _$WatchlistListingCopyWith(_WatchlistListing value, $Res Function(_WatchlistListing) _then) = __$WatchlistListingCopyWithImpl;
@override @useResult
$Res call({
 List<MarketCoin> rows, Currency currency, double rate, bool isPaused
});




}
/// @nodoc
class __$WatchlistListingCopyWithImpl<$Res>
    implements _$WatchlistListingCopyWith<$Res> {
  __$WatchlistListingCopyWithImpl(this._self, this._then);

  final _WatchlistListing _self;
  final $Res Function(_WatchlistListing) _then;

/// Create a copy of WatchlistListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rows = null,Object? currency = null,Object? rate = null,Object? isPaused = null,}) {
  return _then(_WatchlistListing(
rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<MarketCoin>,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
