import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/cliente_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/formapagamento_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/item_pedido_service.dart';
import 'package:gestor_vendas/novo_pedido/data/providers/firebase/pedido_service.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/cliente.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/forma_pagamento.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/item_pedido.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/pedido.dart';

import 'package:gestor_vendas/novo_pedido/presentation/cubit/pedido_state.dart';
import 'package:gestor_vendas/produto/data/providers/firebase/produto_service.dart';

import '../../../../util/validar_celular.dart';

class PedidoCubit extends Cubit<PedidoState> {
  BuildContext _context;
  PedidoCubit(this._context) : super(PedidoState());
  Pedido pedidoEntity = Pedido();

  List<Pedido> lista = [];
  List<Pedido> listaFiltro = [];
  String id = '';

  List<DateTime?> dialogCalendarPickerValue = [];

  DateTime dataInicio = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? dataFinal = null;

  Future<void> retornarUltimaData() async {
    DateTime dataInicio = DateTime(DateTime.now().year, DateTime.now().month, 1);
    dataFinal = DateTime(dataInicio.year, dataInicio.month + 1, 0);
  }

  Future<void> editar() async {
    emit(PedidoState.carregando());
    if (id.isNotEmpty) {
      // pedidoEntity.id = id;

      // await _context.read<PedidoService>().editar(pedidoEntity);
      emit(PedidoState.sucesso(mensagem: 'Dados salvos com sucesso!'));
    } else {
      emit(PedidoState.valido(mensagem: 'Não foi possível salvar essa Pedido.'));
    }
  }

  Future<void> carregarPedidos() async {
    emit(PedidoState.carregando());
    dataFinal = DateTime(dataInicio.year, dataInicio.month + 1, 0);

    //lista = await _context.read<PedidoService>().carregarPedidos(inicio: dataInicio, fim: dataFinal);
    lista = await _context.read<PedidoService>().carregarPedidos();

    for (var i = 0; i < lista.length; i++) {
      lista[i].itens = await _context.read<ItemPedidoService>().carregarItensPedidos(lista[i].id);

      if (lista[i].idCliente == 0) {
        lista[i].cliente = Cliente(nome: 'Anônimo', telefone: '-');
      } else {
        lista[i].cliente = await _context.read<ClienteService>().ler(lista[i].idCliente!);
      }

      if (lista[i].idFormaPagamento == 0) {
        lista[i].formaPagamento = FormaPagamento(nome: '-');
      } else {
        lista[i].formaPagamento = await _context.read<FormaPagamentoService>().ler(lista[i].idFormaPagamento!);
      }
    }

    listaFiltro = lista;

    await searchData();
    emit(PedidoState.completo());
  }

  Future lerPedido(int id) async {
    final itemPedido = await _context.read<ItemPedidoService>().lerPedido(id);
  }

  Future lerProduto(int idProduto) async {
    final produtoEntity = await _context.read<ProdutoService>().lerProduto(idProduto);
  }

  // Future<void> setStatusPedido(EnumPedidoStatus status, String pedidoId) async {
  //   emit(PedidoState.carregando());

  //   await _context.read<PedidoService>().alterarStatus(status.index, pedidoId);
  //   await carregarPedidos();

  //   emit(PedidoState.sucesso(mensagem: 'Status do pedido alterado com sucesso!'));
  // }

  // Future<void> carregarEntregadores() async {
  //   listaEntregadores = await _context.read<EntregadorService>().carregarEntregadores();
  // }

  // Future<void> setEntregadorPedido(String pedidoId, EntregadorEntity entregador) async {
  //   emit(PedidoState.carregando());

  //   await _context.read<PedidoService>().alterarEntregadorPedido(pedidoId, entregador);

  //   emit(PedidoState.completo());
  // }

  Future<void> search(String valor) async {
    var _dataInicio;
    var _dataFinal;
    // emit(PedidoState.carregando());
    if (dialogCalendarPickerValue.length > 0) {
      _dataInicio = DateTime(dialogCalendarPickerValue[0]!.year, dialogCalendarPickerValue[0]!.month, dialogCalendarPickerValue[0]!.day).millisecondsSinceEpoch;
      _dataFinal = DateTime(dialogCalendarPickerValue[1]!.year, dialogCalendarPickerValue[1]!.month, dialogCalendarPickerValue[1]!.day).millisecondsSinceEpoch;
    } else {
      _dataInicio = DateTime(DateTime.now().year, DateTime.now().month, 1).millisecondsSinceEpoch;
      _dataFinal = DateTime(dataInicio.year, dataInicio.month + 1, 0).millisecondsSinceEpoch;
    }

    listaFiltro = lista
        .where((element) =>
            (element.cliente!.nome!.toLowerCase().contains(valor.toLowerCase()) || element.cliente!.telefone!.toLowerCase().contains(ValidarCelular.normalizarCelular(valor))) &&
            (DateTime(element.dataCadastro!.year, element.dataCadastro!.month, element.dataCadastro!.day).millisecondsSinceEpoch >= _dataInicio &&
                DateTime(element.dataCadastro!.year, element.dataCadastro!.month, element.dataCadastro!.day).millisecondsSinceEpoch <= _dataFinal))
        .toList();

    emit(PedidoState.completo());
  }

  // Future<void> searchStatus(EnumPedidoStatus valor) async {
  //   emit(PedidoState.carregando());

  //   listaFiltro = lista.where((element) => element.enumPedidoStatus == valor).toList();

  //   emit(PedidoState.completo());
  // }

  Future<void> searchData() async {
    emit(PedidoState.carregando());

    final dataInicio = DateTime(dialogCalendarPickerValue[0]!.year, dialogCalendarPickerValue[0]!.month, dialogCalendarPickerValue[0]!.day).millisecondsSinceEpoch;
    final dataFinal = DateTime(dialogCalendarPickerValue[1]!.year, dialogCalendarPickerValue[1]!.month, dialogCalendarPickerValue[1]!.day).millisecondsSinceEpoch;

    listaFiltro = lista
        .where((element) =>
            DateTime(element.dataCadastro!.year, element.dataCadastro!.month, element.dataCadastro!.day).millisecondsSinceEpoch >= dataInicio &&
            DateTime(element.dataCadastro!.year, element.dataCadastro!.month, element.dataCadastro!.day).millisecondsSinceEpoch <= dataFinal)
        .toList();

    emit(PedidoState.completo());
  }

  // Future<void> loadEnumStatus() async {
  //   emit(PedidoState.carregando());

  //   for (var i = 0; i < EnumPedidoStatus.values.length; i++) {
  //     listaEnumStatus.add(EnumPedidoStatus.values[i]);
  //   }

  //   emit(PedidoState.completo());
  // }
}
