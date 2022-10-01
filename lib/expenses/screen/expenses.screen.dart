import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/general.dart';
import '../cubit/expenses_cubit.dart';
import '../models/expense.model.dart';
import 'categorie.screen.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  int _selectedIndex = 0;
  // static const List<Widget> _pages = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Expense> expenses =
    //     Provider.of<ExpensesModel>(context, listen: true).expenses;
    // List<ExpenseCategory> _selectedCategories =
    //     context.read<ExpensesCubit>().selectedCategories;
    // List<Expense> gefilterdeUitgaven = context
    //     .read<ExpensesCubit>()
    //     .filterExpensesByCategory(_selectedCategories);
    // double saldo = context.read<ExpensesCubit>().total;
    // double saldo = ExpensesModel.instance.calculateTotal(_selectedCategories);

    return Scaffold(
      appBar: AppBar(
        title: const Text("KeepTrack"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_alt),
            tooltip: 'Filter Categorie',
            onPressed: () {
              _showFilterModal(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Delete All',
            onPressed: () {
              _showAlert(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<ExpensesCubit, ExpensesState>(
        builder: (context, state) {
          print(state);
          if (state is ExpensesCompleted) {
            return Column(
              children: [
                for (int i = 0; i < DateTime.monthsPerYear; i++)
                  Text(context.read<ExpensesCubit>().totalPerMonth(2022, i + 1)),
                // {
                //   let year = DateTime.now().year;
                //   let dateTime = DateTime.utc(year, i);
                //   let month = i;
                //   let str = "$year";
                //   return Text(DateTime.parse().month.toString())
                // },
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
                  child: Text('€ ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.expenses.length,
                    itemBuilder: ((context, index) {
                      final currentExpense = state.expenses[index];

                      if (index == 0) {
                        return Column(
                          children: [
                            _listHeader("Datum", "Naam", "Bedrag"),
                            _listItem(context, index, currentExpense)
                          ],
                        );
                      }

                      return _listItem(context, index, currentExpense);
                    }),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<ExpensesCubit>().importCSV,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _listHeader(String first, String second, String third) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(first),
        const SizedBox(width: 24),
        Text(second),
        const Spacer(),
        Text(third),
      ]),
    );
  }

  Widget _listItem(context, index, Expense uitgave) {
    return Card(
      child: ListTile(
        onTap: () {
          showExpenseCategoryFilter(context, uitgave);
        },
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(formatDate(uitgave.datum)),
          ],
        ),
        title: Text(uitgave.naam),
        subtitle: Row(
          children: [
            Chip(
              label: Text(uitgave.category.name),
            )
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('€ ${uitgave.bedrag}'),
          ],
        ),
        // contentPadding: const EdgeInsets.all(0),
      ),
    );
  }

  _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => ExpensesCubit(),
          child: AlertDialog(
            title: const Text("Verwijder alle uitgaven"),
            actions: [
              TextButton(
                child: const Text("Annuleer"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Builder(builder: (newContext) {
                return TextButton(
                  child: const Text("Verwijder", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    newContext.read<ExpensesCubit>().removeAll();
                    Navigator.of(context).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> _showFilterModal(context) {
    return showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext modalContext) {
          return BlocProvider(
            create: (context) => ExpensesCubit(),
            child: StatefulBuilder(
              builder: ((BuildContext context, StateSetter setModalState) {
                return Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Filter Categoriën",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                          _categoryPicker2(context, setModalState)
                          // _categoryPicker(uitgave, setModalState,
                          //     _selectedCategorie, context),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }

  Wrap _categoryPicker2(BuildContext context, StateSetter setModalState) {
    List<ExpenseCategory> selectedCategories = context.read<ExpensesCubit>().selectedCategories;
    // print(UitgavenModel.uitgavenModel.gefilterdeUitgaven(_selectedCategorie));
    return Wrap(
      spacing: 8,
      runSpacing: -4,
      children: ExpenseCategory.values
          .map<Widget>(
            (categorie) => InputChip(
              onPressed: () async {
                setModalState(() {
                  if (selectedCategories.contains(categorie)) {
                    selectedCategories.remove(categorie);
                  } else {
                    selectedCategories.add(categorie);
                  }
                  print(selectedCategories);
                });
                setState(() {
                  context.read<ExpensesCubit>().calculateEverything();
                });

                await Future.delayed(const Duration(milliseconds: 300));

                Navigator.pop(context);
              },
              labelStyle: selectedCategories.contains(categorie)
                  ? const TextStyle(color: Colors.white)
                  : null,
              backgroundColor: selectedCategories.contains(categorie) ? Colors.blue : null,
              label: Text(categorie.name),
            ),
          )
          .toList(),
    );
  }
}
