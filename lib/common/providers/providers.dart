import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/configuracao/presentation/cubit/configuracao_cubit.dart';
import 'package:gestor_vendas/database/object_box_database.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/cliente_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/formapagamento_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/item_pedido_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/pedido_service.dart';
import 'package:gestor_vendas/novo_pedido/presentation/cubit/novo_pedido_cubit.dart';
import 'package:gestor_vendas/produto/data/providers/firebase/produto_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../categoria/data/providers/firebase/categoria_service.dart';
import '../../categoria/presentation/cubit/categoria_cubit.dart';

final providers = <SingleChildWidget>[
  Provider<ObjectBoxDatabase>(
    create: (context) => ObjectBoxDatabase(),
  ),
  ChangeNotifierProvider<CategoriaService>(
    create: (context) => CategoriaService(
      context.read(),
    ),
  ),
  ChangeNotifierProvider<ProdutoService>(
    create: (context) => ProdutoService(
      context.read(),
    ),
  ),
  ChangeNotifierProvider<PedidoService>(
    create: (context) => PedidoService(
      context.read(),
    ),
  ),
  ChangeNotifierProvider<ClienteService>(
    create: (context) => ClienteService(
      context.read(),
    ),
  ),
  ChangeNotifierProvider<FormaPagamentoService>(
    create: (context) => FormaPagamentoService(
      context.read(),
    ),
  ),
  ChangeNotifierProvider<ItemPedidoService>(
    create: (context) => ItemPedidoService(
      context.read(),
    ),
  ),
  BlocProvider<NovoPedidoCubit>(create: (context) => NovoPedidoCubit(context)),
  BlocProvider<CategoriaCubit>(create: (context) => CategoriaCubit(context)),
  BlocProvider<ConfiguracaoCubit>(create: (context) => ConfiguracaoCubit(context)),
];
