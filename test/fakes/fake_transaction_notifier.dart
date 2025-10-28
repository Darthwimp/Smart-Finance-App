import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_finance_app/models/transaction_model.dart';

class FakeTransactionNotifier extends StateNotifier<List<TransactionModel>> {
  FakeTransactionNotifier()
      : super([
          TransactionModel(
            id: '1',
            amount: 1000,
            category: 'Food',
            date: DateTime.now(),
          ),
          TransactionModel(
            id: '2',
            amount: 500,
            category: 'Travel',
            date: DateTime.now(),
          ),
        ]);

  Future<void> addTransaction(TransactionModel tx) async {
    state = [...state, tx];
  }

  Future<void> updateTransaction({
    required List<TransactionModel> transactions,
    required TransactionModel updatedTx,
  }) async {
    final updatedList = state.map((t) => t.id == updatedTx.id ? updatedTx : t).toList();
    state = updatedList;
  }

  Future<void> deleteTransaction(int index) async {
    final list = [...state]..removeAt(index);
    state = list;
  }
}
