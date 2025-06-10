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
      try {
        await dietasStore.carregarDietas(usuario);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '⚠️ ')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }


  void _abrirPdf(String url) {
    debugPrint('🔗 URL do PDF: $url');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text("Visualizar PDF"),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () async {
                  try {
                    final response = await http.get(Uri.parse(url));
                    if (response.statusCode == 200) {
                      final dir = await getTemporaryDirectory();
                      final fileName = url.split('/').last;
                      final file = File('${dir.path}/$fileName');
                      await file.writeAsBytes(response.bodyBytes);

                      final params = ShareParams(
                        files: [XFile(file.path)],
                        text: 'Confira essa dieta em anexo!',
                      );

                      final result = await SharePlus.instance.share(params);
                      if (result.status == ShareResultStatus.success) {
                        debugPrint('✅ PDF compartilhado com sucesso.');
                      }
                    } else {
                      debugPrint('❌ Erro HTTP ${response.statusCode} ao baixar o PDF');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao baixar o PDF')),
                      );
                    }
                  } catch (e) {
                    debugPrint('❌ Erro ao compartilhar PDF: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Erro no compartilhamento')),
                    );
                  }
                },
              ),
            ],
          ),
          body: PDF().cachedFromUrl(
            url,
            placeholder: (progress) => Center(child: Text('$progress%')),
            errorWidget: (error) {
              debugPrint('❌ Erro ao carregar PDF: $error');
              return Center(child: Text('Erro ao carregar PDF: $error'));
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
