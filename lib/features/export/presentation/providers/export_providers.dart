import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';
import 'package:trip_wallet/features/export/data/repositories/export_repository_impl.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/domain/repositories/export_repository.dart';
import 'package:trip_wallet/features/export/domain/services/pdf_generator.dart';
import 'package:trip_wallet/features/export/domain/usecases/generate_pdf_report.dart';
import 'package:trip_wallet/features/export/domain/usecases/share_report.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';

part 'export_providers.freezed.dart';

/// State class for export operations
@freezed
abstract class ExportState with _$ExportState {
  const factory ExportState({
    @Default(ExportStatus.idle) ExportStatus status,
    File? generatedFile,
    String? errorMessage,
    double? progress,
  }) = _ExportState;
}

/// Provider for PDF generator service
/// NOTE: PdfGenerator is abstract. This provider should be overridden in tests
/// or implemented when PdfGeneratorImpl is created (task #6)
final pdfGeneratorProvider = Provider<PdfGenerator>((ref) {
  throw UnimplementedError('PdfGenerator implementation not yet available');
});

/// Repository provider for export operations
final exportRepositoryProvider = Provider<ExportRepository>((ref) {
  final tripRepository = ref.watch(tripRepositoryProvider);
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  final pdfGenerator = ref.watch(pdfGeneratorProvider);
  final container = ProviderContainer();

  return ExportRepositoryImpl(
    tripRepository: tripRepository,
    expenseRepository: expenseRepository,
    pdfGenerator: pdfGenerator,
    container: container,
  );
});

/// Use case provider for generating PDF reports
final generatePdfReportProvider = Provider<GeneratePdfReport>((ref) {
  final repository = ref.watch(exportRepositoryProvider);
  return GeneratePdfReport(repository);
});

/// Use case provider for sharing reports
final shareReportProvider = Provider<ShareReport>((ref) {
  return ShareReport();
});

/// Notifier that manages export state
class ExportNotifier extends Notifier<ExportState> {
  @override
  ExportState build() => const ExportState();

  /// Generate PDF report for a trip
  Future<void> generateReport(int tripId) async {
    // Set status to generating
    state = state.copyWith(
      status: ExportStatus.generating,
      errorMessage: null,
      generatedFile: null,
    );

    try {
      // Call GeneratePdfReport use case
      final generatePdfReport = ref.read(generatePdfReportProvider);
      final file = await generatePdfReport(tripId);

      // Update state with generated file
      state = state.copyWith(
        status: ExportStatus.completed,
        generatedFile: file,
      );
    } catch (e) {
      // Update state with error
      state = state.copyWith(
        status: ExportStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  /// Share the generated report
  Future<void> shareReport() async {
    // Return early if no file is generated
    if (state.generatedFile == null) {
      return;
    }

    try {
      // Call ShareReport use case
      final shareReport = ref.read(shareReportProvider);
      await shareReport(
        state.generatedFile!,
        subject: 'Trip Report',
      );
    } catch (e) {
      // Update state with error
      state = state.copyWith(
        status: ExportStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }
}

/// Provider for export notifier
final exportNotifierProvider = NotifierProvider<ExportNotifier, ExportState>(
  ExportNotifier.new,
);
