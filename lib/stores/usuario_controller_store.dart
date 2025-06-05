// lib/stores/usuario_controller_store.dart
import 'package:mobx/mobx.dart';
import 'package:app_nutripaloma/models/usuario_model.dart';
import 'package:app_nutripaloma/core/dao/usuario_dao.dart';

part 'usuario_controller_store.g.dart';

class UsuarioControllerStore = _UsuarioControllerStoreBase with _$UsuarioControllerStore;

abstract class _UsuarioControllerStoreBase with Store {
  final UsuarioDAO _usuarioDAO = UsuarioDAO();

  @observable
  Usuario? usuario;

  @action
  Future<void> carregarUsuario() async {
    usuario = await _usuarioDAO.getUsuario();
  }

  @action
  Future<void> atualizarUsuario(Usuario novoUsuario) async {
    await _usuarioDAO.salvarUsuario(novoUsuario);
    usuario = novoUsuario;
  }

  @action
  Future<void> limparUsuario() async {
    await _usuarioDAO.deletarUsuario();
    usuario = null;
  }

  @action
  Future<void> atualizarDadosLocais({
    required String nome,
    required String peso,
    required String altura,
  }) async {
    if (usuario == null) return;

    final usuarioAtualizado = Usuario(
      id: usuario!.id,
      nome: nome,
      email: usuario!.email,
      peso: peso,
      altura: altura,
      objetivo: usuario!.objetivo,
      isPremium: usuario!.isPremium,
      chaveLiberacao: usuario!.chaveLiberacao,
      materialPremiumLinks: usuario!.materialPremiumLinks,
    );

    await _usuarioDAO.salvarUsuario(usuarioAtualizado);
    usuario = usuarioAtualizado;
  }


}
