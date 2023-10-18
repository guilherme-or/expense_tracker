import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:expense_tracker/models/orcamento.dart';

class OrcamentoRepository {
  Future<List<Orcamento>> listarOrcamentos({required String userId}) async {
    final supabase = Supabase.instance.client;

    var query =
        supabase.from('orcamentos').select<List<Map<String, dynamic>>>('''
            *,
            categorias (
              *
            )
            ''').eq('user_id', userId);

    var data = await query;

    final list = data.map((map) {
      return Orcamento.fromMap(map);
    }).toList();

    return list;
  }

  Future cadastrarOrcamento(Orcamento orcamento) async {
    final supabase = Supabase.instance.client;

    await supabase.from('orcamentos').insert({
      'descricao': orcamento.descricao,
      'user_id': orcamento.userId,
      'valor_limite': orcamento.valorLimite,
      'categoria_id': orcamento.categoria.id,
    });
  }

  Future alterarOrcamento(Orcamento orcamento) async {
    final supabase = Supabase.instance.client;

    await supabase.from('orcamentos').update({
      'descricao': orcamento.descricao,
      'user_id': orcamento.userId,
      'valor_limite': orcamento.valorLimite,
      'categoria_id': orcamento.categoria.id,
    }).match({'id': orcamento.id});
  }

  Future excluirOrcamento(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('orcamentos').delete().match({'id': id});
  }

  Future<double> calcularValorRestante(Orcamento orcamento) async {
    final supabase = Supabase.instance.client;
    var data = await supabase
        .from('transacoes')
        .select<List<Map<String, dynamic>>>('valor')
        .eq('categoria_id', orcamento.categoria.id);

    double valorRestante = 0;

    for (var element in data) {
      valorRestante += element['valor'] ?? 0;
    }

    return valorRestante;
  }
}
