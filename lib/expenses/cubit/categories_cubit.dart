import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/expense.model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoryInitial());

  ExpenseCategory selectedCategory = ExpenseCategory.geen;

  selectCategory(ExpenseCategory category) {
    if (category == selectedCategory) {
      selectedCategory = ExpenseCategory.geen;
    } else {
      selectedCategory = category;
    }
    emit(CategorySelected(selectedCategory: selectedCategory));
  }

  // Future<void> getCategories() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   print(selectedCategories);
  //   final strings = selectedCategories.map((e) => e.name).toList();
  //   print(strings);
  //   prefs.setStringList('categories', strings);
  // }
}
