import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keeptrack_flutter/expenses/repository/expense.respository.dart';

import 'expenses/repository/expenses.repository.dart';
import 'expenses/screen/expenses.page.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<ExpensesRepository>(ExpensesRepository());
  getIt.registerSingleton<ExpenseRepository>(ExpenseRepository());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ahhhh yeahhhh!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExpensesPage(),
    );
  }
}
