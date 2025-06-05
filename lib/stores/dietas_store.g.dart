// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dietas_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DietasStore on _DietasStoreBase, Store {
  late final _$pdfsAtom = Atom(name: '_DietasStoreBase.pdfs', context: context);

  @override
  List<String> get pdfs {
    _$pdfsAtom.reportRead();
    return super.pdfs;
  }

  @override
  set pdfs(List<String> value) {
    _$pdfsAtom.reportWrite(value, super.pdfs, () {
      super.pdfs = value;
    });
  }

  late final _$carregandoAtom =
      Atom(name: '_DietasStoreBase.carregando', context: context);

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

  late final _$erroAtom = Atom(name: '_DietasStoreBase.erro', context: context);

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

  late final _$carregarDietasAsyncAction =
      AsyncAction('_DietasStoreBase.carregarDietas', context: context);

  @override
  Future<void> carregarDietas(Usuario usuario) {
    return _$carregarDietasAsyncAction.run(() => super.carregarDietas(usuario));
  }

  @override
  String toString() {
    return '''
pdfs: ${pdfs},
carregando: ${carregando},
erro: ${erro}
    ''';
  }
}
