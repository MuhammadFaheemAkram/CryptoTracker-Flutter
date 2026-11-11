// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PortfolioListing {

 PortfolioValuation get valuation; Currency get currency;/// Units of [currency] per dollar.
 double get rate;/// The user paused live prices: nothing is moving.
 bool get isPaused;
/// Create a copy of PortfolioListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioListingCopyWith<PortfolioListing> get copyWith => _$PortfolioListingCopyWithImpl<PortfolioListing>(this as PortfolioListing, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PortfolioListing;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioListing&&(identical(other.valuation, _this.valuation) || other.valuation == _this.valuation)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.rate, _this.rate) || other.rate == _this.rate)&&(identical(other.isPaused, _this.isPaused) || other.isPaused == _this.isPaused));
}


@override
int get hashCode {
  final _this = this as PortfolioListing;
  return Object.hash(runtimeType,_this.valuation,_this.currency,_this.rate,_this.isPaused);
}

@override
String toString() {
  final _this = this as PortfolioListing;
  return 'PortfolioListing(valuation: ${_this.valuation}, currency: ${_this.currency}, rate: ${_this.rate}, isPaused: ${_this.isPaused})';
}


}

/// @nodoc
abstract mixin class $PortfolioListingCopyWith<$Res>  {
  factory $PortfolioListingCopyWith(PortfolioListing value, $Res Function(PortfolioListing) _then) = _$PortfolioListingCopyWithImpl;
@useResult
$Res call({
 PortfolioValuation valuation, Currency currency, double rate, bool isPaused
});


$PortfolioValuationCopyWith<$Res> get valuation;

}
/// @nodoc
class _$PortfolioListingCopyWithImpl<$Res>
    implements $PortfolioListingCopyWith<$Res> {
  _$PortfolioListingCopyWithImpl(this._self, this._then);

  final PortfolioListing _self;
  final $Res Function(PortfolioListing) _then;

/// Create a copy of PortfolioListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? valuation = null,Object? currency = null,Object? rate = null,Object? isPaused = null,}) {
  return _then(PortfolioListing(
valuation: null == valuation ? _self.valuation : valuation // ignore: cast_nullable_to_non_nullable
as PortfolioValuation,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PortfolioListing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioValuationCopyWith<$Res> get valuation {
  
  return $PortfolioValuationCopyWith<$Res>(_self.valuation, (value) {
    return _then(_self.copyWith(valuation: value));
  });
}
}


/// Adds pattern-matching-related methods to [PortfolioListing].
extension PortfolioListingPatterns on PortfolioListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioListing value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioListing value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PortfolioValuation valuation,  Currency currency,  double rate,  bool isPaused)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioListing() when $default != null:
return $default(_that.valuation,_that.currency,_that.rate,_that.isPaused);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PortfolioValuation valuation,  Currency currency,  double rate,  bool isPaused)  $default,) {final _that = this;
switch (_that) {
case _PortfolioListing():
return $default(_that.valuation,_that.currency,_that.rate,_that.isPaused);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PortfolioValuation valuation,  Currency currency,  double rate,  bool isPaused)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioListing() when $default != null:
return $default(_that.valuation,_that.currency,_that.rate,_that.isPaused);case _:
  return null;

}
}

}

/// @nodoc


class _PortfolioListing implements PortfolioListing {
  const _PortfolioListing({required this.valuation, required this.currency, required this.rate, required this.isPaused});
  

@override final  PortfolioValuation valuation;
@override final  Currency currency;
/// Units of [currency] per dollar.
@override final  double rate;
/// The user paused live prices: nothing is moving.
@override final  bool isPaused;

/// Create a copy of PortfolioListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioListingCopyWith<_PortfolioListing> get copyWith => __$PortfolioListingCopyWithImpl<_PortfolioListing>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioListing&&(identical(other.valuation, valuation) || other.valuation == valuation)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused));
}


@override
int get hashCode {
    return Object.hash(runtimeType,valuation,currency,rate,isPaused);
}

@override
String toString() {
    return 'PortfolioListing(valuation: $valuation, currency: $currency, rate: $rate, isPaused: $isPaused)';
}


}

/// @nodoc
abstract mixin class _$PortfolioListingCopyWith<$Res> implements $PortfolioListingCopyWith<$Res> {
  factory _$PortfolioListingCopyWith(_PortfolioListing value, $Res Function(_PortfolioListing) _then) = __$PortfolioListingCopyWithImpl;
@override @useResult
$Res call({
 PortfolioValuation valuation, Currency currency, double rate, bool isPaused
});


@override $PortfolioValuationCopyWith<$Res> get valuation;

}
/// @nodoc
class __$PortfolioListingCopyWithImpl<$Res>
    implements _$PortfolioListingCopyWith<$Res> {
  __$PortfolioListingCopyWithImpl(this._self, this._then);

  final _PortfolioListing _self;
  final $Res Function(_PortfolioListing) _then;

/// Create a copy of PortfolioListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? valuation = null,Object? currency = null,Object? rate = null,Object? isPaused = null,}) {
  return _then(_PortfolioListing(
valuation: null == valuation ? _self.valuation : valuation // ignore: cast_nullable_to_non_nullable
as PortfolioValuation,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PortfolioListing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioValuationCopyWith<$Res> get valuation {
  
  return $PortfolioValuationCopyWith<$Res>(_self.valuation, (value) {
    return _then(_self.copyWith(valuation: value));
  });
}
}

// dart format on
