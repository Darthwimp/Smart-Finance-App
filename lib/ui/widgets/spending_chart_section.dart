import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingChartSection extends StatelessWidget {
  final Map<String, double> categoryTotals;
  const SpendingChartSection({super.key, required this.categoryTotals});

  @override
  Widget build(BuildContext context) {
    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Spending by Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: categoryTotals.entries.map((entry) {
                    final percent = total == 0 ? 0 : (entry.value / total) * 100;
                    return PieChartSectionData(
                      value: entry.value,
                      title:
                          '${entry.key}\n${percent.toStringAsFixed(1)}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
