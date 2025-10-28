import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_app/models/transaction_model.dart';
import 'package:smart_finance_app/providers/budget_provider.dart';
import 'package:smart_finance_app/providers/theme_provider.dart';
import 'package:smart_finance_app/providers/transaction_provider.dart';
import 'package:smart_finance_app/ui/screens/settings_page.dart';
import 'package:smart_finance_app/ui/widgets/animated_gradient_background.dart';
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
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: AnimatedGradientBackground(
        isDarkMode: isDarkMode,
        child: LayoutBuilder(
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
      ),
    );
  }

  Future<dynamic> showSettingsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 56, right: 12),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 180,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Map<String, double> _getCategoryTotals(List<TransactionModel> transactions) {
    final totals = {'Food': 0.0, 'Travel': 0.0, 'Groceries': 0.0, 'Misc': 0.0};
    for (var tx in transactions) {
      if (totals.containsKey(tx.category)) {
        totals[tx.category] = totals[tx.category]! + tx.amount;
      }
    }
    return totals;
  }
}
