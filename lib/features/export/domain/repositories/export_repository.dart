import 'dart:io';

import 'package:trip_wallet/features/export/domain/entities/export_report.dart';

abstract class ExportRepository {
  Future<ExportReport> collectReportData(int tripId);
  Future<File> generatePdf(ExportReport report);
  Future<void> shareFile(File file, {String? subject});
}
