import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:app_nutripaloma/models/receita_model.dart';

part 'receita_store.g.dart';

class ReceitasStore = _ReceitasStore with _$ReceitasStore;

abstract class _ReceitasStore with Store {
  @observable
  ObservableList<Receita> receitas = ObservableList<Receita>();

  @observable
  bool carregando = false;

  @action
  Future<void> carregarReceitas() async {
    carregando = true;
    try {
      final response = await http.get(Uri.parse(
        'https://nutripalomamartins.com.br/receitas/receitas.json',
      ));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        receitas.clear();
        receitas.addAll(data.map((e) => Receita.fromJson(e)).toList());
      } else {
        throw Exception('Erro ao carregar receitas');
      }
    } catch (e) {
      print('❌ Erro: $e');
    } finally {
      carregando = false;
    }
  }
}
