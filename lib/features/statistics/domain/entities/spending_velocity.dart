import 'package:freezed_annotation/freezed_annotation.dart';

part 'spending_velocity.freezed.dart';

/// Represents spending velocity metrics over a time period
///
/// Tracks the rate of spending (daily/weekly averages) and acceleration
/// (how the spending rate is changing over time).
@freezed
abstract class SpendingVelocity with _$SpendingVelocity {
  const factory SpendingVelocity({
    /// Average daily spending amount
    required double dailyAverage,

    /// Average weekly spending amount (typically dailyAverage * 7)
    required double weeklyAverage,

    /// Rate of change in spending velocity
    /// - Positive: spending is increasing over time
    /// - Negative: spending is decreasing over time
    /// - Zero: spending rate is stable
    required double acceleration,

    /// Start date of the analysis period
    required DateTime periodStart,

    /// End date of the analysis period
    required DateTime periodEnd,
  }) = _SpendingVelocity;
}
