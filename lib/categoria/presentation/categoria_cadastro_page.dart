import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/categoria_cubit.dart';
import 'cubit/categoria_state.dart';

class CategoriaCadastroScreen extends StatefulWidget {
  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<CategoriaCadastroScreen> {
  late CategoriaCubit _cubit;
  final nome = TextEditingController();

  bool addSabores = false;
  int? qtdSelecionado = 1;

  bool status = true;
  final GlobalKey<FormState> _formCategoriaKey = GlobalKey<FormState>();
  //late ConfiguracaoCubit _configuracaoCubit;
  @override
  void initState() {
    _cubit = BlocProvider.of<CategoriaCubit>(context);
    // _configuracaoCubit = BlocProvider.of<ConfiguracaoCubit>(context);

    load_cadastro();
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
          return Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: [
                Form(
                  key: _formCategoriaKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nome da categoria'),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 500,
                        child: TextFormField(
                          controller: nome,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {});
                          },
                          validator: (value) {
                            if (nome.text.isEmpty) {
                              return 'O campo nome é obrigatório';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Ex: Pizzas, Sobremesas, Bebidas'),
                        ),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: 500,
                        child: CheckboxListTile(
                          checkColor: Colors.white,
                          activeColor: Colors.blue,
                          title: Text('Ativar categoria?'),
                          subtitle: Text('Ao ativar, ela será exibida no produto'),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: status,
                          onChanged: (value) {
                            // _cubit.categoriaEntity.ativo = value;
                            setState(() {
                              status = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () {
                        clear_cadastro();
                        _cubit.list();
                      },
                      child: Text('Voltar'),
                    ),
                  ),
                  SizedBox(width: 50),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: _formCategoriaKey.currentState == null || !_formCategoriaKey.currentState!.validate()
                            ? null
                            : () {
                                _cubit.categoriaEntity.nome = nome.text;

                                _cubit.categoriaEntity.ativo = status;

                                if (_cubit.categoriaEntity.id > 0) {
                                  _cubit.editar();
                                } else {
                                  _cubit.cadastrar();
                                }
                              },
                        child: Text('Salvar')),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void clear_cadastro() {
    nome.text = '';

    status = true;
    addSabores = false;
    //_cubit.categoriaEntity.ativo = true;
    //  _cubit.categoriaEntity.aceitaMaisSabores = false;
    _cubit.id = '';
  }

  void load_cadastro() {
    if (_cubit.categoriaEntity.id != null && _cubit.categoriaEntity.id > 0) {
      nome.text = _cubit.categoriaEntity.nome!;
      //  status = _cubit.categoriaEntity.ativo!;
      // _cubit.categoriaEntity.ativo = _cubit.categoriaEntity.ativo!;
      // _cubit.id = _cubit.categoriaEntity.id!;
      // addSabores = _cubit.categoriaEntity.aceitaMaisSabores ?? false;
    } else {
      clear_cadastro();
    }
  }
}
