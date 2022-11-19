part of 'expenses_cubit.dart';

abstract class ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<Expense> expenses;
  final List<ExpenseCategory> selectedCategories;
  final List<SummaryPerMonth> summaries;
  final DateTime monthAndYear;

  ExpensesLoaded({
    required this.expenses,
    required this.selectedCategories,
    required this.summaries,
    required this.monthAndYear,
  });
}
