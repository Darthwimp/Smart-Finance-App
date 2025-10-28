import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_finance_app/providers/theme_provider.dart';
import 'package:smart_finance_app/ui/widgets/animated_gradient_background.dart';
import '../../models/budget_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/budget_provider.dart';
import 'package:hive/hive.dart';

class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage({super.key});
  @override
  ConsumerState<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  final _categories = ['Food', 'Travel', 'Groceries', 'Misc'];
  String? _selectedCategory;

  void _addBudgetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add Budget'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Row(
                            children: [
                              Icon(
                                c == 'Food'
                                    ? FontAwesomeIcons.utensils
                                    : c == 'Travel'
                                    ? FontAwesomeIcons.plane
                                    : c == 'Groceries'
                                    ? FontAwesomeIcons.cartShopping
                                    : FontAwesomeIcons.coins,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(c),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.listUl, size: 16),
                    labelText: 'Select Category',
                  ),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  validator: (val) => val == null ? 'Select a category' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _limitController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.indianRupeeSign,
                      size: 16,
                    ),
                    labelText: 'Monthly Limit',
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Enter limit'
                      : int.tryParse(val) == null
                      ? 'Enter a valid integer'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _limitController.clear();
                _selectedCategory = null;
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: _addBudget,
              icon: const Icon(FontAwesomeIcons.plus, size: 14),
              label: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addBudget() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final limit = int.tryParse(_limitController.text.trim())?.toDouble() ?? 0;
      final budget = BudgetModel(
        category: _selectedCategory!,
        limit: limit,
        spent: 0,
        startDate: DateTime.now(),
        endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      );
      await ref.read(budgetProvider.notifier).addBudget(budget);
      _limitController.clear();
      _selectedCategory = null;
      if (mounted) Navigator.pop(context);
    }
  }

  double _calculateSpentForCategory(String category) {
    final transactionsBox = Hive.box<TransactionModel>('transactions');
    double totalSpent = 0;
    for (var transaction in transactionsBox.values) {
      if (transaction.category == category) totalSpent += transaction.amount;
    }
    return totalSpent;
  }

  @override
  Widget build(BuildContext context) {
    final budgets = ref.watch(budgetProvider);
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBudgetDialog,
        child: const Icon(FontAwesomeIcons.plus),
      ),
      body: AnimatedGradientBackground(
        isDarkMode: isDarkMode,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: budgets.isEmpty
              ? const Center(
                  child: Text(
                    'No budgets yet. Tap + to add one!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    final b = budgets[index];
                    final spent = _calculateSpentForCategory(b.category);
                    final progress = (b.limit == 0) ? 0 : spent / b.limit;
                    final color = progress < 0.7
                        ? Colors.green
                        : progress < 1.0
                        ? Colors.orange
                        : Colors.red;
                    final icon = b.category == 'Food'
                        ? FontAwesomeIcons.utensils
                        : b.category == 'Travel'
                        ? FontAwesomeIcons.plane
                        : b.category == 'Groceries'
                        ? FontAwesomeIcons.cartShopping
                        : FontAwesomeIcons.coins;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withOpacity(0.15),
                          child: Icon(icon, color: color, size: 18),
                        ),
                        title: Text(
                          b.category,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: (progress > 1 ? 1.0 : progress.toDouble()),
                              color: color,
                              backgroundColor: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Spent: ₹${spent.toStringAsFixed(0)} / ₹${b.limit.toStringAsFixed(0)}',
                              style: TextStyle(color: color, fontSize: 13),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(FontAwesomeIcons.trashCan, size: 18),
                          onPressed: () => ref
                              .read(budgetProvider.notifier)
                              .deleteBudget(index),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
