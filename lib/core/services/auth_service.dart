// lib/core/services/auth_service.dart
import 'package:app_nutripaloma/core/dao/usuario_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final UsuarioDAO _usuarioDAO = UsuarioDAO();

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Apenas remove o usuário, sem apagar o banco
    await _usuarioDAO.deletarUsuario();
  }
}
