// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watched_coin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchedCoin {

 String get coinId; DateTime get addedAt;
/// Create a copy of WatchedCoin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchedCoinCopyWith<WatchedCoin> get copyWith => _$WatchedCoinCopyWithImpl<WatchedCoin>(this as WatchedCoin, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WatchedCoin;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchedCoin&&(identical(other.coinId, _this.coinId) || other.coinId == _this.coinId)&&(identical(other.addedAt, _this.addedAt) || other.addedAt == _this.addedAt));
}


@override
int get hashCode {
  final _this = this as WatchedCoin;
  return Object.hash(runtimeType,_this.coinId,_this.addedAt);
}

@override
String toString() {
  final _this = this as WatchedCoin;
  return 'WatchedCoin(coinId: ${_this.coinId}, addedAt: ${_this.addedAt})';
}


}

/// @nodoc
abstract mixin class $WatchedCoinCopyWith<$Res>  {
  factory $WatchedCoinCopyWith(WatchedCoin value, $Res Function(WatchedCoin) _then) = _$WatchedCoinCopyWithImpl;
@useResult
$Res call({
 String coinId, DateTime addedAt
});




}
/// @nodoc
class _$WatchedCoinCopyWithImpl<$Res>
    implements $WatchedCoinCopyWith<$Res> {
  _$WatchedCoinCopyWithImpl(this._self, this._then);

  final WatchedCoin _self;
  final $Res Function(WatchedCoin) _then;

/// Create a copy of WatchedCoin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coinId = null,Object? addedAt = null,}) {
  return _then(WatchedCoin(
coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchedCoin].
extension WatchedCoinPatterns on WatchedCoin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchedCoin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchedCoin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchedCoin value)  $default,){
final _that = this;
switch (_that) {
case _WatchedCoin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchedCoin value)?  $default,){
final _that = this;
switch (_that) {
case _WatchedCoin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coinId,  DateTime addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchedCoin() when $default != null:
return $default(_that.coinId,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coinId,  DateTime addedAt)  $default,) {final _that = this;
switch (_that) {
case _WatchedCoin():
return $default(_that.coinId,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coinId,  DateTime addedAt)?  $default,) {final _that = this;
switch (_that) {
case _WatchedCoin() when $default != null:
return $default(_that.coinId,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc


class _WatchedCoin implements WatchedCoin {
  const _WatchedCoin({required this.coinId, required this.addedAt});
  

@override final  String coinId;
@override final  DateTime addedAt;

/// Create a copy of WatchedCoin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchedCoinCopyWith<_WatchedCoin> get copyWith => __$WatchedCoinCopyWithImpl<_WatchedCoin>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchedCoin&&(identical(other.coinId, coinId) || other.coinId == coinId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,coinId,addedAt);
}

@override
String toString() {
    return 'WatchedCoin(coinId: $coinId, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$WatchedCoinCopyWith<$Res> implements $WatchedCoinCopyWith<$Res> {
  factory _$WatchedCoinCopyWith(_WatchedCoin value, $Res Function(_WatchedCoin) _then) = __$WatchedCoinCopyWithImpl;
@override @useResult
$Res call({
 String coinId, DateTime addedAt
});




}
/// @nodoc
class __$WatchedCoinCopyWithImpl<$Res>
    implements _$WatchedCoinCopyWith<$Res> {
  __$WatchedCoinCopyWithImpl(this._self, this._then);

  final _WatchedCoin _self;
  final $Res Function(_WatchedCoin) _then;

/// Create a copy of WatchedCoin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coinId = null,Object? addedAt = null,}) {
  return _then(_WatchedCoin(
coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
