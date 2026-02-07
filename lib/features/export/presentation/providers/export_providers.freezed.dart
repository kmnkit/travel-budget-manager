// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportState {

 ExportStatus get status; File? get generatedFile; String? get errorMessage; double? get progress;
/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportStateCopyWith<ExportState> get copyWith => _$ExportStateCopyWithImpl<ExportState>(this as ExportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportState&&(identical(other.status, status) || other.status == status)&&(identical(other.generatedFile, generatedFile) || other.generatedFile == generatedFile)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,status,generatedFile,errorMessage,progress);

@override
String toString() {
  return 'ExportState(status: $status, generatedFile: $generatedFile, errorMessage: $errorMessage, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $ExportStateCopyWith<$Res>  {
  factory $ExportStateCopyWith(ExportState value, $Res Function(ExportState) _then) = _$ExportStateCopyWithImpl;
@useResult
$Res call({
 ExportStatus status, File? generatedFile, String? errorMessage, double? progress
});




}
/// @nodoc
class _$ExportStateCopyWithImpl<$Res>
    implements $ExportStateCopyWith<$Res> {
  _$ExportStateCopyWithImpl(this._self, this._then);

  final ExportState _self;
  final $Res Function(ExportState) _then;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? generatedFile = freezed,Object? errorMessage = freezed,Object? progress = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExportStatus,generatedFile: freezed == generatedFile ? _self.generatedFile : generatedFile // ignore: cast_nullable_to_non_nullable
as File?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportState].
extension ExportStatePatterns on ExportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportState value)  $default,){
final _that = this;
switch (_that) {
case _ExportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportState value)?  $default,){
final _that = this;
switch (_that) {
case _ExportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExportStatus status,  File? generatedFile,  String? errorMessage,  double? progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportState() when $default != null:
return $default(_that.status,_that.generatedFile,_that.errorMessage,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExportStatus status,  File? generatedFile,  String? errorMessage,  double? progress)  $default,) {final _that = this;
switch (_that) {
case _ExportState():
return $default(_that.status,_that.generatedFile,_that.errorMessage,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExportStatus status,  File? generatedFile,  String? errorMessage,  double? progress)?  $default,) {final _that = this;
switch (_that) {
case _ExportState() when $default != null:
return $default(_that.status,_that.generatedFile,_that.errorMessage,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _ExportState implements ExportState {
  const _ExportState({this.status = ExportStatus.idle, this.generatedFile, this.errorMessage, this.progress});
  

@override@JsonKey() final  ExportStatus status;
@override final  File? generatedFile;
@override final  String? errorMessage;
@override final  double? progress;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportStateCopyWith<_ExportState> get copyWith => __$ExportStateCopyWithImpl<_ExportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportState&&(identical(other.status, status) || other.status == status)&&(identical(other.generatedFile, generatedFile) || other.generatedFile == generatedFile)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,status,generatedFile,errorMessage,progress);

@override
String toString() {
  return 'ExportState(status: $status, generatedFile: $generatedFile, errorMessage: $errorMessage, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$ExportStateCopyWith<$Res> implements $ExportStateCopyWith<$Res> {
  factory _$ExportStateCopyWith(_ExportState value, $Res Function(_ExportState) _then) = __$ExportStateCopyWithImpl;
@override @useResult
$Res call({
 ExportStatus status, File? generatedFile, String? errorMessage, double? progress
});




}
/// @nodoc
class __$ExportStateCopyWithImpl<$Res>
    implements _$ExportStateCopyWith<$Res> {
  __$ExportStateCopyWithImpl(this._self, this._then);

  final _ExportState _self;
  final $Res Function(_ExportState) _then;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? generatedFile = freezed,Object? errorMessage = freezed,Object? progress = freezed,}) {
  return _then(_ExportState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExportStatus,generatedFile: freezed == generatedFile ? _self.generatedFile : generatedFile // ignore: cast_nullable_to_non_nullable
as File?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
