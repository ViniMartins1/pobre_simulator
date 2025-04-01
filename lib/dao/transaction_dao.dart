import 'package:pobre_simulator/config/db.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/model/transaction.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;

class TransactionDAO {
  static final TransactionDAO _singleton = TransactionDAO._internal();
  static const String table = DB.transactionTable;

  factory TransactionDAO() {
    return _singleton;
  }

  TransactionDAO._internal();

  Future<Database> get _db async => await DB().database;

  Future<void> insertTransaction(Transaction transaction) async {
    final db = await _db;
    await db.insert(table, transaction.toJson());
  }

  Future<List<Transaction>> getTransactions(CategoryType type) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM $table WHERE TYPE = \'${type.db}\'');
    return List.generate(maps.length, (i) {
      return Transaction.fromJson(maps[i]);
    });
  }

  Future<List<Transaction>> getAllTransactions() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Transaction.fromJson(maps[i]);
    });
  }

  Future<Transaction?> getTransaction(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(table, where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return Transaction.fromJson(maps.first);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final db = await _db;
    await db.update(table, transaction.toJson(), where: 'id = ?', whereArgs: [transaction.id]);
  }

  Future<void> deleteTransaction(int transactionId) async {
    final db = await _db;
    await db.delete(table, where: 'id = ?', whereArgs: [transactionId]);
  }
}
