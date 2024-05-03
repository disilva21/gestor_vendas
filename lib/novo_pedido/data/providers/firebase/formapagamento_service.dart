import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestor_vendas/database/object_box_database.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/forma_pagamento.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/pedido.dart';
import 'package:objectbox/objectbox.dart';

class FormaPagamentoService extends ChangeNotifier {
  FormaPagamentoService(this._database);

  late final ObjectBoxDatabase? _database;
  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<FormaPagamento>();
  }

  Future<void> cadastrar(FormaPagamento formaPagamento) async {
    try {
      final box = await getBox();
      box.put(formaPagamento);
    } catch (e) {}
  }

  Future<FormaPagamento?> ler(int idformaPagamento) async {
    try {
      final box = await getBox();
      return box.get(idformaPagamento);
    } catch (e) {}
  }

  Future<List<FormaPagamento>> carregarFormaPagamento() async {
    final box = await getBox();

    return box.getAll() as List<FormaPagamento>;
  }

  Future<void> editar(FormaPagamento formaPagamento) async {}
}
