import 'package:freezed_annotation/freezed_annotation.dart';

part 'trend_data.freezed.dart';

/// Represents a single data point with date and value
@freezed
abstract class DataPoint with _$DataPoint {
  const factory DataPoint({
    required DateTime date,
    required double value,
  }) = _DataPoint;
}

/// Direction of a trend
enum TrendDirection {
  up,    // Increasing trend
  down,  // Decreasing trend
  stable, // Stable/flat trend
}

/// Trend analysis data with historical and optional projected values
@freezed
abstract class TrendData with _$TrendData {
  const factory TrendData({
    required List<DataPoint> historicalData,
    required List<DataPoint>? projectedData,
    required TrendDirection direction,
    required double changePercentage,
    required double confidence,
  }) = _TrendData;
}
