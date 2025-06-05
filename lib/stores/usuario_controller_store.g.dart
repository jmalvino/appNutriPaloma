// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_controller_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UsuarioControllerStore on _UsuarioControllerStoreBase, Store {
  late final _$usuarioAtom =
      Atom(name: '_UsuarioControllerStoreBase.usuario', context: context);

  @override
  Usuario? get usuario {
    _$usuarioAtom.reportRead();
    return super.usuario;
  }

  @override
  set usuario(Usuario? value) {
    _$usuarioAtom.reportWrite(value, super.usuario, () {
      super.usuario = value;
    });
  }

  late final _$carregarUsuarioAsyncAction = AsyncAction(
      '_UsuarioControllerStoreBase.carregarUsuario',
      context: context);

  @override
  Future<void> carregarUsuario() {
    return _$carregarUsuarioAsyncAction.run(() => super.carregarUsuario());
  }

  late final _$atualizarUsuarioAsyncAction = AsyncAction(
      '_UsuarioControllerStoreBase.atualizarUsuario',
      context: context);

  @override
  Future<void> atualizarUsuario(Usuario novoUsuario) {
    return _$atualizarUsuarioAsyncAction
        .run(() => super.atualizarUsuario(novoUsuario));
  }

  late final _$limparUsuarioAsyncAction = AsyncAction(
      '_UsuarioControllerStoreBase.limparUsuario',
      context: context);

  @override
  Future<void> limparUsuario() {
    return _$limparUsuarioAsyncAction.run(() => super.limparUsuario());
  }

  late final _$atualizarDadosLocaisAsyncAction = AsyncAction(
      '_UsuarioControllerStoreBase.atualizarDadosLocais',
      context: context);

  @override
  Future<void> atualizarDadosLocais(
      {required String nome, required String peso, required String altura}) {
    return _$atualizarDadosLocaisAsyncAction.run(() =>
        super.atualizarDadosLocais(nome: nome, peso: peso, altura: altura));
  }

  @override
  String toString() {
    return '''
usuario: ${usuario}
    ''';
  }
}
