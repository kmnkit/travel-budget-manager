// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportReport {

 Trip get trip; List<Expense> get expenses; StatisticsData get statistics; BudgetSummary get budgetSummary; List<AnalyticsInsight> get insights; BudgetForecast? get forecast;
/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportReportCopyWith<ExportReport> get copyWith => _$ExportReportCopyWithImpl<ExportReport>(this as ExportReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportReport&&(identical(other.trip, trip) || other.trip == trip)&&const DeepCollectionEquality().equals(other.expenses, expenses)&&(identical(other.statistics, statistics) || other.statistics == statistics)&&(identical(other.budgetSummary, budgetSummary) || other.budgetSummary == budgetSummary)&&const DeepCollectionEquality().equals(other.insights, insights)&&(identical(other.forecast, forecast) || other.forecast == forecast));
}


@override
int get hashCode => Object.hash(runtimeType,trip,const DeepCollectionEquality().hash(expenses),statistics,budgetSummary,const DeepCollectionEquality().hash(insights),forecast);

@override
String toString() {
  return 'ExportReport(trip: $trip, expenses: $expenses, statistics: $statistics, budgetSummary: $budgetSummary, insights: $insights, forecast: $forecast)';
}


}

/// @nodoc
abstract mixin class $ExportReportCopyWith<$Res>  {
  factory $ExportReportCopyWith(ExportReport value, $Res Function(ExportReport) _then) = _$ExportReportCopyWithImpl;
@useResult
$Res call({
 Trip trip, List<Expense> expenses, StatisticsData statistics, BudgetSummary budgetSummary, List<AnalyticsInsight> insights, BudgetForecast? forecast
});


$TripCopyWith<$Res> get trip;$BudgetSummaryCopyWith<$Res> get budgetSummary;$BudgetForecastCopyWith<$Res>? get forecast;

}
/// @nodoc
class _$ExportReportCopyWithImpl<$Res>
    implements $ExportReportCopyWith<$Res> {
  _$ExportReportCopyWithImpl(this._self, this._then);

  final ExportReport _self;
  final $Res Function(ExportReport) _then;

/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trip = null,Object? expenses = null,Object? statistics = null,Object? budgetSummary = null,Object? insights = null,Object? forecast = freezed,}) {
  return _then(_self.copyWith(
trip: null == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as Trip,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,statistics: null == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as StatisticsData,budgetSummary: null == budgetSummary ? _self.budgetSummary : budgetSummary // ignore: cast_nullable_to_non_nullable
as BudgetSummary,insights: null == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as List<AnalyticsInsight>,forecast: freezed == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as BudgetForecast?,
  ));
}
/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TripCopyWith<$Res> get trip {
  
  return $TripCopyWith<$Res>(_self.trip, (value) {
    return _then(_self.copyWith(trip: value));
  });
}/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetSummaryCopyWith<$Res> get budgetSummary {
  
  return $BudgetSummaryCopyWith<$Res>(_self.budgetSummary, (value) {
    return _then(_self.copyWith(budgetSummary: value));
  });
}/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetForecastCopyWith<$Res>? get forecast {
    if (_self.forecast == null) {
    return null;
  }

  return $BudgetForecastCopyWith<$Res>(_self.forecast!, (value) {
    return _then(_self.copyWith(forecast: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExportReport].
extension ExportReportPatterns on ExportReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportReport value)  $default,){
final _that = this;
switch (_that) {
case _ExportReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportReport value)?  $default,){
final _that = this;
switch (_that) {
case _ExportReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Trip trip,  List<Expense> expenses,  StatisticsData statistics,  BudgetSummary budgetSummary,  List<AnalyticsInsight> insights,  BudgetForecast? forecast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportReport() when $default != null:
return $default(_that.trip,_that.expenses,_that.statistics,_that.budgetSummary,_that.insights,_that.forecast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Trip trip,  List<Expense> expenses,  StatisticsData statistics,  BudgetSummary budgetSummary,  List<AnalyticsInsight> insights,  BudgetForecast? forecast)  $default,) {final _that = this;
switch (_that) {
case _ExportReport():
return $default(_that.trip,_that.expenses,_that.statistics,_that.budgetSummary,_that.insights,_that.forecast);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Trip trip,  List<Expense> expenses,  StatisticsData statistics,  BudgetSummary budgetSummary,  List<AnalyticsInsight> insights,  BudgetForecast? forecast)?  $default,) {final _that = this;
switch (_that) {
case _ExportReport() when $default != null:
return $default(_that.trip,_that.expenses,_that.statistics,_that.budgetSummary,_that.insights,_that.forecast);case _:
  return null;

}
}

}

/// @nodoc


class _ExportReport implements ExportReport {
  const _ExportReport({required this.trip, required final  List<Expense> expenses, required this.statistics, required this.budgetSummary, required final  List<AnalyticsInsight> insights, required this.forecast}): _expenses = expenses,_insights = insights;
  

@override final  Trip trip;
 final  List<Expense> _expenses;
@override List<Expense> get expenses {
  if (_expenses is EqualUnmodifiableListView) return _expenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenses);
}

@override final  StatisticsData statistics;
@override final  BudgetSummary budgetSummary;
 final  List<AnalyticsInsight> _insights;
@override List<AnalyticsInsight> get insights {
  if (_insights is EqualUnmodifiableListView) return _insights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_insights);
}

@override final  BudgetForecast? forecast;

/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportReportCopyWith<_ExportReport> get copyWith => __$ExportReportCopyWithImpl<_ExportReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportReport&&(identical(other.trip, trip) || other.trip == trip)&&const DeepCollectionEquality().equals(other._expenses, _expenses)&&(identical(other.statistics, statistics) || other.statistics == statistics)&&(identical(other.budgetSummary, budgetSummary) || other.budgetSummary == budgetSummary)&&const DeepCollectionEquality().equals(other._insights, _insights)&&(identical(other.forecast, forecast) || other.forecast == forecast));
}


@override
int get hashCode => Object.hash(runtimeType,trip,const DeepCollectionEquality().hash(_expenses),statistics,budgetSummary,const DeepCollectionEquality().hash(_insights),forecast);

@override
String toString() {
  return 'ExportReport(trip: $trip, expenses: $expenses, statistics: $statistics, budgetSummary: $budgetSummary, insights: $insights, forecast: $forecast)';
}


}

/// @nodoc
abstract mixin class _$ExportReportCopyWith<$Res> implements $ExportReportCopyWith<$Res> {
  factory _$ExportReportCopyWith(_ExportReport value, $Res Function(_ExportReport) _then) = __$ExportReportCopyWithImpl;
@override @useResult
$Res call({
 Trip trip, List<Expense> expenses, StatisticsData statistics, BudgetSummary budgetSummary, List<AnalyticsInsight> insights, BudgetForecast? forecast
});


@override $TripCopyWith<$Res> get trip;@override $BudgetSummaryCopyWith<$Res> get budgetSummary;@override $BudgetForecastCopyWith<$Res>? get forecast;

}
/// @nodoc
class __$ExportReportCopyWithImpl<$Res>
    implements _$ExportReportCopyWith<$Res> {
  __$ExportReportCopyWithImpl(this._self, this._then);

  final _ExportReport _self;
  final $Res Function(_ExportReport) _then;

/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trip = null,Object? expenses = null,Object? statistics = null,Object? budgetSummary = null,Object? insights = null,Object? forecast = freezed,}) {
  return _then(_ExportReport(
trip: null == trip ? _self.trip : trip // ignore: cast_nullable_to_non_nullable
as Trip,expenses: null == expenses ? _self._expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,statistics: null == statistics ? _self.statistics : statistics // ignore: cast_nullable_to_non_nullable
as StatisticsData,budgetSummary: null == budgetSummary ? _self.budgetSummary : budgetSummary // ignore: cast_nullable_to_non_nullable
as BudgetSummary,insights: null == insights ? _self._insights : insights // ignore: cast_nullable_to_non_nullable
as List<AnalyticsInsight>,forecast: freezed == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as BudgetForecast?,
  ));
}

/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TripCopyWith<$Res> get trip {
  
  return $TripCopyWith<$Res>(_self.trip, (value) {
    return _then(_self.copyWith(trip: value));
  });
}/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetSummaryCopyWith<$Res> get budgetSummary {
  
  return $BudgetSummaryCopyWith<$Res>(_self.budgetSummary, (value) {
    return _then(_self.copyWith(budgetSummary: value));
  });
}/// Create a copy of ExportReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetForecastCopyWith<$Res>? get forecast {
    if (_self.forecast == null) {
    return null;
  }

  return $BudgetForecastCopyWith<$Res>(_self.forecast!, (value) {
    return _then(_self.copyWith(forecast: value));
  });
}
}

// dart format on
