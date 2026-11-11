// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_valuation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PortfolioPosition {

 Holding get holding; Coin get coin; Quote get quote;/// Which way the price moved on the last tick: the row's flash.
 PriceDirection get direction;
/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioPositionCopyWith<PortfolioPosition> get copyWith => _$PortfolioPositionCopyWithImpl<PortfolioPosition>(this as PortfolioPosition, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PortfolioPosition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioPosition&&(identical(other.holding, _this.holding) || other.holding == _this.holding)&&(identical(other.coin, _this.coin) || other.coin == _this.coin)&&(identical(other.quote, _this.quote) || other.quote == _this.quote)&&(identical(other.direction, _this.direction) || other.direction == _this.direction));
}


@override
int get hashCode {
  final _this = this as PortfolioPosition;
  return Object.hash(runtimeType,_this.holding,_this.coin,_this.quote,_this.direction);
}

@override
String toString() {
  final _this = this as PortfolioPosition;
  return 'PortfolioPosition(holding: ${_this.holding}, coin: ${_this.coin}, quote: ${_this.quote}, direction: ${_this.direction})';
}


}

/// @nodoc
abstract mixin class $PortfolioPositionCopyWith<$Res>  {
  factory $PortfolioPositionCopyWith(PortfolioPosition value, $Res Function(PortfolioPosition) _then) = _$PortfolioPositionCopyWithImpl;
@useResult
$Res call({
 Holding holding, Coin coin, Quote quote, PriceDirection direction
});


$HoldingCopyWith<$Res> get holding;$CoinCopyWith<$Res> get coin;$QuoteCopyWith<$Res> get quote;

}
/// @nodoc
class _$PortfolioPositionCopyWithImpl<$Res>
    implements $PortfolioPositionCopyWith<$Res> {
  _$PortfolioPositionCopyWithImpl(this._self, this._then);

  final PortfolioPosition _self;
  final $Res Function(PortfolioPosition) _then;

/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? holding = null,Object? coin = null,Object? quote = null,Object? direction = null,}) {
  return _then(PortfolioPosition(
holding: null == holding ? _self.holding : holding // ignore: cast_nullable_to_non_nullable
as Holding,coin: null == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as Coin,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as PriceDirection,
  ));
}
/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HoldingCopyWith<$Res> get holding {
  
  return $HoldingCopyWith<$Res>(_self.holding, (value) {
    return _then(_self.copyWith(holding: value));
  });
}/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoinCopyWith<$Res> get coin {
  
  return $CoinCopyWith<$Res>(_self.coin, (value) {
    return _then(_self.copyWith(coin: value));
  });
}/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res> get quote {
  
  return $QuoteCopyWith<$Res>(_self.quote, (value) {
    return _then(_self.copyWith(quote: value));
  });
}
}


/// Adds pattern-matching-related methods to [PortfolioPosition].
extension PortfolioPositionPatterns on PortfolioPosition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioPosition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioPosition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioPosition value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioPosition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioPosition value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioPosition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Holding holding,  Coin coin,  Quote quote,  PriceDirection direction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioPosition() when $default != null:
return $default(_that.holding,_that.coin,_that.quote,_that.direction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Holding holding,  Coin coin,  Quote quote,  PriceDirection direction)  $default,) {final _that = this;
switch (_that) {
case _PortfolioPosition():
return $default(_that.holding,_that.coin,_that.quote,_that.direction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Holding holding,  Coin coin,  Quote quote,  PriceDirection direction)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioPosition() when $default != null:
return $default(_that.holding,_that.coin,_that.quote,_that.direction);case _:
  return null;

}
}

}

/// @nodoc


class _PortfolioPosition extends PortfolioPosition {
  const _PortfolioPosition({required this.holding, required this.coin, required this.quote, this.direction = PriceDirection.flat}): super._();
  

@override final  Holding holding;
@override final  Coin coin;
@override final  Quote quote;
/// Which way the price moved on the last tick: the row's flash.
@override@JsonKey() final  PriceDirection direction;

/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioPositionCopyWith<_PortfolioPosition> get copyWith => __$PortfolioPositionCopyWithImpl<_PortfolioPosition>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioPosition&&(identical(other.holding, holding) || other.holding == holding)&&(identical(other.coin, coin) || other.coin == coin)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.direction, direction) || other.direction == direction));
}


@override
int get hashCode {
    return Object.hash(runtimeType,holding,coin,quote,direction);
}

@override
String toString() {
    return 'PortfolioPosition(holding: $holding, coin: $coin, quote: $quote, direction: $direction)';
}


}

/// @nodoc
abstract mixin class _$PortfolioPositionCopyWith<$Res> implements $PortfolioPositionCopyWith<$Res> {
  factory _$PortfolioPositionCopyWith(_PortfolioPosition value, $Res Function(_PortfolioPosition) _then) = __$PortfolioPositionCopyWithImpl;
@override @useResult
$Res call({
 Holding holding, Coin coin, Quote quote, PriceDirection direction
});


@override $HoldingCopyWith<$Res> get holding;@override $CoinCopyWith<$Res> get coin;@override $QuoteCopyWith<$Res> get quote;

}
/// @nodoc
class __$PortfolioPositionCopyWithImpl<$Res>
    implements _$PortfolioPositionCopyWith<$Res> {
  __$PortfolioPositionCopyWithImpl(this._self, this._then);

  final _PortfolioPosition _self;
  final $Res Function(_PortfolioPosition) _then;

/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? holding = null,Object? coin = null,Object? quote = null,Object? direction = null,}) {
  return _then(_PortfolioPosition(
holding: null == holding ? _self.holding : holding // ignore: cast_nullable_to_non_nullable
as Holding,coin: null == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as Coin,quote: null == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as PriceDirection,
  ));
}

/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HoldingCopyWith<$Res> get holding {
  
  return $HoldingCopyWith<$Res>(_self.holding, (value) {
    return _then(_self.copyWith(holding: value));
  });
}/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoinCopyWith<$Res> get coin {
  
  return $CoinCopyWith<$Res>(_self.coin, (value) {
    return _then(_self.copyWith(coin: value));
  });
}/// Create a copy of PortfolioPosition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res> get quote {
  
  return $QuoteCopyWith<$Res>(_self.quote, (value) {
    return _then(_self.copyWith(quote: value));
  });
}
}

/// @nodoc
mixin _$Allocation {

/// The coin's name, or "Other".
 String get label;/// `null` for "Other".
 String? get symbol; double get valueUsd;/// Its share in hundredths of a percent (5237 = 52.37 %). Whole numbers
/// so the shares add up to **exactly** 100 %.
 int get basisPoints;
/// Create a copy of Allocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AllocationCopyWith<Allocation> get copyWith => _$AllocationCopyWithImpl<Allocation>(this as Allocation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Allocation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Allocation&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.valueUsd, _this.valueUsd) || other.valueUsd == _this.valueUsd)&&(identical(other.basisPoints, _this.basisPoints) || other.basisPoints == _this.basisPoints));
}


@override
int get hashCode {
  final _this = this as Allocation;
  return Object.hash(runtimeType,_this.label,_this.symbol,_this.valueUsd,_this.basisPoints);
}

@override
String toString() {
  final _this = this as Allocation;
  return 'Allocation(label: ${_this.label}, symbol: ${_this.symbol}, valueUsd: ${_this.valueUsd}, basisPoints: ${_this.basisPoints})';
}


}

/// @nodoc
abstract mixin class $AllocationCopyWith<$Res>  {
  factory $AllocationCopyWith(Allocation value, $Res Function(Allocation) _then) = _$AllocationCopyWithImpl;
@useResult
$Res call({
 String label, String? symbol, double valueUsd, int basisPoints
});




}
/// @nodoc
class _$AllocationCopyWithImpl<$Res>
    implements $AllocationCopyWith<$Res> {
  _$AllocationCopyWithImpl(this._self, this._then);

  final Allocation _self;
  final $Res Function(Allocation) _then;

/// Create a copy of Allocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? symbol = freezed,Object? valueUsd = null,Object? basisPoints = null,}) {
  return _then(Allocation(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,symbol: freezed == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String?,valueUsd: null == valueUsd ? _self.valueUsd : valueUsd // ignore: cast_nullable_to_non_nullable
as double,basisPoints: null == basisPoints ? _self.basisPoints : basisPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Allocation].
extension AllocationPatterns on Allocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Allocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Allocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Allocation value)  $default,){
final _that = this;
switch (_that) {
case _Allocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Allocation value)?  $default,){
final _that = this;
switch (_that) {
case _Allocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String? symbol,  double valueUsd,  int basisPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Allocation() when $default != null:
return $default(_that.label,_that.symbol,_that.valueUsd,_that.basisPoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String? symbol,  double valueUsd,  int basisPoints)  $default,) {final _that = this;
switch (_that) {
case _Allocation():
return $default(_that.label,_that.symbol,_that.valueUsd,_that.basisPoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String? symbol,  double valueUsd,  int basisPoints)?  $default,) {final _that = this;
switch (_that) {
case _Allocation() when $default != null:
return $default(_that.label,_that.symbol,_that.valueUsd,_that.basisPoints);case _:
  return null;

}
}

}

/// @nodoc


class _Allocation implements Allocation {
  const _Allocation({required this.label, this.symbol, required this.valueUsd, required this.basisPoints});
  

/// The coin's name, or "Other".
@override final  String label;
/// `null` for "Other".
@override final  String? symbol;
@override final  double valueUsd;
/// Its share in hundredths of a percent (5237 = 52.37 %). Whole numbers
/// so the shares add up to **exactly** 100 %.
@override final  int basisPoints;

/// Create a copy of Allocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllocationCopyWith<_Allocation> get copyWith => __$AllocationCopyWithImpl<_Allocation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Allocation&&(identical(other.label, label) || other.label == label)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.valueUsd, valueUsd) || other.valueUsd == valueUsd)&&(identical(other.basisPoints, basisPoints) || other.basisPoints == basisPoints));
}


@override
int get hashCode {
    return Object.hash(runtimeType,label,symbol,valueUsd,basisPoints);
}

@override
String toString() {
    return 'Allocation(label: $label, symbol: $symbol, valueUsd: $valueUsd, basisPoints: $basisPoints)';
}


}

/// @nodoc
abstract mixin class _$AllocationCopyWith<$Res> implements $AllocationCopyWith<$Res> {
  factory _$AllocationCopyWith(_Allocation value, $Res Function(_Allocation) _then) = __$AllocationCopyWithImpl;
@override @useResult
$Res call({
 String label, String? symbol, double valueUsd, int basisPoints
});




}
/// @nodoc
class __$AllocationCopyWithImpl<$Res>
    implements _$AllocationCopyWith<$Res> {
  __$AllocationCopyWithImpl(this._self, this._then);

  final _Allocation _self;
  final $Res Function(_Allocation) _then;

/// Create a copy of Allocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? symbol = freezed,Object? valueUsd = null,Object? basisPoints = null,}) {
  return _then(_Allocation(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,symbol: freezed == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String?,valueUsd: null == valueUsd ? _self.valueUsd : valueUsd // ignore: cast_nullable_to_non_nullable
as double,basisPoints: null == basisPoints ? _self.basisPoints : basisPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PortfolioValuation {

/// One per holding, oldest first.
 List<PortfolioPosition> get positions;/// By value, largest first: the top coins, then "Other".
 List<Allocation> get allocations; double get totalValueUsd; double get totalCostUsd; double get totalProfitUsd; double get totalProfitPercent; double get change24hUsd; double get change24hPercent;
/// Create a copy of PortfolioValuation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioValuationCopyWith<PortfolioValuation> get copyWith => _$PortfolioValuationCopyWithImpl<PortfolioValuation>(this as PortfolioValuation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PortfolioValuation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioValuation&&const DeepCollectionEquality().equals(other.positions, _this.positions)&&const DeepCollectionEquality().equals(other.allocations, _this.allocations)&&(identical(other.totalValueUsd, _this.totalValueUsd) || other.totalValueUsd == _this.totalValueUsd)&&(identical(other.totalCostUsd, _this.totalCostUsd) || other.totalCostUsd == _this.totalCostUsd)&&(identical(other.totalProfitUsd, _this.totalProfitUsd) || other.totalProfitUsd == _this.totalProfitUsd)&&(identical(other.totalProfitPercent, _this.totalProfitPercent) || other.totalProfitPercent == _this.totalProfitPercent)&&(identical(other.change24hUsd, _this.change24hUsd) || other.change24hUsd == _this.change24hUsd)&&(identical(other.change24hPercent, _this.change24hPercent) || other.change24hPercent == _this.change24hPercent));
}


@override
int get hashCode {
  final _this = this as PortfolioValuation;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.positions),const DeepCollectionEquality().hash(_this.allocations),_this.totalValueUsd,_this.totalCostUsd,_this.totalProfitUsd,_this.totalProfitPercent,_this.change24hUsd,_this.change24hPercent);
}

@override
String toString() {
  final _this = this as PortfolioValuation;
  return 'PortfolioValuation(positions: ${_this.positions}, allocations: ${_this.allocations}, totalValueUsd: ${_this.totalValueUsd}, totalCostUsd: ${_this.totalCostUsd}, totalProfitUsd: ${_this.totalProfitUsd}, totalProfitPercent: ${_this.totalProfitPercent}, change24hUsd: ${_this.change24hUsd}, change24hPercent: ${_this.change24hPercent})';
}


}

/// @nodoc
abstract mixin class $PortfolioValuationCopyWith<$Res>  {
  factory $PortfolioValuationCopyWith(PortfolioValuation value, $Res Function(PortfolioValuation) _then) = _$PortfolioValuationCopyWithImpl;
@useResult
$Res call({
 List<PortfolioPosition> positions, List<Allocation> allocations, double totalValueUsd, double totalCostUsd, double totalProfitUsd, double totalProfitPercent, double change24hUsd, double change24hPercent
});




}
/// @nodoc
class _$PortfolioValuationCopyWithImpl<$Res>
    implements $PortfolioValuationCopyWith<$Res> {
  _$PortfolioValuationCopyWithImpl(this._self, this._then);

  final PortfolioValuation _self;
  final $Res Function(PortfolioValuation) _then;

/// Create a copy of PortfolioValuation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? positions = null,Object? allocations = null,Object? totalValueUsd = null,Object? totalCostUsd = null,Object? totalProfitUsd = null,Object? totalProfitPercent = null,Object? change24hUsd = null,Object? change24hPercent = null,}) {
  return _then(PortfolioValuation(
positions: null == positions ? _self.positions : positions // ignore: cast_nullable_to_non_nullable
as List<PortfolioPosition>,allocations: null == allocations ? _self.allocations : allocations // ignore: cast_nullable_to_non_nullable
as List<Allocation>,totalValueUsd: null == totalValueUsd ? _self.totalValueUsd : totalValueUsd // ignore: cast_nullable_to_non_nullable
as double,totalCostUsd: null == totalCostUsd ? _self.totalCostUsd : totalCostUsd // ignore: cast_nullable_to_non_nullable
as double,totalProfitUsd: null == totalProfitUsd ? _self.totalProfitUsd : totalProfitUsd // ignore: cast_nullable_to_non_nullable
as double,totalProfitPercent: null == totalProfitPercent ? _self.totalProfitPercent : totalProfitPercent // ignore: cast_nullable_to_non_nullable
as double,change24hUsd: null == change24hUsd ? _self.change24hUsd : change24hUsd // ignore: cast_nullable_to_non_nullable
as double,change24hPercent: null == change24hPercent ? _self.change24hPercent : change24hPercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PortfolioValuation].
extension PortfolioValuationPatterns on PortfolioValuation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioValuation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioValuation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioValuation value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioValuation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioValuation value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioValuation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PortfolioPosition> positions,  List<Allocation> allocations,  double totalValueUsd,  double totalCostUsd,  double totalProfitUsd,  double totalProfitPercent,  double change24hUsd,  double change24hPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioValuation() when $default != null:
return $default(_that.positions,_that.allocations,_that.totalValueUsd,_that.totalCostUsd,_that.totalProfitUsd,_that.totalProfitPercent,_that.change24hUsd,_that.change24hPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PortfolioPosition> positions,  List<Allocation> allocations,  double totalValueUsd,  double totalCostUsd,  double totalProfitUsd,  double totalProfitPercent,  double change24hUsd,  double change24hPercent)  $default,) {final _that = this;
switch (_that) {
case _PortfolioValuation():
return $default(_that.positions,_that.allocations,_that.totalValueUsd,_that.totalCostUsd,_that.totalProfitUsd,_that.totalProfitPercent,_that.change24hUsd,_that.change24hPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PortfolioPosition> positions,  List<Allocation> allocations,  double totalValueUsd,  double totalCostUsd,  double totalProfitUsd,  double totalProfitPercent,  double change24hUsd,  double change24hPercent)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioValuation() when $default != null:
return $default(_that.positions,_that.allocations,_that.totalValueUsd,_that.totalCostUsd,_that.totalProfitUsd,_that.totalProfitPercent,_that.change24hUsd,_that.change24hPercent);case _:
  return null;

}
}

}

/// @nodoc


class _PortfolioValuation implements PortfolioValuation {
  const _PortfolioValuation({required  List<PortfolioPosition> positions, required  List<Allocation> allocations, required this.totalValueUsd, required this.totalCostUsd, required this.totalProfitUsd, required this.totalProfitPercent, required this.change24hUsd, required this.change24hPercent}): _positions = positions,_allocations = allocations;
  

/// One per holding, oldest first.
 final  List<PortfolioPosition> _positions;
/// One per holding, oldest first.
@override List<PortfolioPosition> get positions {
  if (_positions is EqualUnmodifiableListView) return _positions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_positions);
}

/// By value, largest first: the top coins, then "Other".
 final  List<Allocation> _allocations;
/// By value, largest first: the top coins, then "Other".
@override List<Allocation> get allocations {
  if (_allocations is EqualUnmodifiableListView) return _allocations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allocations);
}

@override final  double totalValueUsd;
@override final  double totalCostUsd;
@override final  double totalProfitUsd;
@override final  double totalProfitPercent;
@override final  double change24hUsd;
@override final  double change24hPercent;

/// Create a copy of PortfolioValuation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioValuationCopyWith<_PortfolioValuation> get copyWith => __$PortfolioValuationCopyWithImpl<_PortfolioValuation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioValuation&&const DeepCollectionEquality().equals(other.positions, _positions)&&const DeepCollectionEquality().equals(other.allocations, _allocations)&&(identical(other.totalValueUsd, totalValueUsd) || other.totalValueUsd == totalValueUsd)&&(identical(other.totalCostUsd, totalCostUsd) || other.totalCostUsd == totalCostUsd)&&(identical(other.totalProfitUsd, totalProfitUsd) || other.totalProfitUsd == totalProfitUsd)&&(identical(other.totalProfitPercent, totalProfitPercent) || other.totalProfitPercent == totalProfitPercent)&&(identical(other.change24hUsd, change24hUsd) || other.change24hUsd == change24hUsd)&&(identical(other.change24hPercent, change24hPercent) || other.change24hPercent == change24hPercent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_positions),const DeepCollectionEquality().hash(_allocations),totalValueUsd,totalCostUsd,totalProfitUsd,totalProfitPercent,change24hUsd,change24hPercent);
}

@override
String toString() {
    return 'PortfolioValuation(positions: $positions, allocations: $allocations, totalValueUsd: $totalValueUsd, totalCostUsd: $totalCostUsd, totalProfitUsd: $totalProfitUsd, totalProfitPercent: $totalProfitPercent, change24hUsd: $change24hUsd, change24hPercent: $change24hPercent)';
}


}

/// @nodoc
abstract mixin class _$PortfolioValuationCopyWith<$Res> implements $PortfolioValuationCopyWith<$Res> {
  factory _$PortfolioValuationCopyWith(_PortfolioValuation value, $Res Function(_PortfolioValuation) _then) = __$PortfolioValuationCopyWithImpl;
@override @useResult
$Res call({
 List<PortfolioPosition> positions, List<Allocation> allocations, double totalValueUsd, double totalCostUsd, double totalProfitUsd, double totalProfitPercent, double change24hUsd, double change24hPercent
});




}
/// @nodoc
class __$PortfolioValuationCopyWithImpl<$Res>
    implements _$PortfolioValuationCopyWith<$Res> {
  __$PortfolioValuationCopyWithImpl(this._self, this._then);

  final _PortfolioValuation _self;
  final $Res Function(_PortfolioValuation) _then;

/// Create a copy of PortfolioValuation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? positions = null,Object? allocations = null,Object? totalValueUsd = null,Object? totalCostUsd = null,Object? totalProfitUsd = null,Object? totalProfitPercent = null,Object? change24hUsd = null,Object? change24hPercent = null,}) {
  return _then(_PortfolioValuation(
positions: null == positions ? _self._positions : positions // ignore: cast_nullable_to_non_nullable
as List<PortfolioPosition>,allocations: null == allocations ? _self._allocations : allocations // ignore: cast_nullable_to_non_nullable
as List<Allocation>,totalValueUsd: null == totalValueUsd ? _self.totalValueUsd : totalValueUsd // ignore: cast_nullable_to_non_nullable
as double,totalCostUsd: null == totalCostUsd ? _self.totalCostUsd : totalCostUsd // ignore: cast_nullable_to_non_nullable
as double,totalProfitUsd: null == totalProfitUsd ? _self.totalProfitUsd : totalProfitUsd // ignore: cast_nullable_to_non_nullable
as double,totalProfitPercent: null == totalProfitPercent ? _self.totalProfitPercent : totalProfitPercent // ignore: cast_nullable_to_non_nullable
as double,change24hUsd: null == change24hUsd ? _self.change24hUsd : change24hUsd // ignore: cast_nullable_to_non_nullable
as double,change24hPercent: null == change24hPercent ? _self.change24hPercent : change24hPercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
