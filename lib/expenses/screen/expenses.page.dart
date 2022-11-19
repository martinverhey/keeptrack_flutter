import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keeptrack_flutter/expenses/cubit/expense_cubit.dart';
import 'package:keeptrack_flutter/components/category_filter.dart';

import '../../components/chart.dart';
import '../../components/delete_alert.dart';
import '../../components/month_selector.dart';
import '../cubit/expenses_cubit.dart';
import 'expenses.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExpensesCubit()
            ..loading()
            ..getAll(),
        ),
        BlocProvider(
          create: (context) => ExpenseCubit(),
        ),
      ],
      child: BlocBuilder<ExpensesCubit, ExpensesState>(
        builder: (context, state) {
          print(state);
          if (state is ExpensesLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("KeepTrack"),
                actions: _actions(context),
              ),
              body: Column(
                children: [
                  MonthSelector(monthAndYear: state.monthAndYear),
                  Chart(selectedCategories: state.selectedCategories),
                  CategoryFilter(selectedCategories: state.selectedCategories),
                  Expenses(expenses: state.expenses),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text("KeepTrack"),
              actions: _actions(context),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _actions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.file_upload_outlined),
        tooltip: 'File upload',
        onPressed: () => context.read<ExpensesCubit>().importCSV(context),
      ),
      IconButton(
        icon: const Icon(Icons.delete_forever),
        tooltip: 'Delete All',
        onPressed: () => showDeleteAllWarning(context),
      ),
    ];
  }
}
