import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/domain/services/pdf_generator.dart';
import 'package:trip_wallet/features/export/domain/usecases/generate_pdf_report.dart';
import 'package:trip_wallet/features/export/domain/usecases/share_report.dart';
import 'package:trip_wallet/features/export/presentation/providers/export_providers.dart';

class MockGeneratePdfReport extends Mock implements GeneratePdfReport {}

class MockShareReport extends Mock implements ShareReport {}

class MockPdfGenerator extends Mock implements PdfGenerator {}

class MockFile extends Mock implements File {}

class FakeFile extends Fake implements File {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeFile());
  });
  late MockGeneratePdfReport mockGeneratePdfReport;
  late MockShareReport mockShareReport;
  late MockPdfGenerator mockPdfGenerator;
  late ProviderContainer container;

  setUp(() {
    mockGeneratePdfReport = MockGeneratePdfReport();
    mockShareReport = MockShareReport();
    mockPdfGenerator = MockPdfGenerator();

    container = ProviderContainer(
      overrides: [
        pdfGeneratorProvider.overrideWithValue(mockPdfGenerator),
        generatePdfReportProvider.overrideWithValue(mockGeneratePdfReport),
        shareReportProvider.overrideWithValue(mockShareReport),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ExportNotifier', () {
    test('initial state is idle with no file or error', () {
      final state = container.read(exportNotifierProvider);

      expect(state.status, ExportStatus.idle);
      expect(state.generatedFile, isNull);
      expect(state.errorMessage, isNull);
      expect(state.progress, isNull);
    });

    test('generateReport sets status to generating, then completed with file',
        () async {
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/report.pdf');
      when(() => mockGeneratePdfReport.call(any()))
          .thenAnswer((_) async => mockFile);

      final notifier = container.read(exportNotifierProvider.notifier);
      final stateStream = <ExportState>[];

      // Listen to state changes
      container.listen<ExportState>(
        exportNotifierProvider,
        (previous, next) => stateStream.add(next),
        fireImmediately: true,
      );

      await notifier.generateReport(1);

      // Verify state progression
      expect(stateStream.length, greaterThanOrEqualTo(2));
      expect(stateStream[0].status, ExportStatus.idle); // Initial
      expect(stateStream[1].status, ExportStatus.generating);
      expect(stateStream.last.status, ExportStatus.completed);
      expect(stateStream.last.generatedFile, mockFile);
      expect(stateStream.last.errorMessage, isNull);

      verify(() => mockGeneratePdfReport.call(1)).called(1);
    });

    test('generateReport sets status to failed on error', () async {
      when(() => mockGeneratePdfReport.call(any()))
          .thenThrow(Exception('PDF generation failed'));

      final notifier = container.read(exportNotifierProvider.notifier);
      final stateStream = <ExportState>[];

      container.listen<ExportState>(
        exportNotifierProvider,
        (previous, next) => stateStream.add(next),
        fireImmediately: true,
      );

      await notifier.generateReport(1);

      expect(stateStream.last.status, ExportStatus.failed);
      expect(stateStream.last.errorMessage, contains('PDF generation failed'));
      expect(stateStream.last.generatedFile, isNull);

      verify(() => mockGeneratePdfReport.call(1)).called(1);
    });

    test('shareReport calls ShareReport use case with generated file',
        () async {
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/report.pdf');
      when(() => mockShareReport.call(any(), subject: any(named: 'subject')))
          .thenAnswer((_) async => {});

      final notifier = container.read(exportNotifierProvider.notifier);

      // First generate a report
      when(() => mockGeneratePdfReport.call(any()))
          .thenAnswer((_) async => mockFile);
      await notifier.generateReport(1);

      // Then share it
      await notifier.shareReport();

      verify(() => mockShareReport.call(mockFile, subject: any(named: 'subject')))
          .called(1);
    });

    test('shareReport does nothing if no file is generated', () async {
      final notifier = container.read(exportNotifierProvider.notifier);

      await notifier.shareReport();

      verifyNever(() =>
          mockShareReport.call(any(), subject: any(named: 'subject')));
    });

    test('shareReport handles errors gracefully', () async {
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/report.pdf');
      when(() => mockGeneratePdfReport.call(any()))
          .thenAnswer((_) async => mockFile);
      when(() => mockShareReport.call(any(), subject: any(named: 'subject')))
          .thenThrow(Exception('Share failed'));

      final notifier = container.read(exportNotifierProvider.notifier);

      await notifier.generateReport(1);
      await notifier.shareReport();

      // Should not crash, error should be handled
      final state = container.read(exportNotifierProvider);
      expect(state.status, ExportStatus.failed);
      expect(state.errorMessage, contains('Share failed'));
    });
  });
}
