class Receita {
  final String titulo;
  final String url;

  Receita({required this.titulo, required this.url});

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      titulo: json['titulo'],
      url: json['arquivo'],
    );
  }
}
