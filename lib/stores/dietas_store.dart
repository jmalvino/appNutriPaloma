import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:app_nutripaloma/models/usuario_model.dart';
import 'package:http/http.dart' as http;

part 'dietas_store.g.dart';

class DietasStore = _DietasStore with _$DietasStore;

abstract class _DietasStore with Store {
  @observable
  ObservableList<String> pdfs = ObservableList<String>();

  @observable
  bool carregando = false;

  @action
  Future<void> carregarDietas(Usuario usuario) async {
    carregando = true;
    pdfs.clear();

    try {
      final response = await http.get(Uri.parse(
        'https://nutripalomamartins.com.br/api_nutri/dietas.php?email=${usuario.email}',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          pdfs.addAll(List<String>.from(data));
        } else if (data is Map && data.containsKey('erro')) {
          throw Exception(data['erro']);
        } else {
          throw Exception('Resposta inesperada da API.');
        }
      } else {
        throw Exception('Erro ${response.statusCode} ao buscar dietas.');
      }
    } catch (e) {
      rethrow; // Repassa o erro para ser tratado fora
    } finally {
      carregando = false;
    }
  }

}
