import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_wallet/core/constants/currency_constants.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';
import 'package:trip_wallet/shared/widgets/app_scaffold.dart';
import 'package:trip_wallet/shared/widgets/currency_dropdown.dart';
import 'package:trip_wallet/shared/widgets/date_picker_field.dart';

class TripCreateScreen extends ConsumerStatefulWidget {
  const TripCreateScreen({super.key});

  @override
  ConsumerState<TripCreateScreen> createState() => _TripCreateScreenState();
}

class _TripCreateScreenState extends ConsumerState<TripCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _budgetController = TextEditingController();

  late SupportedCurrency _selectedCurrency;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final defaultCurrency = ref.read(defaultCurrencyProvider);
    _selectedCurrency = SupportedCurrency.fromCode(defaultCurrency);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final trip = await ref.read(tripNotifierProvider.notifier).createTrip(
            title: _titleController.text.trim(),
            baseCurrency: _selectedCurrency.code,
            budget: double.parse(_budgetController.text),
            startDate: _startDate,
            endDate: _endDate,
          );

      if (mounted) {
        context.pushReplacement('/trip/${trip.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create trip: $e'),
            backgroundColor: AppColors.budgetWarning,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _cancel() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '여행 추가',
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Trip Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '여행 제목',
                border: OutlineInputBorder(),
                hintText: '예: 도쿄 여행',
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '여행 제목을 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Base Currency
            CurrencyDropdown(
              selectedCurrency: _selectedCurrency,
              onChanged: (currency) {
                if (currency != null) {
                  setState(() => _selectedCurrency = currency);
                }
              },
              decoration: const InputDecoration(
                labelText: '기본 통화',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Budget
            TextFormField(
              controller: _budgetController,
              decoration: InputDecoration(
                labelText: '예산',
                border: const OutlineInputBorder(),
                prefixText: '${_selectedCurrency.symbol} ',
                hintText: '0',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '예산을 입력하세요';
                }
                final budget = double.tryParse(value);
                if (budget == null || budget <= 0) {
                  return '0보다 큰 금액을 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Start Date
            DatePickerField(
              label: '시작일',
              selectedDate: _startDate,
              onDateChanged: (date) {
                setState(() {
                  _startDate = date;
                  // Ensure end date is after start date
                  if (_endDate.isBefore(_startDate)) {
                    _endDate = _startDate.add(const Duration(days: 1));
                  }
                });
              },
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            ),
            const SizedBox(height: 16),

            // End Date
            DatePickerField(
              label: '종료일',
              selectedDate: _endDate,
              onDateChanged: (date) {
                setState(() => _endDate = date);
              },
              firstDate: _startDate,
              lastDate: DateTime(2100),
            ),
            const SizedBox(height: 24),

            // Save Button
            FilledButton(
              onPressed: _isLoading ? null : _saveTrip,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size.fromHeight(48),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('저장'),
            ),
            const SizedBox(height: 12),

            // Cancel Button
            OutlinedButton(
              onPressed: _isLoading ? null : _cancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('취소'),
            ),
          ],
        ),
      ),
    );
  }
}
