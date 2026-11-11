// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PriceSnapshot {

 Map<String, Quote> get quotes;/// Missing for a coin that didn't move (and for every coin in the first
/// snapshot): read it with [directionOf].
 Map<String, PriceDirection> get directions;
/// Create a copy of PriceSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceSnapshotCopyWith<PriceSnapshot> get copyWith => _$PriceSnapshotCopyWithImpl<PriceSnapshot>(this as PriceSnapshot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PriceSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceSnapshot&&const DeepCollectionEquality().equals(other.quotes, _this.quotes)&&const DeepCollectionEquality().equals(other.directions, _this.directions));
}


@override
int get hashCode {
  final _this = this as PriceSnapshot;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.quotes),const DeepCollectionEquality().hash(_this.directions));
}

@override
String toString() {
  final _this = this as PriceSnapshot;
  return 'PriceSnapshot(quotes: ${_this.quotes}, directions: ${_this.directions})';
}


}

/// @nodoc
abstract mixin class $PriceSnapshotCopyWith<$Res>  {
  factory $PriceSnapshotCopyWith(PriceSnapshot value, $Res Function(PriceSnapshot) _then) = _$PriceSnapshotCopyWithImpl;
@useResult
$Res call({
 Map<String, Quote> quotes, Map<String, PriceDirection> directions
});




}
/// @nodoc
class _$PriceSnapshotCopyWithImpl<$Res>
    implements $PriceSnapshotCopyWith<$Res> {
  _$PriceSnapshotCopyWithImpl(this._self, this._then);

  final PriceSnapshot _self;
  final $Res Function(PriceSnapshot) _then;

/// Create a copy of PriceSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quotes = null,Object? directions = null,}) {
  return _then(PriceSnapshot(
quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as Map<String, Quote>,directions: null == directions ? _self.directions : directions // ignore: cast_nullable_to_non_nullable
as Map<String, PriceDirection>,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceSnapshot].
extension PriceSnapshotPatterns on PriceSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _PriceSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _PriceSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Quote> quotes,  Map<String, PriceDirection> directions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceSnapshot() when $default != null:
return $default(_that.quotes,_that.directions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Quote> quotes,  Map<String, PriceDirection> directions)  $default,) {final _that = this;
switch (_that) {
case _PriceSnapshot():
return $default(_that.quotes,_that.directions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Quote> quotes,  Map<String, PriceDirection> directions)?  $default,) {final _that = this;
switch (_that) {
case _PriceSnapshot() when $default != null:
return $default(_that.quotes,_that.directions);case _:
  return null;

}
}

}

/// @nodoc


class _PriceSnapshot extends PriceSnapshot {
  const _PriceSnapshot({required  Map<String, Quote> quotes, required  Map<String, PriceDirection> directions}): _quotes = quotes,_directions = directions,super._();
  

 final  Map<String, Quote> _quotes;
@override Map<String, Quote> get quotes {
  if (_quotes is EqualUnmodifiableMapView) return _quotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_quotes);
}

/// Missing for a coin that didn't move (and for every coin in the first
/// snapshot): read it with [directionOf].
 final  Map<String, PriceDirection> _directions;
/// Missing for a coin that didn't move (and for every coin in the first
/// snapshot): read it with [directionOf].
@override Map<String, PriceDirection> get directions {
  if (_directions is EqualUnmodifiableMapView) return _directions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_directions);
}


/// Create a copy of PriceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceSnapshotCopyWith<_PriceSnapshot> get copyWith => __$PriceSnapshotCopyWithImpl<_PriceSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceSnapshot&&const DeepCollectionEquality().equals(other.quotes, _quotes)&&const DeepCollectionEquality().equals(other.directions, _directions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_quotes),const DeepCollectionEquality().hash(_directions));
}

@override
String toString() {
    return 'PriceSnapshot(quotes: $quotes, directions: $directions)';
}


}

/// @nodoc
abstract mixin class _$PriceSnapshotCopyWith<$Res> implements $PriceSnapshotCopyWith<$Res> {
  factory _$PriceSnapshotCopyWith(_PriceSnapshot value, $Res Function(_PriceSnapshot) _then) = __$PriceSnapshotCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Quote> quotes, Map<String, PriceDirection> directions
});




}
/// @nodoc
class __$PriceSnapshotCopyWithImpl<$Res>
    implements _$PriceSnapshotCopyWith<$Res> {
  __$PriceSnapshotCopyWithImpl(this._self, this._then);

  final _PriceSnapshot _self;
  final $Res Function(_PriceSnapshot) _then;

/// Create a copy of PriceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quotes = null,Object? directions = null,}) {
  return _then(_PriceSnapshot(
quotes: null == quotes ? _self._quotes : quotes // ignore: cast_nullable_to_non_nullable
as Map<String, Quote>,directions: null == directions ? _self._directions : directions // ignore: cast_nullable_to_non_nullable
as Map<String, PriceDirection>,
  ));
}


}

// dart format on
