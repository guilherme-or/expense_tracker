import 'package:expense_tracker_fiap/models/tipo_transacao.dart';
import 'package:expense_tracker_fiap/repository/categoria_repository.dart';
import 'package:flutter/material.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage();

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  final categorias = CategoriaRepository().getCategorias();
  
  @override
  Widget build(BuildContext context) {
    // Ordenação da lista de categorias
    categorias.sort((a, b) => a.nome.compareTo(b.nome));

    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      body: ListView.builder(
          itemCount: categorias.length,
          itemBuilder: (content, index) {
            var categoria = categorias[index];

            return ListTile(
              leading: CircleAvatar(
                child: Icon(categoria.icone, color: Colors.white,),
                backgroundColor: categoria.cor,
              ),
              title: Text(categoria.nome),
              trailing: Text(
                categoria.tipoTransacao == TipoTransacao.receita
                    ? "Receita"
                    : "Despesa",
                style: TextStyle(
                    color: categoria.tipoTransacao == TipoTransacao.receita
                        ? Colors.green
                        : Colors.red),
              ),
            );
          }),
    );
  }
}
