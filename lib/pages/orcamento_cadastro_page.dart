import 'package:expense_tracker/components/categoria_select.dart';
import 'package:expense_tracker/models/categoria.dart';
import 'package:expense_tracker/models/orcamento.dart';
import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:expense_tracker/pages/categorias_select_page.dart';
import 'package:expense_tracker/repository/orcamento_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrcamentoCadastroPage extends StatefulWidget {
  final Orcamento? editOrcamento;

  const OrcamentoCadastroPage({super.key, this.editOrcamento});

  @override
  State<OrcamentoCadastroPage> createState() => _OrcamentoCadastroPageState();
}

class _OrcamentoCadastroPageState extends State<OrcamentoCadastroPage> {
  User? user;
  final OrcamentoRepository repository = OrcamentoRepository();

  final descricaoController = TextEditingController();
  final valorLimiteController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  Categoria? categoriaSelecionada;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final editOrcamento = widget.editOrcamento;

    if (editOrcamento != null) {
      descricaoController.text = editOrcamento.descricao;
      valorLimiteController.text = NumberFormat.simpleCurrency(locale: 'pt_BR')
          .format(editOrcamento.valorLimite);
      categoriaSelecionada = editOrcamento.categoria;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Transação'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoriaSelect(),
                const SizedBox(height: 30),
                _buildDescricao(),
                const SizedBox(height: 30),
                _buildValorLimite(),
                const SizedBox(height: 30),
                _buildSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CategoriaSelect _buildCategoriaSelect() {
    return CategoriaSelect(
      categoria: categoriaSelecionada,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategoriesSelectPage(
              tipoTransacao: TipoTransacao.despesa,
            ),
          ),
        ) as Categoria?;

        if (result != null) {
          setState(() {
            categoriaSelecionada = result;
          });
        }
      },
    );
  }

  TextFormField _buildDescricao() {
    return TextFormField(
      controller: descricaoController,
      decoration: const InputDecoration(
        hintText: 'Informe a descrição do orçamento',
        labelText: 'Descrição',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Descrição';
        }
        if (value.length < 3 || value.length > 50) {
          return 'A Descrição deve entre 3 e 50 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildValorLimite() {
    return TextFormField(
      controller: valorLimiteController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe o valor limite do orçamento',
        labelText: 'Valor',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.cash_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(valorLimiteController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor limite maior que zero';
        }

        return null;
      },
    );
  }

  SizedBox _buildSubmit() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            // Descricao
            final descricao = descricaoController.text;

            // Valor
            final valor = NumberFormat.currency(locale: 'pt_BR')
                .parse(valorLimiteController.text.replaceAll('R\$', ''));

            final userId = user?.id ?? '';

            final orcamento = Orcamento(
              id: 0,
              userId: userId,
              descricao: descricao,
              valorLimite: valor.toDouble(),
              categoria: categoriaSelecionada!,
            );

            if (widget.editOrcamento == null) {
              await _cadastrarOrcamento(orcamento);
            } else {
              orcamento.id = widget.editOrcamento!.id;
              await _alterarOrcamento(orcamento);
            }
          }
        },
        child: const Text('Enviar'),
      ),
    );
  }

  Future<void> _cadastrarOrcamento(Orcamento orcamento) async {
    final scaffold = ScaffoldMessenger.of(context);
    await repository.cadastrarOrcamento(orcamento).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Orçamento cadastrado com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Erro ao cadastrar o Orçamento',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarOrcamento(Orcamento orcamento) async {
    final scaffold = ScaffoldMessenger.of(context);
    await repository.alterarOrcamento(orcamento).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Orçamento alterado com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Erro ao alterar o Orçamento',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
