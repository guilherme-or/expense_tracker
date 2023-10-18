import 'package:expense_tracker/components/orcamento_item.dart';
import 'package:expense_tracker/models/orcamento.dart';
import 'package:expense_tracker/pages/orcamento_cadastro_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:expense_tracker/repository/orcamento_repository.dart';
import 'package:flutter/material.dart';

class OrcamentoPage extends StatefulWidget {
  const OrcamentoPage({super.key});

  @override
  State<OrcamentoPage> createState() => _OrcamentoPageState();
}

class _OrcamentoPageState extends State<OrcamentoPage> {
  final OrcamentoRepository repository = OrcamentoRepository();
  late Future<List<Orcamento>> futureOrcamentos;
  User? user;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;
    futureOrcamentos = repository.listarOrcamentos(userId: user?.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamentos'),
      ),
      body: FutureBuilder<List<Orcamento>>(
        future: futureOrcamentos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar os orçamentos"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhum orçamento cadastrado"),
            );
          } else {
            final orcamentos = snapshot.data!;
            return ListView.separated(
              itemCount: orcamentos.length,
              itemBuilder: (context, index) {
                final orcamento = orcamentos[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrcamentoCadastroPage(
                                editOrcamento: orcamento,
                              ),
                            ),
                          ) as bool?;

                          if (result == true) {
                            setState(() {
                              futureOrcamentos = repository.listarOrcamentos(
                                userId: user?.id ?? '',
                              );
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await repository.excluirOrcamento(orcamento.id);

                          setState(() {
                            orcamentos.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remover',
                      ),
                    ],
                  ),
                  child: OrcamentoItem(
                    orcamento: orcamento,
                    onTap: () {
                      Navigator.pushNamed(context, '/orcamento-detalhe',
                          arguments: orcamento);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "orcamento-cadastro",
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/orcamento-cadastro')
                  as bool?;

          if (result == true) {
            setState(() {
              futureOrcamentos = repository.listarOrcamentos(
                userId: user?.id ?? '',
              );
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
