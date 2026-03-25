import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:law_library/models/law.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  static Database? _database;

  DatabaseService._();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'law_library.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        chapter TEXT PRIMARY KEY,
        category TEXT,
        title TEXT,
        description TEXT,
        compound_fine TEXT,
        second_compound_fine TEXT,
        third_compound_fine TEXT,
        fourth_compound_fine TEXT,
        fifth_compound_fine TEXT
      )
    ''');
  }

  // ------------------- Favorites CRUD -------------------

  Future<List<Law>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return maps.map((map) => Law.fromMap(map)).toList();
  }

  Future<bool> isFavorite(String chapter) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'chapter = ?',
      whereArgs: [chapter],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> addFavorite(Law law) async {
    final db = await database;
    await db.insert(
      'favorites',
      _modelToDbMap(law),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String chapter) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'chapter = ?',
      whereArgs: [chapter],
    );
  }

  Future<void> clearFavorites() async {
    final db = await database;
    await db.delete('favorites');
  }

  // ------------------- Search & Filtering -------------------
  Future<List<Law>> searchFavorites({String? query, String? category}) async {
    final db = await database;

    String whereClause = '';
    List<String> whereArgs = [];

    if (query != null && query.isNotEmpty) {
      whereClause +=
      '(chapter LIKE ? OR title LIKE ? OR description LIKE ? OR category LIKE ?)';
      whereArgs.addAll(['%$query%', '%$query%', '%$query%', '%$query%']);
    }

    if (category != null && category.isNotEmpty) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'category = ?';
      whereArgs.add(category);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return maps.map((map) => Law.fromMap(map)).toList();
  }

  // ------------------- Helpers -------------------

  // Convert model to DB map
  Map<String, dynamic> _modelToDbMap(Law law) {
    return {
      'chapter': law.chapter,
      'category': law.category,
      'title': law.title,
      'description': law.description,
      'compound_fine': law.compoundFine,
      'second_compound_fine': law.secondCompoundFine,
      'third_compound_fine': law.thirdCompoundFine,
      'fourth_compound_fine': law.fourthCompoundFine,
      'fifth_compound_fine': law.fifthCompoundFine,
    };
  }

}
