// import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_pdv/common/app_colors.dart';
import 'package:gestor_pdv/configuracao/presentation/impressora.dart';
import 'package:gestor_pdv/novo_pedido/presentation/novo_pedido_page.dart';
import 'package:gestor_pdv/novo_pedido/presentation/pedido_page.dart';

import 'package:gestor_pdv/produto/presentation/produto_page.dart';

import '../categoria/presentation/categoria_page.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final _cubit = BlocProvider.of<LoginCubit>(context);
    // final _cubitConfig = BlocProvider.of<ConfiguracaoCubit>(context);

    bool isActive = false;

    return Drawer(
      width: 220,
      elevation: 0,
      child: Container(
        color: Color(4293981687),
        padding: EdgeInsets.symmetric(
          horizontal: 0,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  //  _cubitConfig.setMenuVisivel(!_cubitConfig.menuVisivel);
                },
                icon: Icon(Icons.menu),
              ),
            ),
            // if (!_cubitConfig.menuVisivel)
            //   Align(
            //     alignment: Alignment.topRight,
            //     child: IconButton(
            //       onPressed: () {
            //         _cubitConfig.setMenuVisivel(!_cubitConfig.menuVisivel);
            //       },
            //       icon: Icon(Icons.menu),
            //     ),
            //   ),
            // if (!_cubitConfig.menuVisivel)
            //   Container(
            //     height: 40,
            //     width: 40,
            //     child: Center(
            //         child: Text(
            //       _cubit.usuarioEntity.nome == null ? '' : _cubit.usuarioEntity.nome!.substring(0, 1),
            //       style: theme.textTheme.bodyText1!.copyWith(color: Colors.blue),
            //     )),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       shape: BoxShape.circle,
            //     ),
            //   ),
            //  if (_cubitConfig.menuVisivel)
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Olá,'),
                  SizedBox(height: 5),
                  // Text(_cubit.usuarioEntity.nome ?? '', style: theme.textTheme.bodyText1),
                  // Text(_cubit.usuarioEntity.email ?? '', style: theme.textTheme.bodyText1),
                  Text('Edvaldo', style: theme.textTheme.bodyText1),
                  Text('disilva', style: theme.textTheme.bodyText1),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'pedido_realtime', '#/pedido_realtime');
                  //     _cubitConfig.addMarcacaoMenu('pedido_realtime');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => PedidoRealtimeScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Pedidos em tempo real",
                  //     icone: Icon(Icons.dashboard_outlined, size: 18, color: _cubit.menu == 0 ? AppColors.menuSelected : AppColors.txtGry),
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.pedido_realtime,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'novo pedido', '#/novo-pedido');
                  //     _cubitConfig.addMarcacaoMenu('novo_pedido');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => NovoPedidoScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Novo Pedido",
                  //     icone: Icon(Icons.add_circle_outline_outlined, size: 18, color: _cubit.menu == 2 ? AppColors.menuSelected : AppColors.txtGry),
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.novo_pedido,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'dashboard', '#/dashboard');
                  //     _cubitConfig.addMarcacaoMenu('relatorio');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => RelatorioScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Dashboard",
                  //     icone: Icon(Icons.padding_outlined, size: 18, color: _cubit.menu == 2 ? AppColors.menuSelected : AppColors.txtGry),
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.relatorio,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'pedidos', '#/pedido');
                  //     _cubitConfig.addMarcacaoMenu('pedido');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => PedidoPageScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Pedidos",
                  //     icone: Icon(Icons.list_outlined, size: 18, color: _cubit.menu == 2 ? AppColors.menuSelected : AppColors.txtGry),
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.pedido,
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Color.fromARGB(255, 221, 224, 226),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  child: Text(
                    // _cubitConfig.menuVisivel ? "Cardápio".toUpperCase() : '',
                    'Sistema',
                    style: TextStyle(
                      color: AppColors.txtGry,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      //  _cubitConfig.addMarcacaoMenu('categoria');

                      // html.window.history.pushState(null, 'categoria', '#/categoria');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NovoPedidoScreen()));
                    },
                    child: integrationMenuItem(
                      title: "Novo Pedido",
                      icone: Icon(Icons.category, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                      bgColor: AppColors.jiraBgColor,
                      visivel: true,
                      isActive: false,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //  _cubitConfig.addMarcacaoMenu('categoria');

                      // html.window.history.pushState(null, 'categoria', '#/categoria');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PedidoPageScreen()));
                    },
                    child: integrationMenuItem(
                      title: "Pedidos",
                      icone: Icon(Icons.category, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                      bgColor: AppColors.jiraBgColor,
                      visivel: true,
                      isActive: false,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //  _cubitConfig.addMarcacaoMenu('categoria');

                      // html.window.history.pushState(null, 'categoria', '#/categoria');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriaPageScreen()));
                    },
                    child: integrationMenuItem(
                      title: "Categoria",
                      icone: Icon(Icons.category, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                      bgColor: AppColors.jiraBgColor,
                      visivel: true,
                      isActive: false,
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'acompanhamento', '#/acompanhamento');
                  //     _cubitConfig.addMarcacaoMenu('acompanhamento');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => AcompanhamentoPageScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Acompanhamento",
                  //     icone: Icon(Icons.bookmark_add_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                  //     bgColor: AppColors.slackBgColor,
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.acompanhamento,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'adicional', '#/adicional');
                  //     _cubitConfig.addMarcacaoMenu('adicional');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdicionalPageScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Adicionais",
                  //     icone: Icon(Icons.add, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                  //     bgColor: AppColors.slackBgColor,
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.adicional,
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      // html.window.history.pushState(null, 'produto', '#/produto');
                      // _cubitConfig.addMarcacaoMenu('produto');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProdutoScreen()));
                    },
                    child: integrationMenuItem(
                      title: "Produto",
                      icone: Icon(Icons.production_quantity_limits_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                      bgColor: AppColors.slackBgColor,
                      visivel: true,
                      isActive: false,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // html.window.history.pushState(null, 'produto', '#/produto');
                      // _cubitConfig.addMarcacaoMenu('produto');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImpressoraScreen()));
                    },
                    child: integrationMenuItem(
                      title: "Impressora",
                      icone: Icon(Icons.print, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                      bgColor: AppColors.slackBgColor,
                      visivel: true,
                      isActive: false,
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'forma de pagamento', '#/forma-pagamento');
                  //     _cubitConfig.addMarcacaoMenu('forma-pagamento');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormaPagamentoPageScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Forma de Pagamento",
                  //     icone: Icon(Icons.money_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                  //     bgColor: AppColors.slackBgColor,
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.formapagamento,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'forma de entrega', '#/forma-entrega');
                  //     _cubitConfig.addMarcacaoMenu('forma-entrega');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => EntregaPageScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //       title: "Forma de Entrega",
                  //       icone: Icon(Icons.delivery_dining, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                  //       bgColor: AppColors.slackBgColor,
                  //       visivel: _cubitConfig.menuVisivel,
                  //       isActive: _cubitConfig.formaentrega),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'entregadores', '#/entregador');
                  //     _cubitConfig.addMarcacaoMenu('entregador');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => EntregadorPageScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Entregadores",
                  //     icone: Icon(Icons.motorcycle, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                  //     bgColor: AppColors.slackBgColor,
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.entregador,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'entregadores', '#/entregador');
                  //     _cubitConfig.addMarcacaoMenu('impressora');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImpressoraScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Impressora",
                  //     icone: Icon(Icons.print, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                  //     bgColor: AppColors.slackBgColor,
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.impressora,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'configuracao', '#/configuracao');
                  //     _cubitConfig.addMarcacaoMenu('configuracao');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfiguracaoScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Configurar cardápio",
                  //     icone: Icon(Icons.settings, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                  //     bgColor: AppColors.slackBgColor,
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.configuracao,
                  //   ),
                  //),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Color.fromARGB(255, 221, 224, 226),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  // _cubitConfig.menuVisivel ? "Perfil".toUpperCase() : '',
                  'Perfil',
                  style: TextStyle(
                    color: AppColors.txtGry,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'planos', '#/pagamento');
                  //     _cubitConfig.addMarcacaoMenu('pagamento');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => PagamentoPageScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Planos",
                  //     icone: Icon(Icons.paid_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                  //     bgColor: AppColors.jiraBgColor,
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.pagamento,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // html.window.history.pushState(null, 'meus dados', '#/usuario');
                  //     _cubitConfig.addMarcacaoMenu('usuario');
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => UsuarioScreen()));
                  //   },
                  //   child: integrationMenuItem(
                  //     title: "Meus dados",
                  //     icone: Icon(Icons.person, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
                  //     bgColor: AppColors.jiraBgColor,
                  //     visivel: _cubitConfig.menuVisivel,
                  //     isActive: _cubitConfig.usuario,
                  //   ),
                  // ),
                ],
              ),
            ),
            // integrationMenuItem(
            //   title: "Configuração",
            //   icone: Icon(Icons.settings, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
            //   bgColor: AppColors.jiraBgColor,
            //   visivel: _cubitConfig.menuVisivel,
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            const Divider(
              height: 1,
              color: Color.fromARGB(255, 221, 224, 226),
            ),
            const SizedBox(
              height: 10,
            ),
            // integrationMenuItem(
            //   title: "Ajuda",
            //   icone: Icon(Icons.help_outline, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
            //   visivel: _cubitConfig.menuVisivel,
            // ),
            InkWell(
              onTap: () {
                //  _cubit.deslogar();
                // html.window.history.pushState(null, 'login', '#/login');
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginForm()));
              },
              child: integrationMenuItem(
                title: "Sair",
                visivel: false,
                icone: Icon(Icons.logout_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
              ),
            ),
            SizedBox(height: 5),
            Divider(),

            Container(
              padding: EdgeInsets.all(5),
              color: Color.fromARGB(255, 161, 186, 248),
              child: Center(
                child: Text(
                  'Gestor Menu Mania\nversão',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // return BlocProvider<ConfiguracaoCubit>.value(
    //   value: _cubitConfig,
    //   child: BlocBuilder<ConfiguracaoCubit, ConfiguracaoState>(
    //     builder: (context, state) {
    //       return Drawer(
    //         width: !_cubitConfig.menuVisivel ? 90 : 220,
    //         elevation: 0,
    //         child: Container(
    //           color: Color(4293981687),
    //           padding: EdgeInsets.symmetric(
    //             horizontal: 0,
    //           ),
    //           child: ListView(
    //             shrinkWrap: true,
    //             children: [
    //               if (_cubitConfig.menuVisivel)
    //                 Align(
    //                   alignment: Alignment.topRight,
    //                   child: IconButton(
    //                     onPressed: () {
    //                       _cubitConfig.setMenuVisivel(!_cubitConfig.menuVisivel);
    //                     },
    //                     icon: Icon(Icons.menu),
    //                   ),
    //                 ),
    //               if (!_cubitConfig.menuVisivel)
    //                 Align(
    //                   alignment: Alignment.topRight,
    //                   child: IconButton(
    //                     onPressed: () {
    //                       _cubitConfig.setMenuVisivel(!_cubitConfig.menuVisivel);
    //                     },
    //                     icon: Icon(Icons.menu),
    //                   ),
    //                 ),
    //               if (!_cubitConfig.menuVisivel)
    //                 Container(
    //                   height: 40,
    //                   width: 40,
    //                   child: Center(
    //                       child: Text(
    //                     _cubit.usuarioEntity.nome == null ? '' : _cubit.usuarioEntity.nome!.substring(0, 1),
    //                     style: theme.textTheme.bodyText1!.copyWith(color: Colors.blue),
    //                   )),
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     shape: BoxShape.circle,
    //                   ),
    //                 ),
    //               if (_cubitConfig.menuVisivel)
    //                 Container(
    //                   color: Colors.white,
    //                   padding: EdgeInsets.all(10),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text('Olá,'),
    //                       SizedBox(height: 5),
    //                       Text(_cubit.usuarioEntity.nome ?? '', style: theme.textTheme.bodyText1),
    //                       Text(_cubit.usuarioEntity.email ?? '', style: theme.textTheme.bodyText1),
    //                     ],
    //                   ),
    //                 ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Divider(),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 10),
    //                 child: Column(
    //                   children: [
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'pedido_realtime', '#/pedido_realtime');
    //                     //     _cubitConfig.addMarcacaoMenu('pedido_realtime');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => PedidoRealtimeScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Pedidos em tempo real",
    //                     //     icone: Icon(Icons.dashboard_outlined, size: 18, color: _cubit.menu == 0 ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.pedido_realtime,
    //                     //   ),
    //                     // ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'novo pedido', '#/novo-pedido');
    //                     //     _cubitConfig.addMarcacaoMenu('novo_pedido');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => NovoPedidoScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Novo Pedido",
    //                     //     icone: Icon(Icons.add_circle_outline_outlined, size: 18, color: _cubit.menu == 2 ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.novo_pedido,
    //                     //   ),
    //                     // ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'dashboard', '#/dashboard');
    //                     //     _cubitConfig.addMarcacaoMenu('relatorio');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => RelatorioScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Dashboard",
    //                     //     icone: Icon(Icons.padding_outlined, size: 18, color: _cubit.menu == 2 ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.relatorio,
    //                     //   ),
    //                     // ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'pedidos', '#/pedido');
    //                     //     _cubitConfig.addMarcacaoMenu('pedido');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => PedidoPageScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Pedidos",
    //                     //     icone: Icon(Icons.list_outlined, size: 18, color: _cubit.menu == 2 ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.pedido,
    //                     //   ),
    //                     // ),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 15,
    //               ),
    //               Container(
    //                 padding: EdgeInsets.symmetric(vertical: 10),
    //                 color: Color.fromARGB(255, 221, 224, 226),
    //                 child: Padding(
    //                   padding: const EdgeInsets.only(left: 20),
    //                   child: Container(
    //                     child: Text(
    //                       _cubitConfig.menuVisivel ? "Cardápio".toUpperCase() : '',
    //                       style: TextStyle(
    //                         color: AppColors.txtGry,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 10),
    //                 child: Column(
    //                   children: [
    //                     InkWell(
    //                       onTap: () {
    //                         _cubitConfig.addMarcacaoMenu('categoria');

    //                         // html.window.history.pushState(null, 'categoria', '#/categoria');
    //                         Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriaPageScreen()));
    //                       },
    //                       child: integrationMenuItem(
    //                         title: "Sessão",
    //                         icone: Icon(Icons.category, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                         bgColor: AppColors.jiraBgColor,
    //                         visivel: _cubitConfig.menuVisivel,
    //                         isActive: _cubitConfig.categoria,
    //                       ),
    //                     ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'acompanhamento', '#/acompanhamento');
    //                     //     _cubitConfig.addMarcacaoMenu('acompanhamento');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => AcompanhamentoPageScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Acompanhamento",
    //                     //     icone: Icon(Icons.bookmark_add_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     bgColor: AppColors.slackBgColor,
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.acompanhamento,
    //                     //   ),
    //                    // ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'adicional', '#/adicional');
    //                     //     _cubitConfig.addMarcacaoMenu('adicional');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdicionalPageScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Adicionais",
    //                     //     icone: Icon(Icons.add, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     bgColor: AppColors.slackBgColor,
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.adicional,
    //                     //   ),
    //                     // ),
    //                     InkWell(
    //                       onTap: () {
    //                         // html.window.history.pushState(null, 'produto', '#/produto');
    //                         _cubitConfig.addMarcacaoMenu('produto');
    //                         Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProdutoScreen()));
    //                       },
    //                       child: integrationMenuItem(
    //                         title: "Produto",
    //                         icone: Icon(Icons.production_quantity_limits_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                         bgColor: AppColors.slackBgColor,
    //                         visivel: _cubitConfig.menuVisivel,
    //                         isActive: _cubitConfig.produto,
    //                       ),
    //                     ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'forma de pagamento', '#/forma-pagamento');
    //                     //     _cubitConfig.addMarcacaoMenu('forma-pagamento');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormaPagamentoPageScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Forma de Pagamento",
    //                     //     icone: Icon(Icons.money_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     bgColor: AppColors.slackBgColor,
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.formapagamento,
    //                     //   ),
    //                     // ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'forma de entrega', '#/forma-entrega');
    //                     //     _cubitConfig.addMarcacaoMenu('forma-entrega');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => EntregaPageScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //       title: "Forma de Entrega",
    //                     //       icone: Icon(Icons.delivery_dining, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                     //       bgColor: AppColors.slackBgColor,
    //                     //       visivel: _cubitConfig.menuVisivel,
    //                     //       isActive: _cubitConfig.formaentrega),
    //                     // ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'entregadores', '#/entregador');
    //                     //     _cubitConfig.addMarcacaoMenu('entregador');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => EntregadorPageScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Entregadores",
    //                     //     icone: Icon(Icons.motorcycle, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     bgColor: AppColors.slackBgColor,
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.entregador,
    //                     //   ),
    //                     // ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'entregadores', '#/entregador');
    //                     //     _cubitConfig.addMarcacaoMenu('impressora');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImpressoraScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Impressora",
    //                     //     icone: Icon(Icons.print, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     bgColor: AppColors.slackBgColor,
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.impressora,
    //                     //   ),
    //                     // ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'configuracao', '#/configuracao');
    //                     //     _cubitConfig.addMarcacaoMenu('configuracao');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfiguracaoScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Configurar cardápio",
    //                     //     icone: Icon(Icons.settings, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     bgColor: AppColors.slackBgColor,
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.configuracao,
    //                     //   ),
    //                     //),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 15,
    //               ),
    //               Container(
    //                 padding: EdgeInsets.symmetric(vertical: 10),
    //                 color: Color.fromARGB(255, 221, 224, 226),
    //                 child: Padding(
    //                   padding: const EdgeInsets.only(left: 20),
    //                   child: Text(
    //                     _cubitConfig.menuVisivel ? "Perfil".toUpperCase() : '',
    //                     style: TextStyle(
    //                       color: AppColors.txtGry,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 10),
    //                 child: Column(
    //                   children: [
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'planos', '#/pagamento');
    //                     //     _cubitConfig.addMarcacaoMenu('pagamento');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => PagamentoPageScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Planos",
    //                     //     icone: Icon(Icons.paid_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     bgColor: AppColors.jiraBgColor,
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.pagamento,
    //                     //   ),
    //                     // ),
    //                     // InkWell(
    //                     //   onTap: () {
    //                     //     // html.window.history.pushState(null, 'meus dados', '#/usuario');
    //                     //     _cubitConfig.addMarcacaoMenu('usuario');
    //                     //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => UsuarioScreen()));
    //                     //   },
    //                     //   child: integrationMenuItem(
    //                     //     title: "Meus dados",
    //                     //     icone: Icon(Icons.person, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                     //     bgColor: AppColors.jiraBgColor,
    //                     //     visivel: _cubitConfig.menuVisivel,
    //                     //     isActive: _cubitConfig.usuario,
    //                     //   ),
    //                     // ),
    //                   ],
    //                 ),
    //               ),
    //               // integrationMenuItem(
    //               //   title: "Configuração",
    //               //   icone: Icon(Icons.settings, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //               //   bgColor: AppColors.jiraBgColor,
    //               //   visivel: _cubitConfig.menuVisivel,
    //               // ),
    //               // SizedBox(
    //               //   height: 10,
    //               // ),
    //               Divider(
    //                 height: 1,
    //                 color: Color.fromARGB(255, 221, 224, 226),
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               // integrationMenuItem(
    //               //   title: "Ajuda",
    //               //   icone: Icon(Icons.help_outline, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //               //   visivel: _cubitConfig.menuVisivel,
    //               // ),
    //               InkWell(
    //                 onTap: () {
    //                   _cubit.deslogar();
    //                   // html.window.history.pushState(null, 'login', '#/login');
    //                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginForm()));
    //                 },
    //                 child: integrationMenuItem(
    //                   title: "Sair",
    //                   visivel: _cubitConfig.menuVisivel,
    //                   icone: Icon(Icons.logout_outlined, size: 18, color: isActive ? AppColors.menuSelected : AppColors.txtGry),
    //                 ),
    //               ),
    //               SizedBox(height: 5),
    //               Divider(),

    //               Container(
    //                 padding: EdgeInsets.all(5),
    //                 color: Color.fromARGB(255, 161, 186, 248),
    //                 child: Center(
    //                   child: Text(
    //                     'Gestor Menu Mania\nversão ${_cubit.versaoSistema}',
    //                     style: theme.textTheme.bodySmall,
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  Widget integrationMenuItem({String? title, Widget? icone, Color? bgColor, bool isActive = false, bool visivel = true}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // margin: EdgeInsets.symmetric(vertical: 10),
      color: isActive ? Colors.blue[100] : null,
      child: Row(
        children: [
          icone!,
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              visivel ? title! : '',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem({String? title, Widget? icone, int? notification, bool isActive = false}) {
    return ListTile(
      title: Text(
        title!,
        style: TextStyle(
          color: isActive ? AppColors.white : AppColors.txtGry,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: icone,
      trailing: notification != null
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: notification != null ? Color(0xff33b6e0) : AppColors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$notification",
                  style: TextStyle(
                    color: notification != null ? AppColors.white : AppColors.transparent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
