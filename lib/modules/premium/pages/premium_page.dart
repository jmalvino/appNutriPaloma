import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Área Premium')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.play_circle),
              label: const Text('Aulas em Vídeo'),
              onPressed: () {
                // TODO: implementar
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.book),
              label: const Text('E-books e Materiais'),
              onPressed: () {
                // TODO: implementar
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.stars),
              label: const Text('Conteúdo Especial'),
              onPressed: () {
                // TODO: implementar
              },
            ),
          ],
        ),
      ),
    );
  }
}
