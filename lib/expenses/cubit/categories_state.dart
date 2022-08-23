part of 'categories_cubit.dart';

@immutable
abstract class CategoriesState {}

class CategoryInitial extends CategoriesState {}

class CategorySelected extends CategoriesState {
  final ExpenseCategory selectedCategory;

  CategorySelected({required this.selectedCategory});
}
