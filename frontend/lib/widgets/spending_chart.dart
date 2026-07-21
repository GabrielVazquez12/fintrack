import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';

class SpendingChart extends StatelessWidget {
  final Map<String, double> spendingByCategory;

  const SpendingChart({super.key, required this.spendingByCategory});

  @override
  Widget build(BuildContext context) {
    final entries = spendingByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold(0.0, (sum, e) => sum + e.value);
    final fmt = NumberFormat.currency(locale: 'es_MX', symbol: '\$', decimalDigits: 0);

    if (entries.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('Aún no hay gastos registrados')),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GASTOS POR CATEGORÍA', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 42,
                          sections: entries.map((e) {
                            final cat = Category.byId(e.key);
                            return PieChartSectionData(
                              value: e.value,
                              color: cat.color,
                              radius: 24,
                              showTitle: false,
                            );
                          }).toList(),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fmt.format(total),
                            style: GoogleFonts.ptSerif(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          Text('total', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: entries.take(5).map((e) {
                      final cat = Category.byId(e.key);
                      final pct = (e.value / total * 100).toStringAsFixed(0);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(color: cat.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(cat.name, style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Text('$pct%', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      );
                    }).toList(),
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