import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadDietaPage extends StatefulWidget {
  const UploadDietaPage({super.key});

  @override
  State<UploadDietaPage> createState() => _UploadDietaPageState();
}

class _UploadDietaPageState extends State<UploadDietaPage> {
  final emailController = TextEditingController();
  File? arquivoSelecionado;

  Future<void> selecionarArquivo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        arquivoSelecionado = File(result.files.single.path!);
      });
    }
  }

  Future<void> enviarArquivo() async {
    if (arquivoSelecionado == null || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o email e selecione um arquivo')),
      );
      return;
    }

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'email': emailController.text.trim(),
        'arquivo': await MultipartFile.fromFile(arquivoSelecionado!.path, filename: arquivoSelecionado!.path.split('/').last),
      });

      final response = await dio.post(
        'https://nutripalomamartins.com.br/api_nutri/upload_dieta.php',
        data: formData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Dieta enviada com sucesso!')),
        );
      } else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resposta: ${response.data}')),
        );
      }


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enviar PDF de Dieta")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email do usuário'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: selecionarArquivo,
              icon: const Icon(Icons.attach_file),
              label: const Text("Selecionar PDF"),
            ),
            const SizedBox(height: 16),
            if (arquivoSelecionado != null)
              Text("Arquivo: ${arquivoSelecionado!.path.split('/').last}"),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: enviarArquivo,
              icon: const Icon(Icons.send),
              label: const Text("Enviar"),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
