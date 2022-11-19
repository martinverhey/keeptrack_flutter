import '../models/expense.model.dart';

class ExpenseRepository {
  List<ExpenseCategory> selectedCategories = [];

  selectCategories(List<ExpenseCategory> categories) {
    selectedCategories = categories;
  }
}
