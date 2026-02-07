// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consent_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConsentRecord {

 bool get isAccepted; DateTime? get acceptedAt; String get policyVersion;
/// Create a copy of ConsentRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentRecordCopyWith<ConsentRecord> get copyWith => _$ConsentRecordCopyWithImpl<ConsentRecord>(this as ConsentRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentRecord&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion));
}


@override
int get hashCode => Object.hash(runtimeType,isAccepted,acceptedAt,policyVersion);

@override
String toString() {
  return 'ConsentRecord(isAccepted: $isAccepted, acceptedAt: $acceptedAt, policyVersion: $policyVersion)';
}


}

/// @nodoc
abstract mixin class $ConsentRecordCopyWith<$Res>  {
  factory $ConsentRecordCopyWith(ConsentRecord value, $Res Function(ConsentRecord) _then) = _$ConsentRecordCopyWithImpl;
@useResult
$Res call({
 bool isAccepted, DateTime? acceptedAt, String policyVersion
});




}
/// @nodoc
class _$ConsentRecordCopyWithImpl<$Res>
    implements $ConsentRecordCopyWith<$Res> {
  _$ConsentRecordCopyWithImpl(this._self, this._then);

  final ConsentRecord _self;
  final $Res Function(ConsentRecord) _then;

/// Create a copy of ConsentRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAccepted = null,Object? acceptedAt = freezed,Object? policyVersion = null,}) {
  return _then(_self.copyWith(
isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentRecord].
extension ConsentRecordPatterns on ConsentRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentRecord value)  $default,){
final _that = this;
switch (_that) {
case _ConsentRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isAccepted,  DateTime? acceptedAt,  String policyVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentRecord() when $default != null:
return $default(_that.isAccepted,_that.acceptedAt,_that.policyVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isAccepted,  DateTime? acceptedAt,  String policyVersion)  $default,) {final _that = this;
switch (_that) {
case _ConsentRecord():
return $default(_that.isAccepted,_that.acceptedAt,_that.policyVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isAccepted,  DateTime? acceptedAt,  String policyVersion)?  $default,) {final _that = this;
switch (_that) {
case _ConsentRecord() when $default != null:
return $default(_that.isAccepted,_that.acceptedAt,_that.policyVersion);case _:
  return null;

}
}

}

/// @nodoc


class _ConsentRecord extends ConsentRecord {
  const _ConsentRecord({required this.isAccepted, required this.acceptedAt, required this.policyVersion}): super._();
  

@override final  bool isAccepted;
@override final  DateTime? acceptedAt;
@override final  String policyVersion;

/// Create a copy of ConsentRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentRecordCopyWith<_ConsentRecord> get copyWith => __$ConsentRecordCopyWithImpl<_ConsentRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentRecord&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion));
}


@override
int get hashCode => Object.hash(runtimeType,isAccepted,acceptedAt,policyVersion);

@override
String toString() {
  return 'ConsentRecord(isAccepted: $isAccepted, acceptedAt: $acceptedAt, policyVersion: $policyVersion)';
}


}

/// @nodoc
abstract mixin class _$ConsentRecordCopyWith<$Res> implements $ConsentRecordCopyWith<$Res> {
  factory _$ConsentRecordCopyWith(_ConsentRecord value, $Res Function(_ConsentRecord) _then) = __$ConsentRecordCopyWithImpl;
@override @useResult
$Res call({
 bool isAccepted, DateTime? acceptedAt, String policyVersion
});




}
/// @nodoc
class __$ConsentRecordCopyWithImpl<$Res>
    implements _$ConsentRecordCopyWith<$Res> {
  __$ConsentRecordCopyWithImpl(this._self, this._then);

  final _ConsentRecord _self;
  final $Res Function(_ConsentRecord) _then;

/// Create a copy of ConsentRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAccepted = null,Object? acceptedAt = freezed,Object? policyVersion = null,}) {
  return _then(_ConsentRecord(
isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
