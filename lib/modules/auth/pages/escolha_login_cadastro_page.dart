// lib/modules/auth/pages/escolha_login_cadastro_page.dart
import 'package:flutter/material.dart';

class EscolhaLoginCadastroPage extends StatelessWidget {
  const EscolhaLoginCadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem-vindo!')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Você já possui cadastro?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Sim, já tenho'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/cadastro');
              },
              child: const Text('Não, sou novo aqui'),
            ),
          ],
        ),
      ),
    );
  }
}
