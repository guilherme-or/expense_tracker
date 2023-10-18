import 'package:expense_tracker/models/orcamento.dart';
import 'package:expense_tracker/repository/orcamento_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrcamentoDetalhePage extends StatefulWidget {
  const OrcamentoDetalhePage({super.key});

  @override
  State<OrcamentoDetalhePage> createState() => _OrcamentoDetalhePageState();
}

class _OrcamentoDetalhePageState extends State<OrcamentoDetalhePage> {
  final repository = OrcamentoRepository();

  @override
  Widget build(BuildContext context) {
    final orcamento = ModalRoute.of(context)!.settings.arguments as Orcamento;

    return Scaffold(
      appBar: AppBar(
        title: Text(orcamento.descricao),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Categoria'),
              subtitle: Text(orcamento.categoria.descricao),
            ),
            ListTile(
              title: const Text('Valor Limite'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(orcamento.valorLimite)),
            ),
            ListTile(
              title: const Text('Data de Criação'),
              subtitle: Text(DateFormat('MM/dd/yyyy')
                  .format(orcamento.dataCriado ?? DateTime.now())),
            ),
          ],
        ),
      ),
    );
  }
}
