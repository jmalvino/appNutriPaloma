import 'package:mobx/mobx.dart';
import 'package:app_nutripaloma/models/usuario_model.dart';
import 'package:app_nutripaloma/core/services/usuario_service.dart';

part 'dietas_store.g.dart';

class DietasStore = _DietasStoreBase with _$DietasStore;

abstract class _DietasStoreBase with Store {
  final UsuarioService _usuarioService = UsuarioService();

  @observable
  List<String> pdfs = [];

  @observable
  bool carregando = false;

  @observable
  String? erro;

  @action
  Future<void> carregarDietas(Usuario usuario) async {
    carregando = true;
    erro = null;
    try {
      final dados = await _usuarioService.buscarUsuarioPorEmail(usuario.email);
      pdfs = dados?.materialPremiumLinks ?? [];
    } catch (e) {
      erro = 'Erro ao buscar dietas';
    } finally {
      carregando = false;
    }
  }
}
