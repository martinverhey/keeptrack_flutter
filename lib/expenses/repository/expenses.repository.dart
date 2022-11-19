import '../models/expense.model.dart';
import '../db/expenses.db.dart';

class ExpensesRepository {
  late DateTime monthAndYear;
  add(Expense expense) async {
    try {
      await ExpensesDBProvider.db.insert(expense);
    } catch (e) {
      print(e);
    }
  }

  update(Expense expense) async {
    try {
      await ExpensesDBProvider.db.update(expense);
    } catch (e) {
      print(e);
    }
  }

  remove(String id) async {
    try {
      await ExpensesDBProvider.db.delete(id);
    } catch (e) {
      print(e);
    }
  }

  removeAll() async {
    try {
      await ExpensesDBProvider.db.deleteAll();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Expense>> getAll() async {
    List<Expense> expenses = [];
    try {
      expenses = await ExpensesDBProvider.db.expenses();
    } catch (e) {
      print(e);
    }
    return expenses;
  }
}
