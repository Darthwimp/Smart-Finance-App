import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import 'package:smart_finance_app/providers/transaction_provider.dart';
import 'package:uuid/uuid.dart';

void showTransactionDialog(BuildContext context, WidgetRef ref,
    {TransactionModel? editTx}) {
  final notifier = ref.read(transactionProvider.notifier);
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
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                  initialValue: selectedCategory,
                  items: categories
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) selectedCategory = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    Text(DateFormat.yMMMd().format(selectedDate)),
                    const Spacer(),
                    TextButton(
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
                      child: const Text('Select'),
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
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
            child: Text(editTx == null ? 'Add' : 'Save'),
          ),
        ],
      );
    },
  );
}
