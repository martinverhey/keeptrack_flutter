import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../expenses/cubit/expenses_cubit.dart';

Future<void> showDeleteAllWarning(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext alertContext) {
      return BlocProvider.value(
        value: BlocProvider.of<ExpensesCubit>(context),
        child: AlertDialog(
          title: const Text("Verwijder alle uitgaven"),
          actions: [
            TextButton(
              child: const Text("Annuleer"),
              onPressed: () {
                Navigator.of(alertContext).pop();
              },
            ),
            TextButton(
              child: const Text("Verwijder", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(alertContext).pop();
                await context.read<ExpensesCubit>().removeAll();
              },
            ),
          ],
        ),
      );
    },
  );
}
