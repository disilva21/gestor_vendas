import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/components/modal_progress.dart';
import 'package:gestor_vendas/produto/domain/entities/produto.dart';

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
                                BotToast.showText(onlyOne: true, text: state.mensagem!, duration: const Duration(seconds: 5));

                                // Future.delayed(const Duration(seconds: 2)).then((value) {
                                //   setState(() {});
                                // });
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
                                              const SizedBox(height: 10),
                                              Text(
                                                '(Os produtos serão utilizados para geração de pedidos)',
                                                style: theme.textTheme.bodyText2,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 115,
                                                height: 40,
                                                child: TextButton.icon(
                                                    icon: const Icon(Icons.save_alt_rounded),
                                                    onPressed: () async {
                                                      await _cubit.exportarExcel();
                                                    },
                                                    label: const Text(
                                                      'Exportar',
                                                    )),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 118,
                                                height: 40,
                                                child: TextButton.icon(
                                                    icon: const Icon(Icons.read_more_outlined),
                                                    onPressed: () async {
                                                      final data = await showDialog<bool?>(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (_) => StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter myState) {
                                                            return AlertDialog(
                                                              backgroundColor: Colors.white,
                                                              title: Center(
                                                                child: Text(
                                                                  "Atenção!",
                                                                  style: theme.textTheme.displayMedium!.copyWith(color: Colors.red),
                                                                ),
                                                              ),
                                                              content: SingleChildScrollView(
                                                                child: Column(
                                                                  children: <Widget>[
                                                                    const SizedBox(height: 20),
                                                                    Text('Deseja mesmo importar a planilha para o sistema, isso não tem volta!', style: theme.textTheme.displaySmall!),
                                                                    const SizedBox(height: 20),
                                                                    Center(
                                                                      child: Text(
                                                                          'Certifique se que a planilha que está dentro do diretorio "C:/GestorVendas/excel_importar" é a correta\n e tem um arquivo chamado: "produtos_excel.xlsx"',
                                                                          style: theme.textTheme.labelLarge!),
                                                                    ),
                                                                    const SizedBox(height: 40),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                SizedBox(
                                                                  width: 200,
                                                                  height: 30,
                                                                  child: OutlinedButton(
                                                                    child: Text(
                                                                      'Não',
                                                                      style: theme.textTheme.bodyText1!.copyWith(color: const Color.fromARGB(255, 42, 117, 179)),
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop(false);
                                                                    },
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 20),
                                                                SizedBox(
                                                                  width: 200,
                                                                  height: 30,
                                                                  child: ElevatedButton(
                                                                    child: Text(
                                                                      'Sim',
                                                                      style: theme.textTheme.bodyText1!.copyWith(color: Colors.white),
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop(true);
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      );

                                                      if (data == true) {
                                                        await _cubit.importarExcel();
                                                      }
                                                    },
                                                    label: const Text(
                                                      'Importar',
                                                    )),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 160,
                                                height: 40,
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      _cubit.cadastro(ProdutoEntity());
                                                    },
                                                    child: const Text(
                                                      'Novo produto',
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
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
