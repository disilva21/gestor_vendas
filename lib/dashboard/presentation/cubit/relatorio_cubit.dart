import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/cliente_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/formapagamento_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/item_pedido_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/pedido_service.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/cliente.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/forma_pagamento.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/pedido.dart';
import 'package:gestor_vendas/produto/data/providers/firebase/produto_service.dart';
import 'package:gestor_vendas/produto/domain/entities/produto.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/entities/relatorio.dart';
import 'relatorio_state.dart';

class RelatorioCubit extends Cubit<RelatorioState> {
  BuildContext _context;
  RelatorioCubit(this._context) : super(RelatorioState());

  RelatorioEntity relatorioEntity = RelatorioEntity();

  List<RelatorioEntity> lista = [];
  List<RelatorioEntity> listaFiltro = [];

  List<Pedido> listaAll = [];
  List<Pedido> listaNovosPedidos = [];
  List<Pedido> listaEmPreparacao = [];
  List<Pedido> listaFinalizados = [];
  List<Pedido> listaNaEntrega = [];
  List<Pedido> listaEntregues = [];
  List<Pedido> listaCancelados = [];

  List<SalesData> listaSalesData = [];
  List<Pedido> listFiltroDia = [];
  List<PieDataProduto> listaPieDataProduto = [];

  String id = '';
  int tabIndex = 0;

  String? versaoSistema;
  num? buildNumber;

  Future<void> load() async {
    emit(RelatorioState.carregando());
    final data = DateTime.now();
    final inicio = DateTime(data.year, 1, 1);
    final fim = DateTime(data.year, data.month + 1, inicio.day - 1);

    listaAll = await _context.read<PedidoService>().carregarPedidos();

    for (var i = 0; i < listaAll.length; i++) {
      listaAll[i].itens = await _context.read<ItemPedidoService>().carregarItensPedidos(listaAll[i].id);

      if (listaAll[i].idCliente == 0) {
        listaAll[i].cliente = Cliente(nome: 'Anônimo', telefone: '-');
      } else {
        listaAll[i].cliente = await _context.read<ClienteService>().ler(listaAll[i].idCliente!);
      }

      if (listaAll[i].idFormaPagamento == 0) {
        listaAll[i].formaPagamento = FormaPagamento(nome: '-');
      } else {
        listaAll[i].formaPagamento = await _context.read<FormaPagamentoService>().ler(listaAll[i].idFormaPagamento!);
      }

      if (listaAll[i].itens != null) {
        for (var p = 0; p < listaAll[i].itens!.length; p++) {
          final prd = await _context.read<ProdutoService>().lerProduto(listaAll[i].itens![p].idProduto);
          listaAll[i].itens![p].produto = prd;
          listaAll[i].itens![p].unidadeMedida = prd.unidadeMedida == null ? 1 : prd.unidadeMedida!;
        }
      }
    }

    if (listaAll.isNotEmpty) {
      await filtroListaPorAno();
      await graficoTotalVenda();
      await vendaPorStatusPedidos(DateTime.now());

      // List<PieDataProduto> listaPieDataProdutow = LinkedHashSet<PieDataProduto>.from(listaPieDataProdutoAux).toList();
      // List<PieDataProduto> listaPieDataProdutow = listaPieDataProdutoAux.re;
      // if (listaPieDataProdutow.isNotEmpty) {}
    }
    await loadDados();
    emit(RelatorioState.completo());
  }

  Future<void> loadDados() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    buildNumber = int.parse(packageInfo.buildNumber);
    versaoSistema = packageInfo.version + '-' + packageInfo.buildNumber;
  }

  List<SalesData> meses = [
    SalesData('janeiro', 0),
    SalesData('fevereiro', 0),
    SalesData('março', 0),
    SalesData('abril', 0),
    SalesData('maio', 0),
    SalesData('junho', 0),
    SalesData('julho', 0),
    SalesData('agosto', 0),
    SalesData('setembro', 0),
    SalesData('outubro', 0),
    SalesData('novembro', 0),
    SalesData('dezembro', 0)
  ];
  List<SalesData> datas = [];
  List<SalesData> datasComVenda = [];

  Future<void> filtroListaPorAno() async {
    for (var i = 0; i < meses.length; i++) {
      int qtdMes = listaAll.where((e) => DateFormat.MMMM('pt').format(e.dataCadastro!) == meses[i].month).length;

      datas.add(SalesData(meses[i].month, double.parse(qtdMes.toString())));

      if (qtdMes > 0) {
        datasComVenda.add(SalesData(meses[i].month, double.parse(qtdMes.toString())));
      }
    }
  }

  Future<void> filtroVendasMes(String mes) async {
    List<Pedido> dataMes = listaAll.where((e) => DateFormat.MMMM('pt').format(e.dataCadastro!) == mes).toList();

    totalVenda = 0;
    totalTaxaEntrega = 0;

    for (var i = 0; i < dataMes.length; i++) {
      totalVenda = totalVenda + dataMes[i].total;
      // totalTaxaEntrega = totalTaxaEntrega + dataMes[i].taxaEntrega!;
    }
  }

  num totalVenda = 0;
  num totalTaxaEntrega = 0;
  num qtdVendas = 0;
  List<ProdutoEntity> listaProdutos = [];
  List<PieDataProduto> listaPieDataProdutoAux = [];

  Future<void> graficoTotalVenda() async {
    qtdVendas = listaAll.length;
    for (var i = 0; i < listaAll.length; i++) {
      totalVenda = totalVenda + listaAll[i].total;
      //  totalTaxaEntrega = totalTaxaEntrega + listaAll[i].taxaEntrega!;

      for (var p = 0; p < listaAll[i].itens!.length; p++) {
        PieDataProduto prod = PieDataProduto(listaAll[i].itens![p].produto!.nome!, listaAll[i].itens![p].quantidade!, 1, listaAll[i].dataCadastro!);
        listaPieDataProdutoAux.add(prod);
      }
    }
    listaProdutosMaisVendidos();
  }

  List<ProdutoEntity> listaProdutosAux = [];
  List<PieDataProduto> listaAllFiltroMes = [];
  void listaProdutosMaisVendidos({String? mes}) {
    if (mes != null) {
      listaAllFiltroMes = listaPieDataProdutoAux.where((e) => DateFormat.MMMM('pt').format(e.createDate) == mes).toList();
    } else {
      listaAllFiltroMes = listaPieDataProdutoAux;
    }

    listaPieDataProduto = [];
    for (var i = 0; i < listaAllFiltroMes.length; i++) {
      if (listaPieDataProduto.isEmpty) {
        listaPieDataProduto.add(listaAllFiltroMes[i]);
      } else {
        PieDataProduto? dataProduto;
        try {
          dataProduto = listaPieDataProduto.firstWhere((element) => element.nome == listaAllFiltroMes[i].nome);

          if (dataProduto != null) {
            for (var j = 0; j < listaPieDataProduto.length; j++) {
              if (listaPieDataProduto[j].nome == listaAllFiltroMes[i].nome) {
                listaPieDataProduto[j].quantidade = listaPieDataProduto[j].quantidade + listaAllFiltroMes[i].quantidadeItem;
              }
            }
          }
        } catch (e) {
          listaPieDataProduto.add(listaAllFiltroMes[i]);
        }
      }
    }
  }

  num totalVendaNovosPedidos = 0;
  num totalVendaEmPreparacao = 0;
  num totalVendaFinalizados = 0;
  num totalVendaNaEntrega = 0;
  num totalVendaEntregue = 0;
  num totalVendaCancelada = 0;

  void vendaPorStatusPedidosClean() {
    listFiltroDia = [];
    listaNovosPedidos = [];
    listaEmPreparacao = [];
    listaFinalizados = [];
    listaNaEntrega = [];
    listaEntregues = [];
    listaCancelados = [];
    totalVendaNovosPedidos = 0;
    totalVendaEmPreparacao = 0;
    totalVendaFinalizados = 0;
    totalVendaNaEntrega = 0;
    totalVendaEntregue = 0;
    totalVendaCancelada = 0;
  }

  Future<void> vendaPorStatusPedidos(DateTime selectedDate) async {
    vendaPorStatusPedidosClean();
    listFiltroDia = listaAll.where((element) => element.dataCadastro!.month == selectedDate.month && element.dataCadastro!.day == selectedDate.day).toList();

    for (var i = 0; i < listFiltroDia.length; i++) {
      if (listFiltroDia[i].statusPedido == null || listFiltroDia[i].statusPedido == 0) {
        listaNovosPedidos.add(listFiltroDia[i]);
      }
      if (listFiltroDia[i].statusPedido == 1) {
        listaFinalizados.add(listFiltroDia[i]);
      }

      if (listFiltroDia[i].statusPedido == 2) {
        listaCancelados.add(listFiltroDia[i]);
      }
    }

    for (var i = 0; i < listaNovosPedidos.length; i++) {
      totalVendaNovosPedidos = totalVendaNovosPedidos + listaNovosPedidos[i].total;
    }

    for (var i = 0; i < listaFinalizados.length; i++) {
      totalVendaFinalizados = totalVendaFinalizados + listaFinalizados[i].total;
    }

    for (var i = 0; i < listaCancelados.length; i++) {
      totalVendaCancelada = totalVendaCancelada + listaCancelados[i].total;
    }
  }
}

class SalesData {
  SalesData(this.month, this.sales);

  final String month;
  double sales;
}

class PieDataProduto {
  PieDataProduto(
    this.nome,
    this.quantidadeItem,
    this.quantidade,
    this.createDate,
  );
  final String nome;
  num quantidade;
  final num quantidadeItem;
  DateTime createDate;
}
