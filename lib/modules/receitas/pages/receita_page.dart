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
      final response = await http.get(Uri.parse('https://nutripalomamartins.com.br/api_nutri/receitas.json'));

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  void _abrirPdf(String arquivo) {
    // Se já for uma URL completa, usa direto; senão, monta com o domínio correto
    final url = arquivo.startsWith('http')
        ? arquivo
        : 'https://nutripalomamartins.com.br/receitas/$arquivo';

    debugPrint('🔗 Abrindo PDF: $url');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Visualizar Receita')),
          body: PDF().cachedFromUrl(
            url,
            placeholder: (progress) => Center(child: Text('$progress%')),
            errorWidget: (error) =>
                Center(child: Text('Erro ao carregar PDF: $error')),
          ),
        ),
      ),
    );
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
            onTap: () => _abrirPdf(receita['url'] ?? receita['arquivo']),

          );
        },
      ),
    );
  }
}
