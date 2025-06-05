import 'dart:convert';
import 'package:app_nutripaloma/models/usuario_model.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  final String baseUrl = 'https://nutripalomamartins.com.br/api_nutri';

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    final url = Uri.parse('$baseUrl/cadastrar.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': usuario.nome,
        'email': usuario.email,
        'peso': usuario.peso,
        'altura': usuario.altura,
        'objetivo': usuario.objetivo,
      }),
    );

    return response.statusCode == 200;
  }

  Future<Usuario?> buscarUsuarioPorEmail(String email) async {
    final url = Uri.parse('$baseUrl/buscar_usuario.php?email=$email');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Usuario.fromMap(data);
    }

    return null;
  }
}
