import 'package:app_nutripaloma/stores/receita_store.dart';
import 'package:get_it/get_it.dart';
import 'package:app_nutripaloma/stores/usuario_controller_store.dart';
import 'package:app_nutripaloma/stores/dietas_store.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => UsuarioControllerStore());
  getIt.registerLazySingleton(() => DietasStore());
  getIt.registerLazySingleton(() => ReceitasStore());
}
