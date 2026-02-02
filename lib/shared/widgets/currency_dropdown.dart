import 'package:flutter/material.dart';
import 'package:trip_wallet/core/constants/currency_constants.dart';

class CurrencyDropdown extends StatelessWidget {
  final SupportedCurrency selectedCurrency;
  final ValueChanged<SupportedCurrency?> onChanged;
  final InputDecoration? decoration;

  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.onChanged,
    this.decoration,
  });

  static String _getFlagEmoji(String currencyCode) {
    switch (currencyCode) {
      case 'KRW':
        return '🇰🇷';
      case 'USD':
        return '🇺🇸';
      case 'EUR':
        return '🇪🇺';
      case 'JPY':
        return '🇯🇵';
      case 'GBP':
        return '🇬🇧';
      case 'AUD':
        return '🇦🇺';
      case 'CAD':
        return '🇨🇦';
      default:
        return '🌐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Currency selection dropdown',
      child: DropdownButtonFormField<SupportedCurrency>(
        initialValue: selectedCurrency,
        decoration: decoration ??
            const InputDecoration(
              labelText: 'Currency',
              border: OutlineInputBorder(),
            ),
        items: SupportedCurrency.values.map((currency) {
          return DropdownMenuItem<SupportedCurrency>(
            value: currency,
            child: Text(
              '${_getFlagEmoji(currency.code)} ${currency.code}',
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
