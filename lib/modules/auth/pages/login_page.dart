import 'package:app_nutripaloma/core/dao/usuario_dao.dart';
import 'package:app_nutripaloma/core/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _usuarioService = UsuarioService();
  final _usuarioDAO = UsuarioDAO();

  bool _carregando = false;
  String? _erro;

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _carregando = false;
        _erro = 'Informe o e-mail';
      });
      return;
    }

    final usuario = await _usuarioService.buscarUsuarioPorEmail(email);

    if (usuario == null) {
      setState(() {
        _carregando = false;
        _erro = 'Usuário não encontrado';
      });
      return;
    }

    await _usuarioDAO.salvarUsuario(usuario);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('usuarioCadastrado', true);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Informe seu e-mail para acessar o app'),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            if (_erro != null)
              Text(
                _erro!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _carregando ? null : _login,
              child: _carregando
                  ? const CircularProgressIndicator()
                  : const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
