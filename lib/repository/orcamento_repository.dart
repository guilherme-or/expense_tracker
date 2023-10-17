import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:expense_tracker/models/orcamento.dart';

class OrcamentoRepository {
  Future<List<Orcamento>> listarOrcamentos() async {
    final supabase = Supabase.instance.client;
    final data =
        await supabase.from('orcamentos').select<List<Map<String, dynamic>>>();

    final orcamentos = data.map((e) => Orcamento.fromMap(e)).toList();

    return orcamentos;
  }
}