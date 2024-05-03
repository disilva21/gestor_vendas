import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestor_vendas/database/object_box_database.dart';
import 'package:gestor_vendas/database/objectbox.g.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/item_pedido.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/pedido.dart';
import 'package:objectbox/objectbox.dart';

class ItemPedidoService extends ChangeNotifier {
  ItemPedidoService(this._database);

  late final ObjectBoxDatabase? _database;
  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<ItemPedido>();
  }

  Future<void> cadastrar(ItemPedido itemPedido) async {
    try {
      final box = await getBox();
      box.put(itemPedido);
    } catch (e) {}
  }

  Future<List<ItemPedido>> carregarItensPedidos(int idPedido) async {
    final box = await getBox();
    final query = (box.query(ItemPedido_.idPedido.equals(idPedido))).build();
    final results = query.find();
    query.close();
    return results as List<ItemPedido>;
  }

  Future<void> editar(Pedido pedido) async {}

  Future<ItemPedido> lerPedido(int? id) async {
    final box = await getBox();

    return box.get(id!) as ItemPedido;
  }
}
