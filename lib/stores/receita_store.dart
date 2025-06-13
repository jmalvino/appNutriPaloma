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
        final data = json.decode(response.body);
        if (data is List) {
          receitas.clear();
          receitas.addAll(data.map((e) => Receita.fromJson(e)).toList());
        } else {
          throw Exception('Formato inválido no JSON de receitas.');
        }
      } else {
        throw Exception('Erro ao carregar receitas: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erro ao carregar receitas: $e');
    } finally {
      carregando = false;
    }
  }

  @action
  Future<bool> excluirReceita(int id) async {
    try {
      final response = await http.post(
        Uri.parse('https://nutripalomamartins.com.br/api_nutri/delete_receita.php'),
        body: {'id_receita': id.toString()},
      );

      if (response.statusCode == 200 && response.body.contains('sucesso')) {
        receitas.removeWhere((r) => r.id == id);
        return true;
      } else {
        print('❌ Erro ao excluir receita: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Erro na exclusão da receita: $e');
      return false;
    }
  }
}
