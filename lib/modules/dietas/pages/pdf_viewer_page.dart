import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewerPage extends StatelessWidget {
  final String url;
  final String titulo;

  const PdfViewerPage({super.key, required this.url, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // em breve: compartilhar link do PDF
            },
          ),
        ],
      ),
      body: const PDF().cachedFromUrl(
        url,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text('Erro ao carregar PDF')),
      ),
    );
  }
}
