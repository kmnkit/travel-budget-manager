// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spending_velocity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpendingVelocity {

/// Average daily spending amount
 double get dailyAverage;/// Average weekly spending amount (typically dailyAverage * 7)
 double get weeklyAverage;/// Rate of change in spending velocity
/// - Positive: spending is increasing over time
/// - Negative: spending is decreasing over time
/// - Zero: spending rate is stable
 double get acceleration;/// Start date of the analysis period
 DateTime get periodStart;/// End date of the analysis period
 DateTime get periodEnd;
/// Create a copy of SpendingVelocity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpendingVelocityCopyWith<SpendingVelocity> get copyWith => _$SpendingVelocityCopyWithImpl<SpendingVelocity>(this as SpendingVelocity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpendingVelocity&&(identical(other.dailyAverage, dailyAverage) || other.dailyAverage == dailyAverage)&&(identical(other.weeklyAverage, weeklyAverage) || other.weeklyAverage == weeklyAverage)&&(identical(other.acceleration, acceleration) || other.acceleration == acceleration)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd));
}


@override
int get hashCode => Object.hash(runtimeType,dailyAverage,weeklyAverage,acceleration,periodStart,periodEnd);

@override
String toString() {
  return 'SpendingVelocity(dailyAverage: $dailyAverage, weeklyAverage: $weeklyAverage, acceleration: $acceleration, periodStart: $periodStart, periodEnd: $periodEnd)';
}


}

/// @nodoc
abstract mixin class $SpendingVelocityCopyWith<$Res>  {
  factory $SpendingVelocityCopyWith(SpendingVelocity value, $Res Function(SpendingVelocity) _then) = _$SpendingVelocityCopyWithImpl;
@useResult
$Res call({
 double dailyAverage, double weeklyAverage, double acceleration, DateTime periodStart, DateTime periodEnd
});




}
/// @nodoc
class _$SpendingVelocityCopyWithImpl<$Res>
    implements $SpendingVelocityCopyWith<$Res> {
  _$SpendingVelocityCopyWithImpl(this._self, this._then);

  final SpendingVelocity _self;
  final $Res Function(SpendingVelocity) _then;

/// Create a copy of SpendingVelocity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyAverage = null,Object? weeklyAverage = null,Object? acceleration = null,Object? periodStart = null,Object? periodEnd = null,}) {
  return _then(_self.copyWith(
dailyAverage: null == dailyAverage ? _self.dailyAverage : dailyAverage // ignore: cast_nullable_to_non_nullable
as double,weeklyAverage: null == weeklyAverage ? _self.weeklyAverage : weeklyAverage // ignore: cast_nullable_to_non_nullable
as double,acceleration: null == acceleration ? _self.acceleration : acceleration // ignore: cast_nullable_to_non_nullable
as double,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SpendingVelocity].
extension SpendingVelocityPatterns on SpendingVelocity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpendingVelocity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpendingVelocity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpendingVelocity value)  $default,){
final _that = this;
switch (_that) {
case _SpendingVelocity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpendingVelocity value)?  $default,){
final _that = this;
switch (_that) {
case _SpendingVelocity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double dailyAverage,  double weeklyAverage,  double acceleration,  DateTime periodStart,  DateTime periodEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpendingVelocity() when $default != null:
return $default(_that.dailyAverage,_that.weeklyAverage,_that.acceleration,_that.periodStart,_that.periodEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double dailyAverage,  double weeklyAverage,  double acceleration,  DateTime periodStart,  DateTime periodEnd)  $default,) {final _that = this;
switch (_that) {
case _SpendingVelocity():
return $default(_that.dailyAverage,_that.weeklyAverage,_that.acceleration,_that.periodStart,_that.periodEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double dailyAverage,  double weeklyAverage,  double acceleration,  DateTime periodStart,  DateTime periodEnd)?  $default,) {final _that = this;
switch (_that) {
case _SpendingVelocity() when $default != null:
return $default(_that.dailyAverage,_that.weeklyAverage,_that.acceleration,_that.periodStart,_that.periodEnd);case _:
  return null;

}
}

}

/// @nodoc


class _SpendingVelocity implements SpendingVelocity {
  const _SpendingVelocity({required this.dailyAverage, required this.weeklyAverage, required this.acceleration, required this.periodStart, required this.periodEnd});
  

/// Average daily spending amount
@override final  double dailyAverage;
/// Average weekly spending amount (typically dailyAverage * 7)
@override final  double weeklyAverage;
/// Rate of change in spending velocity
/// - Positive: spending is increasing over time
/// - Negative: spending is decreasing over time
/// - Zero: spending rate is stable
@override final  double acceleration;
/// Start date of the analysis period
@override final  DateTime periodStart;
/// End date of the analysis period
@override final  DateTime periodEnd;

/// Create a copy of SpendingVelocity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpendingVelocityCopyWith<_SpendingVelocity> get copyWith => __$SpendingVelocityCopyWithImpl<_SpendingVelocity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpendingVelocity&&(identical(other.dailyAverage, dailyAverage) || other.dailyAverage == dailyAverage)&&(identical(other.weeklyAverage, weeklyAverage) || other.weeklyAverage == weeklyAverage)&&(identical(other.acceleration, acceleration) || other.acceleration == acceleration)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd));
}


@override
int get hashCode => Object.hash(runtimeType,dailyAverage,weeklyAverage,acceleration,periodStart,periodEnd);

@override
String toString() {
  return 'SpendingVelocity(dailyAverage: $dailyAverage, weeklyAverage: $weeklyAverage, acceleration: $acceleration, periodStart: $periodStart, periodEnd: $periodEnd)';
}


}

/// @nodoc
abstract mixin class _$SpendingVelocityCopyWith<$Res> implements $SpendingVelocityCopyWith<$Res> {
  factory _$SpendingVelocityCopyWith(_SpendingVelocity value, $Res Function(_SpendingVelocity) _then) = __$SpendingVelocityCopyWithImpl;
@override @useResult
$Res call({
 double dailyAverage, double weeklyAverage, double acceleration, DateTime periodStart, DateTime periodEnd
});




}
/// @nodoc
class __$SpendingVelocityCopyWithImpl<$Res>
    implements _$SpendingVelocityCopyWith<$Res> {
  __$SpendingVelocityCopyWithImpl(this._self, this._then);

  final _SpendingVelocity _self;
  final $Res Function(_SpendingVelocity) _then;

/// Create a copy of SpendingVelocity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyAverage = null,Object? weeklyAverage = null,Object? acceleration = null,Object? periodStart = null,Object? periodEnd = null,}) {
  return _then(_SpendingVelocity(
dailyAverage: null == dailyAverage ? _self.dailyAverage : dailyAverage // ignore: cast_nullable_to_non_nullable
as double,weeklyAverage: null == weeklyAverage ? _self.weeklyAverage : weeklyAverage // ignore: cast_nullable_to_non_nullable
as double,acceleration: null == acceleration ? _self.acceleration : acceleration // ignore: cast_nullable_to_non_nullable
as double,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
