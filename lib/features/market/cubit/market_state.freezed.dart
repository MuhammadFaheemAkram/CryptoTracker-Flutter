// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MarketState()';
}


}

/// @nodoc
class $MarketStateCopyWith<$Res>  {
$MarketStateCopyWith(MarketState _, $Res Function(MarketState) __);
}


/// Adds pattern-matching-related methods to [MarketState].
extension MarketStatePatterns on MarketState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MarketLoading value)?  loading,TResult Function( MarketError value)?  error,TResult Function( MarketReady value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MarketLoading() when loading != null:
return loading(_that);case MarketError() when error != null:
return error(_that);case MarketReady() when ready != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MarketLoading value)  loading,required TResult Function( MarketError value)  error,required TResult Function( MarketReady value)  ready,}){
final _that = this;
switch (_that) {
case MarketLoading():
return loading(_that);case MarketError():
return error(_that);case MarketReady():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MarketLoading value)?  loading,TResult? Function( MarketError value)?  error,TResult? Function( MarketReady value)?  ready,}){
final _that = this;
switch (_that) {
case MarketLoading() when loading != null:
return loading(_that);case MarketError() when error != null:
return error(_that);case MarketReady() when ready != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( MarketListing listing)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MarketLoading() when loading != null:
return loading();case MarketError() when error != null:
return error(_that.message);case MarketReady() when ready != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( MarketListing listing)  ready,}) {final _that = this;
switch (_that) {
case MarketLoading():
return loading();case MarketError():
return error(_that.message);case MarketReady():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( MarketListing listing)?  ready,}) {final _that = this;
switch (_that) {
case MarketLoading() when loading != null:
return loading();case MarketError() when error != null:
return error(_that.message);case MarketReady() when ready != null:
return ready(_that.listing);case _:
  return null;

}
}

}

/// @nodoc


class MarketLoading implements MarketState {
  const MarketLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MarketState.loading()';
}


}




/// @nodoc


class MarketError implements MarketState {
  const MarketError(this.message);
  

 final  String message;

/// Create a copy of MarketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketErrorCopyWith<MarketError> get copyWith => _$MarketErrorCopyWithImpl<MarketError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'MarketState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $MarketErrorCopyWith<$Res> implements $MarketStateCopyWith<$Res> {
  factory $MarketErrorCopyWith(MarketError value, $Res Function(MarketError) _then) = _$MarketErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MarketErrorCopyWithImpl<$Res>
    implements $MarketErrorCopyWith<$Res> {
  _$MarketErrorCopyWithImpl(this._self, this._then);

  final MarketError _self;
  final $Res Function(MarketError) _then;

/// Create a copy of MarketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MarketError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MarketReady implements MarketState {
  const MarketReady(this.listing);
  

 final  MarketListing listing;

/// Create a copy of MarketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketReadyCopyWith<MarketReady> get copyWith => _$MarketReadyCopyWithImpl<MarketReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketReady&&(identical(other.listing, listing) || other.listing == listing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,listing);
}

@override
String toString() {
    return 'MarketState.ready(listing: $listing)';
}


}

/// @nodoc
abstract mixin class $MarketReadyCopyWith<$Res> implements $MarketStateCopyWith<$Res> {
  factory $MarketReadyCopyWith(MarketReady value, $Res Function(MarketReady) _then) = _$MarketReadyCopyWithImpl;
@useResult
$Res call({
 MarketListing listing
});


$MarketListingCopyWith<$Res> get listing;

}
/// @nodoc
class _$MarketReadyCopyWithImpl<$Res>
    implements $MarketReadyCopyWith<$Res> {
  _$MarketReadyCopyWithImpl(this._self, this._then);

  final MarketReady _self;
  final $Res Function(MarketReady) _then;

/// Create a copy of MarketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? listing = null,}) {
  return _then(MarketReady(
null == listing ? _self.listing : listing // ignore: cast_nullable_to_non_nullable
as MarketListing,
  ));
}

/// Create a copy of MarketState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MarketListingCopyWith<$Res> get listing {
  
  return $MarketListingCopyWith<$Res>(_self.listing, (value) {
    return _then(_self.copyWith(listing: value));
  });
}
}

// dart format on
