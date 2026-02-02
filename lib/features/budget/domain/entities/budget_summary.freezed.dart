// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetSummary {

 int get tripId; double get totalBudget; double get totalSpent; double get remaining; double get percentUsed; BudgetStatus get status; Map<ExpenseCategory, double> get categoryBreakdown; double get dailyAverage; int get daysRemaining; double get dailyBudgetRemaining;
/// Create a copy of BudgetSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetSummaryCopyWith<BudgetSummary> get copyWith => _$BudgetSummaryCopyWithImpl<BudgetSummary>(this as BudgetSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetSummary&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.totalBudget, totalBudget) || other.totalBudget == totalBudget)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.percentUsed, percentUsed) || other.percentUsed == percentUsed)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.categoryBreakdown, categoryBreakdown)&&(identical(other.dailyAverage, dailyAverage) || other.dailyAverage == dailyAverage)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.dailyBudgetRemaining, dailyBudgetRemaining) || other.dailyBudgetRemaining == dailyBudgetRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,tripId,totalBudget,totalSpent,remaining,percentUsed,status,const DeepCollectionEquality().hash(categoryBreakdown),dailyAverage,daysRemaining,dailyBudgetRemaining);

@override
String toString() {
  return 'BudgetSummary(tripId: $tripId, totalBudget: $totalBudget, totalSpent: $totalSpent, remaining: $remaining, percentUsed: $percentUsed, status: $status, categoryBreakdown: $categoryBreakdown, dailyAverage: $dailyAverage, daysRemaining: $daysRemaining, dailyBudgetRemaining: $dailyBudgetRemaining)';
}


}

/// @nodoc
abstract mixin class $BudgetSummaryCopyWith<$Res>  {
  factory $BudgetSummaryCopyWith(BudgetSummary value, $Res Function(BudgetSummary) _then) = _$BudgetSummaryCopyWithImpl;
@useResult
$Res call({
 int tripId, double totalBudget, double totalSpent, double remaining, double percentUsed, BudgetStatus status, Map<ExpenseCategory, double> categoryBreakdown, double dailyAverage, int daysRemaining, double dailyBudgetRemaining
});




}
/// @nodoc
class _$BudgetSummaryCopyWithImpl<$Res>
    implements $BudgetSummaryCopyWith<$Res> {
  _$BudgetSummaryCopyWithImpl(this._self, this._then);

  final BudgetSummary _self;
  final $Res Function(BudgetSummary) _then;

/// Create a copy of BudgetSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tripId = null,Object? totalBudget = null,Object? totalSpent = null,Object? remaining = null,Object? percentUsed = null,Object? status = null,Object? categoryBreakdown = null,Object? dailyAverage = null,Object? daysRemaining = null,Object? dailyBudgetRemaining = null,}) {
  return _then(_self.copyWith(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,totalBudget: null == totalBudget ? _self.totalBudget : totalBudget // ignore: cast_nullable_to_non_nullable
as double,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,percentUsed: null == percentUsed ? _self.percentUsed : percentUsed // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetStatus,categoryBreakdown: null == categoryBreakdown ? _self.categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as Map<ExpenseCategory, double>,dailyAverage: null == dailyAverage ? _self.dailyAverage : dailyAverage // ignore: cast_nullable_to_non_nullable
as double,daysRemaining: null == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int,dailyBudgetRemaining: null == dailyBudgetRemaining ? _self.dailyBudgetRemaining : dailyBudgetRemaining // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetSummary].
extension BudgetSummaryPatterns on BudgetSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetSummary value)  $default,){
final _that = this;
switch (_that) {
case _BudgetSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tripId,  double totalBudget,  double totalSpent,  double remaining,  double percentUsed,  BudgetStatus status,  Map<ExpenseCategory, double> categoryBreakdown,  double dailyAverage,  int daysRemaining,  double dailyBudgetRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetSummary() when $default != null:
return $default(_that.tripId,_that.totalBudget,_that.totalSpent,_that.remaining,_that.percentUsed,_that.status,_that.categoryBreakdown,_that.dailyAverage,_that.daysRemaining,_that.dailyBudgetRemaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tripId,  double totalBudget,  double totalSpent,  double remaining,  double percentUsed,  BudgetStatus status,  Map<ExpenseCategory, double> categoryBreakdown,  double dailyAverage,  int daysRemaining,  double dailyBudgetRemaining)  $default,) {final _that = this;
switch (_that) {
case _BudgetSummary():
return $default(_that.tripId,_that.totalBudget,_that.totalSpent,_that.remaining,_that.percentUsed,_that.status,_that.categoryBreakdown,_that.dailyAverage,_that.daysRemaining,_that.dailyBudgetRemaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tripId,  double totalBudget,  double totalSpent,  double remaining,  double percentUsed,  BudgetStatus status,  Map<ExpenseCategory, double> categoryBreakdown,  double dailyAverage,  int daysRemaining,  double dailyBudgetRemaining)?  $default,) {final _that = this;
switch (_that) {
case _BudgetSummary() when $default != null:
return $default(_that.tripId,_that.totalBudget,_that.totalSpent,_that.remaining,_that.percentUsed,_that.status,_that.categoryBreakdown,_that.dailyAverage,_that.daysRemaining,_that.dailyBudgetRemaining);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetSummary implements BudgetSummary {
  const _BudgetSummary({required this.tripId, required this.totalBudget, required this.totalSpent, required this.remaining, required this.percentUsed, required this.status, required final  Map<ExpenseCategory, double> categoryBreakdown, required this.dailyAverage, required this.daysRemaining, required this.dailyBudgetRemaining}): _categoryBreakdown = categoryBreakdown;
  

@override final  int tripId;
@override final  double totalBudget;
@override final  double totalSpent;
@override final  double remaining;
@override final  double percentUsed;
@override final  BudgetStatus status;
 final  Map<ExpenseCategory, double> _categoryBreakdown;
@override Map<ExpenseCategory, double> get categoryBreakdown {
  if (_categoryBreakdown is EqualUnmodifiableMapView) return _categoryBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoryBreakdown);
}

@override final  double dailyAverage;
@override final  int daysRemaining;
@override final  double dailyBudgetRemaining;

/// Create a copy of BudgetSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetSummaryCopyWith<_BudgetSummary> get copyWith => __$BudgetSummaryCopyWithImpl<_BudgetSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetSummary&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.totalBudget, totalBudget) || other.totalBudget == totalBudget)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.percentUsed, percentUsed) || other.percentUsed == percentUsed)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._categoryBreakdown, _categoryBreakdown)&&(identical(other.dailyAverage, dailyAverage) || other.dailyAverage == dailyAverage)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.dailyBudgetRemaining, dailyBudgetRemaining) || other.dailyBudgetRemaining == dailyBudgetRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,tripId,totalBudget,totalSpent,remaining,percentUsed,status,const DeepCollectionEquality().hash(_categoryBreakdown),dailyAverage,daysRemaining,dailyBudgetRemaining);

@override
String toString() {
  return 'BudgetSummary(tripId: $tripId, totalBudget: $totalBudget, totalSpent: $totalSpent, remaining: $remaining, percentUsed: $percentUsed, status: $status, categoryBreakdown: $categoryBreakdown, dailyAverage: $dailyAverage, daysRemaining: $daysRemaining, dailyBudgetRemaining: $dailyBudgetRemaining)';
}


}

/// @nodoc
abstract mixin class _$BudgetSummaryCopyWith<$Res> implements $BudgetSummaryCopyWith<$Res> {
  factory _$BudgetSummaryCopyWith(_BudgetSummary value, $Res Function(_BudgetSummary) _then) = __$BudgetSummaryCopyWithImpl;
@override @useResult
$Res call({
 int tripId, double totalBudget, double totalSpent, double remaining, double percentUsed, BudgetStatus status, Map<ExpenseCategory, double> categoryBreakdown, double dailyAverage, int daysRemaining, double dailyBudgetRemaining
});




}
/// @nodoc
class __$BudgetSummaryCopyWithImpl<$Res>
    implements _$BudgetSummaryCopyWith<$Res> {
  __$BudgetSummaryCopyWithImpl(this._self, this._then);

  final _BudgetSummary _self;
  final $Res Function(_BudgetSummary) _then;

/// Create a copy of BudgetSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tripId = null,Object? totalBudget = null,Object? totalSpent = null,Object? remaining = null,Object? percentUsed = null,Object? status = null,Object? categoryBreakdown = null,Object? dailyAverage = null,Object? daysRemaining = null,Object? dailyBudgetRemaining = null,}) {
  return _then(_BudgetSummary(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,totalBudget: null == totalBudget ? _self.totalBudget : totalBudget // ignore: cast_nullable_to_non_nullable
as double,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,percentUsed: null == percentUsed ? _self.percentUsed : percentUsed // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetStatus,categoryBreakdown: null == categoryBreakdown ? _self._categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as Map<ExpenseCategory, double>,dailyAverage: null == dailyAverage ? _self.dailyAverage : dailyAverage // ignore: cast_nullable_to_non_nullable
as double,daysRemaining: null == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int,dailyBudgetRemaining: null == dailyBudgetRemaining ? _self.dailyBudgetRemaining : dailyBudgetRemaining // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
