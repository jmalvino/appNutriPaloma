import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart' as http;

class DietasAdminPage extends StatefulWidget {
  const DietasAdminPage({super.key});

  @override
  State<DietasAdminPage> createState() => _DietasAdminPageState();
}

class _DietasAdminPageState extends State<DietasAdminPage> {
  final emailController = TextEditingController();
  List<String> dietas = [];
  bool carregando = false;

  Future<void> buscarDietas() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      carregando = true;
      dietas.clear();
    });

    try {
      final response = await http.get(Uri.parse('https://nutripalomamartins.com.br/api_nutri/dietas.php?email=$email'));
      if (response.statusCode == 200) {
        final List<dynamic> data = List.from(jsonDecode(response.body));
        setState(() {
          dietas = data.cast<String>();
        });
      } else {
        _mostrarErro('Erro: ${response.statusCode}');
      }
    } catch (e) {
      _mostrarErro('Erro ao buscar dietas: $e');
    } finally {
      setState(() => carregando = false);
    }
  }

  void _mostrarErro(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _visualizarPdf(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Visualizar PDF')),
          body: PDF().cachedFromUrl(
            url,
            placeholder: (progress) => Center(child: Text('$progress%')),
            errorWidget: (error) => Center(child: Text('Erro: $error')),
          ),
        ),
      ),
    );
  }

  void _confirmarExclusao(String url) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Dieta'),
        content: const Text('Deseja realmente excluir esta dieta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await http.post(
          Uri.parse('https://nutripalomamartins.com.br/api_nutri/delete_dieta.php'),
          body: {'arquivo': url.split('/').last},
        );
        if (response.statusCode == 200) {
          setState(() => dietas.remove(url));
          _mostrarErro('✅ Dieta excluída com sucesso');
        } else {
          _mostrarErro('Erro ao excluir dieta');
        }
      } catch (e) {
        _mostrarErro('Erro: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dietas do Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email do usuário'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: buscarDietas,
              child: const Text('Buscar Dietas'),
            ),
            const SizedBox(height: 12),
            if (carregando)
              const CircularProgressIndicator()
            else if (dietas.isEmpty)
              const Text('Nenhuma dieta encontrada.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: dietas.length,
                  itemBuilder: (context, index) {
                    final url = dietas[index];
                    final nome = url.split('/').last;
                    return ListTile(
                      title: Text(nome),
                      onTap: () => _visualizarPdf(url),
                      onLongPress: () => _confirmarExclusao(url),
                      leading: const Icon(Icons.picture_as_pdf),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
