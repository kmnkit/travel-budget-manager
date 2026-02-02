import 'package:flutter/material.dart';
import 'package:trip_wallet/core/utils/date_formatter.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final DateTimeRange? selectedDateRange;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<DateTimeRange>? onDateRangeChanged;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool isRange;

  const DatePickerField({
    super.key,
    this.selectedDate,
    this.selectedDateRange,
    this.onDateChanged,
    this.onDateRangeChanged,
    required this.label,
    this.firstDate,
    this.lastDate,
    this.isRange = false,
  }) : assert(
          isRange ? (selectedDateRange != null && onDateRangeChanged != null) : (selectedDate != null && onDateChanged != null),
          'Must provide selectedDate and onDateChanged for single date picker, or selectedDateRange and onDateRangeChanged for range picker',
        );

  Future<void> _pickDate(BuildContext context) async {
    if (isRange) {
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2100),
        initialDateRange: selectedDateRange,
      );
      if (picked != null && onDateRangeChanged != null) {
        onDateRangeChanged!(picked);
      }
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2100),
      );
      if (picked != null && onDateChanged != null) {
        onDateChanged!(picked);
      }
    }
  }

  String get _displayText {
    if (isRange && selectedDateRange != null) {
      return DateFormatter.formatDateRange(
        selectedDateRange!.start,
        selectedDateRange!.end,
      );
    } else if (!isRange && selectedDate != null) {
      return DateFormatter.formatDate(selectedDate!);
    }
    return 'Select date';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label, ${isRange ? 'date range' : 'date'} picker button',
      button: true,
      child: GestureDetector(
        onTap: () => _pickDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
          ),
          child: SizedBox(
            height: 24,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _displayText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
