import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_wallet/features/trip/presentation/screens/home_screen.dart';
import 'package:trip_wallet/features/trip/presentation/screens/trip_create_screen.dart';
import 'package:trip_wallet/features/trip/presentation/screens/trip_edit_screen.dart';
import 'package:trip_wallet/features/expense/presentation/screens/expense_form_screen.dart';
import 'package:trip_wallet/features/payment_method/presentation/screens/payment_method_screen.dart';
import 'package:trip_wallet/features/settings/presentation/screens/settings_screen.dart';
import 'package:trip_wallet/features/onboarding/presentation/screens/onboarding_screen.dart';

// Placeholder screens for compilation - will be replaced by actual screens
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title)),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) {
          final onComplete = state.extra as VoidCallback?;
          return OnboardingScreen(
            onComplete: onComplete ?? () {},
          );
        },
      ),
      GoRoute(
        path: '/trip/create',
        name: 'tripCreate',
        builder: (context, state) => const TripCreateScreen(),
      ),
      GoRoute(
        path: '/trip/:tripId',
        name: 'tripDetail',
        builder: (context, state) {
          final tripId = int.tryParse(state.pathParameters['tripId'] ?? '');
          if (tripId == null) {
            return const HomeScreen();
          }
          return _PlaceholderScreen(title: 'Trip $tripId');
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'tripEdit',
            builder: (context, state) {
              final tripId = int.tryParse(state.pathParameters['tripId'] ?? '');
              if (tripId == null) {
                return const HomeScreen();
              }
              return TripEditScreen(tripId: tripId);
            },
          ),
          GoRoute(
            path: 'expense/create',
            name: 'expenseCreate',
            builder: (context, state) {
              final tripId = int.tryParse(state.pathParameters['tripId'] ?? '');
              if (tripId == null) {
                return const HomeScreen();
              }
              return ExpenseFormScreen(tripId: tripId);
            },
          ),
          GoRoute(
            path: 'expense/:expenseId',
            name: 'expenseEdit',
            builder: (context, state) {
              final tripId = int.tryParse(state.pathParameters['tripId'] ?? '');
              final expenseId = int.tryParse(state.pathParameters['expenseId'] ?? '');
              if (tripId == null || expenseId == null) {
                return const HomeScreen();
              }
              return ExpenseFormScreen(tripId: tripId, expenseId: expenseId);
            },
          ),
          GoRoute(
            path: 'payment-methods',
            name: 'paymentMethods',
            builder: (context, state) => const PaymentMethodScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
