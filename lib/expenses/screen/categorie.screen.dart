import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeptrack_flutter/expenses/cubit/categories_cubit.dart';

import '../../utils/general.dart';
import '../cubit/category_cubit.dart';
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
              create: (context) => CategoriesCubit(),
            ),
            BlocProvider(
              create: (context) => CategoryCubit(),
            ),
          ],
          child: Builder(builder: (context) {
            final _selectedCategories =
                context.read<CategoriesCubit>().selectedCategories;
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
                      _categoryPicker(uitgave, _selectedCategories, context),
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

_categoryPicker(Expense uitgave, List<ExpenseCategory> selectedCategories,
    BuildContext context) {
  return BlocBuilder<CategoryCubit, CategoryState>(
    builder: (context, state) {
      return Wrap(
        spacing: 8,
        runSpacing: -4,
        children: ExpenseCategory.values.map<Widget>((category) {
          if (state is CategoriesSelected) {
            print('State selected');
            return InputChip(
              onPressed: () async {
                // TODO: Categories Cubit
                await _selectCategory(context, category);
              },
              labelStyle: const TextStyle(color: Colors.white),
              backgroundColor: Colors.blue,
              label: Text(category.name + 'ASDLJASJDKJASD'),
            );
          }

          print('State initial');
          return InputChip(
            onPressed: () async {
              // TODO: Expenses Cubit
              // context
              //     .read<ExpensesCubit>()
              //     .expenses
              //     .where((e) => e.naam == uitgave.naam)
              //     .forEach((u) {
              //   context.read<ExpensesCubit>().update(
              //         Expense(
              //           id: u.id,
              //           datum: u.datum,
              //           naam: u.naam,
              //           rekening: u.rekening,
              //           tegenRekening: u.tegenRekening,
              //           code: u.code,
              //           afBij: u.afBij,
              //           bedrag: u.bedrag,
              //           mutatieSoort: u.mutatieSoort,
              //           mededeling: u.mededeling,
              //           category: category,
              //         ),
              //       );
              // });

              // TODO: Categories Cubit
              // _selectedCategory = category;

              await _selectCategory(context, category);
            },
            label: Text(category.name),
          );
        }).toList(),
      );
    },
  );
}

Future<void> _selectCategory(
    BuildContext context, ExpenseCategory category) async {
  context.read<CategoryCubit>().selectCategory(category);

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
            '€' + uitgave.bedrag.toString(),
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
