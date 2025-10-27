import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final Box box;
  TransactionRepository(this.box);

  List<TransactionModel> getAll() {
    final raw = box.values.cast<Map>().map((e) {
      return e as TransactionModel;
    }).toList();
    raw.sort((a, b) => b.date.compareTo(a.date));
    return raw;
  }
  Future<void> add(TransactionModel t) async {
    await box.put(t.id, t);
  }
  Future<void> update(TransactionModel t) async {
    await box.put(t.id, t);
  }
  Future<void> delete(String id) async {
    await box.delete(id);
  }
}
