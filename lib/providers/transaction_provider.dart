import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:smart_finance_app/models/transaction_model.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
      return TransactionNotifier()..loadTransactions();
    });

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionNotifier() : super([]);

  Future<void> loadTransactions() async {
    final box = await Hive.openBox<TransactionModel>('transactions');
    state = box.values.toList();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    final box = await Hive.openBox<TransactionModel>('transactions');
    await box.put(tx.id, tx);
    state = [...state, tx];
  }

  Future<void> updateTransaction({
    required List<TransactionModel> transactions,
    required TransactionModel updatedTx,
  }) async {
    final box = await Hive.openBox<TransactionModel>('transactions');
    await box.put(updatedTx.id, updatedTx);
    final updatedList = [
      for (final tx in transactions)
        if (tx.id == updatedTx.id) updatedTx else tx,
    ];
    state = updatedList;
  }

  Future<void> deleteTransaction(int index) async {
    final box = await Hive.openBox<TransactionModel>('transactions');
    final tx = state[index];
    await box.delete(tx.id);
    state = [...state]..removeAt(index);
  }
}
