// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receita_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReceitasStore on _ReceitasStore, Store {
  late final _$receitasAtom =
      Atom(name: '_ReceitasStore.receitas', context: context);

  @override
  ObservableList<Receita> get receitas {
    _$receitasAtom.reportRead();
    return super.receitas;
  }

  @override
  set receitas(ObservableList<Receita> value) {
    _$receitasAtom.reportWrite(value, super.receitas, () {
      super.receitas = value;
    });
  }

  late final _$carregandoAtom =
      Atom(name: '_ReceitasStore.carregando', context: context);

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

  late final _$carregarReceitasAsyncAction =
      AsyncAction('_ReceitasStore.carregarReceitas', context: context);

  @override
  Future<void> carregarReceitas() {
    return _$carregarReceitasAsyncAction.run(() => super.carregarReceitas());
  }

  @override
  String toString() {
    return '''
receitas: ${receitas},
carregando: ${carregando}
    ''';
  }
}
