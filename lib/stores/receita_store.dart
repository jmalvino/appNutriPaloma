import 'package:app_nutripaloma/core/dao/receita_dao.dart';
import 'package:app_nutripaloma/core/services/receita_service.dart';
import 'package:app_nutripaloma/models/receita_model.dart';
import 'package:mobx/mobx.dart';

part 'receita_store.g.dart';

class ReceitaStore = _ReceitaStoreBase with _$ReceitaStore;

abstract class _ReceitaStoreBase with Store {
  final ReceitaDAO _dao = ReceitaDAO();
  final ReceitaService _service = ReceitaService();

  @observable
  ObservableList<Receita> receitas = ObservableList<Receita>();

  @observable
  bool carregando = false;

  @observable
  String? erro;

  @action
  Future<void> carregarReceitasLocais() async {
    try {
      final lista = await _dao.listarReceitas();
      receitas = ObservableList<Receita>.of(lista);
    } catch (e) {
      erro = 'Erro ao carregar receitas locais: $e';
    }
  }

  @action
  Future<void> sincronizarReceitas() async {
    carregando = true;
    erro = null;

    try {
      final lista = await _service.buscarReceitas();
      await _dao.limparReceitas();
      await _dao.salvarListaReceitas(lista);
      receitas = ObservableList<Receita>.of(lista);
    } catch (e) {
      erro = 'Erro ao sincronizar receitas: $e';
    } finally {
      carregando = false;
    }
  }
}
