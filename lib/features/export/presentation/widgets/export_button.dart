import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/export/presentation/widgets/export_bottom_sheet.dart';

class ExportButton extends ConsumerWidget {
  final int tripId;

  const ExportButton({
    required this.tripId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () => _showExportDialog(context, ref),
      tooltip: 'Export Report',
    );
  }

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ExportBottomSheet(tripId: tripId),
    );
  }
}
