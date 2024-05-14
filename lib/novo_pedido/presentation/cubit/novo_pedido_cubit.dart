import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/categoria/data/providers/firebase/categoria_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/cliente_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/formapagamento_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/item_pedido_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/pedido_service.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/cliente.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/forma_pagamento.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/item_pedido.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/pedido.dart';
import 'package:gestor_vendas/produto/data/providers/firebase/produto_service.dart';
import 'package:path_provider/path_provider.dart';

import '../../../produto/domain/entities/produto.dart';

import '../../../categoria/domain/entities/categoria.dart';
import 'novo_pedido_state.dart';

class NovoPedidoCubit extends Cubit<NovoPedidoState> {
  BuildContext _context;
  NovoPedidoCubit(this._context) : super(NovoPedidoState());

  CategoriaModel categoriaModel = CategoriaModel();
  ProdutoModel produtoModel = ProdutoModel();
  PedidoModel pedido = PedidoModel();

  List<CategoriaModel> listaFiltro = [];
  List<int> listaQuantidadeSabores = [1, 2, 3, 4];
  ClienteModel? cliente;

  List<ProdutoModel> produtosMaisSabores = [];
  List<ProdutoModel> produtosFiltro = [];
  List<ProdutoModel> produtosPedido = [];
  num? valorMaiorSabores = 0;
  num? valorOriginalProduto = 0;

  num? valorProdutoAcompanhamento = 0;
  num? valorProdutoAdicional = 0;

  String? categoriaSelecioanada;
  List<CategoriaModel> categoriasProduto = [];
  List<ProdutoModel> lista = [];
  CategoriaModel? categoriaModelSelecionada;
  String id = '';
  int tabIndex = 0;
  String numeroPedido = '';

  List<FormaPagamentoModel> formaPagamentos = [];
  StreamSubscription<dynamic>? subscription;

  List<double> listaGeo = [];
  double latitude = 0;
  double longitude = 0;
  int? valorDistancia;
  String diretorio = '';

  List<UnidadeMedida> listaUnidadeMedida = [];

  Future<void> loadFormaEntrega() async {
    emit(NovoPedidoState.carregando());

    // formaEntregas = await _context.read<EntregaService>().carregarEntregas();
    emit(NovoPedidoState.completo());
  }

  Future<void> searchCliente(String celular) async {
    emit(NovoPedidoState.carregando());
    celular = celular.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', '');

    cliente = await _context.read<ClienteService>().lerCliente(celular);
    valorDistancia = null;
    emit(NovoPedidoState.completo());
  }

  Future<void> carregarProdutos() async {
    emit(NovoPedidoState.carregando());
    // await pontoCarnes();
    // await loadEnumUnidadeMedida();
    lista = await _context.read<ProdutoService>().carregarProdutos();
    // listaFiltro = lista;
    await carregarCategorias();

    await loadProdutos();
    await loadFormaPagamento();
    await loadFormaEntrega();
    await unidadeMedidas();
    final dir = await getTemporaryDirectory();
    diretorio = dir.path;

    emit(NovoPedidoState.completo());
  }

  Future<List<UnidadeMedida>> unidadeMedidas() async {
    listaUnidadeMedida = [];
    listaUnidadeMedida.add(UnidadeMedida(id: 1, nome: 'Unidade', sigla: 'UN'));
    listaUnidadeMedida.add(UnidadeMedida(id: 2, nome: 'Quilogramas', sigla: 'KG'));
    listaUnidadeMedida.add(UnidadeMedida(id: 3, nome: 'Metro', sigla: 'M'));

    return listaUnidadeMedida;
  }

  carregarCategorias() async {
    categoriasProduto = await _context.read<CategoriaService>().carregarCategorias();
    categoriasProduto.add(CategoriaModel(nome: "Todos"));

    categoriasProduto.sort((a, b) => a.id.compareTo(b.id));
  }

  loadProdutos() async {
    emit(NovoPedidoState.carregandoImagem());

    // for (var i = 0; i < categoriasProduto.length; i++) {
    //   ProdutoModel? prod = lista.firstWhere((element) => element.idCategoria == categoriasProduto[i].id);
    //   if (prod == null) {
    //     categoriasProduto.removeWhere((element) => element.id == categoriasProduto[i].id);
    //   }
    // }

    // if (categoriaSelecioanada == null) {
    //   if (categoriasProduto.isNotEmpty) {
    //     categoriasProduto.first.selecionado = true;
    //     categoriaSelecioanada = categoriasProduto.first.id.toString();
    //   }
    // } else {
    //   for (var i = 0; i < categoriasProduto.length; i++) {
    //     if (categoriasProduto[i].id == categoriaSelecioanada) {
    //       categoriasProduto[i].selecionado = true;
    //     }
    //   }
    // }
    produtosFiltro = lista;

    // produtosFiltro = lista.where((element) => element.idCategoria == int.parse(categoriaSelecioanada!)).toList();
    emit(NovoPedidoState.completo());
  }

  Future<void> filtroCategoria(CategoriaModel item) async {
    emit(NovoPedidoState.carregando());
    if (item.id > 0) {
      produtosFiltro = lista.where((element) => element.idCategoria == item.id).toList();
    } else {
      produtosFiltro = lista;
    }

    categoriaSelecioanada = item.id.toString();
    categoriaModelSelecionada = item;
    emit(NovoPedidoState.completo());
  }

  Future<void> seachProdutos(String texto) async {
    emit(NovoPedidoState.carregando());

    produtosFiltro = lista
        .where((element) => element.nome!.toLowerCase().contains(texto.toLowerCase()) || element.codigo != null && element.codigo!.toString().contains(texto.toLowerCase()))
        // element.nomeCategoria != null && element.nomeCategoria!.toLowerCase().contains(texto.toLowerCase()))
        .toList();

    emit(NovoPedidoState.completo());
  }

  ProdutoModel prodDetalhe = ProdutoModel();

  Future<void> loadDetalhe(ProdutoModel _produtoModel) async {
    prodDetalhe = await lerProduto(_produtoModel.id);
  }

  Future<void> addProdutosPedido(ProdutoModel _produtoModel) async {
    emit(NovoPedidoState.carregando());

    pedido.itens ??= [];

    ItemPedidoModel item = ItemPedidoModel(idProduto: _produtoModel.id, quantidade: _produtoModel.quantidadeItem, valorVenda: _produtoModel.valorVenda);

    final prd = await lerProduto(_produtoModel.id);

    item.produto = prd;
    pedido.itens!.add(item);

    emit(NovoPedidoState.completo());
  }

  Future<void> loadFormaPagamento() async {
    emit(NovoPedidoState.carregando());

    formaPagamentos = await _context.read<FormaPagamentoService>().carregarFormaPagamento();

    if (formaPagamentos.isEmpty) {
      FormaPagamentoModel item1 = FormaPagamentoModel(
        nome: "Crédito",
        ativo: true,
      );

      await _context.read<FormaPagamentoService>().cadastrar(item1);
      FormaPagamentoModel item2 = FormaPagamentoModel(
        nome: "Débito",
        ativo: true,
      );
      await _context.read<FormaPagamentoService>().cadastrar(item2);
      FormaPagamentoModel item3 = FormaPagamentoModel(
        nome: "PIX",
        ativo: true,
      );
      await _context.read<FormaPagamentoService>().cadastrar(item3);
      FormaPagamentoModel item4 = FormaPagamentoModel(
        nome: "Dinheiro",
        ativo: true,
      );
      await _context.read<FormaPagamentoService>().cadastrar(item4);

      formaPagamentos = await _context.read<FormaPagamentoService>().carregarFormaPagamento();
    }

    emit(NovoPedidoState.completo());
  }

  void cancelarSubscription(NovoPedidoState state, StreamSubscription? sub) {
    if (state.falha == true || state.sucesso == true) {
      sub!.cancel();
      sub = null;
    }
  }

  Future<void> enviarPedido() async {
    emit(NovoPedidoState.carregando());
    try {
      //  pedido.numero = Random().nextInt(10000).toString().padLeft(5, '0');
      // pedido.enumPedidoStatus = EnumPedidoStatus.emAnalise;
      // numeroPedido = pedido.numero!;
      //  pedido.tipoEntrega = tipoEntrega;

      // pedido.createDate = DateTime.now();
      if (cliente == null) {
        pedido.idCliente = 0;
        pedido.cliente = ClienteModel(nome: 'Anônimo', telefone: '-');
      } else {
        pedido.idCliente = cliente!.id;
        pedido.cliente = await _context.read<ClienteService>().ler(cliente!.id);
      }

      if (pedido.formaPagamento == null) {
        pedido.idFormaPagamento = 0;
      } else {
        pedido.idFormaPagamento = pedido.formaPagamento!.id;
      }
      pedido.statusPedido = 0; //NOVO
      pedido.dataCadastro = DateTime.now();
      pedido = await _context.read<PedidoService>().cadastrar(pedido);

      if (pedido.id > 0) {
        for (var i = 0; i < pedido.itens!.length; i++) {
          ItemPedidoModel item = ItemPedidoModel(
            idProduto: pedido.itens![i].idProduto,
            idPedido: pedido.id,
            quantidade: pedido.itens![i].quantidade,
            valorVenda: pedido.itens![i].valorVenda,
          );

          await _context.read<ItemPedidoService>().cadastrar(item);
          await baixarQuantidadeEstoque(pedido.itens![i].idProduto, pedido.itens![i].quantidade!);
        }
      }

      emit(NovoPedidoState.sucesso(mensagem: 'Pedido enviado com sucesso!'));
    } catch (e) {
      emit(NovoPedidoState.falha(mensagem: 'Pedido não foi enviado, tente novamente.'));
    }
  }

  Future<void> salvarCliente() async {
    emit(NovoPedidoState.carregando());
    cliente!.telefone = cliente!.telefone!.replaceAll(' ', '').replaceAll('(', '').replaceAll(')', '').replaceAll('-', '');

    await _context.read<ClienteService>().cadastrar(cliente!);
    pedido.cliente = cliente;
    emit(NovoPedidoState.completo());
  }

  Future<void> addItemPedido(ProdutoModel produtoModel, int index) async {
    // pedido.total = pedido.total! + produtoModel.valorVenda!;

    // for (var i = 0; i < produtoModel.adicionais!.length; i++) {
    //   pedido.total = pedido.total! + produtoModel.adicionais![i].valorVenda!;
    // }

    // pedido.produtos![index].quantidadeItem = pedido.produtos![index].quantidadeItem! + 1;
    // emit(ClienteState.completo());
  }

  Future<void> baixarQuantidadeEstoque(int? idProduto, int quantidade) async {
    await _context.read<ProdutoService>().baixarQuantidadeEstoque(idProduto, quantidade);
  }

  Future<ProdutoModel> lerProduto(int? idProduto) async {
    return await _context.read<ProdutoService>().lerProduto(idProduto);
  }
}
