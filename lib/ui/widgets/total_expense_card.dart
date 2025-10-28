import 'package:flutter/material.dart';

class TotalExpenseCard extends StatelessWidget {
  final double totalExpense;
  const TotalExpenseCard({super.key, required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Total Expenses', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              '₹${totalExpense.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
