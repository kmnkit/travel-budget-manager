import 'dart:io';

import 'package:trip_wallet/features/export/domain/entities/export_report.dart';

/// Abstract interface for PDF generation service
abstract class PdfGenerator {
  /// Generates a PDF file from an export report
  ///
  /// Returns a File object pointing to the generated PDF
  /// Throws an exception if generation fails
  Future<File> generate(ExportReport report);
}
