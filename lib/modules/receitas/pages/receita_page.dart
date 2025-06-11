// ReceitasPage com exclusão de receita via long press (admin)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart' as http;

class ReceitasPage extends StatefulWidget {
  const ReceitasPage({super.key});

  @override
  State<ReceitasPage> createState() => _ReceitasPageState();
}

class _ReceitasPageState extends State<ReceitasPage> {
  List<Map<String, dynamic>> receitas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarReceitas();
  }

  Future<void> carregarReceitas() async {
    setState(() => carregando = true);

    try {
      final response = await http.get(Uri.parse('https://nutripalomamartins.com.br/receitas/receitas.json'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            receitas = List<Map<String, dynamic>>.from(data);
          });
        }
      } else {
        _mostrarErro('Erro ao carregar receitas: ${response.statusCode}');
      }
    } catch (e) {
      _mostrarErro('Erro ao buscar receitas: $e');
    } finally {
      setState(() => carregando = false);
    }
  }

  void _mostrarErro(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
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

  void _confirmarExclusao(int index) async {
    final receita = receitas[index];
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Receita'),
        content: Text('Deseja realmente excluir "${receita['titulo']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        final response = await http.post(
          Uri.parse('https://nutripalomamartins.com.br/api_nutri/remover_receita.php'),
          body: {'arquivo': receita['arquivo'].toString().split('/').last},
        );

        if (response.statusCode == 200 && response.body.contains('sucesso')) {
          setState(() => receitas.removeAt(index));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receita excluída com sucesso.')));
        } else {
          _mostrarErro('Erro ao excluir receita.');
        }
      } catch (e) {
        _mostrarErro('Erro ao excluir: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Receitas')),
      body: receitas.isEmpty
          ? const Center(child: Text('Nenhuma receita disponível.'))
          : ListView.builder(
        itemCount: receitas.length,
        itemBuilder: (context, index) {
          final receita = receitas[index];
          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(receita['titulo'] ?? 'Sem título'),
            onTap: () => _abrirPdf(receita['arquivo']),
            onLongPress: () => _confirmarExclusao(index),
          );
        },
      ),
    );
  }
}
