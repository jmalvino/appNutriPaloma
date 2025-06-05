import 'package:app_nutripaloma/core/dao/receita_dao.dart';
import 'package:app_nutripaloma/models/receita_model.dart';
import 'package:flutter/material.dart';


class ReceitaFormPage extends StatefulWidget {
  const ReceitaFormPage({super.key});

  @override
  State<ReceitaFormPage> createState() => _ReceitaFormPageState();
}

class _ReceitaFormPageState extends State<ReceitaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ReceitaDAO _dao = ReceitaDAO();

  String _titulo = '';
  String _ingredientes = '';
  String _modoPreparo = '';
  String _imagemUrl = '';

  Future<void> _salvarReceita() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final receita = Receita(
        titulo: _titulo,
        ingredientes: _ingredientes,
        modoPreparo: _modoPreparo,
        imagemUrl: _imagemUrl,
      );

      await _dao.salvarReceita(receita);

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Receita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                onSaved: (value) => _titulo = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ingredientes'),
                onSaved: (value) => _ingredientes = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Informe os ingredientes' : null,
                maxLines: 4,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Modo de Preparo'),
                onSaved: (value) => _modoPreparo = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Informe o modo de preparo' : null,
                maxLines: 6,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'URL da Imagem'),
                onSaved: (value) => _imagemUrl = value!.trim(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarReceita,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
