import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../main.dart';
import '../../repository/expenses.repository.dart';
import '../../utils/general.dart';
import '../models/expense.model.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit() : super(ExpensesInitial());

  var expensesRepository = getIt<ExpensesRepository>();

  List<Expense> expenses = [];
  double total = 0.0;
  int selectedMonth = 0;
  List<ExpenseCategory> selectedCategories = [];
  Map<ExpenseCategory, Object> all = {};

  void importCSV() async {
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
      var added = 0;
      var duplicate = 0;

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
        if (expenses.contains(uitgave)) {
          // print(
          //     "Already exists: ${uitgave.datum} ${uitgave.naam} ${uitgave.afBij} ${uitgave.bedrag} ${uitgave.mededeling}");
          duplicate++;
        } else {
          await add(uitgave);
          added++;
        }
      });

      // TODO: Add Snackbar back into VIEW
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //   "Done: $added added, $duplicate skipped.",
      // )));
      print("Done: $added added, $duplicate skipped.");
    } else {
      print("File picker cancelled");
    }
  }

  List<Expense> filterExpensesByCategory(List<ExpenseCategory> categories) {
    if (categories.isEmpty) {
      return _sortByDateAndId(expenses);
    }

    List<Expense> filteredExpenses = [];
    for (final category in categories) {
      Iterable<Expense> filteredByCategory =
          expenses.where((element) => element.category == category);
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

  Map<String, double> _totalPricePerCategory() {
    var totalPerCategory = <String, double>{};
    for (final category in ExpenseCategory.values) {
      final _saldo = _calculateTotal([category]);
      totalPerCategory[category.name] = _saldo;
    }
    return totalPerCategory;
  }

  String totalPerMonth(int year, int month) {
    final _month = DateTime.utc(year, month);
    final _monthStr = DateFormat.MMM().format(_month);
    if (all.isNotEmpty) {
      return _monthStr +
          ': ' +
          (all[ExpenseCategory.extraMartin] as Map)[year][month].toString();
    } else {
      return "";
    }
  }

  void calculateEverything() {
    total = _calculateTotal(selectedCategories);
    print('Total: $total');

    final pricePerCategory = _totalPricePerCategory();
    print('Price per category: $pricePerCategory');

    if (selectedCategories.isNotEmpty) {
      for (final category in selectedCategories) {
        final maandOverzicht = pricePerCategoryPerMonth(category);
        all[category] = maandOverzicht;
        final currentMonth = DateTime.now().month;
      }
      print(all);
      // print((all[Category.extraMartin] as Map)[2022][2]);
    }
  }

  Map<int, Object> pricePerCategoryPerMonth(ExpenseCategory categorie) {
    final years = expenses.map((e) => e.datum.year);
    final distinctYears = [
      ...{...years}
    ];
    final months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    var saldoPerJaar = <int, Object>{};
    var saldoPerMaand = <int, double>{};
    for (final year in distinctYears) {
      saldoPerMaand = {};
      for (final month in months) {
        saldoPerMaand[month] = _berekenSaldoPerMaand(categorie, year, month);
      }
      saldoPerJaar[year] = saldoPerMaand;
    }
    return saldoPerJaar;
  }

  double _berekenSaldoPerMaand(ExpenseCategory category, int jaar, int maand) {
    List<Expense> _expenses = expenses
        .where((element) =>
            element.category == category &&
            element.datum.year == jaar &&
            element.datum.month == maand)
        .toList();
    // print("Saldo per $maand = $saldo");
    return addAndSubstractExpenses(_expenses);
  }

  double _calculateTotal(List<ExpenseCategory> categories) {
    if (categories.isEmpty) {
      return addAndSubstractExpenses(expenses);
    }

    var _filteredExpenses = <Expense>[];
    for (final category in categories) {
      _filteredExpenses.addAll(
        expenses.where((e) => e.category == category).toList(),
      );
    }
    return addAndSubstractExpenses(_filteredExpenses);
  }

  double addAndSubstractExpenses(List<Expense> expenses) {
    return expenses.fold<double>(0, (previous, next) {
      if (next.afBij == AfBij.bij.name) {
        return previous + next.bedrag;
      } else {
        return previous - next.bedrag;
      }
    });
  }

  add(Expense expense) async {
    emit(ExpensesLoading());
    expensesRepository.add(expense);
    refreshExpenses();
  }

  update(Expense expense) {
    emit(ExpensesLoading());
    expensesRepository.update(expense);
    refreshExpenses();
  }

  remove(String id) {
    emit(ExpensesLoading());
    expensesRepository.remove(id);
    refreshExpenses();
  }

  removeAll() {
    emit(ExpensesLoading());
    expensesRepository.removeAll();
    refreshExpenses();
  }

  void refreshExpenses() async {
    expenses = await expensesRepository.getAll();
    calculateEverything();
    emit(ExpensesCompleted(expenses: expenses));
  }
}
