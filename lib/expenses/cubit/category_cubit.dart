import 'package:bloc/bloc.dart';
import 'package:keeptrack_flutter/expenses/models/expense.model.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryDefault());

  selectCategory(ExpenseCategory category) {
    emit(CategorySelected());
  }

  deselectCategory(ExpenseCategory category) {
    emit(CategoryDefault());
  }
}
