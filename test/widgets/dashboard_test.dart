// test/widgets/dashboard_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import 'package:smart_finance_app/providers/transaction_provider.dart';
import 'package:smart_finance_app/ui/screens/dashboard.dart';

import '../hive_test_setup.dart';

class FakeTransactionNotifier extends TransactionNotifier {
  FakeTransactionNotifier()
      : super() {
    state = [
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
    ];
  }
}

void main() {
  testWidgets('Dashboard displays correct total expenses and balance', (WidgetTester tester) async {
    await initHiveForTests(); 

    final container = ProviderContainer(
      overrides: [
        transactionProvider.overrideWith((ref) => FakeTransactionNotifier()),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('₹1500'), findsOneWidget);
    expect(find.text('Remaining Balance'), findsOneWidget);
    expect(find.text('Total Expenses'), findsOneWidget);
  });
}
