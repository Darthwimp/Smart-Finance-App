import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecentTransactionsSection extends StatelessWidget {
  final List<TransactionModel> transactions;
  const RecentTransactionsSection({super.key, required this.transactions});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return FontAwesomeIcons.utensils;
      case 'Travel':
        return FontAwesomeIcons.plane;
      case 'Groceries':
        return FontAwesomeIcons.cartShopping;
      case 'Bills':
        return FontAwesomeIcons.fileInvoiceDollar;
      case 'Misc':
        return FontAwesomeIcons.sackDollar;
      default:
        return FontAwesomeIcons.wallet;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange.shade100;
      case 'Travel':
        return Colors.blue.shade100;
      case 'Groceries':
        return Colors.green.shade100;
      case 'Bills':
        return Colors.purple.shade100;
      case 'Misc':
        return Colors.grey.shade300;
      default:
        return Colors.teal.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recent = transactions.take(10).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: double.maxFinite),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (recent.isEmpty)
              const Text('No transactions yet.'),
            ...recent.map(
              (tx) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: _getCategoryColor(tx.category),
                  child: FaIcon(
                    _getCategoryIcon(tx.category),
                    color: Colors.black87,
                    size: 18,
                  ),
                ),
                title: Text(tx.category),
                subtitle: Text(
                  '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  '- ₹${tx.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
