// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_forecast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConfidenceInterval {

 double get bestCase; double get worstCase; double get confidenceLevel;
/// Create a copy of ConfidenceInterval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfidenceIntervalCopyWith<ConfidenceInterval> get copyWith => _$ConfidenceIntervalCopyWithImpl<ConfidenceInterval>(this as ConfidenceInterval, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfidenceInterval&&(identical(other.bestCase, bestCase) || other.bestCase == bestCase)&&(identical(other.worstCase, worstCase) || other.worstCase == worstCase)&&(identical(other.confidenceLevel, confidenceLevel) || other.confidenceLevel == confidenceLevel));
}


@override
int get hashCode => Object.hash(runtimeType,bestCase,worstCase,confidenceLevel);

@override
String toString() {
  return 'ConfidenceInterval(bestCase: $bestCase, worstCase: $worstCase, confidenceLevel: $confidenceLevel)';
}


}

/// @nodoc
abstract mixin class $ConfidenceIntervalCopyWith<$Res>  {
  factory $ConfidenceIntervalCopyWith(ConfidenceInterval value, $Res Function(ConfidenceInterval) _then) = _$ConfidenceIntervalCopyWithImpl;
@useResult
$Res call({
 double bestCase, double worstCase, double confidenceLevel
});




}
/// @nodoc
class _$ConfidenceIntervalCopyWithImpl<$Res>
    implements $ConfidenceIntervalCopyWith<$Res> {
  _$ConfidenceIntervalCopyWithImpl(this._self, this._then);

  final ConfidenceInterval _self;
  final $Res Function(ConfidenceInterval) _then;

/// Create a copy of ConfidenceInterval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bestCase = null,Object? worstCase = null,Object? confidenceLevel = null,}) {
  return _then(_self.copyWith(
bestCase: null == bestCase ? _self.bestCase : bestCase // ignore: cast_nullable_to_non_nullable
as double,worstCase: null == worstCase ? _self.worstCase : worstCase // ignore: cast_nullable_to_non_nullable
as double,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfidenceInterval].
extension ConfidenceIntervalPatterns on ConfidenceInterval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfidenceInterval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfidenceInterval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfidenceInterval value)  $default,){
final _that = this;
switch (_that) {
case _ConfidenceInterval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfidenceInterval value)?  $default,){
final _that = this;
switch (_that) {
case _ConfidenceInterval() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double bestCase,  double worstCase,  double confidenceLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfidenceInterval() when $default != null:
return $default(_that.bestCase,_that.worstCase,_that.confidenceLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double bestCase,  double worstCase,  double confidenceLevel)  $default,) {final _that = this;
switch (_that) {
case _ConfidenceInterval():
return $default(_that.bestCase,_that.worstCase,_that.confidenceLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double bestCase,  double worstCase,  double confidenceLevel)?  $default,) {final _that = this;
switch (_that) {
case _ConfidenceInterval() when $default != null:
return $default(_that.bestCase,_that.worstCase,_that.confidenceLevel);case _:
  return null;

}
}

}

/// @nodoc


class _ConfidenceInterval implements ConfidenceInterval {
  const _ConfidenceInterval({required this.bestCase, required this.worstCase, required this.confidenceLevel});
  

@override final  double bestCase;
@override final  double worstCase;
@override final  double confidenceLevel;

/// Create a copy of ConfidenceInterval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfidenceIntervalCopyWith<_ConfidenceInterval> get copyWith => __$ConfidenceIntervalCopyWithImpl<_ConfidenceInterval>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfidenceInterval&&(identical(other.bestCase, bestCase) || other.bestCase == bestCase)&&(identical(other.worstCase, worstCase) || other.worstCase == worstCase)&&(identical(other.confidenceLevel, confidenceLevel) || other.confidenceLevel == confidenceLevel));
}


@override
int get hashCode => Object.hash(runtimeType,bestCase,worstCase,confidenceLevel);

@override
String toString() {
  return 'ConfidenceInterval(bestCase: $bestCase, worstCase: $worstCase, confidenceLevel: $confidenceLevel)';
}


}

/// @nodoc
abstract mixin class _$ConfidenceIntervalCopyWith<$Res> implements $ConfidenceIntervalCopyWith<$Res> {
  factory _$ConfidenceIntervalCopyWith(_ConfidenceInterval value, $Res Function(_ConfidenceInterval) _then) = __$ConfidenceIntervalCopyWithImpl;
@override @useResult
$Res call({
 double bestCase, double worstCase, double confidenceLevel
});




}
/// @nodoc
class __$ConfidenceIntervalCopyWithImpl<$Res>
    implements _$ConfidenceIntervalCopyWith<$Res> {
  __$ConfidenceIntervalCopyWithImpl(this._self, this._then);

  final _ConfidenceInterval _self;
  final $Res Function(_ConfidenceInterval) _then;

/// Create a copy of ConfidenceInterval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bestCase = null,Object? worstCase = null,Object? confidenceLevel = null,}) {
  return _then(_ConfidenceInterval(
bestCase: null == bestCase ? _self.bestCase : bestCase // ignore: cast_nullable_to_non_nullable
as double,worstCase: null == worstCase ? _self.worstCase : worstCase // ignore: cast_nullable_to_non_nullable
as double,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$BudgetForecast {

 int get tripId; double get totalBudget; double get totalSpent; double get dailySpendingRate; double get projectedTotalSpend; int get daysElapsed; int get daysRemaining; int? get daysUntilExhaustion; ForecastStatus get status; List<DataPoint> get historicalSpending; List<DataPoint> get projectedSpending; List<DataPoint> get budgetLine; ConfidenceInterval get confidenceInterval;
/// Create a copy of BudgetForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetForecastCopyWith<BudgetForecast> get copyWith => _$BudgetForecastCopyWithImpl<BudgetForecast>(this as BudgetForecast, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetForecast&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.totalBudget, totalBudget) || other.totalBudget == totalBudget)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.dailySpendingRate, dailySpendingRate) || other.dailySpendingRate == dailySpendingRate)&&(identical(other.projectedTotalSpend, projectedTotalSpend) || other.projectedTotalSpend == projectedTotalSpend)&&(identical(other.daysElapsed, daysElapsed) || other.daysElapsed == daysElapsed)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.daysUntilExhaustion, daysUntilExhaustion) || other.daysUntilExhaustion == daysUntilExhaustion)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.historicalSpending, historicalSpending)&&const DeepCollectionEquality().equals(other.projectedSpending, projectedSpending)&&const DeepCollectionEquality().equals(other.budgetLine, budgetLine)&&(identical(other.confidenceInterval, confidenceInterval) || other.confidenceInterval == confidenceInterval));
}


@override
int get hashCode => Object.hash(runtimeType,tripId,totalBudget,totalSpent,dailySpendingRate,projectedTotalSpend,daysElapsed,daysRemaining,daysUntilExhaustion,status,const DeepCollectionEquality().hash(historicalSpending),const DeepCollectionEquality().hash(projectedSpending),const DeepCollectionEquality().hash(budgetLine),confidenceInterval);

@override
String toString() {
  return 'BudgetForecast(tripId: $tripId, totalBudget: $totalBudget, totalSpent: $totalSpent, dailySpendingRate: $dailySpendingRate, projectedTotalSpend: $projectedTotalSpend, daysElapsed: $daysElapsed, daysRemaining: $daysRemaining, daysUntilExhaustion: $daysUntilExhaustion, status: $status, historicalSpending: $historicalSpending, projectedSpending: $projectedSpending, budgetLine: $budgetLine, confidenceInterval: $confidenceInterval)';
}


}

/// @nodoc
abstract mixin class $BudgetForecastCopyWith<$Res>  {
  factory $BudgetForecastCopyWith(BudgetForecast value, $Res Function(BudgetForecast) _then) = _$BudgetForecastCopyWithImpl;
@useResult
$Res call({
 int tripId, double totalBudget, double totalSpent, double dailySpendingRate, double projectedTotalSpend, int daysElapsed, int daysRemaining, int? daysUntilExhaustion, ForecastStatus status, List<DataPoint> historicalSpending, List<DataPoint> projectedSpending, List<DataPoint> budgetLine, ConfidenceInterval confidenceInterval
});


$ConfidenceIntervalCopyWith<$Res> get confidenceInterval;

}
/// @nodoc
class _$BudgetForecastCopyWithImpl<$Res>
    implements $BudgetForecastCopyWith<$Res> {
  _$BudgetForecastCopyWithImpl(this._self, this._then);

  final BudgetForecast _self;
  final $Res Function(BudgetForecast) _then;

/// Create a copy of BudgetForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tripId = null,Object? totalBudget = null,Object? totalSpent = null,Object? dailySpendingRate = null,Object? projectedTotalSpend = null,Object? daysElapsed = null,Object? daysRemaining = null,Object? daysUntilExhaustion = freezed,Object? status = null,Object? historicalSpending = null,Object? projectedSpending = null,Object? budgetLine = null,Object? confidenceInterval = null,}) {
  return _then(_self.copyWith(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,totalBudget: null == totalBudget ? _self.totalBudget : totalBudget // ignore: cast_nullable_to_non_nullable
as double,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,dailySpendingRate: null == dailySpendingRate ? _self.dailySpendingRate : dailySpendingRate // ignore: cast_nullable_to_non_nullable
as double,projectedTotalSpend: null == projectedTotalSpend ? _self.projectedTotalSpend : projectedTotalSpend // ignore: cast_nullable_to_non_nullable
as double,daysElapsed: null == daysElapsed ? _self.daysElapsed : daysElapsed // ignore: cast_nullable_to_non_nullable
as int,daysRemaining: null == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int,daysUntilExhaustion: freezed == daysUntilExhaustion ? _self.daysUntilExhaustion : daysUntilExhaustion // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ForecastStatus,historicalSpending: null == historicalSpending ? _self.historicalSpending : historicalSpending // ignore: cast_nullable_to_non_nullable
as List<DataPoint>,projectedSpending: null == projectedSpending ? _self.projectedSpending : projectedSpending // ignore: cast_nullable_to_non_nullable
as List<DataPoint>,budgetLine: null == budgetLine ? _self.budgetLine : budgetLine // ignore: cast_nullable_to_non_nullable
as List<DataPoint>,confidenceInterval: null == confidenceInterval ? _self.confidenceInterval : confidenceInterval // ignore: cast_nullable_to_non_nullable
as ConfidenceInterval,
  ));
}
/// Create a copy of BudgetForecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConfidenceIntervalCopyWith<$Res> get confidenceInterval {
  
  return $ConfidenceIntervalCopyWith<$Res>(_self.confidenceInterval, (value) {
    return _then(_self.copyWith(confidenceInterval: value));
  });
}
}


/// Adds pattern-matching-related methods to [BudgetForecast].
extension BudgetForecastPatterns on BudgetForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetForecast value)  $default,){
final _that = this;
switch (_that) {
case _BudgetForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetForecast value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tripId,  double totalBudget,  double totalSpent,  double dailySpendingRate,  double projectedTotalSpend,  int daysElapsed,  int daysRemaining,  int? daysUntilExhaustion,  ForecastStatus status,  List<DataPoint> historicalSpending,  List<DataPoint> projectedSpending,  List<DataPoint> budgetLine,  ConfidenceInterval confidenceInterval)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetForecast() when $default != null:
return $default(_that.tripId,_that.totalBudget,_that.totalSpent,_that.dailySpendingRate,_that.projectedTotalSpend,_that.daysElapsed,_that.daysRemaining,_that.daysUntilExhaustion,_that.status,_that.historicalSpending,_that.projectedSpending,_that.budgetLine,_that.confidenceInterval);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tripId,  double totalBudget,  double totalSpent,  double dailySpendingRate,  double projectedTotalSpend,  int daysElapsed,  int daysRemaining,  int? daysUntilExhaustion,  ForecastStatus status,  List<DataPoint> historicalSpending,  List<DataPoint> projectedSpending,  List<DataPoint> budgetLine,  ConfidenceInterval confidenceInterval)  $default,) {final _that = this;
switch (_that) {
case _BudgetForecast():
return $default(_that.tripId,_that.totalBudget,_that.totalSpent,_that.dailySpendingRate,_that.projectedTotalSpend,_that.daysElapsed,_that.daysRemaining,_that.daysUntilExhaustion,_that.status,_that.historicalSpending,_that.projectedSpending,_that.budgetLine,_that.confidenceInterval);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tripId,  double totalBudget,  double totalSpent,  double dailySpendingRate,  double projectedTotalSpend,  int daysElapsed,  int daysRemaining,  int? daysUntilExhaustion,  ForecastStatus status,  List<DataPoint> historicalSpending,  List<DataPoint> projectedSpending,  List<DataPoint> budgetLine,  ConfidenceInterval confidenceInterval)?  $default,) {final _that = this;
switch (_that) {
case _BudgetForecast() when $default != null:
return $default(_that.tripId,_that.totalBudget,_that.totalSpent,_that.dailySpendingRate,_that.projectedTotalSpend,_that.daysElapsed,_that.daysRemaining,_that.daysUntilExhaustion,_that.status,_that.historicalSpending,_that.projectedSpending,_that.budgetLine,_that.confidenceInterval);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetForecast implements BudgetForecast {
  const _BudgetForecast({required this.tripId, required this.totalBudget, required this.totalSpent, required this.dailySpendingRate, required this.projectedTotalSpend, required this.daysElapsed, required this.daysRemaining, required this.daysUntilExhaustion, required this.status, required final  List<DataPoint> historicalSpending, required final  List<DataPoint> projectedSpending, required final  List<DataPoint> budgetLine, required this.confidenceInterval}): _historicalSpending = historicalSpending,_projectedSpending = projectedSpending,_budgetLine = budgetLine;
  

@override final  int tripId;
@override final  double totalBudget;
@override final  double totalSpent;
@override final  double dailySpendingRate;
@override final  double projectedTotalSpend;
@override final  int daysElapsed;
@override final  int daysRemaining;
@override final  int? daysUntilExhaustion;
@override final  ForecastStatus status;
 final  List<DataPoint> _historicalSpending;
@override List<DataPoint> get historicalSpending {
  if (_historicalSpending is EqualUnmodifiableListView) return _historicalSpending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_historicalSpending);
}

 final  List<DataPoint> _projectedSpending;
@override List<DataPoint> get projectedSpending {
  if (_projectedSpending is EqualUnmodifiableListView) return _projectedSpending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projectedSpending);
}

 final  List<DataPoint> _budgetLine;
@override List<DataPoint> get budgetLine {
  if (_budgetLine is EqualUnmodifiableListView) return _budgetLine;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgetLine);
}

@override final  ConfidenceInterval confidenceInterval;

/// Create a copy of BudgetForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetForecastCopyWith<_BudgetForecast> get copyWith => __$BudgetForecastCopyWithImpl<_BudgetForecast>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetForecast&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.totalBudget, totalBudget) || other.totalBudget == totalBudget)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.dailySpendingRate, dailySpendingRate) || other.dailySpendingRate == dailySpendingRate)&&(identical(other.projectedTotalSpend, projectedTotalSpend) || other.projectedTotalSpend == projectedTotalSpend)&&(identical(other.daysElapsed, daysElapsed) || other.daysElapsed == daysElapsed)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.daysUntilExhaustion, daysUntilExhaustion) || other.daysUntilExhaustion == daysUntilExhaustion)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._historicalSpending, _historicalSpending)&&const DeepCollectionEquality().equals(other._projectedSpending, _projectedSpending)&&const DeepCollectionEquality().equals(other._budgetLine, _budgetLine)&&(identical(other.confidenceInterval, confidenceInterval) || other.confidenceInterval == confidenceInterval));
}


@override
int get hashCode => Object.hash(runtimeType,tripId,totalBudget,totalSpent,dailySpendingRate,projectedTotalSpend,daysElapsed,daysRemaining,daysUntilExhaustion,status,const DeepCollectionEquality().hash(_historicalSpending),const DeepCollectionEquality().hash(_projectedSpending),const DeepCollectionEquality().hash(_budgetLine),confidenceInterval);

@override
String toString() {
  return 'BudgetForecast(tripId: $tripId, totalBudget: $totalBudget, totalSpent: $totalSpent, dailySpendingRate: $dailySpendingRate, projectedTotalSpend: $projectedTotalSpend, daysElapsed: $daysElapsed, daysRemaining: $daysRemaining, daysUntilExhaustion: $daysUntilExhaustion, status: $status, historicalSpending: $historicalSpending, projectedSpending: $projectedSpending, budgetLine: $budgetLine, confidenceInterval: $confidenceInterval)';
}


}

/// @nodoc
abstract mixin class _$BudgetForecastCopyWith<$Res> implements $BudgetForecastCopyWith<$Res> {
  factory _$BudgetForecastCopyWith(_BudgetForecast value, $Res Function(_BudgetForecast) _then) = __$BudgetForecastCopyWithImpl;
@override @useResult
$Res call({
 int tripId, double totalBudget, double totalSpent, double dailySpendingRate, double projectedTotalSpend, int daysElapsed, int daysRemaining, int? daysUntilExhaustion, ForecastStatus status, List<DataPoint> historicalSpending, List<DataPoint> projectedSpending, List<DataPoint> budgetLine, ConfidenceInterval confidenceInterval
});


@override $ConfidenceIntervalCopyWith<$Res> get confidenceInterval;

}
/// @nodoc
class __$BudgetForecastCopyWithImpl<$Res>
    implements _$BudgetForecastCopyWith<$Res> {
  __$BudgetForecastCopyWithImpl(this._self, this._then);

  final _BudgetForecast _self;
  final $Res Function(_BudgetForecast) _then;

/// Create a copy of BudgetForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tripId = null,Object? totalBudget = null,Object? totalSpent = null,Object? dailySpendingRate = null,Object? projectedTotalSpend = null,Object? daysElapsed = null,Object? daysRemaining = null,Object? daysUntilExhaustion = freezed,Object? status = null,Object? historicalSpending = null,Object? projectedSpending = null,Object? budgetLine = null,Object? confidenceInterval = null,}) {
  return _then(_BudgetForecast(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int,totalBudget: null == totalBudget ? _self.totalBudget : totalBudget // ignore: cast_nullable_to_non_nullable
as double,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as double,dailySpendingRate: null == dailySpendingRate ? _self.dailySpendingRate : dailySpendingRate // ignore: cast_nullable_to_non_nullable
as double,projectedTotalSpend: null == projectedTotalSpend ? _self.projectedTotalSpend : projectedTotalSpend // ignore: cast_nullable_to_non_nullable
as double,daysElapsed: null == daysElapsed ? _self.daysElapsed : daysElapsed // ignore: cast_nullable_to_non_nullable
as int,daysRemaining: null == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int,daysUntilExhaustion: freezed == daysUntilExhaustion ? _self.daysUntilExhaustion : daysUntilExhaustion // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ForecastStatus,historicalSpending: null == historicalSpending ? _self._historicalSpending : historicalSpending // ignore: cast_nullable_to_non_nullable
as List<DataPoint>,projectedSpending: null == projectedSpending ? _self._projectedSpending : projectedSpending // ignore: cast_nullable_to_non_nullable
as List<DataPoint>,budgetLine: null == budgetLine ? _self._budgetLine : budgetLine // ignore: cast_nullable_to_non_nullable
as List<DataPoint>,confidenceInterval: null == confidenceInterval ? _self.confidenceInterval : confidenceInterval // ignore: cast_nullable_to_non_nullable
as ConfidenceInterval,
  ));
}

/// Create a copy of BudgetForecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConfidenceIntervalCopyWith<$Res> get confidenceInterval {
  
  return $ConfidenceIntervalCopyWith<$Res>(_self.confidenceInterval, (value) {
    return _then(_self.copyWith(confidenceInterval: value));
  });
}
}

// dart format on
