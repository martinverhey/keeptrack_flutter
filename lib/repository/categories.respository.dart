import '../expenses/models/expense.model.dart';

class CategoriesRepository {
  final List<ExpenseCategory> categories = [];

  saveSelectedCategories(List<ExpenseCategory> categories) {
    categories = categories;
  }
}
