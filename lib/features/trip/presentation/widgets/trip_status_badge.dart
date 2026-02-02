import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/trip/domain/entities/trip.dart';

class TripStatusBadge extends StatelessWidget {
  final TripStatus status;

  const TripStatusBadge({
    super.key,
    required this.status,
  });

  String get _statusText {
    switch (status) {
      case TripStatus.upcoming:
        return '예정';
      case TripStatus.ongoing:
        return '진행중';
      case TripStatus.completed:
        return '완료';
    }
  }

  Color get _statusColor {
    switch (status) {
      case TripStatus.upcoming:
        return AppColors.statusUpcoming;
      case TripStatus.ongoing:
        return AppColors.statusOngoing;
      case TripStatus.completed:
        return AppColors.statusCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
