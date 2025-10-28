import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import 'package:smart_finance_app/providers/budget_provider.dart';
import 'package:smart_finance_app/providers/transaction_provider.dart';
import 'package:smart_finance_app/ui/widgets/budget_progress_section.dart';
import 'package:smart_finance_app/ui/widgets/dashboard_header_section.dart';
import 'package:smart_finance_app/ui/widgets/recent_transactions_list.dart';
import 'package:smart_finance_app/ui/widgets/spending_chart_section.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetProvider);
    final transactions = ref.watch(transactionProvider);

    final totalExpenses = transactions.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    final categoryTotals = _getCategoryTotals(transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final padding = width < 400 ? 12.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(totalExpenses: totalExpenses),
                const SizedBox(height: 20),
                SpendingChartSection(categoryTotals: categoryTotals),
                const SizedBox(height: 20),
                BudgetProgressSection(
                  budgets: budgets,
                  categoryTotals: categoryTotals,
                  
                ),
                const SizedBox(height: 20),
                RecentTransactionsSection(transactions: transactions),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, double> _getCategoryTotals(List<TransactionModel> transactions) {
    final totals = {
      'Food': 0.0,
      'Travel': 0.0,
      'Groceries': 0.0,
      'Misc': 0.0,
    };
    for (var tx in transactions) {
      if (totals.containsKey(tx.category)) {
        totals[tx.category] = totals[tx.category]! + tx.amount;
      }
    }
    return totals;
  }
}
