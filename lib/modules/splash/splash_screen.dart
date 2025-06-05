// lib/modules/splash/pages/splash_screen.dart
import 'package:app_nutripaloma/core/dao/usuario_dao.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _verificarUsuario();
  }

  Future<void> _verificarUsuario() async {
    await Future.delayed(const Duration(seconds: 2));

    final usuario = await UsuarioDAO().getUsuario();

    if (usuario != null && usuario.email.isNotEmpty) {
      // Usuário existe localmente, ir para login
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Nenhum usuário preenchido, redireciona para tela de decisão
      Navigator.pushReplacementNamed(context, '/escolha-login-ou-cadastro');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              child: Container(
                width: 60,
                height: 60,
                color: Colors.green,
              ),
              // child: Image(
              //   image: AssetImage('assets/logo.png'),
              // ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
