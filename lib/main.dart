import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'expenses/cubit/expenses_cubit.dart';
import 'expenses/screen/expenses.screen.dart';
import 'repository/expenses.repository.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<ExpensesRepository>(ExpensesRepository());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ahhhh yeahhhh!',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
          create: (context) => ExpensesCubit()..refreshExpenses(),
          child: const ExpensesPage()),
    );
  }
}
