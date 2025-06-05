import 'dart:convert';
import 'package:app_nutripaloma/models/receita_model.dart';
import 'package:http/http.dart' as http;

class ReceitaService {
  final String url =
      'https://nutripalomamartins.com.br/api_nutri/receitas.json';

  Future<List<Receita>> buscarReceitas() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Receita.fromMap(e)).toList();
      } else {
        throw Exception('Erro ao carregar receitas da API');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
}
