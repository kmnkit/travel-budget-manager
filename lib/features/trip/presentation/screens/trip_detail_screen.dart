import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_wallet/core/utils/date_formatter.dart';
import 'package:trip_wallet/features/budget/presentation/providers/budget_providers.dart';
import 'package:trip_wallet/features/budget/presentation/widgets/budget_summary_card.dart';
import 'package:trip_wallet/features/expense/presentation/screens/expense_list_screen.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';
import 'package:trip_wallet/shared/widgets/error_widget.dart';
import 'package:trip_wallet/shared/widgets/loading_indicator.dart';

/// Trip detail screen with tabs for expenses, exchange rates, and statistics
class TripDetailScreen extends ConsumerStatefulWidget {
  final int tripId;

  const TripDetailScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to show/hide FAB
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripDetailProvider(widget.tripId));
    final budgetAsync = ref.watch(budgetSummaryProvider(widget.tripId));

    return tripAsync.when(
      loading: () => const Scaffold(
        body: Center(child: LoadingIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('오류')),
        body: AppErrorWidget(
          message: '여행 정보를 불러올 수 없습니다',
          onRetry: () => ref.invalidate(tripDetailProvider(widget.tripId)),
        ),
      ),
      data: (trip) {
        if (trip == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('여행 없음')),
            body: const AppErrorWidget(message: '여행을 찾을 수 없습니다'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(trip.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: '수정',
                onPressed: () => context.go('/trip/${widget.tripId}/edit'),
              ),
            ],
          ),
          body: Column(
            children: [
              // Header with trip info
              _buildHeader(trip),

              // Budget summary card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: budgetAsync.when(
                  loading: () => const SizedBox(
                    height: 200,
                    child: Center(child: LoadingIndicator()),
                  ),
                  error: (error, stack) => const SizedBox.shrink(),
                  data: (budgetSummary) => BudgetSummaryCard(
                    budgetSummary: budgetSummary,
                    currencyCode: trip.baseCurrency,
                  ),
                ),
              ),

              // TabBar
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.receipt_long),
                    text: '지출',
                  ),
                  Tab(
                    icon: Icon(Icons.currency_exchange),
                    text: '환율',
                  ),
                  Tab(
                    icon: Icon(Icons.bar_chart),
                    text: '통계',
                  ),
                ],
              ),

              // TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ExpenseListScreen(tripId: widget.tripId),
                    const Center(child: Text('환율')),
                    const Center(child: Text('통계')),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: _tabController.index == 0
              ? FloatingActionButton(
                  onPressed: () => context.go('/trip/${widget.tripId}/expense/create'),
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  Widget _buildHeader(Trip trip) {
    final theme = Theme.of(context);
    final statusInfo = _getStatusInfo(trip.status);

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormatter.formatDate(trip.startDate)} - ${DateFormatter.formatDate(trip.endDate)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusInfo.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusInfo.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: statusInfo.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(TripStatus status) {
    switch (status) {
      case TripStatus.upcoming:
        return const _StatusInfo(
          label: '예정',
          color: Colors.blue,
        );
      case TripStatus.ongoing:
        return const _StatusInfo(
          label: '진행중',
          color: Colors.green,
        );
      case TripStatus.completed:
        return const _StatusInfo(
          label: '완료',
          color: Colors.grey,
        );
    }
  }
}

class _StatusInfo {
  final String label;
  final Color color;

  const _StatusInfo({
    required this.label,
    required this.color,
  });
}
