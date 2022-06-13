import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'expenses/models/expense.model.dart';

class ExpensesDBProvider {
  static final ExpensesDBProvider db = ExpensesDBProvider();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await openDb();
    return _database!;
  }

  Future openDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'keeptrack.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, datum INTEGER, naam TEXT, rekening TEXT, tegenRekening TEXT, code TEXT, afBij TEXT, bedrag REAL, mutatieSoort TEXT, mededeling TEXT, category TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insert(Expense expense) async {
    final db = await database;

    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    // print("DB insert: " + uitgave.toString());
  }

  Future<List<Expense>> expenses() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('expenses');

    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        datum: DateTime.fromMillisecondsSinceEpoch(maps[i]['datum']),
        naam: maps[i]['naam'],
        rekening: maps[i]['rekening'],
        tegenRekening: maps[i]['tegenRekening'],
        code: maps[i]['code'],
        afBij: maps[i]['afBij'],
        bedrag: maps[i]['bedrag'],
        mutatieSoort: maps[i]['mutatieSoort'],
        mededeling: maps[i]['mededeling'],
        category: ExpenseCategory.values.firstWhere(
          (c) => c.toString() == maps[i]['category'],
        ),
      );
    });
  }

  Future<void> update(Expense expense) async {
    final db = await database;

    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );

    // print("DB update: " + uitgave.toString());
  }

  Future<void> delete(String id) async {
    final db = await database;

    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );

    // print("DB delete (id): " + id.toString());
  }

  Future<void> deleteAll() async {
    final db = await database;

    await db.delete('expenses');

    // print("DB delete all");
  }
}
