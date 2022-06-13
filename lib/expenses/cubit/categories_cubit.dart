import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  final List<ExpenseCategory> selectedCategories = [];

  selectCategory(ExpenseCategory category) {
    print('Current selected Categories:');
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    emit(CategoriesSelected(categories: selectedCategories));
  }

  // Future<void> getCategories() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   print(selectedCategories);
  //   final strings = selectedCategories.map((e) => e.name).toList();
  //   print(strings);
  //   prefs.setStringList('categories', strings);
  // }
}
