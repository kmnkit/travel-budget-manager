// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trend_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DataPoint {

 DateTime get date; double get value;
/// Create a copy of DataPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataPointCopyWith<DataPoint> get copyWith => _$DataPointCopyWithImpl<DataPoint>(this as DataPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,date,value);

@override
String toString() {
  return 'DataPoint(date: $date, value: $value)';
}


}

/// @nodoc
abstract mixin class $DataPointCopyWith<$Res>  {
  factory $DataPointCopyWith(DataPoint value, $Res Function(DataPoint) _then) = _$DataPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double value
});




}
/// @nodoc
class _$DataPointCopyWithImpl<$Res>
    implements $DataPointCopyWith<$Res> {
  _$DataPointCopyWithImpl(this._self, this._then);

  final DataPoint _self;
  final $Res Function(DataPoint) _then;

/// Create a copy of DataPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? value = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DataPoint].
extension DataPointPatterns on DataPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataPoint value)  $default,){
final _that = this;
switch (_that) {
case _DataPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataPoint value)?  $default,){
final _that = this;
switch (_that) {
case _DataPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataPoint() when $default != null:
return $default(_that.date,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double value)  $default,) {final _that = this;
switch (_that) {
case _DataPoint():
return $default(_that.date,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double value)?  $default,) {final _that = this;
switch (_that) {
case _DataPoint() when $default != null:
return $default(_that.date,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _DataPoint implements DataPoint {
  const _DataPoint({required this.date, required this.value});
  

@override final  DateTime date;
@override final  double value;

/// Create a copy of DataPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataPointCopyWith<_DataPoint> get copyWith => __$DataPointCopyWithImpl<_DataPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,date,value);

@override
String toString() {
  return 'DataPoint(date: $date, value: $value)';
}


}

/// @nodoc
abstract mixin class _$DataPointCopyWith<$Res> implements $DataPointCopyWith<$Res> {
  factory _$DataPointCopyWith(_DataPoint value, $Res Function(_DataPoint) _then) = __$DataPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double value
});




}
/// @nodoc
class __$DataPointCopyWithImpl<$Res>
    implements _$DataPointCopyWith<$Res> {
  __$DataPointCopyWithImpl(this._self, this._then);

  final _DataPoint _self;
  final $Res Function(_DataPoint) _then;

/// Create a copy of DataPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? value = null,}) {
  return _then(_DataPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$TrendData {

 List<DataPoint> get historicalData; List<DataPoint>? get projectedData; TrendDirection get direction; double get changePercentage; double get confidence;
/// Create a copy of TrendData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendDataCopyWith<TrendData> get copyWith => _$TrendDataCopyWithImpl<TrendData>(this as TrendData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendData&&const DeepCollectionEquality().equals(other.historicalData, historicalData)&&const DeepCollectionEquality().equals(other.projectedData, projectedData)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.changePercentage, changePercentage) || other.changePercentage == changePercentage)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(historicalData),const DeepCollectionEquality().hash(projectedData),direction,changePercentage,confidence);

@override
String toString() {
  return 'TrendData(historicalData: $historicalData, projectedData: $projectedData, direction: $direction, changePercentage: $changePercentage, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $TrendDataCopyWith<$Res>  {
  factory $TrendDataCopyWith(TrendData value, $Res Function(TrendData) _then) = _$TrendDataCopyWithImpl;
@useResult
$Res call({
 List<DataPoint> historicalData, List<DataPoint>? projectedData, TrendDirection direction, double changePercentage, double confidence
});




}
/// @nodoc
class _$TrendDataCopyWithImpl<$Res>
    implements $TrendDataCopyWith<$Res> {
  _$TrendDataCopyWithImpl(this._self, this._then);

  final TrendData _self;
  final $Res Function(TrendData) _then;

/// Create a copy of TrendData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? historicalData = null,Object? projectedData = freezed,Object? direction = null,Object? changePercentage = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
historicalData: null == historicalData ? _self.historicalData : historicalData // ignore: cast_nullable_to_non_nullable
as List<DataPoint>,projectedData: freezed == projectedData ? _self.projectedData : projectedData // ignore: cast_nullable_to_non_nullable
as List<DataPoint>?,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TrendDirection,changePercentage: null == changePercentage ? _self.changePercentage : changePercentage // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TrendData].
extension TrendDataPatterns on TrendData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendData value)  $default,){
final _that = this;
switch (_that) {
case _TrendData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendData value)?  $default,){
final _that = this;
switch (_that) {
case _TrendData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DataPoint> historicalData,  List<DataPoint>? projectedData,  TrendDirection direction,  double changePercentage,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendData() when $default != null:
return $default(_that.historicalData,_that.projectedData,_that.direction,_that.changePercentage,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DataPoint> historicalData,  List<DataPoint>? projectedData,  TrendDirection direction,  double changePercentage,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _TrendData():
return $default(_that.historicalData,_that.projectedData,_that.direction,_that.changePercentage,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DataPoint> historicalData,  List<DataPoint>? projectedData,  TrendDirection direction,  double changePercentage,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _TrendData() when $default != null:
return $default(_that.historicalData,_that.projectedData,_that.direction,_that.changePercentage,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc


class _TrendData implements TrendData {
  const _TrendData({required final  List<DataPoint> historicalData, required final  List<DataPoint>? projectedData, required this.direction, required this.changePercentage, required this.confidence}): _historicalData = historicalData,_projectedData = projectedData;
  

 final  List<DataPoint> _historicalData;
@override List<DataPoint> get historicalData {
  if (_historicalData is EqualUnmodifiableListView) return _historicalData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_historicalData);
}

 final  List<DataPoint>? _projectedData;
@override List<DataPoint>? get projectedData {
  final value = _projectedData;
  if (value == null) return null;
  if (_projectedData is EqualUnmodifiableListView) return _projectedData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  TrendDirection direction;
@override final  double changePercentage;
@override final  double confidence;

/// Create a copy of TrendData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendDataCopyWith<_TrendData> get copyWith => __$TrendDataCopyWithImpl<_TrendData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendData&&const DeepCollectionEquality().equals(other._historicalData, _historicalData)&&const DeepCollectionEquality().equals(other._projectedData, _projectedData)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.changePercentage, changePercentage) || other.changePercentage == changePercentage)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_historicalData),const DeepCollectionEquality().hash(_projectedData),direction,changePercentage,confidence);

@override
String toString() {
  return 'TrendData(historicalData: $historicalData, projectedData: $projectedData, direction: $direction, changePercentage: $changePercentage, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$TrendDataCopyWith<$Res> implements $TrendDataCopyWith<$Res> {
  factory _$TrendDataCopyWith(_TrendData value, $Res Function(_TrendData) _then) = __$TrendDataCopyWithImpl;
@override @useResult
$Res call({
 List<DataPoint> historicalData, List<DataPoint>? projectedData, TrendDirection direction, double changePercentage, double confidence
});




}
/// @nodoc
class __$TrendDataCopyWithImpl<$Res>
    implements _$TrendDataCopyWith<$Res> {
  __$TrendDataCopyWithImpl(this._self, this._then);

  final _TrendData _self;
  final $Res Function(_TrendData) _then;

/// Create a copy of TrendData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? historicalData = null,Object? projectedData = freezed,Object? direction = null,Object? changePercentage = null,Object? confidence = null,}) {
  return _then(_TrendData(
historicalData: null == historicalData ? _self._historicalData : historicalData // ignore: cast_nullable_to_non_nullable
as List<DataPoint>,projectedData: freezed == projectedData ? _self._projectedData : projectedData // ignore: cast_nullable_to_non_nullable
as List<DataPoint>?,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TrendDirection,changePercentage: null == changePercentage ? _self.changePercentage : changePercentage // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
