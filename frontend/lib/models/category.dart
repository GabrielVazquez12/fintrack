import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TransactionType { income, expense }

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  static const List<Category> expenseCategories = [
    Category(id: 'food', name: 'Comida', icon: Icons.restaurant, color: AppColors.terracotta),
    Category(id: 'transport', name: 'Transporte', icon: Icons.directions_car, color: Color(0xFF7A6C4F)),
    Category(id: 'housing', name: 'Vivienda', icon: Icons.home_outlined, color: Color(0xFF4E6E5D)),
    Category(id: 'entertainment', name: 'Entretenimiento', icon: Icons.movie_outlined, color: Color(0xFF8E5B6B)),
    Category(id: 'health', name: 'Salud', icon: Icons.favorite_border, color: Color(0xFF5B7C99)),
    Category(id: 'other', name: 'Otros', icon: Icons.more_horiz, color: AppColors.inkFaint),
  ];

  static const List<Category> incomeCategories = [
    Category(id: 'salary', name: 'Salario', icon: Icons.work_outline, color: AppColors.gold),
    Category(id: 'freelance', name: 'Freelance', icon: Icons.laptop_mac, color: Color(0xFF9A8148)),
    Category(id: 'gift', name: 'Regalo', icon: Icons.card_giftcard, color: Color(0xFFAD9660)),
    Category(id: 'other_income', name: 'Otros', icon: Icons.more_horiz, color: AppColors.inkFaint),
  ];

  static Category byId(String id) {
    return [...expenseCategories, ...incomeCategories]
        .firstWhere((c) => c.id == id, orElse: () => expenseCategories.last);
  }
}