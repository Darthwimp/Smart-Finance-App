import 'package:flutter/material.dart';
import 'package:smart_finance_app/ui/screens/budget_page.dart';

class BudgetProgressSection extends StatelessWidget {
  final List budgets;
  final Map<String, double> categoryTotals;

  const BudgetProgressSection({
    super.key,
    required this.budgets,
    required this.categoryTotals,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Budgets',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BudgetPage()),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Set / Edit Budget'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            budgets.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('No budgets set yet.'),
                    ),
                  )
                : Column(
                    children: budgets.map<Widget>((budget) {
                      final spent = categoryTotals[budget.category] ?? 0;
                      final ratio = spent / budget.limit;
                      final color = ratio < 0.7
                          ? Colors.green
                          : ratio < 1
                              ? Colors.orange
                              : Colors.red;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${budget.category} — ₹${spent.toStringAsFixed(2)} / ₹${budget.limit.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: ratio.clamp(0, 1),
                              color: color,
                              backgroundColor: Colors.grey.shade300,
                              minHeight: 8,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
