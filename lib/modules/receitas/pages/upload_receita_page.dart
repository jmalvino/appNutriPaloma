import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadReceitaPage extends StatefulWidget {
  const UploadReceitaPage({super.key});

  @override
  State<UploadReceitaPage> createState() => _UploadReceitaPageState();
}

class _UploadReceitaPageState extends State<UploadReceitaPage> {
  File? _arquivoSelecionado;
  final TextEditingController _tituloController = TextEditingController();
  bool _enviando = false;

  void _mostrarSnackbar(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _selecionarArquivo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _arquivoSelecionado = File(result.files.single.path!);
      });
    } else {
      _mostrarSnackbar('Nenhum arquivo selecionado');
    }
  }

  Future<void> _enviarReceita() async {
    final titulo = _tituloController.text.trim();
    if (_arquivoSelecionado == null || titulo.isEmpty) {
      _mostrarSnackbar('Informe um título e selecione um arquivo PDF');
      return;
    }

    setState(() => _enviando = true);

    try {
      final uri = Uri.parse('https://nutripalomamartins.com.br/api_nutri/upload_receita.php');
      final request = http.MultipartRequest('POST', uri)
        ..fields['titulo'] = titulo
        ..files.add(await http.MultipartFile.fromPath('arquivo', _arquivoSelecionado!.path));

      final response = await request.send();
      final resposta = await response.stream.bytesToString();

      if (response.statusCode == 200 && resposta.contains('sucesso')) {
        _mostrarSnackbar('✅ Receita enviada com sucesso!');
        _tituloController.clear();
        setState(() => _arquivoSelecionado = null);
      } else {
        _mostrarSnackbar('❌ Falha ao enviar receita: $resposta');
      }
    } catch (e) {
      _mostrarSnackbar('❌ Erro ao enviar receita: $e');
    } finally {
      setState(() => _enviando = false);
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload de Receita")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título da Receita'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selecionarArquivo,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Selecionar PDF"),
            ),
            if (_arquivoSelecionado != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Arquivo selecionado: ${_arquivoSelecionado!.path.split('/').last}",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _enviando ? null : _enviarReceita,
              icon: const Icon(Icons.upload_file),
              label: _enviando
                  ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text("Enviar Receita"),
            ),
          ],
        ),
      ),
    );
  }
}
