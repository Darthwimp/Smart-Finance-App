import 'package:flutter_test/flutter_test.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import '../fakes/fake_transaction_notifier.dart';

void main() {
  late FakeTransactionNotifier notifier;

  setUp(() {
    notifier = FakeTransactionNotifier();
  });

  test('Add Transaction', () async {
    final tx = TransactionModel(id: '3', amount: 100, category: 'Bills', date: DateTime.now());
    await notifier.addTransaction(tx);
    expect(notifier.state.length, 3);
    expect(notifier.state.last.amount, 100);
  });

  test('Update Transaction', () async {
    final updatedTx = TransactionModel(id: '1', amount: 2000, category: 'Food', date: DateTime.now());
    await notifier.updateTransaction(transactions: notifier.state, updatedTx: updatedTx);
    expect(notifier.state.first.amount, 2000);
  });

  test('Delete Transaction', () async {
    await notifier.deleteTransaction(0);
    expect(notifier.state.length, 1);
  });
}
