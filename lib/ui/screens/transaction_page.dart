import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import 'package:smart_finance_app/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final notifier = ref.read(transactionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Dismissible(
                  key: Key(tx.id),
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    final deletedTx = tx;
                    await notifier.deleteTransaction(index);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Transaction deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () async {
                            await notifier.addTransaction(deletedTx);
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(tx.category[0]),
                      ),
                      title: Text(tx.category),
                      subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                      trailing: Text(
                        '₹${tx.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        _showTransactionDialog(context, ref, editTx: tx);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTransactionDialog(context, ref),
        label: const Text('Add Transaction'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // Dialog for adding or editing a transaction
  void _showTransactionDialog(BuildContext context, WidgetRef ref,
      {TransactionModel? editTx}) {
    final notifier = ref.read(transactionProvider.notifier);

    final formKey = GlobalKey<FormState>();
    final amountController =
        TextEditingController(text: editTx?.amount.toString() ?? '');
    final categories = ['Food', 'Travel', 'Groceries', 'Bills', 'Misc'];
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
                    keyboardType: TextInputType.number,
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
                        updatedTx: newTx);
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
}
