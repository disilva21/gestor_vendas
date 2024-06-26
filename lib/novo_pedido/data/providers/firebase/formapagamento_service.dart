import 'package:flutter/material.dart';

import 'package:gestor_vendas/db_gestor/object_box_database.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/forma_pagamento.dart';

import 'package:objectbox/objectbox.dart';

class FormaPagamentoService extends ChangeNotifier {
  FormaPagamentoService(this._database);

  late final ObjectBoxDatabase? _database;
  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<FormaPagamentoModel>();
  }

  Future<void> cadastrar(FormaPagamentoModel formaPagamento) async {
    try {
      final box = await getBox();
      box.put(formaPagamento);
    } catch (e) {}
  }

  Future<FormaPagamentoModel?> ler(int idformaPagamento) async {
    try {
      final box = await getBox();
      return box.get(idformaPagamento);
    } catch (e) {}
  }

  Future<List<FormaPagamentoModel>> carregarFormaPagamento() async {
    final box = await getBox();

    return box.getAll() as List<FormaPagamentoModel>;
  }

  Future<void> editar(FormaPagamentoModel formaPagamento) async {}
}
