import 'package:sqflite/sqflite.dart';
import 'law_database.dart';
import '../../models/law.dart';

/// Local cache for law search results.
/// Uses the [LawDatabase] SQLite file (separate from the favorites database).
class LawLocalDataSource {
  final LawDatabase _dbHelper = LawDatabase.instance;

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Insert or replace a batch of laws into the cache.
  Future<void> insertLaws(List<Law> laws) async {
    if (laws.isEmpty) return;
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (final law in laws) {
      batch.insert(
        'laws',
        law.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Delete all cached laws (e.g. on logout or manual cache clear).
  Future<void> clearLaws() async {
    final db = await _dbHelper.database;
    await db.delete('laws');
  }

  // ── Read ───────────────────────────────────────────────────────────────────

  /// Search cached laws with optional query, category filter, and pagination.
  /// Mirrors the parameters used by [ApiService.getLaws].
  Future<List<Law>> searchLaws({
    String? query,
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    final db = await _dbHelper.database;
    final conditions = <String>[];
    final args = <dynamic>[];

    if (query != null && query.isNotEmpty) {
      conditions.add(
        '(Title LIKE ? OR Description LIKE ? OR Chapter LIKE ?)',
      );
      args.addAll(['%$query%', '%$query%', '%$query%']);
    }

    if (category != null && category.isNotEmpty) {
      conditions.add('Category = ?');
      args.add(category);
    }

    final offset = (page - 1) * limit;
    final maps = await db.query(
      'laws',
      where: conditions.isNotEmpty ? conditions.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      limit: limit,
      offset: offset,
      orderBy: 'Title ASC',
    );

    return maps.map((m) => Law.fromJson(m)).toList();
  }

  /// Returns distinct category names from cached laws (offline fallback).
  Future<List<String>> getDistinctCategories() async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery(
      'SELECT DISTINCT Category FROM laws ORDER BY Category ASC',
    );
    return maps
        .map((m) => m['Category'] as String)
        .where((c) => c.isNotEmpty)
        .toList();
  }
}
