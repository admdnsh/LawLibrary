import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LawDatabase {
  static final LawDatabase instance = LawDatabase._internal();
  static Database? _database;

  LawDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'law_library.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE laws (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        Chapter TEXT NOT NULL,
        Category TEXT NOT NULL,
        Title TEXT NOT NULL,
        Description TEXT NOT NULL,

        Compound_Fine TEXT,
        Second_Compound_Fine TEXT,
        Third_Compound_Fine TEXT,
        Fourth_Compound_Fine TEXT,
        Fifth_Compound_Fine TEXT,

        isFavorite INTEGER DEFAULT 0
      )
    ''');
  }
}
