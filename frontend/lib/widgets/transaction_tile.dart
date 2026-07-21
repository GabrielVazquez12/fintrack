import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final FinanceTransaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final cat = Category.byId(transaction.categoryId);
    final isIncome = transaction.type == TransactionType.income;
    final fmt = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    final dateFmt = DateFormat('d MMM', 'es_MX');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cat.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(cat.icon, color: cat.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  '${cat.name} · ${dateFmt.format(transaction.date)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}${fmt.format(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isIncome ? AppColors.gold : AppColors.terracotta,
            ),
          ),
        ],
      ),
    );
  }
}