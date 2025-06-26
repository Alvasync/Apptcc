import 'package:flutter/material.dart';

class ImovelDetalhePage extends StatelessWidget {
  final String tipo;
  final String titulo;
  final String dicas;
  const ImovelDetalhePage({super.key, required this.tipo, required this.titulo, required this.dicas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dicas para escolher $tipo:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              dicas,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 