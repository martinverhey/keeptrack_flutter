import 'expense.model.dart';

class SummaryPerMonth {
  final DateTime date;
  final ExpenseCategory category;
  final double amount;

  SummaryPerMonth({
    required this.date,
    required this.category,
    required this.amount,
  });
}
