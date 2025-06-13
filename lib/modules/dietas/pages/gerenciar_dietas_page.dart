import 'dart:convert';
import 'package:app_nutripaloma/models/dieta_model.dart';
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
  List<DietaModel> dietas = [];
  bool carregando = false;

  Future<int> buscarIdUsuario(String email) async {
    final url = 'https://nutripalomamartins.com.br/api_nutri/usuarios.json';
    debugPrint('🔎 Buscando ID do usuário em: $url');

    final response = await http.get(Uri.parse(url));
    debugPrint('🔁 Status code: ${response.statusCode}');
    debugPrint('📥 Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      for (var u in data) {
        if (u['email'].toString().toLowerCase() == email.toLowerCase()) {
          debugPrint('✅ ID do usuário encontrado: ${u['id']}');
          return u['id'];
        }
      }

      throw Exception('Usuário com e-mail "$email" não encontrado.');
    } else {
      throw Exception('Erro ao buscar usuários: ${response.statusCode}');
    }
  }

  Future<void> buscarDietas() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      carregando = true;
      dietas.clear();
    });

    try {
      final idUsuario = await buscarIdUsuario(email);
      final url = 'https://nutripalomamartins.com.br/dietas/$idUsuario/dietas.json';
      debugPrint('📡 Buscando dietas em: $url');

      final response = await http.get(Uri.parse(url));
      debugPrint('🔁 Status code: ${response.statusCode}');
      debugPrint('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            dietas = data.map((e) => DietaModel.fromJson(e)).toList();
            debugPrint('📄 Dietas carregadas: ${dietas.length}');
          });
        } else {
          _mostrarErro('❌ Resposta inesperada da API.');
          debugPrint('⚠️ Tipo de resposta: ${data.runtimeType}');
        }
      } else {
        _mostrarErro('❌ Erro ${response.statusCode} ao buscar dietas.');
      }
    } catch (e) {
      debugPrint('❌ Exceção ao buscar dietas: $e');
      _mostrarErro('Erro ao buscar dietas: $e');
    } finally {
      setState(() => carregando = false);
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _abrirPdf(String url) {
    debugPrint('📂 Abrindo PDF: $url');

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

  Future<void> _confirmarExclusao(DietaModel dieta) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Dieta'),
        content: const Text('Deseja realmente excluir esta dieta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirm != true) return;

    final email = emailController.text.trim();

    try {
      debugPrint('🗑️ Solicitando exclusão da dieta ID ${dieta.id}...');
      final response = await http.post(
        Uri.parse('https://nutripalomamartins.com.br/api_nutri/delete_dieta.php'),
        body: {
          'email': email,
          'id_dieta': dieta.id.toString(),
        },
      );

      debugPrint('🔁 Status code: ${response.statusCode}');
      debugPrint('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'sucesso') {
          setState(() {
            dietas.removeWhere((d) => d.id == dieta.id);
          });
          _mostrarErro('✅ Dieta excluída com sucesso');
        } else {
          _mostrarErro('Erro: ${body['mensagem']}');
        }
      } else {
        _mostrarErro('Erro ao excluir dieta (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('❌ Exceção ao excluir: $e');
      _mostrarErro('Erro ao excluir dieta: $e');
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
                    final dieta = dietas[index];
                    return ListTile(
                      title: Text(dieta.titulo),
                      subtitle: Text(dieta.nomeArquivo),
                      leading: const Icon(Icons.picture_as_pdf),
                      onTap: () => _abrirPdf(dieta.url),
                      onLongPress: () => _confirmarExclusao(dieta),
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
