// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardWidgetConfig {

 DashboardWidgetType get widgetType; int get position; bool get isVisible;
/// Create a copy of DashboardWidgetConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardWidgetConfigCopyWith<DashboardWidgetConfig> get copyWith => _$DashboardWidgetConfigCopyWithImpl<DashboardWidgetConfig>(this as DashboardWidgetConfig, _$identity);

  /// Serializes this DashboardWidgetConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardWidgetConfig&&(identical(other.widgetType, widgetType) || other.widgetType == widgetType)&&(identical(other.position, position) || other.position == position)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,widgetType,position,isVisible);

@override
String toString() {
  return 'DashboardWidgetConfig(widgetType: $widgetType, position: $position, isVisible: $isVisible)';
}


}

/// @nodoc
abstract mixin class $DashboardWidgetConfigCopyWith<$Res>  {
  factory $DashboardWidgetConfigCopyWith(DashboardWidgetConfig value, $Res Function(DashboardWidgetConfig) _then) = _$DashboardWidgetConfigCopyWithImpl;
@useResult
$Res call({
 DashboardWidgetType widgetType, int position, bool isVisible
});




}
/// @nodoc
class _$DashboardWidgetConfigCopyWithImpl<$Res>
    implements $DashboardWidgetConfigCopyWith<$Res> {
  _$DashboardWidgetConfigCopyWithImpl(this._self, this._then);

  final DashboardWidgetConfig _self;
  final $Res Function(DashboardWidgetConfig) _then;

/// Create a copy of DashboardWidgetConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? widgetType = null,Object? position = null,Object? isVisible = null,}) {
  return _then(_self.copyWith(
widgetType: null == widgetType ? _self.widgetType : widgetType // ignore: cast_nullable_to_non_nullable
as DashboardWidgetType,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardWidgetConfig].
extension DashboardWidgetConfigPatterns on DashboardWidgetConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardWidgetConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardWidgetConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardWidgetConfig value)  $default,){
final _that = this;
switch (_that) {
case _DashboardWidgetConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardWidgetConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardWidgetConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardWidgetType widgetType,  int position,  bool isVisible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardWidgetConfig() when $default != null:
return $default(_that.widgetType,_that.position,_that.isVisible);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardWidgetType widgetType,  int position,  bool isVisible)  $default,) {final _that = this;
switch (_that) {
case _DashboardWidgetConfig():
return $default(_that.widgetType,_that.position,_that.isVisible);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardWidgetType widgetType,  int position,  bool isVisible)?  $default,) {final _that = this;
switch (_that) {
case _DashboardWidgetConfig() when $default != null:
return $default(_that.widgetType,_that.position,_that.isVisible);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardWidgetConfig implements DashboardWidgetConfig {
  const _DashboardWidgetConfig({required this.widgetType, required this.position, this.isVisible = true});
  factory _DashboardWidgetConfig.fromJson(Map<String, dynamic> json) => _$DashboardWidgetConfigFromJson(json);

@override final  DashboardWidgetType widgetType;
@override final  int position;
@override@JsonKey() final  bool isVisible;

/// Create a copy of DashboardWidgetConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardWidgetConfigCopyWith<_DashboardWidgetConfig> get copyWith => __$DashboardWidgetConfigCopyWithImpl<_DashboardWidgetConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardWidgetConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardWidgetConfig&&(identical(other.widgetType, widgetType) || other.widgetType == widgetType)&&(identical(other.position, position) || other.position == position)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,widgetType,position,isVisible);

@override
String toString() {
  return 'DashboardWidgetConfig(widgetType: $widgetType, position: $position, isVisible: $isVisible)';
}


}

/// @nodoc
abstract mixin class _$DashboardWidgetConfigCopyWith<$Res> implements $DashboardWidgetConfigCopyWith<$Res> {
  factory _$DashboardWidgetConfigCopyWith(_DashboardWidgetConfig value, $Res Function(_DashboardWidgetConfig) _then) = __$DashboardWidgetConfigCopyWithImpl;
@override @useResult
$Res call({
 DashboardWidgetType widgetType, int position, bool isVisible
});




}
/// @nodoc
class __$DashboardWidgetConfigCopyWithImpl<$Res>
    implements _$DashboardWidgetConfigCopyWith<$Res> {
  __$DashboardWidgetConfigCopyWithImpl(this._self, this._then);

  final _DashboardWidgetConfig _self;
  final $Res Function(_DashboardWidgetConfig) _then;

/// Create a copy of DashboardWidgetConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? widgetType = null,Object? position = null,Object? isVisible = null,}) {
  return _then(_DashboardWidgetConfig(
widgetType: null == widgetType ? _self.widgetType : widgetType // ignore: cast_nullable_to_non_nullable
as DashboardWidgetType,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DashboardConfig {

 String get id; String get name; List<DashboardWidgetConfig> get widgets; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DashboardConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardConfigCopyWith<DashboardConfig> get copyWith => _$DashboardConfigCopyWithImpl<DashboardConfig>(this as DashboardConfig, _$identity);

  /// Serializes this DashboardConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.widgets, widgets)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(widgets),createdAt,updatedAt);

@override
String toString() {
  return 'DashboardConfig(id: $id, name: $name, widgets: $widgets, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DashboardConfigCopyWith<$Res>  {
  factory $DashboardConfigCopyWith(DashboardConfig value, $Res Function(DashboardConfig) _then) = _$DashboardConfigCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<DashboardWidgetConfig> widgets, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DashboardConfigCopyWithImpl<$Res>
    implements $DashboardConfigCopyWith<$Res> {
  _$DashboardConfigCopyWithImpl(this._self, this._then);

  final DashboardConfig _self;
  final $Res Function(DashboardConfig) _then;

/// Create a copy of DashboardConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? widgets = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,widgets: null == widgets ? _self.widgets : widgets // ignore: cast_nullable_to_non_nullable
as List<DashboardWidgetConfig>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardConfig].
extension DashboardConfigPatterns on DashboardConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardConfig value)  $default,){
final _that = this;
switch (_that) {
case _DashboardConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<DashboardWidgetConfig> widgets,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardConfig() when $default != null:
return $default(_that.id,_that.name,_that.widgets,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<DashboardWidgetConfig> widgets,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DashboardConfig():
return $default(_that.id,_that.name,_that.widgets,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<DashboardWidgetConfig> widgets,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DashboardConfig() when $default != null:
return $default(_that.id,_that.name,_that.widgets,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DashboardConfig extends DashboardConfig {
  const _DashboardConfig({required this.id, required this.name, required final  List<DashboardWidgetConfig> widgets, required this.createdAt, required this.updatedAt}): _widgets = widgets,super._();
  factory _DashboardConfig.fromJson(Map<String, dynamic> json) => _$DashboardConfigFromJson(json);

@override final  String id;
@override final  String name;
 final  List<DashboardWidgetConfig> _widgets;
@override List<DashboardWidgetConfig> get widgets {
  if (_widgets is EqualUnmodifiableListView) return _widgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_widgets);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of DashboardConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardConfigCopyWith<_DashboardConfig> get copyWith => __$DashboardConfigCopyWithImpl<_DashboardConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._widgets, _widgets)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_widgets),createdAt,updatedAt);

@override
String toString() {
  return 'DashboardConfig(id: $id, name: $name, widgets: $widgets, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DashboardConfigCopyWith<$Res> implements $DashboardConfigCopyWith<$Res> {
  factory _$DashboardConfigCopyWith(_DashboardConfig value, $Res Function(_DashboardConfig) _then) = __$DashboardConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<DashboardWidgetConfig> widgets, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DashboardConfigCopyWithImpl<$Res>
    implements _$DashboardConfigCopyWith<$Res> {
  __$DashboardConfigCopyWithImpl(this._self, this._then);

  final _DashboardConfig _self;
  final $Res Function(_DashboardConfig) _then;

/// Create a copy of DashboardConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? widgets = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DashboardConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,widgets: null == widgets ? _self._widgets : widgets // ignore: cast_nullable_to_non_nullable
as List<DashboardWidgetConfig>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
