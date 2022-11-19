import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeptrack_flutter/expenses/repository/expense.respository.dart';

import '../models/summary_per_month.model.dart';
import '../../main.dart';
import '../repository/expenses.repository.dart';
import '../../utils/general.dart';
import '../models/expense.model.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit() : super(ExpensesLoading());

  final ExpensesRepository _expensesRepository = getIt<ExpensesRepository>();
  final ExpenseRepository _expenseRepository = getIt<ExpenseRepository>();

  void importCSV(BuildContext context) async {
    List<Expense> importedExpenses = [];

    print("Pick file");
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      print("File picked: $file");

      final input = file.openRead();
      final rows = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter(fieldDelimiter: ';'))
          .toList();

      rows.removeAt(0);
      print('File has ${rows.length} rows (excl. header)');
      int added = 0;
      int duplicate = 0;

      await Future.forEach(rows, (row) async {
        (row as List<dynamic>);
        final uitgave = Expense(
          datum: makeDate(row[0]),
          naam: row[1],
          rekening: row[2],
          tegenRekening: row[3],
          code: row[4],
          afBij: row[5],
          bedrag: makeDouble(row[6]),
          mutatieSoort: row[7],
          mededeling: row[8],
        );

        // print(uitgave);
        if ((state as ExpensesLoaded).expenses.contains(uitgave)) {
          // print(
          //     "Already exists: ${uitgave.datum} ${uitgave.naam} ${uitgave.afBij} ${uitgave.bedrag} ${uitgave.mededeling}");
          duplicate++;
        } else {
          importedExpenses.add(uitgave);
          added++;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Done: $added added, $duplicate skipped.",
      )));
      print("Done: $added added, $duplicate skipped.");
      // inspect(importedExpenses);
      final test = await addAll(importedExpenses);
      print(test);
    } else {
      print("File picker cancelled");
    }
  }

  void setMonth(DateTime monthAndYear) {
    if (state is ExpensesLoaded) {
      _expensesRepository.monthAndYear = monthAndYear;

      ExpensesLoaded loadedState = state as ExpensesLoaded;

      emit(ExpensesLoaded(
          expenses: loadedState.expenses,
          selectedCategories: loadedState.selectedCategories,
          summaries: loadedState.summaries,
          monthAndYear: monthAndYear));
    }
  }

  List<Expense> filterExpensesByCategory(List<Expense> expenses, List<ExpenseCategory> categories) {
    if (categories.isEmpty) {
      return _sortByDateAndId(expenses);
    }

    List<Expense> filteredExpenses = [];
    for (final category in categories) {
      List<Expense> filteredByCategory = expenses.where((e) => e.category == category).toList();
      filteredExpenses.addAll(filteredByCategory);
    }
    return _sortByDateAndId(filteredExpenses);
  }

  List<Expense> _sortByDateAndId(List<Expense> expenses) {
    expenses.sort((a, b) {
      int compare = b.datum.compareTo(a.datum);
      if (compare != 0) return compare;
      return a.id!.compareTo(b.id!);
    });
    return expenses;
  }

  add(Expense expense) async {
    await _expensesRepository.add(expense);
    await getAll();
  }

  addAll(List<Expense> expenses) async {
    await Future.wait(expenses.map((expense) async {
      await _expensesRepository.add(expense);
    }));
    await getAll();
  }

  update(Expense expense) async {
    await _expensesRepository.update(expense);
    await getAll();
  }

  remove(String id) async {
    await _expensesRepository.remove(id);
    await getAll();
  }

  removeAll() async {
    await _expensesRepository.removeAll();
    await getAll();
  }

  loading() {
    final DateTime now = DateTime.now();
    _expensesRepository.monthAndYear = DateTime(now.year, now.month);
    emit(ExpensesLoading());
  }

  getAll() async {
    List<Expense> expenses = await _expensesRepository.getAll();
    List<ExpenseCategory> selectedCategories = _expenseRepository.selectedCategories;
    if (selectedCategories.isNotEmpty) {
      expenses =
          expenses.where((expense) => selectedCategories.contains(expense.category)).toList();
    }
    final DateTime monthAndYear = _expensesRepository.monthAndYear;
    inspect(expenses);
    print('REFRESH!');

    emit(ExpensesLoaded(
      expenses: expenses
          .where(
            (element) =>
                element.datum.year == monthAndYear.year &&
                element.datum.month == monthAndYear.month,
          )
          .toList(),
      selectedCategories: selectedCategories,
      summaries: selectedCategories.isEmpty
          ? summaryPerMonth(expenses, ExpenseCategory.values)
              .where((element) =>
                  element.date.year == monthAndYear.year &&
                  element.date.month == monthAndYear.month)
              .toList()
          : summaryPerMonth(expenses, selectedCategories),
      monthAndYear: _expensesRepository.monthAndYear,
    ));
  }

  void setFilter(ExpenseCategory category) {
    List<ExpenseCategory> selectedCategories = _expenseRepository.selectedCategories;
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }

    _expenseRepository.selectCategories(selectedCategories);
  }

  List<SummaryPerMonth> summaryPerMonth(
    List<Expense> expenses,
    List<ExpenseCategory> categories,
  ) {
    final List<int> years = expenses.map((expense) => expense.datum.year).toList();
    final List<int> distinctYears = [
      ...{...years}
    ];
    final List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    List<SummaryPerMonth> summaries = [];

    for (final year in distinctYears) {
      for (final month in months) {
        for (final category in categories) {
          List<Expense> categoryPerMonth = expenses
              .where((expense) =>
                  expense.category == category &&
                  expense.datum.year == year &&
                  expense.datum.month == month)
              .toList();

          summaries.add(
            SummaryPerMonth(
              category: category,
              date: DateTime(year, month),
              amount: expenseTotal(categoryPerMonth),
            ),
          );
        }
      }
    }
    return summaries;
  }

  double expenseTotal(List<Expense> expenses) {
    return expenses.fold<double>(0, (previous, next) {
      if (next.afBij == FromTo.bij.name) {
        return previous + next.bedrag;
      } else {
        return previous - next.bedrag;
      }
    });
  }
}
