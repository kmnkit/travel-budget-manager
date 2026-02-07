import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_insight.freezed.dart';

/// Type of analytics insight
enum InsightType {
  spending,       // Spending pattern insight
  budget,         // Budget-related insight
  trend,          // Trend analysis
  anomaly,        // Unusual activity
  recommendation, // Actionable recommendation
}

/// Priority level of an insight
enum InsightPriority {
  high,   // Requires immediate attention
  medium, // Notable information
  low,    // General informational
}

/// Represents an analytics insight generated from spending data
@freezed
abstract class AnalyticsInsight with _$AnalyticsInsight {
  const factory AnalyticsInsight({
    required String id,
    required InsightType type,
    required String title,
    required String description,
    required InsightPriority priority,
    required DateTime generatedAt,
    Map<String, dynamic>? metadata,
  }) = _AnalyticsInsight;
}
