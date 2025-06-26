import 'package:flutter/material.dart';
import 'imovel_detalhe_page.dart';

class BuscaPage extends StatefulWidget {
  const BuscaPage({super.key});

  @override
  State<BuscaPage> createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  final TextEditingController _controller = TextEditingController();
  String? _erro;

  void _buscar() {
    final termo = _controller.text.trim().toLowerCase();
    if (termo.isEmpty) {
      setState(() => _erro = 'Digite o tipo de imóvel para buscar.');
      return;
    }
    String tipo = '';
    String dicas = '';
    String titulo = '';
    if (termo.contains('casa')) {
      tipo = 'uma casa';
      titulo = 'Casa';
      dicas = 'Considere localização, segurança, tamanho, vizinhança e proximidade de serviços.';
    } else if (termo.contains('terreno')) {
      tipo = 'um terreno';
      titulo = 'Terreno';
      dicas = 'Verifique documentação, zoneamento, acesso, infraestrutura e valorização futura.';
    } else if (termo.contains('apartamento')) {
      tipo = 'um apartamento';
      titulo = 'Apartamento';
      dicas = 'Avalie condomínio, lazer, segurança, localização e custos mensais.';
    } else if (termo.contains('comercial')) {
      tipo = 'um imóvel comercial';
      titulo = 'Comercial';
      dicas = 'Pense em fluxo de pessoas, acessibilidade, estacionamento e potencial de crescimento.';
    } else {
      setState(() => _erro = 'Tipo de imóvel não encontrado.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImovelDetalhePage(tipo: tipo, titulo: titulo, dicas: dicas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Imóvel')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Buscar por casa, terreno, apartamento, comercial...',
                errorText: _erro,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscar,
                ),
              ),
              onSubmitted: (_) => _buscar(),
            ),
          ],
        ),
      ),
    );
  }
} 