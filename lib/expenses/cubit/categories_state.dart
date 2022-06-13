part of 'categories_cubit.dart';

@immutable
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesSelected extends CategoriesState {
  final List<ExpenseCategory> categories;

  CategoriesSelected({required this.categories});
}
