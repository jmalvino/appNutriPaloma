import 'package:app_nutripaloma/models/receita_model.dart';
import 'package:app_nutripaloma/stores/receita_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class ReceitasPage extends StatefulWidget {
  const ReceitasPage({super.key});

  @override
  State<ReceitasPage> createState() => _ReceitasPageState();
}

class _ReceitasPageState extends State<ReceitasPage> {
  final receitasStore = GetIt.I<ReceitasStore>();

  @override
  void initState() {
    super.initState();
    receitasStore.carregarReceitas();
  }

  void _abrirPdf(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Visualizar Receita')),
          body: PDF().cachedFromUrl(
            url,
            placeholder: (progress) => Center(child: Text('$progress%')),
            errorWidget: (error) => Center(child: Text('Erro ao carregar PDF: $error')),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarExclusao(Receita receita) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Receita'),
        content: Text('Deseja realmente excluir "${receita.titulo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        print('🔁 Deletando receita ID: ${receita.id}');
        print('🛰️ Enviando para: https://nutripalomamartins.com.br/api_nutri/delete_receita.php');

        final response = await http.post(
          Uri.parse('https://nutripalomamartins.com.br/api_nutri/delete_receita.php'),
          body: {'id': receita.id.toString()},
        );

        print('📥 Status code: ${response.statusCode}');
        print('📦 Body: ${response.body}');

        if (response.statusCode == 200 && response.body.contains('sucesso')) {
          receitasStore.receitas.removeWhere((r) => r.id == receita.id);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Receita excluída com sucesso.')),
            );
          }
        } else {
          _mostrarErro('Erro ao excluir receita.');
        }
      } catch (e) {
        _mostrarErro('Erro ao excluir: $e');
      }
    }
  }

  void _mostrarErro(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receitas')),
      body: Observer(
        builder: (_) {
          if (receitasStore.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (receitasStore.receitas.isEmpty) {
            return const Center(child: Text('Nenhuma receita disponível.'));
          }

          return ListView.builder(
            itemCount: receitasStore.receitas.length,
            itemBuilder: (context, index) {
              final receita = receitasStore.receitas[index];
              return ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text(receita.titulo),
                onTap: () => _abrirPdf(receita.url),
                onLongPress: () => _confirmarExclusao(receita),
              );
            },
          );
        },
      ),
    );
  }
}
