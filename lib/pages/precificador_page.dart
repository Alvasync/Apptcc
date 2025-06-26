import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrecificadorPage extends StatefulWidget {
  const PrecificadorPage({super.key});

  @override
  State<PrecificadorPage> createState() => _PrecificadorPageState();
}

const List<String> bairros = [
  "Águas de Igaratá", "Altos de Sant'ana I", "Altos de Sant'ana II", "Avareí",
  "Balneário Paraíba", "Bandeira Branca I", "Bandeira Branca II", "Beira Rio",
  "Bela Vista", "Bica do Boi", "Campo Grande", "Cassununga", "Centro",
  "Chacaras Guararema", "Chacaras Marília", "Chacaras Reunidas do Igarapés",
  "Cidade Jardim", "Cidade Salvador", "Clube de Campo", "Conjunto 1° de Maio",
  "Conjunto 22 de Abril", "Conjunto São Benedito", "Estância Porto Velho",
  "Fazenda Três Moleques", "Igarapés", "Itapoã", "Jardim América",
  "Jardim Bela Vista", "Jardim Boa Vista", "Jardim Califórnia", "Jardim Coleginho",
  "Jardim das Oliveiras", "Jardim Emília", "Jardim Esperança", "Jardim Flórida",
  "Jardim Guarani", "Jardim Independência", "Jardim Jacinto", "Jardim Leblon",
  "Jardim Leonidia", "Jardim Liberdade", "Jardim Luíza", "Jardim Marcondes",
  "Jardim Maria Amélia I", "Jardim Maria Amélia II", "Jardim Marister", "Jardim Mesquita",
  "Jardim Nicélia", "Jardim Nossa Senhora de Lourdes", "Jardim Nova Esperança",
  "Jardim Novo Amanhecer", "Jardim Olímpia", "Jardim Panorama", "Jardim Paraíba",
  "Jardim Paraíso", "Jardim Paulistano", "Jardim Pereira do Amparo", "Jardim Pitoresco",
  "Jardim Primavera", "Jardim Real", "Jardim Santa Maria", "Jardim Santa Marina",
  "Jardim Santa Terezinha", "Jardim São Gabriel", "Jardim São José", "Jardim São Luiz",
  "Jardim São Manoel", "Jardim São Paulo", "Jardim Siesta", "Jardim Sper",
  "Jardim Vera Lúcia", "Jardim Vista Verde", "Jardim Yolanda", "Lagoinha",
  "Lagoa Azul", "Mandi", "Mirante do Vale", "Nova Aliança", "Nova Jacareí",
  "Pagador Andrade", "Parateí de Baixo", "Parateí de Cima", "Parateí do Meio",
  "Parque Brasil", "Parque Califórnia", "Parque dos Príncipes", "Parque dos Sinos",
  "Parque Imperial", "Parque Itamaraty", "Parque Meia Lua", "Parque Nova América",
  "Parque Residencial Jequitiba", "Parque Santo Antônio", "Parque Santa Paula",
  "Pedramar", "Pedras Preciosas", "Pedregulho", "Portal Alvorada",
  "Prolongamento Santa Maria", "Recanto dos Pássaros", "Remédios", "Rio Abaixo",
  "Rio Comprido", "Santa Cruz dos Lázaros", "Santo Antonio da Boa Vista",
  "São João", "São Silvestre", "Sunset Garden", "Terras da Conceição",
  "Terras de Santa Clara", "Terras de Santa Helena", "Terras de Sant'ana",
  "Terras de São João", "Vale dos Lagos", "Veraneio Ijal", "Veraneio Irajá",
  "Vila Aprazível", "Vila Denise", "Vila D'Itália", "Vila Emídia Costa",
  "Vila Formosa", "Vila Garcia", "Vila Lopez", "Vila Machado", "Vila Martinez",
  "Vila Nossa Senhora de Fátima", "Vila Pinheiro", "Vila Romana", "Vila Santa Mônica",
  "Vila Santa Rita", "Vila São Judas Tadeu", "Vila São João II", "Vila São Simão",
  "Vila Vilma", "Vila Zezé", "Vilas de Sant'ana", "Villa Branca", "Vista Azul"
];

double predictPrice({
  required String bairro,
  required double areaConstruida,
  required double areaTerreno,
  required int quartos,
  required int banheiros,
  required String tipoImovel,
}) {
  final valorM2 = {
    'Casa': 3000.0,
    'Apartamento': 3000.0,
    'Terreno': 700.0,
    'Comercial': 4000.0,
  };
  double precoEstimado;
  if (tipoImovel == 'Casa') {
    precoEstimado = areaConstruida * valorM2['Casa']! + areaTerreno * valorM2['Terreno']!;
  } else if (tipoImovel == 'Terreno') {
    precoEstimado = areaTerreno * valorM2['Terreno']!;
  } else {
    precoEstimado = areaConstruida * (valorM2[tipoImovel] ?? 3000.0);
  }
  return double.parse(precoEstimado.toStringAsFixed(2));
}

class _PrecificadorPageState extends State<PrecificadorPage> {
  final _formKey = GlobalKey<FormState>();
  String? _tipo;
  String? _bairro;
  double? _area;
  int? _quartos;
  double? _precoEstimado;

  void _calcularPreco() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Chama a função de precificação integrada
      setState(() {
        _precoEstimado = predictPrice(
          bairro: _bairro ?? '',
          areaConstruida: _area ?? 0,
          areaTerreno: _tipo == 'Casa' || _tipo == 'Terreno' ? _area ?? 0 : 0,
          quartos: _quartos ?? 1,
          banheiros: 1, // Pode adicionar campo se quiser
          tipoImovel: _tipo ?? '',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.background;
    final precoFormatado = _precoEstimado != null
        ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(_precoEstimado)
        : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Precificador de Imóvel')),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _tipo,
                items: const [
                  DropdownMenuItem(value: 'Casa', child: Text('Casa')),
                  DropdownMenuItem(value: 'Apartamento', child: Text('Apartamento')),
                  DropdownMenuItem(value: 'Terreno', child: Text('Terreno')),
                  DropdownMenuItem(value: 'Comercial', child: Text('Comercial')),
                ],
                onChanged: (v) => setState(() => _tipo = v),
                decoration: const InputDecoration(labelText: 'Tipo de imóvel'),
                validator: (v) => v == null ? 'Selecione o tipo' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _bairro,
                items: bairros.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (v) => setState(() => _bairro = v),
                decoration: const InputDecoration(labelText: 'Bairro'),
                validator: (v) => v == null ? 'Selecione o bairro' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Área construída (m²)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _area = double.tryParse(v ?? ''),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Informe a área construída' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quartos'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _quartos = int.tryParse(v ?? ''),
                validator: (v) => v == null || int.tryParse(v) == null ? 'Informe o número de quartos' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calcularPreco,
                child: const Text('Calcular Preço'),
              ),
              if (precoFormatado != null) ...[
                const SizedBox(height: 24),
                Text('Preço estimado: $precoFormatado', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 