import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeptrack_flutter/expenses/cubit/expense_cubit.dart';

import '../../../utils/general.dart';
import '../../../expenses/cubit/expenses_cubit.dart';
import '../models/expense.model.dart';

Future<dynamic> showExpense(expenseContext, Expense expense) {
  print(expense);
  return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: expenseContext,
      builder: (BuildContext modalContext) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(expense),
                  _rowTitle("Categorie"),
                  _categoryPicker(expense, expenseContext),
                  const SizedBox(height: 16),
                  _rowTitle("Rekening"),
                  Text(expense.rekening),
                  const SizedBox(height: 16),
                  _rowTitle("Mededeling"),
                  Text(expense.mededeling),
                ],
              ),
            ),
          ],
        );
      });
}

Widget _categoryPicker(Expense expense, BuildContext expenseContext) {
  return MultiBlocProvider(
    providers: [
      BlocProvider.value(
        value: BlocProvider.of<ExpensesCubit>(expenseContext),
      ),
      BlocProvider(
        create: (context) => ExpenseCubit()..selectCategory(expense.category), // TODO: klopt dit?
      ),
    ],
    child: BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        print(state);
        if (state is ExpenseLoaded) {
          return Wrap(
            spacing: 8,
            children: [
              for (final category in ExpenseCategory.values)
                InputChip(
                  onPressed: () async {
                    await _selectCategory(context, expense, category);
                  },
                  label: Text(
                    category.name,
                    style: state.selectedCategories.contains(category)
                        ? const TextStyle(color: Colors.white)
                        : null,
                  ),
                  backgroundColor:
                      state.selectedCategories.contains(category) ? category.color : null,
                ),
            ],
          );
        }

        return const CircularProgressIndicator();
      },
    ),
  );
}

Future<void> _selectCategory(
  BuildContext context,
  Expense expense,
  ExpenseCategory category,
) async {
  final ExpenseCategory newCategory =
      expense.category == category ? ExpenseCategory.geen : category;

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

  context.read<ExpenseCubit>().selectCategory(newCategory);
  await context.read<ExpensesCubit>().update(newExpense);

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
