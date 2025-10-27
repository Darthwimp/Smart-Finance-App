import 'package:hive/hive.dart';
part 'budget_model.g.dart';

@HiveType(typeId: 1) 
class BudgetModel extends HiveObject {

  @HiveField(0)
  final String category;

  @HiveField(1)
  final double limit;

  @HiveField(2)
  final double spent;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime endDate;

  BudgetModel({
    required this.category,
    required this.limit,
    required this.spent,
    required this.startDate,
    required this.endDate,
  });

  BudgetModel copyWith({
    String? category,
    double? limit,
    double? spent,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BudgetModel(
      category: category ?? this.category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
