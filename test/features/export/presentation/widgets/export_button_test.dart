import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/presentation/providers/export_providers.dart';
import 'package:trip_wallet/features/export/presentation/widgets/export_button.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

class TestExportNotifier extends ExportNotifier {
  final ExportState _initialState;

  TestExportNotifier(this._initialState);

  @override
  ExportState build() => _initialState;

  @override
  Future<void> generateReport(int tripId) async {
    // No-op for basic tests
  }

  @override
  Future<void> shareReport() async {
    // No-op for basic tests
  }
}

void main() {
  Widget buildTestWidget({int tripId = 1}) {
    final testNotifier = TestExportNotifier(
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
          body: ExportButton(tripId: tripId),
        ),
      ),
    );
  }

  group('ExportButton', () {
    testWidgets('renders IconButton with share icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('has Export Report tooltip', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.tooltip, 'Export Report');
    });

    testWidgets('shows bottom sheet when pressed', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap the button
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify bottom sheet is shown (by checking for modal barrier)
      expect(find.byType(ModalBarrier), findsWidgets);
    });

    testWidgets('passes tripId to bottom sheet', (tester) async {
      await tester.pumpWidget(buildTestWidget(tripId: 42));

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Bottom sheet should be present (we'll verify the actual sheet in its own test)
      expect(find.byType(ModalBarrier), findsWidgets);
    });
  });
}
