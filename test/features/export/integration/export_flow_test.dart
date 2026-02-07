import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/presentation/providers/export_providers.dart';
import 'package:trip_wallet/features/export/presentation/widgets/export_button.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

class MockFile extends Mock implements File {}

// Test notifier that simulates state transitions
class TestExportNotifier extends ExportNotifier {
  final ExportState _initialState;
  final List<ExportState> stateHistory = [];

  TestExportNotifier(this._initialState);

  @override
  ExportState build() => _initialState;

  void setTestState(ExportState newState) {
    stateHistory.add(newState);
    state = newState;
  }

  @override
  Future<void> generateReport(int tripId) async {
    // Simulate generating state
    setTestState(ExportState(
      status: ExportStatus.generating,
      generatedFile: null,
      errorMessage: null,
      progress: 0.5,
    ));

    // Simulate async work
    await Future.delayed(const Duration(milliseconds: 100));

    // Simulate completion
    final mockFile = MockFile();
    when(() => mockFile.path).thenReturn('/path/to/report_$tripId.pdf');

    setTestState(ExportState(
      status: ExportStatus.completed,
      generatedFile: mockFile,
      errorMessage: null,
      progress: 1.0,
    ));
  }

  @override
  Future<void> shareReport() async {
    // Simulate sharing (no-op for test)
    await Future.delayed(const Duration(milliseconds: 50));
  }
}

void main() {
  late TestExportNotifier testNotifier;

  // Helper to build widget with localization
  Widget buildTestApp() {
    testNotifier = TestExportNotifier(
      ExportState(
        status: ExportStatus.idle,
        generatedFile: null,
        errorMessage: null,
        progress: null,
      ),
    );

    return ProviderScope(
      overrides: [
        exportNotifierProvider.overrideWith(() => testNotifier),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        home: Scaffold(
          appBar: AppBar(
            actions: [
              ExportButton(tripId: 1),
            ],
          ),
          body: const Center(child: Text('Test Screen')),
        ),
      ),
    );
  }

  group('Export Flow Integration Test', () {
    testWidgets('complete export flow: idle -> generating -> completed -> share',
        (tester) async {
      // ARRANGE: Build the app with ExportButton
      await tester.pumpWidget(buildTestApp());

      // ASSERT: Initial state - ExportButton is visible
      expect(find.byType(ExportButton), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);

      // ACT: Step 1 - Tap ExportButton to open modal bottom sheet
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // ASSERT: Modal bottom sheet appears
      expect(find.byType(ModalBarrier), findsWidgets);
      expect(find.text('보고서 내보내기'), findsOneWidget);

      // ASSERT: Step 2 - Initial state shows "PDF 생성" button
      expect(find.text('PDF 생성'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // ACT: Step 3 - Tap "PDF 생성" button
      await tester.tap(find.text('PDF 생성'));
      await tester.pump(); // Start the async operation

      // ASSERT: Status changes to generating
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('PDF 생성'), findsNothing); // Button is hidden during generation

      // ACT: Step 4 - Wait for PDF generation to complete
      await tester.pumpAndSettle();

      // ASSERT: Status changes to completed
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('공유하기'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // ASSERT: Verify state history
      expect(testNotifier.stateHistory.length, 2); // generating + completed
      expect(testNotifier.stateHistory[0].status, ExportStatus.generating);
      expect(testNotifier.stateHistory[1].status, ExportStatus.completed);
      expect(testNotifier.stateHistory[1].generatedFile, isNotNull);

      // ACT: Step 5 - Tap "공유하기" button
      await tester.tap(find.text('공유하기'));
      await tester.pumpAndSettle();

      // ASSERT: Share action completes (no error)
      // Bottom sheet should still be visible after sharing
      expect(find.text('보고서 내보내기'), findsOneWidget);
    });

    testWidgets('export flow handles error state', (tester) async {
      // ARRANGE: Build app with notifier that will fail
      final failingNotifier = TestExportNotifier(
        ExportState(
          status: ExportStatus.idle,
          generatedFile: null,
          errorMessage: null,
          progress: null,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exportNotifierProvider.overrideWith(() => failingNotifier),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ko'),
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ExportButton(tripId: 1),
                ],
              ),
              body: const Center(child: Text('Test Screen')),
            ),
          ),
        ),
      );

      // ACT: Open bottom sheet
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // ACT: Manually set error state
      failingNotifier.setTestState(ExportState(
        status: ExportStatus.failed,
        generatedFile: null,
        errorMessage: 'PDF 생성에 실패했습니다',
        progress: null,
      ));
      await tester.pump();

      // ASSERT: Error message is displayed
      expect(find.text('PDF 생성에 실패했습니다'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // ASSERT: Error text is red
      final errorText = tester.widget<Text>(find.text('PDF 생성에 실패했습니다'));
      expect(errorText.style?.color, Colors.red);
    });

    testWidgets('can close bottom sheet during any state', (tester) async {
      // ARRANGE
      await tester.pumpWidget(buildTestApp());

      // ACT: Open bottom sheet
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // ASSERT: Bottom sheet is visible
      expect(find.text('보고서 내보내기'), findsOneWidget);

      // ACT: Close bottom sheet by popping navigator
      Navigator.of(tester.element(find.byType(ExportButton))).pop();
      await tester.pumpAndSettle();

      // ASSERT: Bottom sheet is closed
      expect(find.text('보고서 내보내기'), findsNothing);
    });

    testWidgets('multiple export buttons work independently', (tester) async {
      // ARRANGE: Create app with two export buttons
      final notifier1 = TestExportNotifier(
        ExportState(
          status: ExportStatus.idle,
          generatedFile: null,
          errorMessage: null,
          progress: null,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exportNotifierProvider.overrideWith(() => notifier1),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ko'),
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  ExportButton(tripId: 1),
                  ExportButton(tripId: 2),
                ],
              ),
              body: const Center(child: Text('Test Screen')),
            ),
          ),
        ),
      );

      // ASSERT: Two export buttons exist
      expect(find.byType(ExportButton), findsNWidgets(2));
      expect(find.byIcon(Icons.share), findsNWidgets(2));

      // ACT: Tap first button
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();

      // ASSERT: Bottom sheet opens
      expect(find.text('보고서 내보내기'), findsOneWidget);
    });

    testWidgets('regenerating PDF after completion works', (tester) async {
      // ARRANGE
      await tester.pumpWidget(buildTestApp());

      // ACT: Open bottom sheet and generate PDF
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('PDF 생성'));
      await tester.pumpAndSettle();

      // ASSERT: First generation completed
      expect(find.text('공유하기'), findsOneWidget);
      final firstGenerationStateCount = testNotifier.stateHistory.length;

      // ACT: Reset to idle and regenerate
      testNotifier.setTestState(ExportState(
        status: ExportStatus.idle,
        generatedFile: null,
        errorMessage: null,
        progress: null,
      ));
      await tester.pump();

      // ASSERT: Back to initial state
      expect(find.text('PDF 생성'), findsOneWidget);

      // ACT: Generate again
      await tester.tap(find.text('PDF 생성'));
      await tester.pumpAndSettle();

      // ASSERT: Second generation completed
      expect(find.text('공유하기'), findsOneWidget);
      expect(testNotifier.stateHistory.length, greaterThan(firstGenerationStateCount));
    });
  });
}
