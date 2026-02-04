import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';
import 'package:trip_wallet/features/trip/presentation/screens/home_screen.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

void main() {
  group('HomeScreen Locale Switching', () {
    testWidgets('filter chips display Korean labels when locale is ko', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProviderScope(
            overrides: [
              tripListProvider.overrideWith((ref) => Stream.value([])),
              tripFilterProvider.overrideWith(() => TripFilterNotifier()),
              totalBalanceProvider.overrideWith((ref) async => (total: 0.0, currency: 'KRW')),
            ],
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check filter chip labels in Korean
      expect(find.text('모든 여행'), findsOneWidget);
      expect(find.text('진행중'), findsOneWidget);
      expect(find.text('완료'), findsOneWidget);
    });

    testWidgets('filter chips display English labels when locale is en', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProviderScope(
            overrides: [
              tripListProvider.overrideWith((ref) => Stream.value([])),
              tripFilterProvider.overrideWith(() => TripFilterNotifier()),
              totalBalanceProvider.overrideWith((ref) async => (total: 0.0, currency: 'KRW')),
            ],
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check filter chip labels in English
      expect(find.text('All Trips'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Past'), findsOneWidget);
    });

    testWidgets('total balance banner shows Korean label when locale is ko', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProviderScope(
            overrides: [
              tripListProvider.overrideWith((ref) => Stream.value([])),
              tripFilterProvider.overrideWith(() => TripFilterNotifier()),
              totalBalanceProvider.overrideWith((ref) async => (total: 100000.0, currency: 'KRW')),
            ],
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check total balance label in Korean
      expect(find.text('총 잔액'), findsOneWidget);
    });

    testWidgets('total balance banner shows English label when locale is en', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProviderScope(
            overrides: [
              tripListProvider.overrideWith((ref) => Stream.value([])),
              tripFilterProvider.overrideWith(() => TripFilterNotifier()),
              totalBalanceProvider.overrideWith((ref) async => (total: 100000.0, currency: 'KRW')),
            ],
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check total balance label in English
      expect(find.text('TOTAL BALANCE'), findsOneWidget);
    });
  });
}
