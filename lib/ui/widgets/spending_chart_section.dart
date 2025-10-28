import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SpendingChartSection extends StatelessWidget {
  final Map<String, double> categoryTotals;
  const SpendingChartSection({super.key, required this.categoryTotals});

  // Category colors
  static const categoryColors = {
    'Groceries': Color(0xFF42A5F5),
    'Food': Color(0xFFFFA726),
    'Travel': Color(0xFF66BB6A),
    'Misc': Color(0xFF9E9E9E),
  };

  // Category icons
  static const categoryIcons = {
    'Groceries': FontAwesomeIcons.cartShopping,
    'Food': FontAwesomeIcons.utensils,
    'Travel': FontAwesomeIcons.plane,
    'Misc': FontAwesomeIcons.coins,
  };

  @override
  Widget build(BuildContext context) {
    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Spending by Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Pie Chart
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 50,
                  sections: categoryTotals.entries.map((entry) {
                    final color = categoryColors[entry.key] ?? Colors.grey;
                    final percent = total == 0 ? 0 : (entry.value / total) * 100;
                    return PieChartSectionData(
                      color: color,
                      value: entry.value,
                      title: '${percent.toStringAsFixed(1)}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Category legend
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: categoryTotals.keys.map((category) {
                final icon = categoryIcons[category] ?? FontAwesomeIcons.coins;
                final color = categoryColors[category] ?? Colors.grey;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: color, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      category,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
