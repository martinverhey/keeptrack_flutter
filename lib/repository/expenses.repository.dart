import '../expenses/models/expense.model.dart';
import '../db/expenses.db.dart';

class ExpensesRepository {
  add(Expense expense) {
    ExpensesDBProvider.db.insert(expense);
  }

  update(Expense expense) {
    ExpensesDBProvider.db.update(expense);
  }

  remove(String id) {
    ExpensesDBProvider.db.delete(id);
  }

  removeAll() {
    ExpensesDBProvider.db.deleteAll();
  }

  Future<List<Expense>> getAll() async {
    return await ExpensesDBProvider.db.expenses();
  }
}
