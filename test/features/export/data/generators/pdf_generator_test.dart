import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';
import 'package:trip_wallet/features/export/data/generators/pdf_generator.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PdfGeneratorImpl pdfGenerator;
  late MockPathProviderPlatform mockPathProvider;
  late Directory tempDir;

  setUp(() async {
    pdfGenerator = PdfGeneratorImpl();
    mockPathProvider = MockPathProviderPlatform();
    PathProviderPlatform.instance = mockPathProvider;

    // Create a real temp directory for testing
    tempDir = await Directory.systemTemp.createTemp('pdf_test_');

    when(() => mockPathProvider.getApplicationDocumentsPath())
        .thenAnswer((_) async => tempDir.path);
  });

  tearDown(() async {
    // Clean up temp directory
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('PdfGenerator', () {
    test('generates PDF file with correct name pattern', () async {
      // Arrange
      final now = DateTime.now();
      final trip = Trip(
        id: 123,
        title: 'Tokyo Trip',
        baseCurrency: 'KRW',
        budget: 1000000.0,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 7),
        createdAt: now,
        updatedAt: now,
      );

      final report = ExportReport(
        trip: trip,
        expenses: [],
        statistics: const StatisticsData(
          categoryTotals: {},
          dailyTotals: {},
          paymentMethodTotals: {},
          totalAmount: 0,
          categoryDailyTotals: {},
        ),
        budgetSummary: BudgetSummary(
          tripId: 123,
          totalBudget: 1000000.0,
          totalSpent: 0,
          remaining: 1000000.0,
          percentUsed: 0,
          status: BudgetStatus.comfortable,
          categoryBreakdown: const {},
          dailyAverage: 0,
          daysRemaining: 7,
          dailyBudgetRemaining: 1000000.0 / 7,
        ),
        insights: [],
        forecast: null,
      );

      // Act
      final file = await pdfGenerator.generate(report);

      // Assert
      expect(file.existsSync(), isTrue);
      expect(file.path, contains('trip_report_'));
      expect(file.path, contains('123'));
      expect(file.path, endsWith('.pdf'));

      // Verify file has content
      final bytes = await file.readAsBytes();
      expect(bytes.isNotEmpty, isTrue);
      expect(bytes.length, greaterThan(100)); // PDF has header and content
    });

    test('generates PDF file that can be read', () async {
      // Arrange
      final now = DateTime.now();
      final trip = Trip(
        id: 456,
        title: 'Seoul Trip',
        baseCurrency: 'KRW',
        budget: 500000.0,
        startDate: DateTime(2024, 2, 1),
        endDate: DateTime(2024, 2, 5),
        createdAt: now,
        updatedAt: now,
      );

      final report = ExportReport(
        trip: trip,
        expenses: [],
        statistics: const StatisticsData(
          categoryTotals: {},
          dailyTotals: {},
          paymentMethodTotals: {},
          totalAmount: 0,
          categoryDailyTotals: {},
        ),
        budgetSummary: BudgetSummary(
          tripId: 456,
          totalBudget: 500000.0,
          totalSpent: 0,
          remaining: 500000.0,
          percentUsed: 0,
          status: BudgetStatus.comfortable,
          categoryBreakdown: const {},
          dailyAverage: 0,
          daysRemaining: 4,
          dailyBudgetRemaining: 500000.0 / 4,
        ),
        insights: [],
        forecast: null,
      );

      // Act
      final file = await pdfGenerator.generate(report);

      // Assert
      final bytes = await file.readAsBytes();

      // Verify PDF magic number (starts with %PDF)
      final header = String.fromCharCodes(bytes.take(4));
      expect(header, equals('%PDF'));
    });

    test('creates file in application documents directory', () async {
      // Arrange
      final now = DateTime.now();
      final trip = Trip(
        id: 789,
        title: 'Busan Trip',
        baseCurrency: 'KRW',
        budget: 300000.0,
        startDate: DateTime(2024, 3, 1),
        endDate: DateTime(2024, 3, 3),
        createdAt: now,
        updatedAt: now,
      );

      final report = ExportReport(
        trip: trip,
        expenses: [],
        statistics: const StatisticsData(
          categoryTotals: {},
          dailyTotals: {},
          paymentMethodTotals: {},
          totalAmount: 0,
          categoryDailyTotals: {},
        ),
        budgetSummary: BudgetSummary(
          tripId: 789,
          totalBudget: 300000.0,
          totalSpent: 0,
          remaining: 300000.0,
          percentUsed: 0,
          status: BudgetStatus.comfortable,
          categoryBreakdown: const {},
          dailyAverage: 0,
          daysRemaining: 2,
          dailyBudgetRemaining: 300000.0 / 2,
        ),
        insights: [],
        forecast: null,
      );

      // Act
      final file = await pdfGenerator.generate(report);

      // Assert
      expect(file.path, startsWith(tempDir.path));
      verify(() => mockPathProvider.getApplicationDocumentsPath()).called(1);
    });
  });
}
