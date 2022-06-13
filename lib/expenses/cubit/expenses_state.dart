part of 'expenses_cubit.dart';

@immutable
abstract class ExpensesState {}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesCompleted extends ExpensesState {
  final List<Expense> expenses;

  ExpensesCompleted({required this.expenses});
}
