// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExchangeRate {

 int get id; int? get tripId; String get baseCurrency; String get targetCurrency; double get rate; bool get isManual; DateTime get updatedAt;
/// Create a copy of ExchangeRate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeRateCopyWith<ExchangeRate> get copyWith => _$ExchangeRateCopyWithImpl<ExchangeRate>(this as ExchangeRate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeRate&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.baseCurrency, baseCurrency) || other.baseCurrency == baseCurrency)&&(identical(other.targetCurrency, targetCurrency) || other.targetCurrency == targetCurrency)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.isManual, isManual) || other.isManual == isManual)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tripId,baseCurrency,targetCurrency,rate,isManual,updatedAt);

@override
String toString() {
  return 'ExchangeRate(id: $id, tripId: $tripId, baseCurrency: $baseCurrency, targetCurrency: $targetCurrency, rate: $rate, isManual: $isManual, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ExchangeRateCopyWith<$Res>  {
  factory $ExchangeRateCopyWith(ExchangeRate value, $Res Function(ExchangeRate) _then) = _$ExchangeRateCopyWithImpl;
@useResult
$Res call({
 int id, int? tripId, String baseCurrency, String targetCurrency, double rate, bool isManual, DateTime updatedAt
});




}
/// @nodoc
class _$ExchangeRateCopyWithImpl<$Res>
    implements $ExchangeRateCopyWith<$Res> {
  _$ExchangeRateCopyWithImpl(this._self, this._then);

  final ExchangeRate _self;
  final $Res Function(ExchangeRate) _then;

/// Create a copy of ExchangeRate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tripId = freezed,Object? baseCurrency = null,Object? targetCurrency = null,Object? rate = null,Object? isManual = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int?,baseCurrency: null == baseCurrency ? _self.baseCurrency : baseCurrency // ignore: cast_nullable_to_non_nullable
as String,targetCurrency: null == targetCurrency ? _self.targetCurrency : targetCurrency // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isManual: null == isManual ? _self.isManual : isManual // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ExchangeRate].
extension ExchangeRatePatterns on ExchangeRate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExchangeRate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExchangeRate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExchangeRate value)  $default,){
final _that = this;
switch (_that) {
case _ExchangeRate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExchangeRate value)?  $default,){
final _that = this;
switch (_that) {
case _ExchangeRate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? tripId,  String baseCurrency,  String targetCurrency,  double rate,  bool isManual,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExchangeRate() when $default != null:
return $default(_that.id,_that.tripId,_that.baseCurrency,_that.targetCurrency,_that.rate,_that.isManual,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? tripId,  String baseCurrency,  String targetCurrency,  double rate,  bool isManual,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ExchangeRate():
return $default(_that.id,_that.tripId,_that.baseCurrency,_that.targetCurrency,_that.rate,_that.isManual,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? tripId,  String baseCurrency,  String targetCurrency,  double rate,  bool isManual,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ExchangeRate() when $default != null:
return $default(_that.id,_that.tripId,_that.baseCurrency,_that.targetCurrency,_that.rate,_that.isManual,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ExchangeRate implements ExchangeRate {
  const _ExchangeRate({required this.id, this.tripId, required this.baseCurrency, required this.targetCurrency, required this.rate, this.isManual = false, required this.updatedAt});
  

@override final  int id;
@override final  int? tripId;
@override final  String baseCurrency;
@override final  String targetCurrency;
@override final  double rate;
@override@JsonKey() final  bool isManual;
@override final  DateTime updatedAt;

/// Create a copy of ExchangeRate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExchangeRateCopyWith<_ExchangeRate> get copyWith => __$ExchangeRateCopyWithImpl<_ExchangeRate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExchangeRate&&(identical(other.id, id) || other.id == id)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.baseCurrency, baseCurrency) || other.baseCurrency == baseCurrency)&&(identical(other.targetCurrency, targetCurrency) || other.targetCurrency == targetCurrency)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.isManual, isManual) || other.isManual == isManual)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tripId,baseCurrency,targetCurrency,rate,isManual,updatedAt);

@override
String toString() {
  return 'ExchangeRate(id: $id, tripId: $tripId, baseCurrency: $baseCurrency, targetCurrency: $targetCurrency, rate: $rate, isManual: $isManual, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExchangeRateCopyWith<$Res> implements $ExchangeRateCopyWith<$Res> {
  factory _$ExchangeRateCopyWith(_ExchangeRate value, $Res Function(_ExchangeRate) _then) = __$ExchangeRateCopyWithImpl;
@override @useResult
$Res call({
 int id, int? tripId, String baseCurrency, String targetCurrency, double rate, bool isManual, DateTime updatedAt
});




}
/// @nodoc
class __$ExchangeRateCopyWithImpl<$Res>
    implements _$ExchangeRateCopyWith<$Res> {
  __$ExchangeRateCopyWithImpl(this._self, this._then);

  final _ExchangeRate _self;
  final $Res Function(_ExchangeRate) _then;

/// Create a copy of ExchangeRate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tripId = freezed,Object? baseCurrency = null,Object? targetCurrency = null,Object? rate = null,Object? isManual = null,Object? updatedAt = null,}) {
  return _then(_ExchangeRate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int?,baseCurrency: null == baseCurrency ? _self.baseCurrency : baseCurrency // ignore: cast_nullable_to_non_nullable
as String,targetCurrency: null == targetCurrency ? _self.targetCurrency : targetCurrency // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,isManual: null == isManual ? _self.isManual : isManual // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
