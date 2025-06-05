import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'nutri_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT,
        peso TEXT,
        altura TEXT,
        objetivo TEXT,
        isPremium INTEGER,
        chaveLiberacao TEXT,
        materialPremiumLinks TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE receitas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        ingredientes TEXT,
        modoPreparo TEXT,
        imagemUrl TEXT
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<void> limparBase() async {
    final db = await database;
    await db.delete('usuario');
    await db.delete('receitas');
  }
}
