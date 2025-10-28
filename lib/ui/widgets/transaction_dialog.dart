import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import 'package:smart_finance_app/providers/transaction_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:smart_finance_app/providers/theme_provider.dart';

void showTransactionDialog(BuildContext context, WidgetRef ref,
    {TransactionModel? editTx}) {
  final notifier = ref.read(transactionProvider.notifier);
  final isDark = ref.read(themeProvider);
  final formKey = GlobalKey<FormState>();
  final amountController =
      TextEditingController(text: editTx?.amount.toString() ?? '');
  final categories = ['Food', 'Travel', 'Groceries', 'Misc'];
  String selectedCategory = editTx?.category ?? categories.first;
  DateTime selectedDate = editTx?.date ?? DateTime.now();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(editTx == null ? 'Add Transaction' : 'Edit Transaction'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Icon(FontAwesomeIcons.indianRupeeSign, size: 16),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(
                                cat == 'Food'
                                    ? FontAwesomeIcons.utensils
                                    : cat == 'Travel'
                                        ? FontAwesomeIcons.plane
                                        : cat == 'Groceries'
                                            ? FontAwesomeIcons.cartShopping
                                            : FontAwesomeIcons.coins,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(cat),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) selectedCategory = value;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.listUl, size: 16),
                    labelText: 'Category',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(FontAwesomeIcons.calendarDay, size: 16),
                    const SizedBox(width: 8),
                    Text(DateFormat.yMMMd().format(selectedDate)),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(FontAwesomeIcons.calendarPlus, size: 14),
                      label: const Text('Select'),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          selectedDate = picked;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.blue,
              ),
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? Colors.blue[400] : Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final amount = double.parse(amountController.text);
                final newTx = TransactionModel(
                  id: editTx?.id ?? const Uuid().v4(),
                  amount: amount,
                  category: selectedCategory,
                  date: selectedDate,
                );
                if (editTx == null) {
                  await notifier.addTransaction(newTx);
                } else {
                  await notifier.updateTransaction(
                    transactions: ref.read(transactionProvider),
                    updatedTx: newTx,
                  );
                }
                Navigator.pop(context);
              }
            },
            icon: Icon(
              editTx == null ? FontAwesomeIcons.plus : FontAwesomeIcons.floppyDisk,
              size: 14,
            ),
            label: Text(editTx == null ? 'Add' : 'Save'),
          ),
        ],
      );
    },
  );
}
