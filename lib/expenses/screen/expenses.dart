import 'package:flutter/material.dart';

import '../models/expense.model.dart';
import 'expense.item.dart';

class Expenses extends StatelessWidget {
  final List<Expense> expenses;
  const Expenses({Key? key, required this.expenses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: expenses.length,
        itemBuilder: ((context, index) {
          final currentExpense = expenses[index];

          if (index == 0) {
            return Column(
              children: [
                _listHeader("Datum", "Naam", "Bedrag"),
                ExpenseItem(
                  context: context,
                  index: index,
                  uitgave: currentExpense,
                )
              ],
            );
          }

          return ExpenseItem(
            context: context,
            index: index,
            uitgave: currentExpense,
          );
        }),
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
}
