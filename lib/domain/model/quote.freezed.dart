// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Quote {

 String get coinId; double get priceUsd; double get open24hUsd; DateTime get updatedAt;
/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteCopyWith<Quote> get copyWith => _$QuoteCopyWithImpl<Quote>(this as Quote, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Quote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quote&&(identical(other.coinId, _this.coinId) || other.coinId == _this.coinId)&&(identical(other.priceUsd, _this.priceUsd) || other.priceUsd == _this.priceUsd)&&(identical(other.open24hUsd, _this.open24hUsd) || other.open24hUsd == _this.open24hUsd)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as Quote;
  return Object.hash(runtimeType,_this.coinId,_this.priceUsd,_this.open24hUsd,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Quote;
  return 'Quote(coinId: ${_this.coinId}, priceUsd: ${_this.priceUsd}, open24hUsd: ${_this.open24hUsd}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $QuoteCopyWith<$Res>  {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) _then) = _$QuoteCopyWithImpl;
@useResult
$Res call({
 String coinId, double priceUsd, double open24hUsd, DateTime updatedAt
});




}
/// @nodoc
class _$QuoteCopyWithImpl<$Res>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._self, this._then);

  final Quote _self;
  final $Res Function(Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coinId = null,Object? priceUsd = null,Object? open24hUsd = null,Object? updatedAt = null,}) {
  return _then(Quote(
coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,priceUsd: null == priceUsd ? _self.priceUsd : priceUsd // ignore: cast_nullable_to_non_nullable
as double,open24hUsd: null == open24hUsd ? _self.open24hUsd : open24hUsd // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Quote].
extension QuotePatterns on Quote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quote value)  $default,){
final _that = this;
switch (_that) {
case _Quote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quote value)?  $default,){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coinId,  double priceUsd,  double open24hUsd,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.coinId,_that.priceUsd,_that.open24hUsd,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coinId,  double priceUsd,  double open24hUsd,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Quote():
return $default(_that.coinId,_that.priceUsd,_that.open24hUsd,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coinId,  double priceUsd,  double open24hUsd,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.coinId,_that.priceUsd,_that.open24hUsd,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Quote extends Quote {
  const _Quote({required this.coinId, required this.priceUsd, required this.open24hUsd, required this.updatedAt}): super._();
  

@override final  String coinId;
@override final  double priceUsd;
@override final  double open24hUsd;
@override final  DateTime updatedAt;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteCopyWith<_Quote> get copyWith => __$QuoteCopyWithImpl<_Quote>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quote&&(identical(other.coinId, coinId) || other.coinId == coinId)&&(identical(other.priceUsd, priceUsd) || other.priceUsd == priceUsd)&&(identical(other.open24hUsd, open24hUsd) || other.open24hUsd == open24hUsd)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,coinId,priceUsd,open24hUsd,updatedAt);
}

@override
String toString() {
    return 'Quote(coinId: $coinId, priceUsd: $priceUsd, open24hUsd: $open24hUsd, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$QuoteCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$QuoteCopyWith(_Quote value, $Res Function(_Quote) _then) = __$QuoteCopyWithImpl;
@override @useResult
$Res call({
 String coinId, double priceUsd, double open24hUsd, DateTime updatedAt
});




}
/// @nodoc
class __$QuoteCopyWithImpl<$Res>
    implements _$QuoteCopyWith<$Res> {
  __$QuoteCopyWithImpl(this._self, this._then);

  final _Quote _self;
  final $Res Function(_Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coinId = null,Object? priceUsd = null,Object? open24hUsd = null,Object? updatedAt = null,}) {
  return _then(_Quote(
coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,priceUsd: null == priceUsd ? _self.priceUsd : priceUsd // ignore: cast_nullable_to_non_nullable
as double,open24hUsd: null == open24hUsd ? _self.open24hUsd : open24hUsd // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
