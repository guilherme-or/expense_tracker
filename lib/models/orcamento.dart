import 'package:expense_tracker/models/categoria.dart';

class Orcamento {
  int id;
  String userId;
  String descricao;
  double valorLimite;
  DateTime dataCriado;
  Categoria categoria;

  Orcamento({
    required this.id,
    required this.userId,
    required this.descricao,
    required this.valorLimite,
    required this.dataCriado,
    required this.categoria,
  });

  factory Orcamento.fromMap(Map<String, dynamic> map) {
    return Orcamento(
      id: map['id'],
      userId: map['user_id'],
      descricao: map['descricao'],
      valorLimite: map['valor'],
      dataCriado: DateTime.parse(map['data_transacao']),
      categoria: Categoria.fromMap(map['categorias']),
    );
  }
}
