import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense.dart';
import 'package:trip_wallet/features/statistics/domain/entities/analytics_insight.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';

part 'export_report.freezed.dart';

/// Export format options
enum ExportFormat {
  pdf,
  csv,
}

/// Export generation status
enum ExportStatus {
  idle,
  generating,
  completed,
  failed,
}

/// Complete report data for export
@freezed
abstract class ExportReport with _$ExportReport {
  const factory ExportReport({
    required Trip trip,
    required List<Expense> expenses,
    required StatisticsData statistics,
    required BudgetSummary budgetSummary,
    required List<AnalyticsInsight> insights,
    required BudgetForecast? forecast,
  }) = _ExportReport;
}
