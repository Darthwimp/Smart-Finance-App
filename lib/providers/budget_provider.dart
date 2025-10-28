import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import '../models/budget_model.dart';


final budgetProvider =
    StateNotifierProvider<BudgetNotifier, List<BudgetModel>>(
  (ref) => BudgetNotifier(),
);

class BudgetNotifier extends StateNotifier<List<BudgetModel>> {
  BudgetNotifier() : super([]) {
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    final box = Hive.box<BudgetModel>('budgets');
    state = box.values.toList();
  }

  Future<void> addBudget(BudgetModel budget) async {
    final box = Hive.box<BudgetModel>('budgets');
    await box.add(budget);
    state = box.values.toList();
  }

  Future<void> updateBudget(int index, BudgetModel updated) async {
    final box = Hive.box<BudgetModel>('budgets');
    await box.putAt(index, updated);
    state = box.values.toList();
  }

  Future<void> deleteBudget(int index) async {
    final box = Hive.box<BudgetModel>('budgets');
    await box.deleteAt(index);
    state = box.values.toList();
  }

  Future<void> clearBudgets() async {
    final box = Hive.box<BudgetModel>('budgets');
    await box.clear();
    state = [];
  }
  Future<void> setBudget(BudgetModel budget) async {
    final box = await Hive.openBox<BudgetModel>('budgets');
    await box.put(budget.category, budget);
    state = [...state.where((b) => b.category != budget.category), budget];
  }
}
