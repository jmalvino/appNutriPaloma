import 'dart:convert';
import 'package:app_nutripaloma/models/dieta_model.dart';
import 'package:mobx/mobx.dart';
import 'package:app_nutripaloma/models/usuario_model.dart';
import 'package:http/http.dart' as http;

part 'dietas_store.g.dart';

class DietasStore = _DietasStore with _$DietasStore;

abstract class _DietasStore with Store {
  @observable
  ObservableList<DietaModel> pdfs = ObservableList<DietaModel>();


  @observable
  bool carregando = false;

  @action
  Future<void> carregarDietas(Usuario usuario) async {
    carregando = true;
    pdfs.clear();

    try {
      final url = 'https://nutripalomamartins.com.br/api_nutri/dietas.php?email=${usuario.email}';
      print('📡 Buscando dietas em: $url');

      final response = await http.get(Uri.parse(url));
      print('🔁 Status code: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          pdfs.addAll(data.map<DietaModel>((json) => DietaModel.fromJson(json)).toList());
        } else if (data is Map && data.containsKey('erro')) {
          throw Exception(data['erro']);
        } else {
          throw Exception('Resposta inesperada da API.');
        }
      } else {
        throw Exception('Erro ${response.statusCode} ao buscar dietas.');
      }
    } catch (e) {
      print('❌ Erro ao carregar dietas: $e');
      rethrow;
    } finally {
      carregando = false;
    }
  }


  @action
  Future<List<String>> carregarDietasAdmin(String email) async {
    final urlUsuarios = 'https://nutripalomamartins.com.br/api_nutri/usuarios.json';
    try {
      final responseUsuarios = await http.get(Uri.parse(urlUsuarios));
      if (responseUsuarios.statusCode == 200) {
        final List dataUsuarios = json.decode(responseUsuarios.body);
        final usuarioEncontrado = dataUsuarios.firstWhere(
              (u) => u['email'] == email,
          orElse: () => null,
        );

        if (usuarioEncontrado == null) {
          throw Exception('Usuário não encontrado.');
        }

        final idUsuario = usuarioEncontrado['id'];
        final urlDietas = 'https://nutripalomamartins.com.br/dietas/$idUsuario/dietas.json';

        final responseDietas = await http.get(Uri.parse(urlDietas));
        if (responseDietas.statusCode == 200) {
          final data = json.decode(responseDietas.body);
          if (data is List) {
            return List<String>.from(data.map((e) => 'https://nutripalomamartins.com.br/dietas/$idUsuario/${e['nome_arquivo']}'));
          } else {
            throw Exception('Formato inesperado no dietas.json.');
          }
        } else {
          throw Exception('Erro ${responseDietas.statusCode} ao buscar dietas.');
        }
      } else {
        throw Exception('Erro ${responseUsuarios.statusCode} ao buscar usuários.');
      }
    } catch (e) {
      throw Exception('Erro ao carregar dietas do usuário: $e');
    }
  }
}
