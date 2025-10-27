import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/budget_model.dart';
import '../../providers/budget_provider.dart';

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
      setState(() => _selectedCategory = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgets = ref.watch(budgetProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _categories
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                          .toList(),
                      decoration:
                          const InputDecoration(labelText: 'Select Category'),
                      onChanged: (val) => setState(() => _selectedCategory = val),
                      validator: (val) =>
                          val == null ? 'Select a category' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _limitController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration:
                          const InputDecoration(labelText: 'Monthly Limit'),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Enter limit'
                          : int.tryParse(val) == null
                              ? 'Enter a valid integer'
                              : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addBudget,
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final b = budgets[index];
                  final progress = b.spent / b.limit;
                  final color = progress < 0.7
                      ? Colors.green
                      : progress < 1.0
                          ? Colors.orange
                          : Colors.red;
                  return Card(
                    child: ListTile(
                      title: Text(b.category),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: progress > 1 ? 1 : progress,
                            color: color,
                            backgroundColor: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Spent: ₹${b.spent.toStringAsFixed(0)} / ₹${b.limit.toStringAsFixed(0)}',
                            style: TextStyle(color: color),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => ref
                            .read(budgetProvider.notifier)
                            .deleteBudget(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
