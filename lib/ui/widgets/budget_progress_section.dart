import 'package:flutter/material.dart';
import '../../models/budget_model.dart';

class BudgetProgressSection extends StatelessWidget {
  final List<BudgetModel> budgets;
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
            const Text('Budget Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...budgets.map((budget) {
              final spent = categoryTotals[budget.category] ?? 0;
              final double progress =
                  budget.limit == 0 ? 0.0 : (spent / budget.limit).clamp(0, 1.0);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${budget.category} - ₹${spent.toStringAsFixed(0)} / ₹${budget.limit.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        color: progress > 0.9
                            ? Colors.red
                            : progress > 0.7
                                ? Colors.orange
                                : Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
