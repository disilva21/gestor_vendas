import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/categoria/domain/entities/categoria.dart';

import 'cubit/produto_cubit.dart';
import 'cubit/produto_state.dart';

class ProdutoListScreen extends StatefulWidget {
  @override
  _EntregaPageState createState() => _EntregaPageState();
}

class _EntregaPageState extends State<ProdutoListScreen> with SingleTickerProviderStateMixin {
  late ProdutoCubit _cubit;

  bool status = true;

  TextEditingController searchController = TextEditingController();
  CategoriaEntity? categoriaIdSelected;

  @override
  void initState() {
    _cubit = BlocProvider.of<ProdutoCubit>(context);

    _cubit.carregarProdutos();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ProdutoCubit, ProdutoState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              _cubit.filtroTexto = value;
                              _cubit.seachProdutos(searchController.text);
                            },
                            controller: searchController,
                            decoration: InputDecoration(
                              labelText: "Buscar produto por nome ou código",
                              labelStyle: TextStyle(color: Colors.blue),
                              prefixIcon: Icon(Icons.search, color: Colors.blue),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _cubit.closeSeachProdutos();
                                  searchController.text = '';
                                  _cubit.filtroTexto = '';
                                },
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(top: 12),
                          height: 80,
                          child: DropdownButtonFormField<CategoriaEntity>(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                hintText: "Selecione uma categoria",
                                hintStyle: theme.textTheme.bodyText2!.copyWith(color: Colors.black)
                                // fillColor: Colors.grey[300],
                                ),
                            dropdownColor: Colors.white,
                            value: categoriaIdSelected,
                            items: _cubit.categorias.map((CategoriaEntity e) {
                              return DropdownMenuItem<CategoriaEntity>(value: e, child: Text(e.nome!));
                            }).toList(),
                            onChanged: (CategoriaEntity? newValue) {
                              setState(() {
                                searchController.text = "";
                                _cubit.filtroTexto = null;
                                categoriaIdSelected = newValue;
                                _cubit.filtroCategoria(newValue!);
                                _cubit.filtroCategoriaID = newValue.id;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 30),
                  if (_cubit.listaFiltro.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'Nenhum produto cadastrado',
                          style: theme.textTheme.bodyText2,
                        ),
                      ),
                    ),
                  Column(
                    children: _cubit.listaFiltro.map((item) {
                      return Container(
                        decoration: BoxDecoration(
                          color: item.ativo != null && item.ativo! ? Colors.white : Colors.grey[300],
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                item.codigo != null ? item.codigo.toString() : '00000',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(' - '),
                              Text(
                                item.nome.toString(),
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('Categoria:'),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          item.nomeCategoria ?? 'item.nomeCategoria.toString()',
                                          style: theme.textTheme.titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text('Estoque:'),
                                      const SizedBox(width: 5),
                                      Text(
                                        item.quantidadeEstoque != null ? item.quantidadeEstoque.toString() : '-',
                                        style: theme.textTheme.titleMedium!.copyWith(color: item.quantidadeEstoque! > 0 ? Colors.black : Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 100),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('Valor:'),
                                      const SizedBox(width: 5),
                                      Text(
                                        item.valorVenda != null ? item.valorVenda.toString() : '0',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 140,
                            child: Row(
                              children: [
                                IconButton(
                                  tooltip: "Editar produto",
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.orange[300],
                                  ),
                                  onPressed: () {
                                    _cubit.cadastro(item);
                                  },
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 40,
                                  child: IconButton(
                                    tooltip: "Deletar produto",
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _cubit.deletar(item.id);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: IconButton(
                                        tooltip: "Ativar ou desativar",
                                        icon: Icon(
                                          item.ativo != null && item.ativo! ? Icons.check_box : Icons.check_box_outline_blank_sharp,
                                          color: item.ativo != null && item.ativo! ? Colors.blue : Colors.grey,
                                        ),
                                        onPressed: () {
                                          _cubit.alterarStatus(item);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      child: Text(
                                        item.ativo != null && item.ativo! ? 'Ativo' : 'Inativo',
                                        style: theme.textTheme.bodySmall!.copyWith(fontSize: 10),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
