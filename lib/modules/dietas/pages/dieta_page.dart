// lib/modules/dietas/pages/dieta_page.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app_nutripaloma/core/dao/usuario_dao.dart';
import 'package:app_nutripaloma/stores/dietas_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get_it/get_it.dart';

class DietaPage extends StatefulWidget {
  const DietaPage({super.key});

  @override
  State<DietaPage> createState() => _DietaPageState();
}

class _DietaPageState extends State<DietaPage> {
  final dietasStore = GetIt.I<DietasStore>();

  @override
  void initState() {
    super.initState();
    carregamentoInicio();
  }

  void carregamentoInicio() async {
    final usuario = await UsuarioDAO().getUsuario();

    if (usuario != null) {
      await dietasStore.carregarDietas(usuario);
    } else {
      // Pode redirecionar para o login ou mostrar uma mensagem de erro
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _abrirPdf(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text("Visualizar PDF"),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _compartilharPdf(url),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Limpar PDFs locais',
                onPressed: _limparPdfsLocais,
              ),
            ],
          ),
          body: FutureBuilder<File>(
            future: _carregarPdfLocal(url),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('Erro ao carregar PDF'));
              } else {
                return PDF().fromPath(snapshot.data!.path);
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _compartilharPdf(String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = url.split('/').last;
      final file = File('${dir.path}/$fileName');

      if (!await file.exists()) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          throw Exception('Erro ao baixar o PDF');
        }
      }

      final params = ShareParams(
        files: [XFile(file.path)],
        text: 'Confira essa dieta em anexo!',
      );

      await SharePlus.instance.share(params);
    } catch (e) {
      debugPrint('Erro ao compartilhar PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro no compartilhamento')),
        );
      }
    }
  }

  Future<void> _limparPdfsLocais() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final files = dir.listSync();

      for (var file in files) {
        if (file is File && file.path.endsWith('.pdf')) {
          await file.delete();
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDFs apagados com sucesso.')),
        );
      }
    } catch (e) {
      debugPrint('Erro ao limpar PDFs: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao limpar PDFs.')),
        );
      }
    }
  }

  Future<File> _carregarPdfLocal(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = url.split('/').last;
    final file = File('${dir.path}/$fileName');

    if (await file.exists()) {
      return file;
    } else {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Falha ao baixar PDF');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Dietas")),
      body: Observer(
        builder: (_) {
          if (dietasStore.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dietasStore.pdfs.isEmpty) {
            return const Center(child: Text("Nenhuma dieta disponível."));
          }

          return ListView.builder(
            itemCount: dietasStore.pdfs.length,
            itemBuilder: (context, index) {
              final url = dietasStore.pdfs[index];
              final nome = url.split('/').last;
              return ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: Text(
                  nome,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () => _abrirPdf(url),
              );
            },
          );
        },
      ),
    );
  }
}
