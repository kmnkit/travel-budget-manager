import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_wallet/core/constants/currency_constants.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/expense/domain/entities/expense_category.dart';
import 'package:trip_wallet/features/expense/presentation/providers/expense_providers.dart';
import 'package:trip_wallet/features/expense/presentation/widgets/amount_input.dart';
import 'package:trip_wallet/features/expense/presentation/widgets/category_grid.dart';
import 'package:trip_wallet/features/expense/presentation/widgets/payment_method_chips.dart';
import 'package:trip_wallet/features/exchange_rate/presentation/providers/exchange_rate_providers.dart';
import 'package:trip_wallet/features/payment_method/domain/entities/payment_method.dart';
import 'package:trip_wallet/features/payment_method/presentation/providers/payment_method_providers.dart';
import 'package:trip_wallet/features/trip/presentation/providers/trip_providers.dart';
import 'package:trip_wallet/shared/widgets/date_picker_field.dart';
import 'package:trip_wallet/shared/widgets/loading_indicator.dart';

/// Screen for creating or editing an expense.
///
/// Shows form with:
/// - Amount input with currency selection and conversion
/// - Category grid (2x4)
/// - Payment method chips
/// - Date picker
/// - Memo field
///
/// In edit mode, the form is pre-filled with existing expense data.
class ExpenseFormScreen extends ConsumerStatefulWidget {
  final int tripId;
  final int? expenseId;

  const ExpenseFormScreen({
    super.key,
    required this.tripId,
    this.expenseId,
  });

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();

  ExpenseCategory? _selectedCategory;
  PaymentMethod? _selectedPaymentMethod;
  String _selectedCurrency = 'KRW';
  DateTime _selectedDate = DateTime.now();
  double? _convertedAmount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);

    // 날짜 및 통화 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tripAsync = ref.read(tripDetailProvider(widget.tripId));
      if (tripAsync.hasValue && tripAsync.value != null) {
        final trip = tripAsync.value!;
        final now = DateTime.now();

        // 날짜를 여행 기간으로 clamp
        DateTime initialDate;
        if (now.isBefore(trip.startDate)) {
          initialDate = trip.startDate;
        } else if (now.isAfter(trip.endDate)) {
          initialDate = trip.endDate;
        } else {
          initialDate = now;
        }

        setState(() {
          _selectedDate = initialDate;
          _selectedCurrency = trip.baseCurrency; // 통화를 여행 통화로 초기화
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.expenseId != null;

  void _onAmountChanged() {
    final amountText = _amountController.text;
    if (amountText.isEmpty) {
      setState(() {
        _convertedAmount = null;
      });
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() {
        _convertedAmount = null;
      });
      return;
    }

    _convertAmount(amount);
  }

  Future<void> _convertAmount(double amount) async {
    // Get base currency from trip
    final tripAsync = ref.read(tripDetailProvider(widget.tripId));
    final trip = tripAsync.value;
    if (trip == null) return;

    final baseCurrency = trip.baseCurrency;

    // Skip conversion if same currency
    if (_selectedCurrency == baseCurrency) {
      setState(() {
        _convertedAmount = amount;
      });
      return;
    }

    // Convert currency
    final converter = ref.read(currencyConverterProvider);
    try {
      final converted = await converter(
        amount,
        _selectedCurrency,
        baseCurrency,
        tripId: widget.tripId,
      );
      setState(() {
        _convertedAmount = converted;
      });
    } catch (e) {
      // If conversion fails, show original amount
      setState(() {
        _convertedAmount = amount;
      });
    }
  }

  void _onCurrencyChanged(String currency) {
    setState(() {
      _selectedCurrency = currency;
    });
    _onAmountChanged();
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate selections
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리를 선택해주세요')),
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지불수단을 선택해주세요')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 금액을 입력해주세요')),
      );
      return;
    }

    if (_convertedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('환율 변환 중입니다. 잠시만 기다려주세요')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final notifier = ref.read(expenseNotifierProvider.notifier);

      if (_isEditMode) {
        // TODO: Load existing expense and update
        // For now, just pop
        if (mounted) {
          context.pop();
        }
      } else {
        await notifier.createExpense(
          tripId: widget.tripId,
          amount: amount,
          currency: _selectedCurrency,
          convertedAmount: _convertedAmount!,
          category: _selectedCategory!,
          paymentMethodId: _selectedPaymentMethod!.id,
          memo: _memoController.text.trim().isEmpty ? null : _memoController.text.trim(),
          date: _selectedDate,
        );

        if (mounted) {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripDetailProvider(widget.tripId));
    final paymentMethodsAsync = ref.watch(paymentMethodListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? '지출 수정' : '지출 추가'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: tripAsync.when(
        data: (trip) {
          if (trip == null) {
            return const Center(child: Text('여행을 찾을 수 없습니다'));
          }

          return paymentMethodsAsync.when(
            data: (paymentMethods) {
              if (paymentMethods.isEmpty) {
                return const Center(
                  child: Text('지불수단이 없습니다. 먼저 지불수단을 추가해주세요.'),
                );
              }

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Amount input
                    AmountInput(
                      amount: _amountController,
                      selectedCurrency: _selectedCurrency,
                      baseCurrency: trip.baseCurrency,
                      convertedAmount: _convertedAmount,
                      onCurrencyChanged: _onCurrencyChanged,
                      onAmountChanged: (_) => _onAmountChanged(),
                      availableCurrencies: SupportedCurrency.codes,
                    ),
                    const SizedBox(height: 24),

                    // Category grid
                    const Text(
                      '카테고리',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CategoryGrid(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Payment method chips
                    const Text(
                      '지불수단',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PaymentMethodChips(
                      paymentMethods: paymentMethods,
                      selectedId: _selectedPaymentMethod?.id,
                      onSelected: (method) {
                        setState(() {
                          _selectedPaymentMethod = method;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Date picker
                    DatePickerField(
                      label: '날짜',
                      selectedDate: _selectedDate,
                      onDateChanged: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      firstDate: trip.startDate,
                      lastDate: trip.endDate,
                    ),
                    const SizedBox(height: 24),

                    // Memo field
                    TextFormField(
                      controller: _memoController,
                      decoration: InputDecoration(
                        labelText: '메모 (선택)',
                        hintText: '메모를 입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveExpense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                '저장',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const LoadingIndicator(),
            error: (error, stack) => Center(
              child: Text('지불수단 로드 실패: $error'),
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => Center(
          child: Text('여행 정보 로드 실패: $error'),
        ),
      ),
    );
  }
}
