import 'dart:convert';

class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String peso;
  final String altura;
  final String objetivo;
  final bool isPremium;
  final String chaveLiberacao;
  final List<String> materialPremiumLinks;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.peso,
    required this.altura,
    required this.objetivo,
    this.isPremium = false,
    this.chaveLiberacao = '',
    this.materialPremiumLinks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'peso': peso,
      'altura': altura,
      'objetivo': objetivo,
      'isPremium': isPremium ? 1 : 0,
      'chaveLiberacao': chaveLiberacao,
      'materialPremiumLinks': jsonEncode(materialPremiumLinks),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      peso: map['peso'],
      altura: map['altura'],
      objetivo: map['objetivo'],
      isPremium: map['isPremium'] == 1 || map['isPremium'] == true,
      chaveLiberacao: map['chaveLiberacao'] ?? '',
      materialPremiumLinks: _extrairLinks(map['materialPremiumLinks']),
    );
  }

  static List<String> _extrairLinks(dynamic valor) {
    if (valor is String) {
      try {
        final List<dynamic> lista = jsonDecode(valor);
        return lista.map((e) => e.toString()).toList();
      } catch (_) {
        return [];
      }
    } else if (valor is List) {
      return valor.map((e) => e.toString()).toList();
    }
    return [];
  }
}
