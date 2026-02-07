import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/export/domain/entities/export_report.dart';
import 'package:trip_wallet/features/export/presentation/providers/export_providers.dart';
import 'package:trip_wallet/l10n/generated/app_localizations.dart';

/// Bottom sheet for exporting trip reports
class ExportBottomSheet extends ConsumerWidget {
  final int tripId;

  const ExportBottomSheet({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final exportState = ref.watch(exportNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            l10n.exportReport,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Content based on status
          _buildContent(context, ref, exportState, l10n),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ExportState state,
    AppLocalizations l10n,
  ) {
    switch (state.status) {
      case ExportStatus.idle:
        return ElevatedButton(
          onPressed: () {
            ref.read(exportNotifierProvider.notifier).generateReport(tripId);
          },
          child: Text(l10n.generatePdf),
        );

      case ExportStatus.generating:
        return const Center(
          child: CircularProgressIndicator(),
        );

      case ExportStatus.completed:
        return ElevatedButton(
          onPressed: () {
            ref.read(exportNotifierProvider.notifier).shareReport();
          },
          child: Text(l10n.shareReport),
        );

      case ExportStatus.failed:
        return Text(
          state.errorMessage ?? 'Unknown error',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        );
    }
  }
}
