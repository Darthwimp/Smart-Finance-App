import 'package:hive/hive.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.date
  });

  TransactionModel copyWith({double? amount, String? category, DateTime? date}) {
    return TransactionModel(
      id: id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date
    );
  }
}
