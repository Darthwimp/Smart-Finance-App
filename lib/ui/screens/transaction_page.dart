import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_app/providers/transaction_provider.dart';
import 'package:smart_finance_app/ui/widgets/transaction_dialog.dart';
import 'package:smart_finance_app/ui/widgets/transaction_list.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions yet.'))
          : TransactionList(transactions: transactions),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTransactionDialog(context, ref),
        label: const Text('Add Transaction'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
