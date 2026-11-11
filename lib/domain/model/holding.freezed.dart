// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Holding {

 int get id; String get coinId; double get amount;/// The price paid for one coin, in dollars.
 double get buyPriceUsd; DateTime get createdAt;
/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingCopyWith<Holding> get copyWith => _$HoldingCopyWithImpl<Holding>(this as Holding, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Holding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Holding&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.coinId, _this.coinId) || other.coinId == _this.coinId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.buyPriceUsd, _this.buyPriceUsd) || other.buyPriceUsd == _this.buyPriceUsd)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as Holding;
  return Object.hash(runtimeType,_this.id,_this.coinId,_this.amount,_this.buyPriceUsd,_this.createdAt);
}

@override
String toString() {
  final _this = this as Holding;
  return 'Holding(id: ${_this.id}, coinId: ${_this.coinId}, amount: ${_this.amount}, buyPriceUsd: ${_this.buyPriceUsd}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $HoldingCopyWith<$Res>  {
  factory $HoldingCopyWith(Holding value, $Res Function(Holding) _then) = _$HoldingCopyWithImpl;
@useResult
$Res call({
 int id, String coinId, double amount, double buyPriceUsd, DateTime createdAt
});




}
/// @nodoc
class _$HoldingCopyWithImpl<$Res>
    implements $HoldingCopyWith<$Res> {
  _$HoldingCopyWithImpl(this._self, this._then);

  final Holding _self;
  final $Res Function(Holding) _then;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? coinId = null,Object? amount = null,Object? buyPriceUsd = null,Object? createdAt = null,}) {
  return _then(Holding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,buyPriceUsd: null == buyPriceUsd ? _self.buyPriceUsd : buyPriceUsd // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Holding].
extension HoldingPatterns on Holding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Holding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Holding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Holding value)  $default,){
final _that = this;
switch (_that) {
case _Holding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Holding value)?  $default,){
final _that = this;
switch (_that) {
case _Holding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String coinId,  double amount,  double buyPriceUsd,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that.id,_that.coinId,_that.amount,_that.buyPriceUsd,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String coinId,  double amount,  double buyPriceUsd,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Holding():
return $default(_that.id,_that.coinId,_that.amount,_that.buyPriceUsd,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String coinId,  double amount,  double buyPriceUsd,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that.id,_that.coinId,_that.amount,_that.buyPriceUsd,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Holding implements Holding {
  const _Holding({required this.id, required this.coinId, required this.amount, required this.buyPriceUsd, required this.createdAt});
  

@override final  int id;
@override final  String coinId;
@override final  double amount;
/// The price paid for one coin, in dollars.
@override final  double buyPriceUsd;
@override final  DateTime createdAt;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HoldingCopyWith<_Holding> get copyWith => __$HoldingCopyWithImpl<_Holding>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Holding&&(identical(other.id, id) || other.id == id)&&(identical(other.coinId, coinId) || other.coinId == coinId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.buyPriceUsd, buyPriceUsd) || other.buyPriceUsd == buyPriceUsd)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,coinId,amount,buyPriceUsd,createdAt);
}

@override
String toString() {
    return 'Holding(id: $id, coinId: $coinId, amount: $amount, buyPriceUsd: $buyPriceUsd, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$HoldingCopyWith<$Res> implements $HoldingCopyWith<$Res> {
  factory _$HoldingCopyWith(_Holding value, $Res Function(_Holding) _then) = __$HoldingCopyWithImpl;
@override @useResult
$Res call({
 int id, String coinId, double amount, double buyPriceUsd, DateTime createdAt
});




}
/// @nodoc
class __$HoldingCopyWithImpl<$Res>
    implements _$HoldingCopyWith<$Res> {
  __$HoldingCopyWithImpl(this._self, this._then);

  final _Holding _self;
  final $Res Function(_Holding) _then;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? coinId = null,Object? amount = null,Object? buyPriceUsd = null,Object? createdAt = null,}) {
  return _then(_Holding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,buyPriceUsd: null == buyPriceUsd ? _self.buyPriceUsd : buyPriceUsd // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
