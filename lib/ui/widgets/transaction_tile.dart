import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  const TransactionTile({super.key, required this.transaction, this.onTap});

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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(transaction.category),
          child: FaIcon(
            _getCategoryIcon(transaction.category),
            color: Colors.black87,
            size: 18,
          ),
        ),
        title: Text(transaction.category),
        subtitle: Text(
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          '- ₹${transaction.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
