import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/expense.model.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseLoading());

  void selectCategory(ExpenseCategory category) {
    emit(ExpenseLoaded(selectedCategories: [category]));
  }
}
