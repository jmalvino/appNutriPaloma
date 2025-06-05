import 'package:app_nutripaloma/models/usuario_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UsuarioDAO {
  static const _dbName = 'nutri_app.db';
  static const _table = 'usuario';

  Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _dbName),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT UNIQUE,
            peso TEXT,
            altura TEXT,
            objetivo TEXT,
            isPremium INTEGER,
            chaveLiberacao TEXT,
            materialPremiumLinks TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> salvarUsuario(Usuario usuario) async {
    final db = await _getDatabase();
    await db.insert(
      _table,
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Usuario?> buscarUsuario() async {
    final db = await _getDatabase();
    final maps = await db.query(_table, limit: 1);
    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<void> deletarUsuario() async {
    final db = await _getDatabase();
    await db.delete(_table);
  }

  Future<Usuario?> getUsuario() async {
    final db = await _getDatabase();
    final result = await db.query('usuario', limit: 1);

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }

  Future<void> deletarBancoLocal() async {
    final dbPath = await getDatabasesPath();
    await deleteDatabase(join(dbPath, 'nutri_app.db'));
  }

}
