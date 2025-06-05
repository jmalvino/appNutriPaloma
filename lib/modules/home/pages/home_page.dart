// lib/modules/home/pages/home_page.dart
import 'package:app_nutripaloma/core/dao/usuario_dao.dart';
import 'package:app_nutripaloma/core/utils/auth_guard.dart';
import 'package:app_nutripaloma/models/usuario_model.dart';
import 'package:app_nutripaloma/stores/usuario_controller_store.dart';
import 'package:app_nutripaloma/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usuarioStore = GetIt.I<UsuarioControllerStore>(); // Certifique-se que foi registrado no GetIt

  @override
  void initState() {
    super.initState();
    _verificarSessao();
  }

  Future<void> _verificarSessao() async {
    final autenticado = await verificarUsuarioAutenticado(context);
    if (autenticado) {
      _carregarUsuario();
    }
  }

  Future<void> _carregarUsuario() async {
    await usuarioStore.carregarUsuario();
  }

  Future<void> _logout() async {
    final dao = UsuarioDAO();
    await dao.deletarUsuario();
    await usuarioStore.limparUsuario(); // Opcional: limpar store ao deslogar
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final usuario = usuarioStore.usuario;
        final nome = usuario?.nome ?? 'Usuário';
        final email = usuario?.email ?? '';

        return Scaffold(
          appBar: AppBar(title: Text('Bem-vindo(a)!')),
          drawer: const CustomDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/dietas'),
                  child: const Text('📄 Minhas Dietas'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/receitas'),
                  child: const Text('🍲 Receitas'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/configuracao'),
                  child: const Text('⚙️ Configurações'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/premium'),
                  child: const Text('🌟 Área Premium'),
                ),
                const SizedBox(height: 20),
                if (email == 'admin@nutripaloma.com')
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/nova-receita'),
                    child: const Text('➕ Nova Receita (Admin)'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
