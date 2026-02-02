import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/exchange_rate/presentation/providers/exchange_rate_providers.dart';

/// Toggle button for switching between auto and manual exchange rate modes
class AutoManualToggle extends StatelessWidget {
  final ExchangeRateMode selectedMode;
  final ValueChanged<ExchangeRateMode> onModeChanged;

  const AutoManualToggle({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ExchangeRateMode>(
      segments: const [
        ButtonSegment<ExchangeRateMode>(
          value: ExchangeRateMode.auto,
          label: Text('자동'),
          icon: Icon(Icons.refresh),
        ),
        ButtonSegment<ExchangeRateMode>(
          value: ExchangeRateMode.manual,
          label: Text('수동'),
          icon: Icon(Icons.edit),
        ),
      ],
      selected: {selectedMode},
      onSelectionChanged: (Set<ExchangeRateMode> newSelection) {
        onModeChanged(newSelection.first);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.onPrimary;
            }
            return AppColors.textPrimary;
          },
        ),
      ),
    );
  }
}
