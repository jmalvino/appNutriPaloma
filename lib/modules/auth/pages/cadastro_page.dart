import 'package:app_nutripaloma/modules/auth/controllers/cadastro_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  late CadastroController controller;

  final _formKey = GlobalKey<FormState>();
  final List<String> objetivos = [
    'Perda de peso',
    'Introdução alimentar',
    'Gestante'
  ];

  @override
  void initState() {
    super.initState();
    controller = CadastroController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Inicial')),
      body: Observer(
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome'),
                  onChanged: (v) => controller.nome = v,
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (v) => controller.email = v,
                  validator: (v) =>
                  v == null || !v.contains('@') ? 'Email inválido' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.peso = v,
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Altura (m)'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.altura = v,
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: controller.objetivo,
                  items: objetivos
                      .map((o) =>
                      DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
                  onChanged: (v) => controller.objetivo = v ?? '',
                  decoration:
                  const InputDecoration(labelText: 'Objetivo nutricional'),
                ),
                const SizedBox(height: 20),
                controller.carregando
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final ok = await controller.cadastrarUsuario();
                      if (ok) {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(controller.erro ?? 'Erro'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Concluir Cadastro'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
