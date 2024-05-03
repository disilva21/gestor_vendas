import 'package:gestor_vendas/novo_pedido/domain/entities/cliente.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/forma_pagamento.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/item_pedido.dart';
import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity()
class Pedido {
  int id = 0;
  int? idCliente;
  @Transient()
  Cliente? cliente;
  String? descricao;
  @Transient()
  List<ItemPedido>? itens;
  @Transient()
  FormaPagamento? formaPagamento;
  int? idFormaPagamento;
  bool? jaPagou = false;
  double total = 0;

  @Property(type: PropertyType.date)
  DateTime? dataCadastro = DateTime.now();

  Pedido({
    this.idCliente,
    this.descricao,
    this.itens,
    this.idFormaPagamento,
    this.jaPagou,
    this.dataCadastro,
  });
  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(dataCadastro!);
}
