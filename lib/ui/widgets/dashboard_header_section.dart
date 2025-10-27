import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final double totalExpenses;
  const HeaderSection({super.key, required this.totalExpenses});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildTotalCard(context)),
        const SizedBox(width: 10),
        if (width > 330)
          _buildAddAndViewButton(context)
        else
          // On smaller phones, stack below the card
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildAddAndViewButton(context),
          ),
      ],
    );
  }

  Widget _buildTotalCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Expenses',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              '₹${totalExpenses.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAndViewButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, '/transaction'),
      icon: const Icon(Icons.add),
      label: const Text('Add & View Transactions'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
