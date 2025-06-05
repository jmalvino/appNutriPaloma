class Receita {
  final int? id;
  final String titulo;
  final String ingredientes;
  final String modoPreparo;
  final String imagemUrl;

  Receita({
    this.id,
    required this.titulo,
    required this.ingredientes,
    required this.modoPreparo,
    required this.imagemUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'ingredientes': ingredientes,
      'modoPreparo': modoPreparo,
      'imagemUrl': imagemUrl,
    };
  }

  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      id: map['id'],
      titulo: map['titulo'],
      ingredientes: map['ingredientes'],
      modoPreparo: map['modoPreparo'],
      imagemUrl: map['imagemUrl'],
    );
  }
}
