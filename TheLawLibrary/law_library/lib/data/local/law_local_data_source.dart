import 'package:sqflite/sqflite.dart';
import 'law_database.dart';
import '../../models/law.dart';

class LawLocalDataSource {
  final LawDatabase _dbHelper = LawDatabase.instance;

  // Insert multiple laws
  Future<void> insertLaws(List<Law> laws) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var law in laws) {
      batch.insert(
        'laws',
        law.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Get all laws
  Future<List<Law>> getAllLaws() async {
    final db = await _dbHelper.database;
    final maps = await db.query('laws');
    return maps.map((map) => Law.fromMap(map)).toList();
  }

  // Get laws by category
  Future<List<Law>> getLawsByCategory(String category) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'laws',
      where: 'Category = ?',
      whereArgs: [category],
    );
    return maps.map((map) => Law.fromMap(map)).toList();
  }

  // Update favorite
  Future<void> updateFavorite(int id, bool isFavorite) async {
    final db = await _dbHelper.database;
    await db.update(
      'laws',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all laws (optional)
  Future<void> clearLaws() async {
    final db = await _dbHelper.database;
    await db.delete('laws');
  }
}
