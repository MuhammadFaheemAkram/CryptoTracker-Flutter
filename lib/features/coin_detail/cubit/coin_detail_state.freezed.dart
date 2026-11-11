// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoinDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CoinDetailState()';
}


}

/// @nodoc
class $CoinDetailStateCopyWith<$Res>  {
$CoinDetailStateCopyWith(CoinDetailState _, $Res Function(CoinDetailState) __);
}


/// Adds pattern-matching-related methods to [CoinDetailState].
extension CoinDetailStatePatterns on CoinDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CoinDetailLoading value)?  loading,TResult Function( CoinDetailError value)?  error,TResult Function( CoinDetailNotFound value)?  notFound,TResult Function( CoinDetailReady value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CoinDetailLoading() when loading != null:
return loading(_that);case CoinDetailError() when error != null:
return error(_that);case CoinDetailNotFound() when notFound != null:
return notFound(_that);case CoinDetailReady() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CoinDetailLoading value)  loading,required TResult Function( CoinDetailError value)  error,required TResult Function( CoinDetailNotFound value)  notFound,required TResult Function( CoinDetailReady value)  ready,}){
final _that = this;
switch (_that) {
case CoinDetailLoading():
return loading(_that);case CoinDetailError():
return error(_that);case CoinDetailNotFound():
return notFound(_that);case CoinDetailReady():
return ready(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CoinDetailLoading value)?  loading,TResult? Function( CoinDetailError value)?  error,TResult? Function( CoinDetailNotFound value)?  notFound,TResult? Function( CoinDetailReady value)?  ready,}){
final _that = this;
switch (_that) {
case CoinDetailLoading() when loading != null:
return loading(_that);case CoinDetailError() when error != null:
return error(_that);case CoinDetailNotFound() when notFound != null:
return notFound(_that);case CoinDetailReady() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String message)?  error,TResult Function()?  notFound,TResult Function( CoinDetail detail)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CoinDetailLoading() when loading != null:
return loading();case CoinDetailError() when error != null:
return error(_that.message);case CoinDetailNotFound() when notFound != null:
return notFound();case CoinDetailReady() when ready != null:
return ready(_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function()  notFound,required TResult Function( CoinDetail detail)  ready,}) {final _that = this;
switch (_that) {
case CoinDetailLoading():
return loading();case CoinDetailError():
return error(_that.message);case CoinDetailNotFound():
return notFound();case CoinDetailReady():
return ready(_that.detail);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function()?  notFound,TResult? Function( CoinDetail detail)?  ready,}) {final _that = this;
switch (_that) {
case CoinDetailLoading() when loading != null:
return loading();case CoinDetailError() when error != null:
return error(_that.message);case CoinDetailNotFound() when notFound != null:
return notFound();case CoinDetailReady() when ready != null:
return ready(_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class CoinDetailLoading implements CoinDetailState {
  const CoinDetailLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CoinDetailState.loading()';
}


}




/// @nodoc


class CoinDetailError implements CoinDetailState {
  const CoinDetailError(this.message);
  

 final  String message;

/// Create a copy of CoinDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinDetailErrorCopyWith<CoinDetailError> get copyWith => _$CoinDetailErrorCopyWithImpl<CoinDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CoinDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CoinDetailErrorCopyWith<$Res> implements $CoinDetailStateCopyWith<$Res> {
  factory $CoinDetailErrorCopyWith(CoinDetailError value, $Res Function(CoinDetailError) _then) = _$CoinDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CoinDetailErrorCopyWithImpl<$Res>
    implements $CoinDetailErrorCopyWith<$Res> {
  _$CoinDetailErrorCopyWithImpl(this._self, this._then);

  final CoinDetailError _self;
  final $Res Function(CoinDetailError) _then;

/// Create a copy of CoinDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CoinDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CoinDetailNotFound implements CoinDetailState {
  const CoinDetailNotFound();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinDetailNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CoinDetailState.notFound()';
}


}




/// @nodoc


class CoinDetailReady implements CoinDetailState {
  const CoinDetailReady(this.detail);
  

 final  CoinDetail detail;

/// Create a copy of CoinDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinDetailReadyCopyWith<CoinDetailReady> get copyWith => _$CoinDetailReadyCopyWithImpl<CoinDetailReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinDetailReady&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode {
    return Object.hash(runtimeType,detail);
}

@override
String toString() {
    return 'CoinDetailState.ready(detail: $detail)';
}


}

/// @nodoc
abstract mixin class $CoinDetailReadyCopyWith<$Res> implements $CoinDetailStateCopyWith<$Res> {
  factory $CoinDetailReadyCopyWith(CoinDetailReady value, $Res Function(CoinDetailReady) _then) = _$CoinDetailReadyCopyWithImpl;
@useResult
$Res call({
 CoinDetail detail
});


$CoinDetailCopyWith<$Res> get detail;

}
/// @nodoc
class _$CoinDetailReadyCopyWithImpl<$Res>
    implements $CoinDetailReadyCopyWith<$Res> {
  _$CoinDetailReadyCopyWithImpl(this._self, this._then);

  final CoinDetailReady _self;
  final $Res Function(CoinDetailReady) _then;

/// Create a copy of CoinDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = null,}) {
  return _then(CoinDetailReady(
null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as CoinDetail,
  ));
}

/// Create a copy of CoinDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoinDetailCopyWith<$Res> get detail {
  
  return $CoinDetailCopyWith<$Res>(_self.detail, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}

// dart format on
