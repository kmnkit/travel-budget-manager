import 'package:flutter/material.dart';
import 'package:trip_wallet/core/theme/app_colors.dart';

enum ExpenseCategory {
  food(icon: Icons.restaurant, labelEn: 'Food', labelKo: '식비', color: AppColors.categoryFood),
  transport(icon: Icons.directions_bus, labelEn: 'Transport', labelKo: '교통', color: AppColors.categoryTransport),
  accommodation(icon: Icons.hotel, labelEn: 'Accommodation', labelKo: '숙박', color: AppColors.categoryAccommodation),
  shopping(icon: Icons.shopping_bag, labelEn: 'Shopping', labelKo: '쇼핑', color: AppColors.categoryShopping),
  entertainment(icon: Icons.celebration, labelEn: 'Entertainment', labelKo: '오락', color: AppColors.categoryEntertainment),
  sightseeing(icon: Icons.photo_camera, labelEn: 'Sightseeing', labelKo: '관광', color: AppColors.categorySightseeing),
  communication(icon: Icons.phone, labelEn: 'Communication', labelKo: '통신', color: AppColors.categoryCommunication),
  other(icon: Icons.more_horiz, labelEn: 'Other', labelKo: '기타', color: AppColors.categoryOther);

  const ExpenseCategory({
    required this.icon,
    required this.labelEn,
    required this.labelKo,
    required this.color,
  });

  final IconData icon;
  final String labelEn;
  final String labelKo;
  final Color color;
}
