import 'package:app_nutripaloma/core/dao/usuario_dao.dart';
import 'package:flutter/material.dart';

Future<bool> verificarUsuarioAutenticado(BuildContext context) async {
  final dao = UsuarioDAO();
  final usuario = await dao.getUsuario();

  if (usuario == null) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    return false;
  }
  return true;
}
