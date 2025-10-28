import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import 'package:smart_finance_app/providers/transaction_provider.dart';
import 'transaction_tile.dart';
import 'transaction_dialog.dart';

class TransactionList extends ConsumerWidget {
  final List<TransactionModel> transactions;
  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(transactionProvider.notifier);

    return ListView.builder(
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
                    await notifier.insertTransactionAt(deletedTx, index);
                  },
                ),
              ),
            );
          },
          child: TransactionTile(
            transaction: tx,
            onTap: () => showTransactionDialog(context, ref, editTx: tx),
          ),
        );
      },
    );
  }
}
