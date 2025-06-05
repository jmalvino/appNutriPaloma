import 'package:app_nutripaloma/core/dao/usuario_dao.dart';
import 'package:app_nutripaloma/core/services/usuario_service.dart';
import 'package:app_nutripaloma/models/usuario_model.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cadastro_controller.g.dart';

class CadastroController = _CadastroControllerBase with _$CadastroController;

abstract class _CadastroControllerBase with Store {
  final UsuarioService _usuarioService = UsuarioService();
  final UsuarioDAO _usuarioDAO = UsuarioDAO();

  @observable
  String nome = '';

  @observable
  String email = '';

  @observable
  String peso = '';

  @observable
  String altura = '';

  @observable
  String objetivo = 'Perda de peso';

  @observable
  bool carregando = false;

  @observable
  String? erro;

  @action
  Future<bool> cadastrarUsuario() async {
    erro = null;
    carregando = true;

    final usuario = Usuario(
      nome: nome.trim(),
      email: email.trim(),
      peso: peso.trim(),
      altura: altura.trim(),
      objetivo: objetivo,
    );

    try {
      final sucessoApi = await _usuarioService.cadastrarUsuario(usuario);
      if (!sucessoApi) {
        erro = 'Erro ao cadastrar na API';
        carregando = false;
        return false;
      }

      await _usuarioDAO.salvarUsuario(usuario);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('usuarioCadastrado', true);

      carregando = false;
      return true;
    } catch (e) {
      erro = 'Erro inesperado: $e';
      carregando = false;
      return false;
    }
  }
}
