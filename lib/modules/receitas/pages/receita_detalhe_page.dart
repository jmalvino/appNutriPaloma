import 'package:app_nutripaloma/models/receita_model.dart';
import 'package:flutter/material.dart';

class ReceitaDetalhePage extends StatelessWidget {
  const ReceitaDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    final receita = ModalRoute.of(context)!.settings.arguments as Receita;

    return Scaffold(
      appBar: AppBar(title: Text(receita.titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (receita.imagemUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(receita.imagemUrl),
              ),
            const SizedBox(height: 16),
            const Text('Ingredientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(receita.ingredientes),
            const SizedBox(height: 16),
            const Text('Modo de Preparo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(receita.modoPreparo),
          ],
        ),
      ),
    );
  }
}
