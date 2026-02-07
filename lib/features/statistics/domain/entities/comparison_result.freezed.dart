// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comparison_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComparisonResult {

/// Label describing this comparison (e.g., "이번 주 vs 지난 주")
 String get label;/// Current period's total value
 double get currentValue;/// Comparison period's total value
 double get comparisonValue;/// Absolute difference (currentValue - comparisonValue)
 double get difference;/// Percentage change from comparison to current
 double get percentageChange;/// Direction of the change
 TrendDirection get direction;
/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComparisonResultCopyWith<ComparisonResult> get copyWith => _$ComparisonResultCopyWithImpl<ComparisonResult>(this as ComparisonResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComparisonResult&&(identical(other.label, label) || other.label == label)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.comparisonValue, comparisonValue) || other.comparisonValue == comparisonValue)&&(identical(other.difference, difference) || other.difference == difference)&&(identical(other.percentageChange, percentageChange) || other.percentageChange == percentageChange)&&(identical(other.direction, direction) || other.direction == direction));
}


@override
int get hashCode => Object.hash(runtimeType,label,currentValue,comparisonValue,difference,percentageChange,direction);

@override
String toString() {
  return 'ComparisonResult(label: $label, currentValue: $currentValue, comparisonValue: $comparisonValue, difference: $difference, percentageChange: $percentageChange, direction: $direction)';
}


}

/// @nodoc
abstract mixin class $ComparisonResultCopyWith<$Res>  {
  factory $ComparisonResultCopyWith(ComparisonResult value, $Res Function(ComparisonResult) _then) = _$ComparisonResultCopyWithImpl;
@useResult
$Res call({
 String label, double currentValue, double comparisonValue, double difference, double percentageChange, TrendDirection direction
});




}
/// @nodoc
class _$ComparisonResultCopyWithImpl<$Res>
    implements $ComparisonResultCopyWith<$Res> {
  _$ComparisonResultCopyWithImpl(this._self, this._then);

  final ComparisonResult _self;
  final $Res Function(ComparisonResult) _then;

/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? currentValue = null,Object? comparisonValue = null,Object? difference = null,Object? percentageChange = null,Object? direction = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,comparisonValue: null == comparisonValue ? _self.comparisonValue : comparisonValue // ignore: cast_nullable_to_non_nullable
as double,difference: null == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as double,percentageChange: null == percentageChange ? _self.percentageChange : percentageChange // ignore: cast_nullable_to_non_nullable
as double,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TrendDirection,
  ));
}

}


/// Adds pattern-matching-related methods to [ComparisonResult].
extension ComparisonResultPatterns on ComparisonResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComparisonResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComparisonResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComparisonResult value)  $default,){
final _that = this;
switch (_that) {
case _ComparisonResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComparisonResult value)?  $default,){
final _that = this;
switch (_that) {
case _ComparisonResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  double currentValue,  double comparisonValue,  double difference,  double percentageChange,  TrendDirection direction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComparisonResult() when $default != null:
return $default(_that.label,_that.currentValue,_that.comparisonValue,_that.difference,_that.percentageChange,_that.direction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  double currentValue,  double comparisonValue,  double difference,  double percentageChange,  TrendDirection direction)  $default,) {final _that = this;
switch (_that) {
case _ComparisonResult():
return $default(_that.label,_that.currentValue,_that.comparisonValue,_that.difference,_that.percentageChange,_that.direction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  double currentValue,  double comparisonValue,  double difference,  double percentageChange,  TrendDirection direction)?  $default,) {final _that = this;
switch (_that) {
case _ComparisonResult() when $default != null:
return $default(_that.label,_that.currentValue,_that.comparisonValue,_that.difference,_that.percentageChange,_that.direction);case _:
  return null;

}
}

}

/// @nodoc


class _ComparisonResult implements ComparisonResult {
  const _ComparisonResult({required this.label, required this.currentValue, required this.comparisonValue, required this.difference, required this.percentageChange, required this.direction});
  

/// Label describing this comparison (e.g., "이번 주 vs 지난 주")
@override final  String label;
/// Current period's total value
@override final  double currentValue;
/// Comparison period's total value
@override final  double comparisonValue;
/// Absolute difference (currentValue - comparisonValue)
@override final  double difference;
/// Percentage change from comparison to current
@override final  double percentageChange;
/// Direction of the change
@override final  TrendDirection direction;

/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComparisonResultCopyWith<_ComparisonResult> get copyWith => __$ComparisonResultCopyWithImpl<_ComparisonResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComparisonResult&&(identical(other.label, label) || other.label == label)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.comparisonValue, comparisonValue) || other.comparisonValue == comparisonValue)&&(identical(other.difference, difference) || other.difference == difference)&&(identical(other.percentageChange, percentageChange) || other.percentageChange == percentageChange)&&(identical(other.direction, direction) || other.direction == direction));
}


@override
int get hashCode => Object.hash(runtimeType,label,currentValue,comparisonValue,difference,percentageChange,direction);

@override
String toString() {
  return 'ComparisonResult(label: $label, currentValue: $currentValue, comparisonValue: $comparisonValue, difference: $difference, percentageChange: $percentageChange, direction: $direction)';
}


}

/// @nodoc
abstract mixin class _$ComparisonResultCopyWith<$Res> implements $ComparisonResultCopyWith<$Res> {
  factory _$ComparisonResultCopyWith(_ComparisonResult value, $Res Function(_ComparisonResult) _then) = __$ComparisonResultCopyWithImpl;
@override @useResult
$Res call({
 String label, double currentValue, double comparisonValue, double difference, double percentageChange, TrendDirection direction
});




}
/// @nodoc
class __$ComparisonResultCopyWithImpl<$Res>
    implements _$ComparisonResultCopyWith<$Res> {
  __$ComparisonResultCopyWithImpl(this._self, this._then);

  final _ComparisonResult _self;
  final $Res Function(_ComparisonResult) _then;

/// Create a copy of ComparisonResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? currentValue = null,Object? comparisonValue = null,Object? difference = null,Object? percentageChange = null,Object? direction = null,}) {
  return _then(_ComparisonResult(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,comparisonValue: null == comparisonValue ? _self.comparisonValue : comparisonValue // ignore: cast_nullable_to_non_nullable
as double,difference: null == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as double,percentageChange: null == percentageChange ? _self.percentageChange : percentageChange // ignore: cast_nullable_to_non_nullable
as double,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TrendDirection,
  ));
}


}

// dart format on
