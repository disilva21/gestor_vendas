import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_pdv/categoria/data/providers/firebase/categoria_service.dart';
import 'package:gestor_pdv/novo_pedido/data/providers/firebase/cliente_service.dart';
import 'package:gestor_pdv/novo_pedido/data/providers/firebase/formapagamento_service.dart';
import 'package:gestor_pdv/novo_pedido/data/providers/firebase/item_pedido_service.dart';
import 'package:gestor_pdv/novo_pedido/data/providers/firebase/pedido_service.dart';
import 'package:gestor_pdv/novo_pedido/domain/entities/cliente.dart';
import 'package:gestor_pdv/novo_pedido/domain/entities/forma_pagamento.dart';
import 'package:gestor_pdv/novo_pedido/domain/entities/item_pedido.dart';
import 'package:gestor_pdv/novo_pedido/domain/entities/pedido.dart';
import 'package:gestor_pdv/produto/data/providers/firebase/produto_service.dart';
import 'package:path_provider/path_provider.dart';

import '../../../produto/domain/entities/produto.dart';

import '../../../categoria/domain/entities/categoria.dart';
import 'novo_pedido_state.dart';

class NovoPedidoCubit extends Cubit<NovoPedidoState> {
  BuildContext _context;
  NovoPedidoCubit(this._context) : super(NovoPedidoState());

  CategoriaEntity categoriaEntity = CategoriaEntity();
  ProdutoEntity produtoEntity = ProdutoEntity();
  Pedido pedido = Pedido();

  List<CategoriaEntity> listaFiltro = [];
  List<int> listaQuantidadeSabores = [1, 2, 3, 4];
  Cliente? cliente;

  List<ProdutoEntity> produtosMaisSabores = [];
  List<ProdutoEntity> produtosFiltro = [];
  List<ProdutoEntity> produtosPedido = [];
  num? valorMaiorSabores = 0;
  num? valorOriginalProduto = 0;

  num? valorProdutoAcompanhamento = 0;
  num? valorProdutoAdicional = 0;

  String? categoriaSelecioanada;
  List<CategoriaEntity> categoriasProduto = [];
  List<ProdutoEntity> lista = [];
  CategoriaEntity? categoriaEntitySelecionada;
  String id = '';
  int tabIndex = 0;
  String numeroPedido = '';

  List<FormaPagamento> formaPagamentos = [];
  StreamSubscription<dynamic>? subscription;

  List<double> listaGeo = [];
  double latitude = 0;
  double longitude = 0;
  int? valorDistancia;
  String diretorio = '';

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
    final dir = await getTemporaryDirectory();
    diretorio = dir.path;

    emit(NovoPedidoState.completo());
  }

  carregarCategorias() async {
    categoriasProduto = await _context.read<CategoriaService>().carregarCategorias();
  }

  loadProdutos() async {
    emit(NovoPedidoState.carregandoImagem());

    // for (var i = 0; i < categoriasProduto.length; i++) {
    //   ProdutoEntity? prod = lista.firstWhere((element) => element.idCategoria == categoriasProduto[i].id);
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

  Future<void> filtroCategoria(CategoriaEntity item) async {
    emit(NovoPedidoState.carregando());
    produtosFiltro = lista.where((element) => element.idCategoria == item.id).toList();
    categoriaSelecioanada = item.id.toString();
    categoriaEntitySelecionada = item;
    emit(NovoPedidoState.completo());
  }

  ProdutoEntity prodDetalhe = ProdutoEntity();

  Future<void> loadDetalhe(ProdutoEntity _produtoEntity) async {
    prodDetalhe = await lerProduto(_produtoEntity.id);
  }

  Future<void> addProdutosPedido(ProdutoEntity _produtoEntity) async {
    emit(NovoPedidoState.carregando());

    pedido.itens ??= [];

    ItemPedido item = ItemPedido(idProduto: _produtoEntity.id, quantidade: _produtoEntity.quantidadeItem, valorVenda: _produtoEntity.valorVenda);

    final prd = await lerProduto(_produtoEntity.id);
    item.nomeProduto = prd.nome;
    pedido.itens!.add(item);

    emit(NovoPedidoState.completo());
  }

  Future<void> loadFormaPagamento() async {
    emit(NovoPedidoState.carregando());

    // FormaPagamento item1 = FormaPagamento(
    //   nome: "Crédito",
    //   ativo: true,
    // );

    // await _context.read<FormaPagamentoService>().cadastrar(item1);
    // FormaPagamento item2 = FormaPagamento(
    //   nome: "Débito",
    //   ativo: true,
    // );
    // await _context.read<FormaPagamentoService>().cadastrar(item2);
    // FormaPagamento item3 = FormaPagamento(
    //   nome: "PIX",
    //   ativo: true,
    // );
    // await _context.read<FormaPagamentoService>().cadastrar(item3);
    // FormaPagamento item4 = FormaPagamento(
    //   nome: "Dinheiro",
    //   ativo: true,
    // );
    // await _context.read<FormaPagamentoService>().cadastrar(item4);

    formaPagamentos = await _context.read<FormaPagamentoService>().carregarFormaPagamento();
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
      } else {
        pedido.idCliente = cliente!.id;
      }
      if (pedido.formaPagamento == null) {
        pedido.idFormaPagamento = 0;
      } else {
        pedido.idFormaPagamento = pedido.formaPagamento!.id;
      }

      pedido.dataCadastro = DateTime.now();
      pedido = await _context.read<PedidoService>().cadastrar(pedido);

      if (pedido.id > 0) {
        for (var i = 0; i < pedido.itens!.length; i++) {
          ItemPedido item = ItemPedido(
            idProduto: pedido.itens![i].idProduto,
            idPedido: pedido.id,
            quantidade: pedido.itens![i].quantidade,
            valorVenda: pedido.itens![i].valorVenda,
          );

          await _context.read<ItemPedidoService>().cadastrar(item);
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

  Future<void> addItemPedido(ProdutoEntity produtoEntity, int index) async {
    // pedido.total = pedido.total! + produtoEntity.valorVenda!;

    // for (var i = 0; i < produtoEntity.adicionais!.length; i++) {
    //   pedido.total = pedido.total! + produtoEntity.adicionais![i].valorVenda!;
    // }

    // pedido.produtos![index].quantidadeItem = pedido.produtos![index].quantidadeItem! + 1;
    // emit(ClienteState.completo());
  }

  Future<ProdutoEntity> lerProduto(int? idProduto) async {
    return await _context.read<ProdutoService>().lerProduto(idProduto);
  }
}
