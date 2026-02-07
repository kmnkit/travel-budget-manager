import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_insight.freezed.dart';

/// Represents insight data for a single expense category
///
/// Contains spending amount, percentage of total, rank among categories,
/// top expense descriptions, and optional comparison with previous period.
@freezed
abstract class CategoryInsight with _$CategoryInsight {
  const factory CategoryInsight({
    /// Category name (e.g., '식비', '교통비')
    required String category,

    /// Total spending amount in this category
    required double amount,

    /// Percentage of total spending this category represents
    required double percentage,

    /// Rank among all categories (1 = highest spending)
    required int rank,

    /// Descriptions of top expenses in this category
    required List<String> topExpenseDescriptions,

    /// Previous period's amount for comparison (null if no comparison)
    double? previousAmount,

    /// Percentage change from previous period (null if no comparison)
    double? changePercentage,
  }) = _CategoryInsight;
}
