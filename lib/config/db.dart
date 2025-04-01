import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/utils/color_utils.dart';
import 'package:pobre_simulator/utils/style_presets.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static final DB _instance = DB._();
  static Database? _db;

  DB._();

  factory DB() => _instance;

  static const String _databaseName = 'pobresimulator.db';
  static const int _databaseVersion = 1;

  static const String generalTable = 'GENERAL';
  static const String accountTable = 'ACCOUNT';
  static const String cardTable = 'CARD';
  static const String categoryTable = 'CATEGORY';
  static const String transactionTable = 'TRANSACTIONS';

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    _createAccountTable(db);
    _createCardTable(db);
    _createCategoryTable(db);
    _createTransactionTable(db);

    _createDefaultEntries(db);
  }

  Future<List<Map<String, dynamic>>> select() async {
    List<Map<String, dynamic>> result = [];

    return result;
  }

  Future<void> _createAccountTable(Database db) async {
    await db.execute(
      'CREATE TABLE $accountTable '
      '(id INTEGER PRIMARY KEY '
      'AUTOINCREMENT,'
      ' name TEXT,'
      ' amount REAL,'
      ' color INTEGER,'
      ' instituition INTEGER)',
    );
  }

  Future<void> _createCardTable(Database db) async {
    await db.execute(
      'CREATE TABLE $cardTable '
      '(id INTEGER PRIMARY KEY '
      'AUTOINCREMENT,'
      ' card_limit TEXT,'
      ' instituition INTEGER,'
      ' description TEXT,'
      ' card_brand,'
      ' account_number TEXT,'
      ' card_closing DATE, '
      ' card_expiration DATE)',
    );
  }

  Future<void> _createCategoryTable(Database db) async {
    await db.execute(
      'CREATE TABLE $categoryTable '
      '(id INTEGER PRIMARY KEY '
      'AUTOINCREMENT,'
      ' name TEXT,'
      ' type TEXT,'
      ' color INTEGER,'
      ' icon INTEGER)',
    );
  }

  Future<void> _createTransactionTable(Database db) async {
    await db.execute(
      'CREATE TABLE $transactionTable '
      ' (id INTEGER PRIMARY KEY '
      'AUTOINCREMENT, '
      ' date DATE, '
      ' description TEXT, '
      ' type TEXT, '
      ' category INTEGER, '
      ' amount REAL)',
    );
  }

  Future<void> _createDefaultEntries(Database db) async {
    await db.insert(categoryTable, {
      'id': 1,
      'name': 'Saída',
      'type': CategoryType.expense.db,
      'color': CategoryType.expense.color.toInt(),
      'icon': Icons.category.codePoint,
    });

    await db.insert(categoryTable, {
      'id': 2,
      'name': 'Entrada',
      'type': CategoryType.receipt.db,
      'color': CategoryType.receipt.color.toInt(),
      'icon': Icons.category.codePoint,
    });

    await db.insert(accountTable, {
      'name': 'Carteira',
      'amount': 0.0,
      'color': StylePresets.cBlue.toInt(),
    });

    await db.insert(cardTable, {
      'card_limit': '5000.0',
      'instituition': 'Banco X',
      'description': 'Cartão de Crédito',
      'card_brand': 'Visa',
      'account_number': '1234567890',
      'card_closing': '2024-10-31',
      'card_expiration': '2025-12-31',
    });
  }

  Future close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
