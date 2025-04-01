import 'package:pobre_simulator/config/db.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDAO {
  static const String table = 'CATEGORY';

  Future<Database> get _db async => await DB().database;

  Future<void> insertCategory(Category category) async {
    final db = await _db;
    await db.insert(table, category.toJson());
  }

  Future<List<Category>> getCategories(CategoryType type) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM CATEGORY WHERE type = \'${type.db}\'');
    return List.generate(maps.length, (i) {
      return Category.fromJson(maps[i]);
    });
  }

  Future<List<Category>> getAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM CATEGORY');
    return List.generate(maps.length, (i) {
      return Category.fromJson(maps[i]);
    });
  }

  Future<Category?> getCategory(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('CATEGORY', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return Category.fromJson(maps.first);
  }

  Future<void> updateCategory(Category category) async {
    final db = await _db;
    await db.update(table, category.toJson(), where: 'id = ?', whereArgs: [category.id]);
  }

  Future<void> deleteCategory(int categoryId) async {
    final db = await _db;
    await db.delete(table, where: 'id = ?', whereArgs: [categoryId]);
  }
}
