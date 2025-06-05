
import 'package:app_nutripaloma/core/database/database_helper.dart';
import 'package:app_nutripaloma/models/receita_model.dart';
import 'package:sqflite/sqflite.dart';

class ReceitaDAO {
  Future<Database> get _db async => await DatabaseHelper.instance.database;

  Future<void> salvarReceita(Receita receita) async {
    final db = await _db;
    await db.insert(
      'receitas',
      receita.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> salvarListaReceitas(List<Receita> receitas) async {
    final db = await _db;
    final batch = db.batch();

    for (final receita in receitas) {
      batch.insert(
        'receitas',
        receita.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }


  Future<List<Receita>> listarReceitas() async {
    final db = await _db;
    final maps = await db.query('receitas', orderBy: 'id DESC');

    return maps.map((map) => Receita.fromMap(map)).toList();
  }

  Future<void> deletarReceita(int id) async {
    final db = await _db;
    await db.delete('receitas', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> limparReceitas() async {
    final db = await _db;
    await db.delete('receitas');
  }
}
