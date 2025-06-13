class DietaModel {
  final int id;
  final String titulo;
  final String nomeArquivo;
  final String url;

  DietaModel({
    required this.id,
    required this.titulo,
    required this.nomeArquivo,
    required this.url,
  });

  factory DietaModel.fromJson(Map<String, dynamic> json) {
    return DietaModel(
      id: json['id_dieta'],
      titulo: json['titulo'],
      nomeArquivo: json['nome_arquivo'],
      url: json['url'],
    );
  }
}
