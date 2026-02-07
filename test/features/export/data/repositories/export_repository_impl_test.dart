import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/export/data/repositories/export_repository_impl.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/domain/services/pdf_generator.dart';
import 'package:trip_wallet/features/expense/domain/repositories/expense_repository.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/domain/repositories/trip_repository.dart';

// Mocks
class MockTripRepository extends Mock implements TripRepository {}

class MockExpenseRepository extends Mock implements ExpenseRepository {}

class MockPdfGenerator extends Mock implements PdfGenerator {}

// Fallback values
class FakeExportReport extends Fake implements ExportReport {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ExportRepositoryImpl repository;
  late MockTripRepository mockTripRepository;
  late MockExpenseRepository mockExpenseRepository;
  late MockPdfGenerator mockPdfGenerator;
  late ProviderContainer container;

  setUp(() {
    mockTripRepository = MockTripRepository();
    mockExpenseRepository = MockExpenseRepository();
    mockPdfGenerator = MockPdfGenerator();
    container = ProviderContainer();

    repository = ExportRepositoryImpl(
      tripRepository: mockTripRepository,
      expenseRepository: mockExpenseRepository,
      pdfGenerator: mockPdfGenerator,
      container: container,
    );

    // Register fallback values
    registerFallbackValue(FakeExportReport());
  });

  tearDown(() {
    container.dispose();
  });

  group('collectReportData', () {
    test('should throw when trip not found', () async {
      // Arrange
      when(() => mockTripRepository.getTripById(1))
          .thenAnswer((_) async => null);

      // Act & Assert
      expect(
        () => repository.collectReportData(1),
        throwsException,
      );
      verify(() => mockTripRepository.getTripById(1)).called(1);
    });

    // Note: Full integration tests for collectReportData with providers
    // should be in integration tests, as they require complex setup with
    // database mocking, provider overrides, etc.
  });

  group('generatePdf', () {
    final testReport = ExportReport(
      trip: Trip(
        id: 1,
        title: 'Test Trip',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 5),
        budget: 1000.0,
        baseCurrency: 'USD',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      ),
      expenses: [],
      statistics: const StatisticsData(
        categoryTotals: {},
        dailyTotals: {},
        paymentMethodTotals: {},
        totalAmount: 0.0,
        categoryDailyTotals: {},
      ),
      budgetSummary: BudgetSummary(
        tripId: 1,
        totalBudget: 1000.0,
        totalSpent: 0.0,
        remaining: 1000.0,
        percentUsed: 0.0,
        status: BudgetStatus.comfortable,
        categoryBreakdown: {},
        dailyAverage: 0.0,
        daysRemaining: 5,
        dailyBudgetRemaining: 200.0,
      ),
      insights: [],
      forecast: null,
    );

    test('should delegate to PdfGenerator', () async {
      // Arrange
      final expectedFile = File('/path/to/report.pdf');
      when(() => mockPdfGenerator.generate(any()))
          .thenAnswer((_) async => expectedFile);

      // Act
      final result = await repository.generatePdf(testReport);

      // Assert
      expect(result, equals(expectedFile));
      verify(() => mockPdfGenerator.generate(testReport)).called(1);
    });

    test('should throw when PDF generation fails', () async {
      // Arrange
      when(() => mockPdfGenerator.generate(any()))
          .thenThrow(Exception('PDF generation failed'));

      // Act & Assert
      expect(
        () => repository.generatePdf(testReport),
        throwsException,
      );
      verify(() => mockPdfGenerator.generate(testReport)).called(1);
    });
  });

  group('shareFile', () {
    const shareChannel = MethodChannel('dev.fluttercommunity.plus/share');

    setUp(() {
      // Mock the share_plus method channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(shareChannel, (MethodCall methodCall) async {
        if (methodCall.method == 'shareXFiles') {
          return 'success';
        }
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(shareChannel, null);
    });

    test('should share file with subject', () async {
      // Arrange
      final testFile = File('/path/to/report.pdf');
      const testSubject = 'Trip Report';

      // Act & Assert
      // Should not throw when sharing file
      await expectLater(
        repository.shareFile(testFile, subject: testSubject),
        completes,
      );
    });

    test('should share file without subject', () async {
      // Arrange
      final testFile = File('/path/to/report.pdf');

      // Act & Assert
      // Should not throw when sharing file without subject
      await expectLater(
        repository.shareFile(testFile),
        completes,
      );
    });
  });
}
