class Receita {
  final int id;
  final String titulo;
  final String url;

  Receita({
    required this.id,
    required this.titulo,
    required this.url,
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['id_receita'],
      titulo: json['titulo'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id_receita': id,
    'titulo': titulo,
    'url': url,
  };
}
