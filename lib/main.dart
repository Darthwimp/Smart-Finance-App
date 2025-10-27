import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_app/models/budget_model.dart';
import 'package:smart_finance_app/models/transaction_model.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());

  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox<BudgetModel>('budgets');

  runApp(const ProviderScope(child: SmartFinanceApp()));
}

class SmartFinanceApp extends ConsumerWidget {
  const SmartFinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Finance",
      home: Scaffold(),
    );
  }
}
