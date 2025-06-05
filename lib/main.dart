import 'package:app_nutripaloma/core/dao/usuario_dao.dart';
import 'package:app_nutripaloma/core/locator.dart';
import 'package:app_nutripaloma/core/routes/app_routes.dart';
import 'package:app_nutripaloma/stores/dietas_store.dart';
import 'package:app_nutripaloma/stores/usuario_controller_store.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  final prefs = await SharedPreferences.getInstance();
  final dao = UsuarioDAO();
  final usuario = await dao.buscarUsuario();
  final isCadastrado = prefs.getBool('usuarioCadastrado') ?? false;

  runApp(MyApp(
    usuarioCadastrado: isCadastrado && usuario != null,
  ));
}

class MyApp extends StatelessWidget {
  final bool usuarioCadastrado;

  const MyApp({super.key, required this.usuarioCadastrado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriPaloma',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      initialRoute: usuarioCadastrado ? '/home' : '/splash',
      routes: AppRoutes.routes,
    );
  }
}
