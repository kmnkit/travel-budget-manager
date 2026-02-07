// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryInsight {

/// Category name (e.g., '식비', '교통비')
 String get category;/// Total spending amount in this category
 double get amount;/// Percentage of total spending this category represents
 double get percentage;/// Rank among all categories (1 = highest spending)
 int get rank;/// Descriptions of top expenses in this category
 List<String> get topExpenseDescriptions;/// Previous period's amount for comparison (null if no comparison)
 double? get previousAmount;/// Percentage change from previous period (null if no comparison)
 double? get changePercentage;
/// Create a copy of CategoryInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryInsightCopyWith<CategoryInsight> get copyWith => _$CategoryInsightCopyWithImpl<CategoryInsight>(this as CategoryInsight, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryInsight&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.rank, rank) || other.rank == rank)&&const DeepCollectionEquality().equals(other.topExpenseDescriptions, topExpenseDescriptions)&&(identical(other.previousAmount, previousAmount) || other.previousAmount == previousAmount)&&(identical(other.changePercentage, changePercentage) || other.changePercentage == changePercentage));
}


@override
int get hashCode => Object.hash(runtimeType,category,amount,percentage,rank,const DeepCollectionEquality().hash(topExpenseDescriptions),previousAmount,changePercentage);

@override
String toString() {
  return 'CategoryInsight(category: $category, amount: $amount, percentage: $percentage, rank: $rank, topExpenseDescriptions: $topExpenseDescriptions, previousAmount: $previousAmount, changePercentage: $changePercentage)';
}


}

/// @nodoc
abstract mixin class $CategoryInsightCopyWith<$Res>  {
  factory $CategoryInsightCopyWith(CategoryInsight value, $Res Function(CategoryInsight) _then) = _$CategoryInsightCopyWithImpl;
@useResult
$Res call({
 String category, double amount, double percentage, int rank, List<String> topExpenseDescriptions, double? previousAmount, double? changePercentage
});




}
/// @nodoc
class _$CategoryInsightCopyWithImpl<$Res>
    implements $CategoryInsightCopyWith<$Res> {
  _$CategoryInsightCopyWithImpl(this._self, this._then);

  final CategoryInsight _self;
  final $Res Function(CategoryInsight) _then;

/// Create a copy of CategoryInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? amount = null,Object? percentage = null,Object? rank = null,Object? topExpenseDescriptions = null,Object? previousAmount = freezed,Object? changePercentage = freezed,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,topExpenseDescriptions: null == topExpenseDescriptions ? _self.topExpenseDescriptions : topExpenseDescriptions // ignore: cast_nullable_to_non_nullable
as List<String>,previousAmount: freezed == previousAmount ? _self.previousAmount : previousAmount // ignore: cast_nullable_to_non_nullable
as double?,changePercentage: freezed == changePercentage ? _self.changePercentage : changePercentage // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryInsight].
extension CategoryInsightPatterns on CategoryInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryInsight value)  $default,){
final _that = this;
switch (_that) {
case _CategoryInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryInsight value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  double amount,  double percentage,  int rank,  List<String> topExpenseDescriptions,  double? previousAmount,  double? changePercentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryInsight() when $default != null:
return $default(_that.category,_that.amount,_that.percentage,_that.rank,_that.topExpenseDescriptions,_that.previousAmount,_that.changePercentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  double amount,  double percentage,  int rank,  List<String> topExpenseDescriptions,  double? previousAmount,  double? changePercentage)  $default,) {final _that = this;
switch (_that) {
case _CategoryInsight():
return $default(_that.category,_that.amount,_that.percentage,_that.rank,_that.topExpenseDescriptions,_that.previousAmount,_that.changePercentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  double amount,  double percentage,  int rank,  List<String> topExpenseDescriptions,  double? previousAmount,  double? changePercentage)?  $default,) {final _that = this;
switch (_that) {
case _CategoryInsight() when $default != null:
return $default(_that.category,_that.amount,_that.percentage,_that.rank,_that.topExpenseDescriptions,_that.previousAmount,_that.changePercentage);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryInsight implements CategoryInsight {
  const _CategoryInsight({required this.category, required this.amount, required this.percentage, required this.rank, required final  List<String> topExpenseDescriptions, this.previousAmount, this.changePercentage}): _topExpenseDescriptions = topExpenseDescriptions;
  

/// Category name (e.g., '식비', '교통비')
@override final  String category;
/// Total spending amount in this category
@override final  double amount;
/// Percentage of total spending this category represents
@override final  double percentage;
/// Rank among all categories (1 = highest spending)
@override final  int rank;
/// Descriptions of top expenses in this category
 final  List<String> _topExpenseDescriptions;
/// Descriptions of top expenses in this category
@override List<String> get topExpenseDescriptions {
  if (_topExpenseDescriptions is EqualUnmodifiableListView) return _topExpenseDescriptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topExpenseDescriptions);
}

/// Previous period's amount for comparison (null if no comparison)
@override final  double? previousAmount;
/// Percentage change from previous period (null if no comparison)
@override final  double? changePercentage;

/// Create a copy of CategoryInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryInsightCopyWith<_CategoryInsight> get copyWith => __$CategoryInsightCopyWithImpl<_CategoryInsight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryInsight&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.rank, rank) || other.rank == rank)&&const DeepCollectionEquality().equals(other._topExpenseDescriptions, _topExpenseDescriptions)&&(identical(other.previousAmount, previousAmount) || other.previousAmount == previousAmount)&&(identical(other.changePercentage, changePercentage) || other.changePercentage == changePercentage));
}


@override
int get hashCode => Object.hash(runtimeType,category,amount,percentage,rank,const DeepCollectionEquality().hash(_topExpenseDescriptions),previousAmount,changePercentage);

@override
String toString() {
  return 'CategoryInsight(category: $category, amount: $amount, percentage: $percentage, rank: $rank, topExpenseDescriptions: $topExpenseDescriptions, previousAmount: $previousAmount, changePercentage: $changePercentage)';
}


}

/// @nodoc
abstract mixin class _$CategoryInsightCopyWith<$Res> implements $CategoryInsightCopyWith<$Res> {
  factory _$CategoryInsightCopyWith(_CategoryInsight value, $Res Function(_CategoryInsight) _then) = __$CategoryInsightCopyWithImpl;
@override @useResult
$Res call({
 String category, double amount, double percentage, int rank, List<String> topExpenseDescriptions, double? previousAmount, double? changePercentage
});




}
/// @nodoc
class __$CategoryInsightCopyWithImpl<$Res>
    implements _$CategoryInsightCopyWith<$Res> {
  __$CategoryInsightCopyWithImpl(this._self, this._then);

  final _CategoryInsight _self;
  final $Res Function(_CategoryInsight) _then;

/// Create a copy of CategoryInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? amount = null,Object? percentage = null,Object? rank = null,Object? topExpenseDescriptions = null,Object? previousAmount = freezed,Object? changePercentage = freezed,}) {
  return _then(_CategoryInsight(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,topExpenseDescriptions: null == topExpenseDescriptions ? _self._topExpenseDescriptions : topExpenseDescriptions // ignore: cast_nullable_to_non_nullable
as List<String>,previousAmount: freezed == previousAmount ? _self.previousAmount : previousAmount // ignore: cast_nullable_to_non_nullable
as double?,changePercentage: freezed == changePercentage ? _self.changePercentage : changePercentage // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
