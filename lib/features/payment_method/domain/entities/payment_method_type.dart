import 'package:flutter/material.dart';

enum PaymentMethodType {
  cash(icon: Icons.money, labelEn: 'Cash', labelKo: '현금'),
  creditCard(icon: Icons.credit_card, labelEn: 'Credit Card', labelKo: '신용카드'),
  debitCard(icon: Icons.credit_card_outlined, labelEn: 'Debit Card', labelKo: '체크카드'),
  transitCard(icon: Icons.directions_transit, labelEn: 'Transit Card', labelKo: '교통카드'),
  other(icon: Icons.payment, labelEn: 'Other', labelKo: '기타');

  const PaymentMethodType({
    required this.icon,
    required this.labelEn,
    required this.labelKo,
  });

  final IconData icon;
  final String labelEn;
  final String labelKo;
}
