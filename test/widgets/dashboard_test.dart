import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import 'package:smart_finance_app/models/budget_model.dart';
import 'package:smart_finance_app/ui/screens/dashboard.dart';

Future<void> _initHiveOnce() async {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(BudgetModelAdapter());
  }

  final dir = await Directory.systemTemp.createTemp('hive_test');
  Hive.init(dir.path);

  if (!Hive.isBoxOpen('transactions')) {
    await Hive.openBox<TransactionModel>('transactions');
  }
  if (!Hive.isBoxOpen('budgets')) {
    await Hive.openBox<BudgetModel>('budgets');
  }
}

Future<void> _seedTestData() async {
  final tBox = Hive.box<TransactionModel>('transactions');
  final bBox = Hive.box<BudgetModel>('budgets');
  await tBox.clear();
  await bBox.clear();

  final now = DateTime.now();

  await tBox.putAll({
    '1': TransactionModel(id: '1', amount: 1000, category: 'Food', date: now),
    '2': TransactionModel(id: '2', amount: 500, category: 'Travel', date: now),
  });
}

void main() {
  setUpAll(() async {
    await _initHiveOnce();
    await _seedTestData();
  });

  tearDownAll(() async {
    final tBox = Hive.box<TransactionModel>('transactions');
    final bBox = Hive.box<BudgetModel>('budgets');
    await tBox.clear();
    await bBox.clear();
  });

  testWidgets('Dashboard displays correct total expenses and balance',
      (WidgetTester tester) async {
    if (!Hive.isBoxOpen('transactions') || !Hive.isBoxOpen('budgets')) {
      await _initHiveOnce();
      await _seedTestData();
    }

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('₹1500'), findsOneWidget);
    expect(find.text('Total Expenses'), findsOneWidget);
    expect(find.text('Remaining Balance'), findsOneWidget);
  });
}
