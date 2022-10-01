import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeptrack_flutter/expenses/cubit/categories_cubit.dart';

import '../../utils/general.dart';
import '../cubit/expenses_cubit.dart';
import '../models/expense.model.dart';

Future<dynamic> showExpenseCategoryFilter(context, Expense uitgave) {
  print(uitgave);
  return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext buildcontext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ExpensesCubit()..refreshExpenses(),
            ),
            BlocProvider(
              create: (context) => CategoriesCubit()..selectCategory(uitgave.category),
            ),
          ],
          child: Builder(builder: (context) {
            // ExpenseCategory _selectedCategory = context
            //     .read<ExpensesCubit>()
            //     .expenses
            //     .where((u) => u.id == uitgave.id)
            //     .first
            //     .category;
            // print(_selectedCategory);

            return Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title(uitgave),
                      _rowTitle("Categorie"),
                      _categoryPicker(uitgave, context),
                      const SizedBox(height: 16),
                      _rowTitle("Rekening"),
                      Text(uitgave.rekening),
                      const SizedBox(height: 16),
                      _rowTitle("Mededeling"),
                      Text(uitgave.mededeling),
                    ],
                  ),
                ),
              ],
            );
          }),
        );
      });
}

_categoryPicker(Expense expense, BuildContext context) {
  return BlocBuilder<CategoriesCubit, CategoriesState>(
    builder: (context, state) {
      print(state);
      if (state is CategorySelected) {
        return Wrap(
          spacing: 8,
          runSpacing: -4,
          children: ExpenseCategory.values.map<Widget>((category) {
            if (state.selectedCategory == category) {
              return InputChip(
                onPressed: () async {
                  await _selectCategory(context, expense, category);
                },
                labelStyle: const TextStyle(color: Colors.white),
                backgroundColor: Colors.blue,
                label: Text(category.name),
              );
            } else {
              return InputChip(
                onPressed: () async {
                  await _selectCategory(context, expense, category);
                },
                label: Text(category.name),
              );
            }
          }).toList(),
        );
      }

      return const CircularProgressIndicator();
    },
  );
}

Future<void> _selectCategory(
    BuildContext context, Expense expense, ExpenseCategory category) async {
  final ExpenseCategory newCategory =
      expense.category == category ? ExpenseCategory.geen : category;
  context.read<CategoriesCubit>().selectCategory(newCategory);

  final Expense newExpense = Expense(
      id: expense.id,
      datum: expense.datum,
      naam: expense.naam,
      rekening: expense.rekening,
      tegenRekening: expense.tegenRekening,
      code: expense.code,
      afBij: expense.afBij,
      bedrag: expense.bedrag,
      mutatieSoort: expense.mutatieSoort,
      mededeling: expense.mededeling,
      category: category);
  context.read<ExpensesCubit>().update(newExpense);

  await Future.delayed(const Duration(milliseconds: 300));

  Navigator.pop(context);
}

Text _rowTitle(String title) {
  return Text(title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ));
}

Column _title(Expense uitgave) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uitgave.naam,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(formatDateFull(uitgave.datum)),
              ],
            ),
          ),
          Text(
            '€${uitgave.bedrag}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ],
  );
}
