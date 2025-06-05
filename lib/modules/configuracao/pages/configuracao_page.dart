// lib/modules/configuracao/pages/configuracao_page.dart
import 'package:app_nutripaloma/models/usuario_model.dart';
import 'package:app_nutripaloma/stores/usuario_controller_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class ConfiguracaoPage extends StatefulWidget {
  const ConfiguracaoPage({super.key});

  @override
  State<ConfiguracaoPage> createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  final usuarioStore = GetIt.I<UsuarioControllerStore>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _pesoController;
  late TextEditingController _alturaController;

  @override
  void initState() {
    super.initState();
    final usuario = usuarioStore.usuario;
    _nomeController = TextEditingController(text: usuario?.nome);
    _pesoController = TextEditingController(text: usuario?.peso);
    _alturaController = TextEditingController(text: usuario?.altura);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      await usuarioStore.atualizarDadosLocais(
        nome: _nomeController.text.trim(),
        peso: _pesoController.text.trim(),
        altura: _alturaController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final usuario = usuarioStore.usuario;

        return Scaffold(
          appBar: AppBar(title: const Text('Configurações')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pesoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Peso (kg)'),
                    validator: (value) => value == null || value.isEmpty ? 'Informe o peso' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _alturaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Altura (m)'),
                    validator: (value) => value == null || value.isEmpty ? 'Informe a altura' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _salvar,
                    child: const Text('Salvar alterações'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
