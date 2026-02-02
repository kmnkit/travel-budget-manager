import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trip_wallet/core/utils/currency_formatter.dart';

/// A widget for inputting expense amounts with currency selection.
///
/// Features:
/// - Currency dropdown selector (left)
/// - Large amount text field (center)
/// - Converted amount display in base currency (below)
class AmountInput extends StatelessWidget {
  /// Controller for the amount text field
  final TextEditingController amount;

  /// Currently selected currency code
  final String selectedCurrency;

  /// Base currency code for conversion display
  final String baseCurrency;

  /// Converted amount in base currency (null if not yet calculated)
  final double? convertedAmount;

  /// Callback when currency is changed
  final ValueChanged<String> onCurrencyChanged;

  /// Callback when amount text changes
  final ValueChanged<String> onAmountChanged;

  /// List of available currency codes
  final List<String> availableCurrencies;

  const AmountInput({
    super.key,
    required this.amount,
    required this.selectedCurrency,
    required this.baseCurrency,
    this.convertedAmount,
    required this.onCurrencyChanged,
    required this.onAmountChanged,
    this.availableCurrencies = const ['KRW', 'USD', 'JPY', 'EUR', 'CNY', 'GBP', 'THB'],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Amount input',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Currency dropdown
              Semantics(
                label: 'Currency selector',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCurrency,
                    underline: const SizedBox.shrink(),
                    isDense: true,
                    items: availableCurrencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getCurrencyFlag(currency),
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              currency,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onCurrencyChanged(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Amount text field
              Expanded(
                child: Semantics(
                  label: 'Amount',
                  textField: true,
                  child: TextField(
                    controller: amount,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.right,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: onAmountChanged,
                  ),
                ),
              ),
            ],
          ),

          // Converted amount display
          if (convertedAmount != null && selectedCurrency != baseCurrency) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Semantics(
                label: 'Converted amount: ${CurrencyFormatter.format(convertedAmount!, baseCurrency)}',
                child: Text(
                  '= ${CurrencyFormatter.format(convertedAmount!, baseCurrency)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Returns flag emoji for currency code
  String _getCurrencyFlag(String currencyCode) {
    switch (currencyCode) {
      case 'KRW':
        return '🇰🇷';
      case 'USD':
        return '🇺🇸';
      case 'JPY':
        return '🇯🇵';
      case 'EUR':
        return '🇪🇺';
      case 'CNY':
        return '🇨🇳';
      case 'GBP':
        return '🇬🇧';
      case 'THB':
        return '🇹🇭';
      default:
        return '💱';
    }
  }
}
