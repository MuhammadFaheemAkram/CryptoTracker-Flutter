// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketListing {

 List<MarketCoin> get rows;/// The query the rows were filtered by: settled (debounced) and
/// trimmed.
 String get query; SortOption get sort; Currency get currency;/// Units of [currency] per dollar.
 double get rate;/// The user paused live prices: nothing is moving.
 bool get isPaused;
/// Create a copy of MarketListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketListingCopyWith<MarketListing> get copyWith => _$MarketListingCopyWithImpl<MarketListing>(this as MarketListing, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MarketListing;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketListing&&const DeepCollectionEquality().equals(other.rows, _this.rows)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.rate, _this.rate) || other.rate == _this.rate)&&(identical(other.isPaused, _this.isPaused) || other.isPaused == _this.isPaused));
}


@override
int get hashCode {
  final _this = this as MarketListing;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.rows),_this.query,_this.sort,_this.currency,_this.rate,_this.isPaused);
}

@override
String toString() {
  final _this = this as MarketListing;
  return 'MarketListing(rows: ${_this.rows}, query: ${_this.query}, sort: ${_this.sort}, currency: ${_this.currency}, rate: ${_this.rate}, isPaused: ${_this.isPaused})';
}


}

/// @nodoc
abstract mixin class $MarketListingCopyWith<$Res>  {
  factory $MarketListingCopyWith(MarketListing value, $Res Function(MarketListing) _then) = _$MarketListingCopyWithImpl;
@useResult
$Res call({
 List<MarketCoin> rows, String query, SortOption sort, Currency currency, double rate, bool isPaused
});




}
/// @nodoc
class _$MarketListingCopyWithImpl<$Res>
    implements $MarketListingCopyWith<$Res> {
  _$MarketListingCopyWithImpl(this._self, this._then);

  final MarketListing _self;
  final $Res Function(MarketListing) _then;

/// Create a copy of MarketListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rows = null,Object? query = null,Object? sort = null,Object? currency = null,Object? rate = null,Object? isPaused = null,}) {
  return _then(MarketListing(
rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<MarketCoin>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as SortOption,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketListing].
extension MarketListingPatterns on MarketListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketListing value)  $default,){
final _that = this;
switch (_that) {
case _MarketListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketListing value)?  $default,){
final _that = this;
switch (_that) {
case _MarketListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MarketCoin> rows,  String query,  SortOption sort,  Currency currency,  double rate,  bool isPaused)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketListing() when $default != null:
return $default(_that.rows,_that.query,_that.sort,_that.currency,_that.rate,_that.isPaused);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MarketCoin> rows,  String query,  SortOption sort,  Currency currency,  double rate,  bool isPaused)  $default,) {final _that = this;
switch (_that) {
case _MarketListing():
return $default(_that.rows,_that.query,_that.sort,_that.currency,_that.rate,_that.isPaused);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MarketCoin> rows,  String query,  SortOption sort,  Currency currency,  double rate,  bool isPaused)?  $default,) {final _that = this;
switch (_that) {
case _MarketListing() when $default != null:
return $default(_that.rows,_that.query,_that.sort,_that.currency,_that.rate,_that.isPaused);case _:
  return null;

}
}

}

/// @nodoc


class _MarketListing implements MarketListing {
  const _MarketListing({required  List<MarketCoin> rows, required this.query, required this.sort, required this.currency, required this.rate, required this.isPaused}): _rows = rows;
  

 final  List<MarketCoin> _rows;
@override List<MarketCoin> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

/// The query the rows were filtered by: settled (debounced) and
/// trimmed.
@override final  String query;
@override final  SortOption sort;
@override final  Currency currency;
/// Units of [currency] per dollar.
@override final  double rate;
/// The user paused live prices: nothing is moving.
@override final  bool isPaused;

/// Create a copy of MarketListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketListingCopyWith<_MarketListing> get copyWith => __$MarketListingCopyWithImpl<_MarketListing>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketListing&&const DeepCollectionEquality().equals(other.rows, _rows)&&(identical(other.query, query) || other.query == query)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_rows),query,sort,currency,rate,isPaused);
}

@override
String toString() {
    return 'MarketListing(rows: $rows, query: $query, sort: $sort, currency: $currency, rate: $rate, isPaused: $isPaused)';
}


}

/// @nodoc
abstract mixin class _$MarketListingCopyWith<$Res> implements $MarketListingCopyWith<$Res> {
  factory _$MarketListingCopyWith(_MarketListing value, $Res Function(_MarketListing) _then) = __$MarketListingCopyWithImpl;
@override @useResult
$Res call({
 List<MarketCoin> rows, String query, SortOption sort, Currency currency, double rate, bool isPaused
});




}
/// @nodoc
class __$MarketListingCopyWithImpl<$Res>
    implements _$MarketListingCopyWith<$Res> {
  __$MarketListingCopyWithImpl(this._self, this._then);

  final _MarketListing _self;
  final $Res Function(_MarketListing) _then;

/// Create a copy of MarketListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rows = null,Object? query = null,Object? sort = null,Object? currency = null,Object? rate = null,Object? isPaused = null,}) {
  return _then(_MarketListing(
rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<MarketCoin>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as SortOption,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
