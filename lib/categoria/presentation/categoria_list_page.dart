import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/categoria_cubit.dart';
import 'cubit/categoria_state.dart';

class CategoriaListScreen extends StatefulWidget {
  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<CategoriaListScreen> with SingleTickerProviderStateMixin {
  late CategoriaCubit _cubit;

  bool status = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _cubit = BlocProvider.of<CategoriaCubit>(context);
    _cubit.carregarCategorias();
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
      child: BlocBuilder<CategoriaCubit, CategoriaState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                _cubit.searchCategoria(searchController.text);
                              },
                              controller: searchController,
                              decoration: InputDecoration(
                                labelText: "Buscar categoria",
                                labelStyle: TextStyle(color: Colors.blue),
                                prefixIcon: Icon(Icons.search, color: Colors.blue),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    _cubit.closeSearchCategorias();
                                    searchController.text = '';
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_cubit.listaFiltro.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            'Nenhum categoria cadastrado',
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
                            title: Text(
                              item.nome.toString(),
                              style: theme.textTheme.bodyText1,
                            ),
                            subtitle: Text(item.ativo != null && item.ativo! ? 'Ativo' : 'Inativo'),
                            trailing: SizedBox(
                              width: 140,
                              child: Row(
                                children: [
                                  IconButton(
                                    tooltip: "Editar categoria",
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
                                      tooltip: "Deletar categoria",
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
                                  IconButton(
                                    tooltip: "Ativar ou desativar",
                                    icon: Icon(
                                      item.ativo != null && item.ativo! ? Icons.check_box : Icons.check_box_outline_blank_sharp,
                                      color: item.ativo != null && item.ativo! ? Colors.blue : Colors.grey,
                                    ),
                                    onPressed: () {
                                      _cubit.alterarStatus(item);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
