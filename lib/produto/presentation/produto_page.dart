import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_pdv/components/modal_progress.dart';
import 'package:gestor_pdv/produto/domain/entities/produto.dart';

import '../../widget/header_widget.dart';
import '../../widget/side_bar.dart';
import 'cubit/produto_cadastro_state.dart';
import 'cubit/produto_cubit.dart';
import 'cubit/produto_list_state.dart';
import 'cubit/produto_state.dart';
import 'produto_cadastro_page.dart';
import 'produto_list_page.dart';

class ProdutoScreen extends StatefulWidget {
  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoScreen> {
  late ProdutoCubit _cubit;

  @override
  void initState() {
    _cubit = ProdutoCubit(context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget body(ProdutoState state) {
    if (state is ProdutoListState) return ProdutoListScreen();
    if (state is ProdutoCadastroState) return ProdutoCadastroScreen();

    return ProdutoListScreen();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ProdutoCubit, ProdutoState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.primaryColor,
            body: Column(
              children: [
                HeaderWidget(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SideBar(),
                      Flexible(
                          flex: 4,
                          child: BlocConsumer<ProdutoCubit, ProdutoState>(
                            listener: (context, state) {
                              if (state.sucesso == true) {
                                BotToast.showText(onlyOne: true, text: state.mensagem!, duration: Duration(seconds: 5));
                              }

                              if (state.falha == true) {
                                BotToast.showText(onlyOne: true, text: state.mensagem!, contentColor: Color.fromARGB(255, 247, 77, 51), duration: Duration(seconds: 5));
                              }
                            },
                            builder: (context, state) {
                              return Container(
                                padding: EdgeInsets.all(12),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Produto',
                                                style: theme.textTheme.bodyText1,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                '(Os produtos serão utilizados para geração de pedidos)',
                                                style: theme.textTheme.bodyText2,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 40,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  _cubit.cadastro(ProdutoEntity());
                                                },
                                                child: Text(
                                                  'Novo produto',
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Expanded(child: body(state)),
                                  ],
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
