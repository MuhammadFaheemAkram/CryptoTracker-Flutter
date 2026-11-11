// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holding_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HoldingFormState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingFormState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HoldingFormState()';
}


}

/// @nodoc
class $HoldingFormStateCopyWith<$Res>  {
$HoldingFormStateCopyWith(HoldingFormState _, $Res Function(HoldingFormState) __);
}


/// Adds pattern-matching-related methods to [HoldingFormState].
extension HoldingFormStatePatterns on HoldingFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HoldingFormLoading value)?  loading,TResult Function( HoldingFormError value)?  error,TResult Function( HoldingFormNotFound value)?  notFound,TResult Function( HoldingFormEditing value)?  editing,TResult Function( HoldingFormSaved value)?  saved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HoldingFormLoading() when loading != null:
return loading(_that);case HoldingFormError() when error != null:
return error(_that);case HoldingFormNotFound() when notFound != null:
return notFound(_that);case HoldingFormEditing() when editing != null:
return editing(_that);case HoldingFormSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HoldingFormLoading value)  loading,required TResult Function( HoldingFormError value)  error,required TResult Function( HoldingFormNotFound value)  notFound,required TResult Function( HoldingFormEditing value)  editing,required TResult Function( HoldingFormSaved value)  saved,}){
final _that = this;
switch (_that) {
case HoldingFormLoading():
return loading(_that);case HoldingFormError():
return error(_that);case HoldingFormNotFound():
return notFound(_that);case HoldingFormEditing():
return editing(_that);case HoldingFormSaved():
return saved(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HoldingFormLoading value)?  loading,TResult? Function( HoldingFormError value)?  error,TResult? Function( HoldingFormNotFound value)?  notFound,TResult? Function( HoldingFormEditing value)?  editing,TResult? Function( HoldingFormSaved value)?  saved,}){
final _that = this;
switch (_that) {
case HoldingFormLoading() when loading != null:
return loading(_that);case HoldingFormError() when error != null:
return error(_that);case HoldingFormNotFound() when notFound != null:
return notFound(_that);case HoldingFormEditing() when editing != null:
return editing(_that);case HoldingFormSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String message)?  error,TResult Function()?  notFound,TResult Function( HoldingForm form)?  editing,TResult Function( String message)?  saved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HoldingFormLoading() when loading != null:
return loading();case HoldingFormError() when error != null:
return error(_that.message);case HoldingFormNotFound() when notFound != null:
return notFound();case HoldingFormEditing() when editing != null:
return editing(_that.form);case HoldingFormSaved() when saved != null:
return saved(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function()  notFound,required TResult Function( HoldingForm form)  editing,required TResult Function( String message)  saved,}) {final _that = this;
switch (_that) {
case HoldingFormLoading():
return loading();case HoldingFormError():
return error(_that.message);case HoldingFormNotFound():
return notFound();case HoldingFormEditing():
return editing(_that.form);case HoldingFormSaved():
return saved(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function()?  notFound,TResult? Function( HoldingForm form)?  editing,TResult? Function( String message)?  saved,}) {final _that = this;
switch (_that) {
case HoldingFormLoading() when loading != null:
return loading();case HoldingFormError() when error != null:
return error(_that.message);case HoldingFormNotFound() when notFound != null:
return notFound();case HoldingFormEditing() when editing != null:
return editing(_that.form);case HoldingFormSaved() when saved != null:
return saved(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HoldingFormLoading implements HoldingFormState {
  const HoldingFormLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingFormLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HoldingFormState.loading()';
}


}




/// @nodoc


class HoldingFormError implements HoldingFormState {
  const HoldingFormError(this.message);
  

 final  String message;

/// Create a copy of HoldingFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingFormErrorCopyWith<HoldingFormError> get copyWith => _$HoldingFormErrorCopyWithImpl<HoldingFormError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingFormError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'HoldingFormState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $HoldingFormErrorCopyWith<$Res> implements $HoldingFormStateCopyWith<$Res> {
  factory $HoldingFormErrorCopyWith(HoldingFormError value, $Res Function(HoldingFormError) _then) = _$HoldingFormErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HoldingFormErrorCopyWithImpl<$Res>
    implements $HoldingFormErrorCopyWith<$Res> {
  _$HoldingFormErrorCopyWithImpl(this._self, this._then);

  final HoldingFormError _self;
  final $Res Function(HoldingFormError) _then;

/// Create a copy of HoldingFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HoldingFormError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HoldingFormNotFound implements HoldingFormState {
  const HoldingFormNotFound();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingFormNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HoldingFormState.notFound()';
}


}




/// @nodoc


class HoldingFormEditing implements HoldingFormState {
  const HoldingFormEditing(this.form);
  

 final  HoldingForm form;

/// Create a copy of HoldingFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingFormEditingCopyWith<HoldingFormEditing> get copyWith => _$HoldingFormEditingCopyWithImpl<HoldingFormEditing>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingFormEditing&&(identical(other.form, form) || other.form == form));
}


@override
int get hashCode {
    return Object.hash(runtimeType,form);
}

@override
String toString() {
    return 'HoldingFormState.editing(form: $form)';
}


}

/// @nodoc
abstract mixin class $HoldingFormEditingCopyWith<$Res> implements $HoldingFormStateCopyWith<$Res> {
  factory $HoldingFormEditingCopyWith(HoldingFormEditing value, $Res Function(HoldingFormEditing) _then) = _$HoldingFormEditingCopyWithImpl;
@useResult
$Res call({
 HoldingForm form
});


$HoldingFormCopyWith<$Res> get form;

}
/// @nodoc
class _$HoldingFormEditingCopyWithImpl<$Res>
    implements $HoldingFormEditingCopyWith<$Res> {
  _$HoldingFormEditingCopyWithImpl(this._self, this._then);

  final HoldingFormEditing _self;
  final $Res Function(HoldingFormEditing) _then;

/// Create a copy of HoldingFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? form = null,}) {
  return _then(HoldingFormEditing(
null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as HoldingForm,
  ));
}

/// Create a copy of HoldingFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HoldingFormCopyWith<$Res> get form {
  
  return $HoldingFormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}
}

/// @nodoc


class HoldingFormSaved implements HoldingFormState {
  const HoldingFormSaved(this.message);
  

 final  String message;

/// Create a copy of HoldingFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingFormSavedCopyWith<HoldingFormSaved> get copyWith => _$HoldingFormSavedCopyWithImpl<HoldingFormSaved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingFormSaved&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'HoldingFormState.saved(message: $message)';
}


}

/// @nodoc
abstract mixin class $HoldingFormSavedCopyWith<$Res> implements $HoldingFormStateCopyWith<$Res> {
  factory $HoldingFormSavedCopyWith(HoldingFormSaved value, $Res Function(HoldingFormSaved) _then) = _$HoldingFormSavedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HoldingFormSavedCopyWithImpl<$Res>
    implements $HoldingFormSavedCopyWith<$Res> {
  _$HoldingFormSavedCopyWithImpl(this._self, this._then);

  final HoldingFormSaved _self;
  final $Res Function(HoldingFormSaved) _then;

/// Create a copy of HoldingFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HoldingFormSaved(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$HoldingForm {

/// The coins to pick from, in rank order.
 List<Coin> get coins;/// The chosen coin; `null` until one is picked.
 Coin? get coin;/// The holding being edited; `null` for a new one (its coin is then
/// fixed).
 int? get holdingId;/// Exactly what's typed.
 String get amountText; String get priceText;/// The currency the buy price is typed in, and its rate per dollar.
 Currency get currency; double get rate;/// The coin's price now, in dollars (live; the "worth now" preview).
 double? get currentPriceUsd;/// What the form started with: changes to these ask before discarding.
 String? get initialCoinId; String get initialAmountText; String get initialPriceText;/// The buy price the form filled in itself (a new holding's coin, at
/// its price then). Not the user's change; replaced if the coin is.
 String? get suggestedPriceText;/// Save was tapped: every problem shows now, an empty field included.
 bool get submitted; bool get isSaving;
/// Create a copy of HoldingForm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingFormCopyWith<HoldingForm> get copyWith => _$HoldingFormCopyWithImpl<HoldingForm>(this as HoldingForm, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HoldingForm;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingForm&&const DeepCollectionEquality().equals(other.coins, _this.coins)&&(identical(other.coin, _this.coin) || other.coin == _this.coin)&&(identical(other.holdingId, _this.holdingId) || other.holdingId == _this.holdingId)&&(identical(other.amountText, _this.amountText) || other.amountText == _this.amountText)&&(identical(other.priceText, _this.priceText) || other.priceText == _this.priceText)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.rate, _this.rate) || other.rate == _this.rate)&&(identical(other.currentPriceUsd, _this.currentPriceUsd) || other.currentPriceUsd == _this.currentPriceUsd)&&(identical(other.initialCoinId, _this.initialCoinId) || other.initialCoinId == _this.initialCoinId)&&(identical(other.initialAmountText, _this.initialAmountText) || other.initialAmountText == _this.initialAmountText)&&(identical(other.initialPriceText, _this.initialPriceText) || other.initialPriceText == _this.initialPriceText)&&(identical(other.suggestedPriceText, _this.suggestedPriceText) || other.suggestedPriceText == _this.suggestedPriceText)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving));
}


@override
int get hashCode {
  final _this = this as HoldingForm;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.coins),_this.coin,_this.holdingId,_this.amountText,_this.priceText,_this.currency,_this.rate,_this.currentPriceUsd,_this.initialCoinId,_this.initialAmountText,_this.initialPriceText,_this.suggestedPriceText,_this.submitted,_this.isSaving);
}

@override
String toString() {
  final _this = this as HoldingForm;
  return 'HoldingForm(coins: ${_this.coins}, coin: ${_this.coin}, holdingId: ${_this.holdingId}, amountText: ${_this.amountText}, priceText: ${_this.priceText}, currency: ${_this.currency}, rate: ${_this.rate}, currentPriceUsd: ${_this.currentPriceUsd}, initialCoinId: ${_this.initialCoinId}, initialAmountText: ${_this.initialAmountText}, initialPriceText: ${_this.initialPriceText}, suggestedPriceText: ${_this.suggestedPriceText}, submitted: ${_this.submitted}, isSaving: ${_this.isSaving})';
}


}

/// @nodoc
abstract mixin class $HoldingFormCopyWith<$Res>  {
  factory $HoldingFormCopyWith(HoldingForm value, $Res Function(HoldingForm) _then) = _$HoldingFormCopyWithImpl;
@useResult
$Res call({
 List<Coin> coins, Coin? coin, int? holdingId, String amountText, String priceText, Currency currency, double rate, double? currentPriceUsd, String? initialCoinId, String initialAmountText, String initialPriceText, String? suggestedPriceText, bool submitted, bool isSaving
});


$CoinCopyWith<$Res>? get coin;

}
/// @nodoc
class _$HoldingFormCopyWithImpl<$Res>
    implements $HoldingFormCopyWith<$Res> {
  _$HoldingFormCopyWithImpl(this._self, this._then);

  final HoldingForm _self;
  final $Res Function(HoldingForm) _then;

/// Create a copy of HoldingForm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coins = null,Object? coin = freezed,Object? holdingId = freezed,Object? amountText = null,Object? priceText = null,Object? currency = null,Object? rate = null,Object? currentPriceUsd = freezed,Object? initialCoinId = freezed,Object? initialAmountText = null,Object? initialPriceText = null,Object? suggestedPriceText = freezed,Object? submitted = null,Object? isSaving = null,}) {
  return _then(HoldingForm(
coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as List<Coin>,coin: freezed == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as Coin?,holdingId: freezed == holdingId ? _self.holdingId : holdingId // ignore: cast_nullable_to_non_nullable
as int?,amountText: null == amountText ? _self.amountText : amountText // ignore: cast_nullable_to_non_nullable
as String,priceText: null == priceText ? _self.priceText : priceText // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,currentPriceUsd: freezed == currentPriceUsd ? _self.currentPriceUsd : currentPriceUsd // ignore: cast_nullable_to_non_nullable
as double?,initialCoinId: freezed == initialCoinId ? _self.initialCoinId : initialCoinId // ignore: cast_nullable_to_non_nullable
as String?,initialAmountText: null == initialAmountText ? _self.initialAmountText : initialAmountText // ignore: cast_nullable_to_non_nullable
as String,initialPriceText: null == initialPriceText ? _self.initialPriceText : initialPriceText // ignore: cast_nullable_to_non_nullable
as String,suggestedPriceText: freezed == suggestedPriceText ? _self.suggestedPriceText : suggestedPriceText // ignore: cast_nullable_to_non_nullable
as String?,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HoldingForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoinCopyWith<$Res>? get coin {
    if (_self.coin == null) {
    return null;
  }

  return $CoinCopyWith<$Res>(_self.coin!, (value) {
    return _then(_self.copyWith(coin: value));
  });
}
}


/// Adds pattern-matching-related methods to [HoldingForm].
extension HoldingFormPatterns on HoldingForm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HoldingForm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HoldingForm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HoldingForm value)  $default,){
final _that = this;
switch (_that) {
case _HoldingForm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HoldingForm value)?  $default,){
final _that = this;
switch (_that) {
case _HoldingForm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Coin> coins,  Coin? coin,  int? holdingId,  String amountText,  String priceText,  Currency currency,  double rate,  double? currentPriceUsd,  String? initialCoinId,  String initialAmountText,  String initialPriceText,  String? suggestedPriceText,  bool submitted,  bool isSaving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HoldingForm() when $default != null:
return $default(_that.coins,_that.coin,_that.holdingId,_that.amountText,_that.priceText,_that.currency,_that.rate,_that.currentPriceUsd,_that.initialCoinId,_that.initialAmountText,_that.initialPriceText,_that.suggestedPriceText,_that.submitted,_that.isSaving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Coin> coins,  Coin? coin,  int? holdingId,  String amountText,  String priceText,  Currency currency,  double rate,  double? currentPriceUsd,  String? initialCoinId,  String initialAmountText,  String initialPriceText,  String? suggestedPriceText,  bool submitted,  bool isSaving)  $default,) {final _that = this;
switch (_that) {
case _HoldingForm():
return $default(_that.coins,_that.coin,_that.holdingId,_that.amountText,_that.priceText,_that.currency,_that.rate,_that.currentPriceUsd,_that.initialCoinId,_that.initialAmountText,_that.initialPriceText,_that.suggestedPriceText,_that.submitted,_that.isSaving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Coin> coins,  Coin? coin,  int? holdingId,  String amountText,  String priceText,  Currency currency,  double rate,  double? currentPriceUsd,  String? initialCoinId,  String initialAmountText,  String initialPriceText,  String? suggestedPriceText,  bool submitted,  bool isSaving)?  $default,) {final _that = this;
switch (_that) {
case _HoldingForm() when $default != null:
return $default(_that.coins,_that.coin,_that.holdingId,_that.amountText,_that.priceText,_that.currency,_that.rate,_that.currentPriceUsd,_that.initialCoinId,_that.initialAmountText,_that.initialPriceText,_that.suggestedPriceText,_that.submitted,_that.isSaving);case _:
  return null;

}
}

}

/// @nodoc


class _HoldingForm extends HoldingForm {
  const _HoldingForm({required  List<Coin> coins, this.coin, this.holdingId, this.amountText = '', this.priceText = '', required this.currency, required this.rate, this.currentPriceUsd, this.initialCoinId, this.initialAmountText = '', this.initialPriceText = '', this.suggestedPriceText, this.submitted = false, this.isSaving = false}): _coins = coins,super._();
  

/// The coins to pick from, in rank order.
 final  List<Coin> _coins;
/// The coins to pick from, in rank order.
@override List<Coin> get coins {
  if (_coins is EqualUnmodifiableListView) return _coins;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coins);
}

/// The chosen coin; `null` until one is picked.
@override final  Coin? coin;
/// The holding being edited; `null` for a new one (its coin is then
/// fixed).
@override final  int? holdingId;
/// Exactly what's typed.
@override@JsonKey() final  String amountText;
@override@JsonKey() final  String priceText;
/// The currency the buy price is typed in, and its rate per dollar.
@override final  Currency currency;
@override final  double rate;
/// The coin's price now, in dollars (live; the "worth now" preview).
@override final  double? currentPriceUsd;
/// What the form started with: changes to these ask before discarding.
@override final  String? initialCoinId;
@override@JsonKey() final  String initialAmountText;
@override@JsonKey() final  String initialPriceText;
/// The buy price the form filled in itself (a new holding's coin, at
/// its price then). Not the user's change; replaced if the coin is.
@override final  String? suggestedPriceText;
/// Save was tapped: every problem shows now, an empty field included.
@override@JsonKey() final  bool submitted;
@override@JsonKey() final  bool isSaving;

/// Create a copy of HoldingForm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HoldingFormCopyWith<_HoldingForm> get copyWith => __$HoldingFormCopyWithImpl<_HoldingForm>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HoldingForm&&const DeepCollectionEquality().equals(other.coins, _coins)&&(identical(other.coin, coin) || other.coin == coin)&&(identical(other.holdingId, holdingId) || other.holdingId == holdingId)&&(identical(other.amountText, amountText) || other.amountText == amountText)&&(identical(other.priceText, priceText) || other.priceText == priceText)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.currentPriceUsd, currentPriceUsd) || other.currentPriceUsd == currentPriceUsd)&&(identical(other.initialCoinId, initialCoinId) || other.initialCoinId == initialCoinId)&&(identical(other.initialAmountText, initialAmountText) || other.initialAmountText == initialAmountText)&&(identical(other.initialPriceText, initialPriceText) || other.initialPriceText == initialPriceText)&&(identical(other.suggestedPriceText, suggestedPriceText) || other.suggestedPriceText == suggestedPriceText)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_coins),coin,holdingId,amountText,priceText,currency,rate,currentPriceUsd,initialCoinId,initialAmountText,initialPriceText,suggestedPriceText,submitted,isSaving);
}

@override
String toString() {
    return 'HoldingForm(coins: $coins, coin: $coin, holdingId: $holdingId, amountText: $amountText, priceText: $priceText, currency: $currency, rate: $rate, currentPriceUsd: $currentPriceUsd, initialCoinId: $initialCoinId, initialAmountText: $initialAmountText, initialPriceText: $initialPriceText, suggestedPriceText: $suggestedPriceText, submitted: $submitted, isSaving: $isSaving)';
}


}

/// @nodoc
abstract mixin class _$HoldingFormCopyWith<$Res> implements $HoldingFormCopyWith<$Res> {
  factory _$HoldingFormCopyWith(_HoldingForm value, $Res Function(_HoldingForm) _then) = __$HoldingFormCopyWithImpl;
@override @useResult
$Res call({
 List<Coin> coins, Coin? coin, int? holdingId, String amountText, String priceText, Currency currency, double rate, double? currentPriceUsd, String? initialCoinId, String initialAmountText, String initialPriceText, String? suggestedPriceText, bool submitted, bool isSaving
});


@override $CoinCopyWith<$Res>? get coin;

}
/// @nodoc
class __$HoldingFormCopyWithImpl<$Res>
    implements _$HoldingFormCopyWith<$Res> {
  __$HoldingFormCopyWithImpl(this._self, this._then);

  final _HoldingForm _self;
  final $Res Function(_HoldingForm) _then;

/// Create a copy of HoldingForm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coins = null,Object? coin = freezed,Object? holdingId = freezed,Object? amountText = null,Object? priceText = null,Object? currency = null,Object? rate = null,Object? currentPriceUsd = freezed,Object? initialCoinId = freezed,Object? initialAmountText = null,Object? initialPriceText = null,Object? suggestedPriceText = freezed,Object? submitted = null,Object? isSaving = null,}) {
  return _then(_HoldingForm(
coins: null == coins ? _self._coins : coins // ignore: cast_nullable_to_non_nullable
as List<Coin>,coin: freezed == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as Coin?,holdingId: freezed == holdingId ? _self.holdingId : holdingId // ignore: cast_nullable_to_non_nullable
as int?,amountText: null == amountText ? _self.amountText : amountText // ignore: cast_nullable_to_non_nullable
as String,priceText: null == priceText ? _self.priceText : priceText // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,currentPriceUsd: freezed == currentPriceUsd ? _self.currentPriceUsd : currentPriceUsd // ignore: cast_nullable_to_non_nullable
as double?,initialCoinId: freezed == initialCoinId ? _self.initialCoinId : initialCoinId // ignore: cast_nullable_to_non_nullable
as String?,initialAmountText: null == initialAmountText ? _self.initialAmountText : initialAmountText // ignore: cast_nullable_to_non_nullable
as String,initialPriceText: null == initialPriceText ? _self.initialPriceText : initialPriceText // ignore: cast_nullable_to_non_nullable
as String,suggestedPriceText: freezed == suggestedPriceText ? _self.suggestedPriceText : suggestedPriceText // ignore: cast_nullable_to_non_nullable
as String?,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HoldingForm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoinCopyWith<$Res>? get coin {
    if (_self.coin == null) {
    return null;
  }

  return $CoinCopyWith<$Res>(_self.coin!, (value) {
    return _then(_self.copyWith(coin: value));
  });
}
}

// dart format on
