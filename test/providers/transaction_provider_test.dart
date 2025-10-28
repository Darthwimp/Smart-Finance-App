import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import 'package:smart_finance_app/providers/transaction_provider.dart';
import '../hive_test_setup.dart';

void main() {
  late TransactionNotifier transactionNotifier;
  late Box<TransactionModel> box;

  setUpAll(() async {
    await initHiveForTests();
    Hive.registerAdapter(TransactionModelAdapter());

    if (!Hive.isBoxOpen('transactions')) {
      box = await Hive.openBox<TransactionModel>('transactions');
    } else {
      box = Hive.box<TransactionModel>('transactions');
    }

    transactionNotifier = TransactionNotifier();
  });

  tearDown(() async {
    await box.clear();
  });

  tearDownAll(() async {
    await box.close();
    await Hive.deleteBoxFromDisk('transactions');
  });

  test('Add Transaction', () async {
    final tx = TransactionModel(
      id: '1',
      amount: 100,
      category: 'Food',
      date: DateTime.now(),
    );

    await transactionNotifier.addTransaction(tx);
    expect(box.length, 1);
    expect(box.getAt(0)?.amount, 100);
  });

  test('Update Transaction', () async {
    final tx = TransactionModel(
      id: '1',
      amount: 100,
      category: 'Food',
      date: DateTime.now(),
    );

    await transactionNotifier.addTransaction(tx);

    final updatedTx = TransactionModel(
      id: '1',
      amount: 200,
      category: 'Food',
      date: DateTime.now(),
    );

    await transactionNotifier.updateTransaction(
      transactions: [tx],
      updatedTx: updatedTx,
    );

    expect(box.getAt(0)?.amount, 200);
  });

  test('Delete Transaction', () async {
    final tx = TransactionModel(
      id: '1',
      amount: 150,
      category: 'Misc',
      date: DateTime.now(),
    );

    await transactionNotifier.addTransaction(tx);
    await transactionNotifier.deleteTransaction(0);

    expect(box.isEmpty, true);
  });
}
