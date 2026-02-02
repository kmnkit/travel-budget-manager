import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/budget/domain/entities/budget_summary.dart';

class CircularBudgetProgress extends StatelessWidget {
  final double percentUsed;
  final BudgetStatus status;
  final double size;

  const CircularBudgetProgress({
    super.key,
    required this.percentUsed,
    required this.status,
    this.size = 150,
  });

  Color _getStatusColor() {
    switch (status) {
      case BudgetStatus.comfortable:
        return AppColors.budgetComfortable;
      case BudgetStatus.caution:
        return AppColors.budgetCaution;
      case BudgetStatus.warning:
        return AppColors.budgetWarning;
      case BudgetStatus.exceeded:
        return AppColors.budgetExceeded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          percentUsed: percentUsed,
          statusColor: _getStatusColor(),
          backgroundColor: colorScheme.surfaceContainerHighest,
        ),
        child: Center(
          child: Text(
            '${percentUsed.clamp(0, 100).toInt()}%',
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percentUsed;
  final Color statusColor;
  final Color backgroundColor;

  const _CircularProgressPainter({
    required this.percentUsed,
    required this.statusColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = statusColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // Start from top
    final clampedPercent = percentUsed.clamp(0, 100);
    final sweepAngle = (clampedPercent / 100) * 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.percentUsed != percentUsed ||
        oldDelegate.statusColor != statusColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
