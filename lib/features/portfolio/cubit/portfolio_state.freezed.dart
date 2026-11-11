// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PortfolioState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PortfolioState()';
}


}

/// @nodoc
class $PortfolioStateCopyWith<$Res>  {
$PortfolioStateCopyWith(PortfolioState _, $Res Function(PortfolioState) __);
}


/// Adds pattern-matching-related methods to [PortfolioState].
extension PortfolioStatePatterns on PortfolioState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PortfolioLoading value)?  loading,TResult Function( PortfolioError value)?  error,TResult Function( PortfolioReady value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PortfolioLoading() when loading != null:
return loading(_that);case PortfolioError() when error != null:
return error(_that);case PortfolioReady() when ready != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PortfolioLoading value)  loading,required TResult Function( PortfolioError value)  error,required TResult Function( PortfolioReady value)  ready,}){
final _that = this;
switch (_that) {
case PortfolioLoading():
return loading(_that);case PortfolioError():
return error(_that);case PortfolioReady():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PortfolioLoading value)?  loading,TResult? Function( PortfolioError value)?  error,TResult? Function( PortfolioReady value)?  ready,}){
final _that = this;
switch (_that) {
case PortfolioLoading() when loading != null:
return loading(_that);case PortfolioError() when error != null:
return error(_that);case PortfolioReady() when ready != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( PortfolioListing listing)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PortfolioLoading() when loading != null:
return loading();case PortfolioError() when error != null:
return error(_that.message);case PortfolioReady() when ready != null:
return ready(_that.listing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( PortfolioListing listing)  ready,}) {final _that = this;
switch (_that) {
case PortfolioLoading():
return loading();case PortfolioError():
return error(_that.message);case PortfolioReady():
return ready(_that.listing);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( PortfolioListing listing)?  ready,}) {final _that = this;
switch (_that) {
case PortfolioLoading() when loading != null:
return loading();case PortfolioError() when error != null:
return error(_that.message);case PortfolioReady() when ready != null:
return ready(_that.listing);case _:
  return null;

}
}

}

/// @nodoc


class PortfolioLoading implements PortfolioState {
  const PortfolioLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PortfolioState.loading()';
}


}




/// @nodoc


class PortfolioError implements PortfolioState {
  const PortfolioError(this.message);
  

 final  String message;

/// Create a copy of PortfolioState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioErrorCopyWith<PortfolioError> get copyWith => _$PortfolioErrorCopyWithImpl<PortfolioError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'PortfolioState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PortfolioErrorCopyWith<$Res> implements $PortfolioStateCopyWith<$Res> {
  factory $PortfolioErrorCopyWith(PortfolioError value, $Res Function(PortfolioError) _then) = _$PortfolioErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PortfolioErrorCopyWithImpl<$Res>
    implements $PortfolioErrorCopyWith<$Res> {
  _$PortfolioErrorCopyWithImpl(this._self, this._then);

  final PortfolioError _self;
  final $Res Function(PortfolioError) _then;

/// Create a copy of PortfolioState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PortfolioError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PortfolioReady implements PortfolioState {
  const PortfolioReady(this.listing);
  

 final  PortfolioListing listing;

/// Create a copy of PortfolioState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioReadyCopyWith<PortfolioReady> get copyWith => _$PortfolioReadyCopyWithImpl<PortfolioReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioReady&&(identical(other.listing, listing) || other.listing == listing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,listing);
}

@override
String toString() {
    return 'PortfolioState.ready(listing: $listing)';
}


}

/// @nodoc
abstract mixin class $PortfolioReadyCopyWith<$Res> implements $PortfolioStateCopyWith<$Res> {
  factory $PortfolioReadyCopyWith(PortfolioReady value, $Res Function(PortfolioReady) _then) = _$PortfolioReadyCopyWithImpl;
@useResult
$Res call({
 PortfolioListing listing
});


$PortfolioListingCopyWith<$Res> get listing;

}
/// @nodoc
class _$PortfolioReadyCopyWithImpl<$Res>
    implements $PortfolioReadyCopyWith<$Res> {
  _$PortfolioReadyCopyWithImpl(this._self, this._then);

  final PortfolioReady _self;
  final $Res Function(PortfolioReady) _then;

/// Create a copy of PortfolioState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? listing = null,}) {
  return _then(PortfolioReady(
null == listing ? _self.listing : listing // ignore: cast_nullable_to_non_nullable
as PortfolioListing,
  ));
}

/// Create a copy of PortfolioState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioListingCopyWith<$Res> get listing {
  
  return $PortfolioListingCopyWith<$Res>(_self.listing, (value) {
    return _then(_self.copyWith(listing: value));
  });
}
}

// dart format on
