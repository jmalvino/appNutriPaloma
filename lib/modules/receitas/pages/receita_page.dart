import 'package:app_nutripaloma/models/receita_model.dart';
import 'package:app_nutripaloma/stores/receita_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class ReceitaPage extends StatefulWidget {
  const ReceitaPage({Key? key}) : super(key: key);

  @override
  State<ReceitaPage> createState() => _ReceitaPageState();
}

class _ReceitaPageState extends State<ReceitaPage> {
  final ReceitaStore _store = GetIt.I<ReceitaStore>();

  @override
  void initState() {
    super.initState();
    _store.carregarReceitasLocais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => _store.sincronizarReceitas(),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_store.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.receitas.isEmpty) {
            return const Center(child: Text('Nenhuma receita encontrada.'));
          }

          return ListView.builder(
            itemCount: _store.receitas.length,
            itemBuilder: (_, index) {
              final receita = _store.receitas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: receita.imagemUrl.isNotEmpty
                      ? Image.network(
                    receita.imagemUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.food_bank),
                  title: Text(receita.titulo),
                  subtitle: Text(receita.ingredientes),
                  onTap: () {
                    _abrirDetalhes(receita);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _abrirDetalhes(Receita receita) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(receita.titulo),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (receita.imagemUrl.isNotEmpty)
                Image.network(receita.imagemUrl),
              const SizedBox(height: 12),
              const Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(receita.ingredientes),
              const SizedBox(height: 12),
              const Text('Modo de preparo:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(receita.modoPreparo),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))
        ],
      ),
    );
  }
}
