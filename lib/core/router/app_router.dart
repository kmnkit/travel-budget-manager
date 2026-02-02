import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
      ),
      GoRoute(
        path: '/trip/create',
        name: 'tripCreate',
        builder: (context, state) => const _PlaceholderScreen(title: 'Create Trip'),
      ),
      GoRoute(
        path: '/trip/:tripId',
        name: 'tripDetail',
        builder: (context, state) {
          final tripId = int.parse(state.pathParameters['tripId']!);
          return _PlaceholderScreen(title: 'Trip $tripId');
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'tripEdit',
            builder: (context, state) {
              final tripId = int.parse(state.pathParameters['tripId']!);
              return _PlaceholderScreen(title: 'Edit Trip $tripId');
            },
          ),
          GoRoute(
            path: 'expense/create',
            name: 'expenseCreate',
            builder: (context, state) => const _PlaceholderScreen(title: 'Create Expense'),
          ),
          GoRoute(
            path: 'expense/:expenseId',
            name: 'expenseEdit',
            builder: (context, state) {
              final expenseId = int.parse(state.pathParameters['expenseId']!);
              return _PlaceholderScreen(title: 'Edit Expense $expenseId');
            },
          ),
          GoRoute(
            path: 'payment-methods',
            name: 'paymentMethods',
            builder: (context, state) => const _PlaceholderScreen(title: 'Payment Methods'),
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const _PlaceholderScreen(title: 'Settings'),
      ),
    ],
  );
});
