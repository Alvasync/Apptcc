import 'package:flutter/material.dart';

class PrecificadorPage extends StatefulWidget {
  const PrecificadorPage({super.key});

  @override
  State<PrecificadorPage> createState() => _PrecificadorPageState();
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
      // Simulação de cálculo (pode ser substituído por API real ou Firestore)
      double base = 1000;
      if (_tipo == 'Casa') base = 2000;
      if (_tipo == 'Apartamento') base = 1800;
      if (_tipo == 'Comercial') base = 2500;
      double preco = base * (_area ?? 0) + ((_quartos ?? 1) * 10000);
      setState(() => _precoEstimado = preco);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Precificador de Imóvel')),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Bairro'),
                onSaved: (v) => _bairro = v,
                validator: (v) => v == null || v.isEmpty ? 'Informe o bairro' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Área (m²)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _area = double.tryParse(v ?? ''),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Informe a área' : null,
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
              if (_precoEstimado != null) ...[
                const SizedBox(height: 24),
                Text('Preço estimado: R\$ ${_precoEstimado!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 