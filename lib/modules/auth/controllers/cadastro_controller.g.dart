// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CadastroController on _CadastroControllerBase, Store {
  late final _$nomeAtom =
      Atom(name: '_CadastroControllerBase.nome', context: context);

  @override
  String get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  late final _$emailAtom =
      Atom(name: '_CadastroControllerBase.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$pesoAtom =
      Atom(name: '_CadastroControllerBase.peso', context: context);

  @override
  String get peso {
    _$pesoAtom.reportRead();
    return super.peso;
  }

  @override
  set peso(String value) {
    _$pesoAtom.reportWrite(value, super.peso, () {
      super.peso = value;
    });
  }

  late final _$alturaAtom =
      Atom(name: '_CadastroControllerBase.altura', context: context);

  @override
  String get altura {
    _$alturaAtom.reportRead();
    return super.altura;
  }

  @override
  set altura(String value) {
    _$alturaAtom.reportWrite(value, super.altura, () {
      super.altura = value;
    });
  }

  late final _$objetivoAtom =
      Atom(name: '_CadastroControllerBase.objetivo', context: context);

  @override
  String get objetivo {
    _$objetivoAtom.reportRead();
    return super.objetivo;
  }

  @override
  set objetivo(String value) {
    _$objetivoAtom.reportWrite(value, super.objetivo, () {
      super.objetivo = value;
    });
  }

  late final _$carregandoAtom =
      Atom(name: '_CadastroControllerBase.carregando', context: context);

  @override
  bool get carregando {
    _$carregandoAtom.reportRead();
    return super.carregando;
  }

  @override
  set carregando(bool value) {
    _$carregandoAtom.reportWrite(value, super.carregando, () {
      super.carregando = value;
    });
  }

  late final _$erroAtom =
      Atom(name: '_CadastroControllerBase.erro', context: context);

  @override
  String? get erro {
    _$erroAtom.reportRead();
    return super.erro;
  }

  @override
  set erro(String? value) {
    _$erroAtom.reportWrite(value, super.erro, () {
      super.erro = value;
    });
  }

  late final _$cadastrarUsuarioAsyncAction =
      AsyncAction('_CadastroControllerBase.cadastrarUsuario', context: context);

  @override
  Future<bool> cadastrarUsuario() {
    return _$cadastrarUsuarioAsyncAction.run(() => super.cadastrarUsuario());
  }

  @override
  String toString() {
    return '''
nome: ${nome},
email: ${email},
peso: ${peso},
altura: ${altura},
objetivo: ${objetivo},
carregando: ${carregando},
erro: ${erro}
    ''';
  }
}
