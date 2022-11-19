import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../expenses/cubit/expenses_cubit.dart';

class MonthSelector extends StatelessWidget {
  final DateTime monthAndYear;

  const MonthSelector({
    Key? key,
    required this.monthAndYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            splashRadius: 24,
            iconSize: 32,
            onPressed: () {
              context
                  .read<ExpensesCubit>()
                  .setMonth(DateTime(monthAndYear.year, monthAndYear.month - 1));
              context.read<ExpensesCubit>().getAll();
            },
            icon: const Icon(Icons.chevron_left),
          ),
          const Spacer(),
          Text(
            DateFormat(DateFormat.MONTH).format(monthAndYear),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            splashRadius: 24,
            iconSize: 32,
            onPressed: () {
              context
                  .read<ExpensesCubit>()
                  .setMonth(DateTime(monthAndYear.year, monthAndYear.month + 1));
              context.read<ExpensesCubit>().getAll();
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
