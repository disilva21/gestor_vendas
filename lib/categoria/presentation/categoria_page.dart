// import 'package:bot_toast/bot_toast.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/widget/header_widget.dart';
import 'package:gestor_vendas/widget/side_bar.dart';

import '../../components/modal_progress.dart';
import '../domain/entities/categoria.dart';
import 'categoria_cadastro_page.dart';
import 'categoria_list_page.dart';
import 'cubit/categoria_cadastro_state.dart';
import 'cubit/categoria_cubit.dart';
import 'cubit/categoria_list_state.dart';
import 'cubit/categoria_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../domain/entities/categoria.dart';
// import 'categoria_cadastro_page.dart';
// import 'categoria_list_page.dart';
// import 'cubit/categoria_cadastro_state.dart';
// import 'cubit/categoria_cubit.dart';
// import 'cubit/categoria_list_state.dart';

class CategoriaPageScreen extends StatefulWidget {
  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<CategoriaPageScreen> {
  late CategoriaCubit _cubit;

  @override
  void initState() {
    _cubit = CategoriaCubit(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget body(CategoriaState state) {
    if (state is CategoriaListState) return CategoriaListScreen();
    if (state is CategoriaCadastroState) return CategoriaCadastroScreen();

    return CategoriaListScreen();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<CategoriaCubit, CategoriaState>(
        builder: (context, state) {
          return ModalLoading(
            isLoading: state.carregando == true,
            child: Scaffold(
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
                        Expanded(
                            flex: 4,
                            child: BlocConsumer<CategoriaCubit, CategoriaState>(
                              listener: (context, state) {
                                if (state.sucesso == true) {
                                  BotToast.showText(onlyOne: true, text: state.mensagem!, duration: Duration(seconds: 5));
                                }
                                if (state.falha == true) {
                                  BotToast.showText(onlyOne: true, text: state.mensagem!, contentColor: Color.fromARGB(255, 248, 51, 51), duration: Duration(seconds: 5));
                                }
                                // if (BlocProvider.of<LoginCubit>(context).permitirAcesso == false) {
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => PagamentoPageScreen()));
                                // }
                              },
                              builder: (context, state) {
                                return Container(
                                    padding: EdgeInsets.all(12),
                                    color: Colors.white,
                                    child: Column(
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
                                                    'Categoria',
                                                    style: theme.textTheme.bodyText1,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    '(A categoria será um agrupador de produtos)',
                                                    style: theme.textTheme.bodyText2,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 250,
                                                height: 40,
                                                child: ElevatedButton(
                                                  onPressed:
                                                      // BlocProvider.of<CategoriaCubit>(context).permitirAcesso == false
                                                      // ? null
                                                      // :
                                                      () {
                                                    _cubit.cadastro(CategoriaEntity());
                                                  },
                                                  child: Text('Nova categoria'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Expanded(child: body(state)),
                                      ],
                                    ));
                              },
                            )),
                      ],
                    ),
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
