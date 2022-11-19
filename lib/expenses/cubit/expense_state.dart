part of '../../expenses/cubit/expense_cubit.dart';

@immutable
abstract class ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseCategory> selectedCategories;

  ExpenseLoaded({required this.selectedCategories});
}
