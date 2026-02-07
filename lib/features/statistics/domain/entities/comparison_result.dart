import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trip_wallet/features/statistics/domain/entities/trend_data.dart';

part 'comparison_result.freezed.dart';

/// Represents the result of comparing two periods of spending data
///
/// Contains the current value, comparison value, difference,
/// percentage change, and trend direction.
@freezed
abstract class ComparisonResult with _$ComparisonResult {
  const factory ComparisonResult({
    /// Label describing this comparison (e.g., "이번 주 vs 지난 주")
    required String label,

    /// Current period's total value
    required double currentValue,

    /// Comparison period's total value
    required double comparisonValue,

    /// Absolute difference (currentValue - comparisonValue)
    required double difference,

    /// Percentage change from comparison to current
    required double percentageChange,

    /// Direction of the change
    required TrendDirection direction,
  }) = _ComparisonResult;
}
