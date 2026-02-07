import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/presentation/providers/export_providers.dart';
import 'package:trip_wallet/features/export/presentation/widgets/export_bottom_sheet.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

class MockFile extends Mock implements File {}

// Test notifier that we can control
class TestExportNotifier extends ExportNotifier {
  ExportState _testState;
  int generateReportCallCount = 0;
  int shareReportCallCount = 0;

  TestExportNotifier(this._testState);

  @override
  ExportState build() => _testState;

  void setState(ExportState state) {
    _testState = state;
    // Update the actual state
    this.state = state;
  }

  @override
  Future<void> generateReport(int tripId) async {
    generateReportCallCount++;
    // Don't call super to avoid UnimplementedError
  }

  @override
  Future<void> shareReport() async {
    shareReportCallCount++;
    // Don't call super to avoid errors
  }
}

void main() {
  late TestExportNotifier testNotifier;

  // Helper to build widget with localization
  Widget buildTestWidget(ExportState initialState) {
    testNotifier = TestExportNotifier(initialState);

    return ProviderScope(
      overrides: [
        exportNotifierProvider.overrideWith(() => testNotifier),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        home: Scaffold(
          body: Builder(
            builder: (context) => ExportBottomSheet(tripId: 1),
          ),
        ),
      ),
    );
  }

  group('ExportBottomSheet', () {
    testWidgets('renders title "보고서 내보내기"', (tester) async {
      // Arrange
      final idleState = ExportState(
        status: ExportStatus.idle,
        generatedFile: null,
        errorMessage: null,
        progress: null,
      );

      // Act
      await tester.pumpWidget(buildTestWidget(idleState));

      // Assert
      expect(find.text('보고서 내보내기'), findsOneWidget);
    });

    testWidgets('shows "PDF 생성" button when status is idle', (tester) async {
      // Arrange
      final idleState = ExportState(
        status: ExportStatus.idle,
        generatedFile: null,
        errorMessage: null,
        progress: null,
      );

      // Act
      await tester.pumpWidget(buildTestWidget(idleState));

      // Assert
      expect(find.text('PDF 생성'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when status is generating',
        (tester) async {
      // Arrange
      final generatingState = ExportState(
        status: ExportStatus.generating,
        generatedFile: null,
        errorMessage: null,
        progress: 0.5,
      );

      // Act
      await tester.pumpWidget(buildTestWidget(generatingState));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('shows "공유하기" button when status is completed',
        (tester) async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/report.pdf');
      final completedState = ExportState(
        status: ExportStatus.completed,
        generatedFile: mockFile,
        errorMessage: null,
        progress: 1.0,
      );

      // Act
      await tester.pumpWidget(buildTestWidget(completedState));

      // Assert
      expect(find.text('공유하기'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows error message when status is failed', (tester) async {
      // Arrange
      final errorMessage = 'PDF 생성에 실패했습니다';
      final failedState = ExportState(
        status: ExportStatus.failed,
        generatedFile: null,
        errorMessage: errorMessage,
        progress: null,
      );

      // Act
      await tester.pumpWidget(buildTestWidget(failedState));

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('calls generateReport when "PDF 생성" button is tapped',
        (tester) async {
      // Arrange
      final idleState = ExportState(
        status: ExportStatus.idle,
        generatedFile: null,
        errorMessage: null,
        progress: null,
      );

      // Act
      await tester.pumpWidget(buildTestWidget(idleState));

      // Tap the button
      await tester.tap(find.text('PDF 생성'));
      await tester.pump();

      // Assert - verify the method was called
      expect(testNotifier.generateReportCallCount, 1);
    });

    testWidgets('calls shareReport when "공유하기" button is tapped',
        (tester) async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('/path/to/report.pdf');
      final completedState = ExportState(
        status: ExportStatus.completed,
        generatedFile: mockFile,
        errorMessage: null,
        progress: 1.0,
      );

      // Act
      await tester.pumpWidget(buildTestWidget(completedState));

      // Tap the button
      await tester.tap(find.text('공유하기'));
      await tester.pump();

      // Assert - verify the method was called
      expect(testNotifier.shareReportCallCount, 1);
    });

    testWidgets('error message is displayed in red color', (tester) async {
      // Arrange
      final errorMessage = '오류 발생';
      final failedState = ExportState(
        status: ExportStatus.failed,
        generatedFile: null,
        errorMessage: errorMessage,
        progress: null,
      );

      // Act
      await tester.pumpWidget(buildTestWidget(failedState));

      // Assert
      final textWidget = tester.widget<Text>(find.text(errorMessage));
      expect(textWidget.style?.color, Colors.red);
    });
  });
}
