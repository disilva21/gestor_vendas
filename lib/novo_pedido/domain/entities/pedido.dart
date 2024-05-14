import 'package:gestor_vendas/novo_pedido/domain/entities/cliente.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/forma_pagamento.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/item_pedido.dart';
import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity()
class PedidoModel {
  int id = 0;
  int? idCliente;
  @Transient()
  ClienteModel? cliente;
  String? descricao;
  @Transient()
  List<ItemPedidoModel>? itens;
  @Transient()
  FormaPagamentoModel? formaPagamento;
  int? idFormaPagamento;
  bool? jaPagou = false;
  double total = 0;
  int? statusPedido = 0;

  @Property(type: PropertyType.date)
  DateTime? dataCadastro = DateTime.now();

  PedidoModel({
    this.idCliente,
    this.descricao,
    this.itens,
    this.idFormaPagamento,
    this.jaPagou,
    this.dataCadastro,
    this.statusPedido,
  });
  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(dataCadastro!);
}
