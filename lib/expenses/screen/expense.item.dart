import 'package:flutter/material.dart';

import '../../utils/general.dart';
import '../models/expense.model.dart';
import 'expense.bottomsheet.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    Key? key,
    required this.context,
    required this.index,
    required this.uitgave,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final Expense uitgave;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          showExpense(context, uitgave);
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
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    uitgave.category.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: uitgave.category.color,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('€ ${uitgave.bedrag}'),
          ],
        ),
      ),
    );
  }
}
