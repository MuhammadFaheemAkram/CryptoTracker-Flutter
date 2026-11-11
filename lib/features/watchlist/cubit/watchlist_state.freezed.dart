// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchlistState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WatchlistState()';
}


}

/// @nodoc
class $WatchlistStateCopyWith<$Res>  {
$WatchlistStateCopyWith(WatchlistState _, $Res Function(WatchlistState) __);
}


/// Adds pattern-matching-related methods to [WatchlistState].
extension WatchlistStatePatterns on WatchlistState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WatchlistLoading value)?  loading,TResult Function( WatchlistError value)?  error,TResult Function( WatchlistReady value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WatchlistLoading() when loading != null:
return loading(_that);case WatchlistError() when error != null:
return error(_that);case WatchlistReady() when ready != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WatchlistLoading value)  loading,required TResult Function( WatchlistError value)  error,required TResult Function( WatchlistReady value)  ready,}){
final _that = this;
switch (_that) {
case WatchlistLoading():
return loading(_that);case WatchlistError():
return error(_that);case WatchlistReady():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WatchlistLoading value)?  loading,TResult? Function( WatchlistError value)?  error,TResult? Function( WatchlistReady value)?  ready,}){
final _that = this;
switch (_that) {
case WatchlistLoading() when loading != null:
return loading(_that);case WatchlistError() when error != null:
return error(_that);case WatchlistReady() when ready != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( WatchlistListing listing)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WatchlistLoading() when loading != null:
return loading();case WatchlistError() when error != null:
return error(_that.message);case WatchlistReady() when ready != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( WatchlistListing listing)  ready,}) {final _that = this;
switch (_that) {
case WatchlistLoading():
return loading();case WatchlistError():
return error(_that.message);case WatchlistReady():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( WatchlistListing listing)?  ready,}) {final _that = this;
switch (_that) {
case WatchlistLoading() when loading != null:
return loading();case WatchlistError() when error != null:
return error(_that.message);case WatchlistReady() when ready != null:
return ready(_that.listing);case _:
  return null;

}
}

}

/// @nodoc


class WatchlistLoading implements WatchlistState {
  const WatchlistLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WatchlistState.loading()';
}


}




/// @nodoc


class WatchlistError implements WatchlistState {
  const WatchlistError(this.message);
  

 final  String message;

/// Create a copy of WatchlistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistErrorCopyWith<WatchlistError> get copyWith => _$WatchlistErrorCopyWithImpl<WatchlistError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'WatchlistState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $WatchlistErrorCopyWith<$Res> implements $WatchlistStateCopyWith<$Res> {
  factory $WatchlistErrorCopyWith(WatchlistError value, $Res Function(WatchlistError) _then) = _$WatchlistErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$WatchlistErrorCopyWithImpl<$Res>
    implements $WatchlistErrorCopyWith<$Res> {
  _$WatchlistErrorCopyWithImpl(this._self, this._then);

  final WatchlistError _self;
  final $Res Function(WatchlistError) _then;

/// Create a copy of WatchlistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(WatchlistError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class WatchlistReady implements WatchlistState {
  const WatchlistReady(this.listing);
  

 final  WatchlistListing listing;

/// Create a copy of WatchlistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistReadyCopyWith<WatchlistReady> get copyWith => _$WatchlistReadyCopyWithImpl<WatchlistReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistReady&&(identical(other.listing, listing) || other.listing == listing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,listing);
}

@override
String toString() {
    return 'WatchlistState.ready(listing: $listing)';
}


}

/// @nodoc
abstract mixin class $WatchlistReadyCopyWith<$Res> implements $WatchlistStateCopyWith<$Res> {
  factory $WatchlistReadyCopyWith(WatchlistReady value, $Res Function(WatchlistReady) _then) = _$WatchlistReadyCopyWithImpl;
@useResult
$Res call({
 WatchlistListing listing
});


$WatchlistListingCopyWith<$Res> get listing;

}
/// @nodoc
class _$WatchlistReadyCopyWithImpl<$Res>
    implements $WatchlistReadyCopyWith<$Res> {
  _$WatchlistReadyCopyWithImpl(this._self, this._then);

  final WatchlistReady _self;
  final $Res Function(WatchlistReady) _then;

/// Create a copy of WatchlistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? listing = null,}) {
  return _then(WatchlistReady(
null == listing ? _self.listing : listing // ignore: cast_nullable_to_non_nullable
as WatchlistListing,
  ));
}

/// Create a copy of WatchlistState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WatchlistListingCopyWith<$Res> get listing {
  
  return $WatchlistListingCopyWith<$Res>(_self.listing, (value) {
    return _then(_self.copyWith(listing: value));
  });
}
}

// dart format on
