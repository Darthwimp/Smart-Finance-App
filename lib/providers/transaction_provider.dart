import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>(
      (ref) => TransactionNotifier(),
    );

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionNotifier() : super([]) {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final box = Hive.box<TransactionModel>('transactions');
    state = box.values.toList();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final box = Hive.box<TransactionModel>('transactions');
    await box.add(transaction);
    state = box.values.toList();
  }

  Future<void> updateTransaction({
    required List<TransactionModel> transactions,
    required TransactionModel updatedTx,
  }) async {
    final box = Hive.box<TransactionModel>('transactions');
    final index = transactions.indexWhere((tx) => tx.id == updatedTx.id);
    if (index != -1) {
      await box.putAt(index, updatedTx);
      state = box.values.toList();
    }
  }

  Future<void> deleteTransaction(int index) async {
    final box = Hive.box<TransactionModel>('transactions');
    await box.deleteAt(index);
    state = box.values.toList();
  }

  Future<void> clearTransactions() async {
    final box = Hive.box<TransactionModel>('transactions');
    await box.clear();
    state = [];
  }
}
