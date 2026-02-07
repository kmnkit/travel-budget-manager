import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/domain/repositories/export_repository.dart';
import 'package:trip_wallet/features/export/domain/services/pdf_generator.dart';
import 'package:trip_wallet/features/statistics/domain/entities/budget_forecast.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/budget_forecast_providers.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/insights_provider.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

/// Implementation of ExportRepository
class ExportRepositoryImpl implements ExportRepository {
  final TripRepository tripRepository;
  final ExpenseRepository expenseRepository;
  final PdfGenerator pdfGenerator;
  final ProviderContainer container;

  ExportRepositoryImpl({
    required this.tripRepository,
    required this.expenseRepository,
    required this.pdfGenerator,
    required this.container,
  });

  @override
  Future<ExportReport> collectReportData(int tripId) async {
    // Fetch trip
    final trip = await tripRepository.getTripById(tripId);
    if (trip == null) {
      throw Exception('Trip not found');
    }

    // Fetch expenses
    final expenses = await expenseRepository.getExpensesByTrip(tripId);

    // Fetch statistics
    final statistics = await container.read(statisticsDataProvider(tripId).future);

    // Fetch budget summary
    final budgetSummary = await container.read(budgetSummaryProvider(tripId).future);

    // Fetch insights
    final insightsData = await container.read(insightsProvider(tripId).future);

    // Fetch forecast (may be null if no budget)
    BudgetForecast? forecast;
    try {
      final forecastData = await container.read(budgetForecastProvider(tripId).future);
      forecast = forecastData.forecast;
    } catch (_) {
      // Forecast not available - that's okay
      forecast = null;
    }

    // Construct report
    return ExportReport(
      trip: trip,
      expenses: expenses,
      statistics: statistics,
      budgetSummary: budgetSummary,
      insights: insightsData.insights,
      forecast: forecast,
    );
  }

  @override
  Future<File> generatePdf(ExportReport report) async {
    return await pdfGenerator.generate(report);
  }

  @override
  Future<void> shareFile(File file, {String? subject}) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject,
    );
  }
}
