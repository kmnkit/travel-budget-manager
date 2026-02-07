// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsInsight {

 String get id; InsightType get type; String get title; String get description; InsightPriority get priority; DateTime get generatedAt; Map<String, dynamic>? get metadata;
/// Create a copy of AnalyticsInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsInsightCopyWith<AnalyticsInsight> get copyWith => _$AnalyticsInsightCopyWithImpl<AnalyticsInsight>(this as AnalyticsInsight, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsInsight&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,priority,generatedAt,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'AnalyticsInsight(id: $id, type: $type, title: $title, description: $description, priority: $priority, generatedAt: $generatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AnalyticsInsightCopyWith<$Res>  {
  factory $AnalyticsInsightCopyWith(AnalyticsInsight value, $Res Function(AnalyticsInsight) _then) = _$AnalyticsInsightCopyWithImpl;
@useResult
$Res call({
 String id, InsightType type, String title, String description, InsightPriority priority, DateTime generatedAt, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$AnalyticsInsightCopyWithImpl<$Res>
    implements $AnalyticsInsightCopyWith<$Res> {
  _$AnalyticsInsightCopyWithImpl(this._self, this._then);

  final AnalyticsInsight _self;
  final $Res Function(AnalyticsInsight) _then;

/// Create a copy of AnalyticsInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? priority = null,Object? generatedAt = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InsightType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as InsightPriority,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsInsight].
extension AnalyticsInsightPatterns on AnalyticsInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsInsight value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsInsight value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  InsightType type,  String title,  String description,  InsightPriority priority,  DateTime generatedAt,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsInsight() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.priority,_that.generatedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  InsightType type,  String title,  String description,  InsightPriority priority,  DateTime generatedAt,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsInsight():
return $default(_that.id,_that.type,_that.title,_that.description,_that.priority,_that.generatedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  InsightType type,  String title,  String description,  InsightPriority priority,  DateTime generatedAt,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsInsight() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.priority,_that.generatedAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc


class _AnalyticsInsight implements AnalyticsInsight {
  const _AnalyticsInsight({required this.id, required this.type, required this.title, required this.description, required this.priority, required this.generatedAt, final  Map<String, dynamic>? metadata}): _metadata = metadata;
  

@override final  String id;
@override final  InsightType type;
@override final  String title;
@override final  String description;
@override final  InsightPriority priority;
@override final  DateTime generatedAt;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AnalyticsInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsInsightCopyWith<_AnalyticsInsight> get copyWith => __$AnalyticsInsightCopyWithImpl<_AnalyticsInsight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsInsight&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,priority,generatedAt,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'AnalyticsInsight(id: $id, type: $type, title: $title, description: $description, priority: $priority, generatedAt: $generatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsInsightCopyWith<$Res> implements $AnalyticsInsightCopyWith<$Res> {
  factory _$AnalyticsInsightCopyWith(_AnalyticsInsight value, $Res Function(_AnalyticsInsight) _then) = __$AnalyticsInsightCopyWithImpl;
@override @useResult
$Res call({
 String id, InsightType type, String title, String description, InsightPriority priority, DateTime generatedAt, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$AnalyticsInsightCopyWithImpl<$Res>
    implements _$AnalyticsInsightCopyWith<$Res> {
  __$AnalyticsInsightCopyWithImpl(this._self, this._then);

  final _AnalyticsInsight _self;
  final $Res Function(_AnalyticsInsight) _then;

/// Create a copy of AnalyticsInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? priority = null,Object? generatedAt = null,Object? metadata = freezed,}) {
  return _then(_AnalyticsInsight(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InsightType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as InsightPriority,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
