import 'dart:io';
import '../repositories/export_repository.dart';

/// Use case for generating PDF report from trip data
///
/// Steps:
/// 1. Collect report data (trip, expenses, statistics, budget, insights)
/// 2. Generate PDF file from collected data
/// 3. Return the generated PDF file
class GeneratePdfReport {
  final ExportRepository _repository;

  GeneratePdfReport(this._repository);

  Future<File> call(int tripId) async {
    // Collect all report data
    final report = await _repository.collectReportData(tripId);

    // Generate PDF from report data
    final pdfFile = await _repository.generatePdf(report);

    return pdfFile;
  }
}
