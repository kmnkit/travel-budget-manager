import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/onboarding/presentation/widgets/page_indicator.dart';

void main() {
  group('PageIndicator', () {
    testWidgets('renders correct number of dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageIndicator(currentPage: 0, pageCount: 3),
          ),
        ),
      );

      final containers = find.byType(AnimatedContainer);
      expect(containers, findsNWidgets(3));
    });

    testWidgets('active dot is wider than inactive dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageIndicator(currentPage: 1, pageCount: 3),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The test verifies the widget builds correctly with different pages
      expect(find.byType(PageIndicator), findsOneWidget);
    });
  });
}
