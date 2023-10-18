import 'package:expense_tracker/models/orcamento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrcamentoItem extends StatelessWidget {
  final Orcamento orcamento;
  final void Function()? onTap;

  const OrcamentoItem(
      {super.key, required this.orcamento, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: orcamento.categoria.cor,
        child: Icon(
          orcamento.categoria.icone,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(orcamento.descricao),
      subtitle: Text(DateFormat('MM/dd/yyyy').format(orcamento.dataCriado ?? DateTime.now())),
      trailing: Text(
          NumberFormat.simpleCurrency(locale: 'pt_BR')
              .format(orcamento.valorLimite),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          )),
      onTap: onTap,
    );
  }
}
