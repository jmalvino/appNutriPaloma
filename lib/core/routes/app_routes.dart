// app_routes.dart
import 'package:app_nutripaloma/modules/auth/pages/cadastro_page.dart';
import 'package:app_nutripaloma/modules/auth/pages/escolha_login_cadastro_page.dart';
import 'package:app_nutripaloma/modules/auth/pages/login_page.dart';
import 'package:app_nutripaloma/modules/configuracao/pages/configuracao_page.dart';
import 'package:app_nutripaloma/modules/dietas/pages/dieta_page.dart';
import 'package:app_nutripaloma/modules/home/pages/home_page.dart';
import 'package:app_nutripaloma/modules/premium/pages/premium_page.dart';
import 'package:app_nutripaloma/modules/receitas/pages/receita_detalhe_page.dart';
import 'package:app_nutripaloma/modules/receitas/pages/receita_form_page.dart';
import 'package:app_nutripaloma/modules/receitas/pages/receita_page.dart';
import 'package:app_nutripaloma/modules/splash/splash_screen.dart';

class AppRoutes {
  static final routes = {
    '/splash': (context) => const SplashScreen(),
    '/login': (context) => const LoginPage(),
    '/cadastro': (context) => const CadastroPage(),
    '/home': (context) => const HomePage(),
    '/dietas': (context) => const DietaPage(),
    '/receitas': (context) => const ReceitaPage(),
    '/receita_detalhe': (context) => const ReceitaDetalhePage(),
    '/configuracao': (context) => const ConfiguracaoPage(),
    '/premium': (context) => const PremiumPage(),
    '/nova-receita': (context) => const ReceitaFormPage(),
    '/escolha-login-ou-cadastro': (_) => const EscolhaLoginCadastroPage(),


  };
}