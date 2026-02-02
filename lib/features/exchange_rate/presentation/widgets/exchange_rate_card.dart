import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:trip_wallet/core/constants/currency_constants.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';
import 'package:trip_wallet/features/exchange_rate/domain/entities/exchange_rate.dart';

/// Card displaying a currency pair exchange rate
class ExchangeRateCard extends StatefulWidget {
  final ExchangeRate exchangeRate;
  final bool isManual;
  final ValueChanged<double>? onRateChanged;

  const ExchangeRateCard({
    super.key,
    required this.exchangeRate,
    required this.isManual,
    this.onRateChanged,
  });

  @override
  State<ExchangeRateCard> createState() => _ExchangeRateCardState();
}

class _ExchangeRateCardState extends State<ExchangeRateCard> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.exchangeRate.rate.toStringAsFixed(4),
    );
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(ExchangeRateCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exchangeRate.rate != widget.exchangeRate.rate) {
      _controller.text = widget.exchangeRate.rate.toStringAsFixed(4);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    }
  }

  String _getCurrencyFlag(String currencyCode) {
    final currency = SupportedCurrency.fromCode(currencyCode);
    // Map currency codes to flag emojis
    switch (currency) {
      case SupportedCurrency.KRW:
        return '🇰🇷';
      case SupportedCurrency.USD:
        return '🇺🇸';
      case SupportedCurrency.EUR:
        return '🇪🇺';
      case SupportedCurrency.JPY:
        return '🇯🇵';
      case SupportedCurrency.GBP:
        return '🇬🇧';
      case SupportedCurrency.AUD:
        return '🇦🇺';
      case SupportedCurrency.CAD:
        return '🇨🇦';
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseCurrency = SupportedCurrency.fromCode(widget.exchangeRate.baseCurrency);
    final targetCurrency = SupportedCurrency.fromCode(widget.exchangeRate.targetCurrency);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Currency pair with flags
                Text(
                  '${_getCurrencyFlag(widget.exchangeRate.baseCurrency)} → ${_getCurrencyFlag(widget.exchangeRate.targetCurrency)}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${baseCurrency.code} → ${targetCurrency.code}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      Text(
                        baseCurrency.nameKo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            // Exchange rate display/input
            Row(
              children: [
                Text(
                  '1 ${baseCurrency.code} =',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(width: 8),
                if (widget.isManual)
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
                      ],
                      decoration: InputDecoration(
                        suffixText: targetCurrency.code,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                      onSubmitted: (value) {
                        final rate = double.tryParse(value);
                        if (rate != null && widget.onRateChanged != null) {
                          widget.onRateChanged!(rate);
                        }
                      },
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      '${NumberFormat('#,##0.0000').format(widget.exchangeRate.rate)} ${targetCurrency.code}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Last updated time
            Row(
              children: [
                Icon(
                  widget.exchangeRate.isManual ? Icons.edit : Icons.refresh,
                  size: 14,
                  color: AppColors.textHint,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.exchangeRate.isManual
                      ? '수동 입력 · ${_getTimeAgo(widget.exchangeRate.updatedAt)}'
                      : '마지막 업데이트 · ${_getTimeAgo(widget.exchangeRate.updatedAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
