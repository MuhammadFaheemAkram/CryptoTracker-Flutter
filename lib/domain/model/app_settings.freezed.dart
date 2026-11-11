// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 Currency get currency; TickInterval get interval;/// Live prices stopped by the user. Moving content must be pausable
/// (WCAG 2.2.2, "Pause, Stop, Hide"), and resuming keeps [interval].
 bool get livePricesPaused; AppThemeMode get themeMode;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.interval, _this.interval) || other.interval == _this.interval)&&(identical(other.livePricesPaused, _this.livePricesPaused) || other.livePricesPaused == _this.livePricesPaused)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode));
}


@override
int get hashCode {
  final _this = this as AppSettings;
  return Object.hash(runtimeType,_this.currency,_this.interval,_this.livePricesPaused,_this.themeMode);
}

@override
String toString() {
  final _this = this as AppSettings;
  return 'AppSettings(currency: ${_this.currency}, interval: ${_this.interval}, livePricesPaused: ${_this.livePricesPaused}, themeMode: ${_this.themeMode})';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 Currency currency, TickInterval interval, bool livePricesPaused, AppThemeMode themeMode
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? interval = null,Object? livePricesPaused = null,Object? themeMode = null,}) {
  return _then(AppSettings(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as TickInterval,livePricesPaused: null == livePricesPaused ? _self.livePricesPaused : livePricesPaused // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Currency currency,  TickInterval interval,  bool livePricesPaused,  AppThemeMode themeMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.currency,_that.interval,_that.livePricesPaused,_that.themeMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Currency currency,  TickInterval interval,  bool livePricesPaused,  AppThemeMode themeMode)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.currency,_that.interval,_that.livePricesPaused,_that.themeMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Currency currency,  TickInterval interval,  bool livePricesPaused,  AppThemeMode themeMode)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.currency,_that.interval,_that.livePricesPaused,_that.themeMode);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({this.currency = Currency.usd, this.interval = TickInterval.twoSeconds, this.livePricesPaused = false, this.themeMode = AppThemeMode.system});
  

@override@JsonKey() final  Currency currency;
@override@JsonKey() final  TickInterval interval;
/// Live prices stopped by the user. Moving content must be pausable
/// (WCAG 2.2.2, "Pause, Stop, Hide"), and resuming keeps [interval].
@override@JsonKey() final  bool livePricesPaused;
@override@JsonKey() final  AppThemeMode themeMode;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.livePricesPaused, livePricesPaused) || other.livePricesPaused == livePricesPaused)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currency,interval,livePricesPaused,themeMode);
}

@override
String toString() {
    return 'AppSettings(currency: $currency, interval: $interval, livePricesPaused: $livePricesPaused, themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 Currency currency, TickInterval interval, bool livePricesPaused, AppThemeMode themeMode
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? interval = null,Object? livePricesPaused = null,Object? themeMode = null,}) {
  return _then(_AppSettings(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as TickInterval,livePricesPaused: null == livePricesPaused ? _self.livePricesPaused : livePricesPaused // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,
  ));
}


}

// dart format on
