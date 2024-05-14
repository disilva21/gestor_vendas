import 'package:flutter/material.dart';

import 'package:gestor_vendas/db_gestor/object_box_database.dart';
import 'package:gestor_vendas/db_gestor/objectbox.g.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/item_pedido.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/pedido.dart';
import 'package:objectbox/objectbox.dart';

class ItemPedidoService extends ChangeNotifier {
  ItemPedidoService(this._database);

  late final ObjectBoxDatabase? _database;
  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<ItemPedidoModel>();
  }

  Future<void> cadastrar(ItemPedidoModel itemPedido) async {
    try {
      final box = await getBox();
      box.put(itemPedido);
    } catch (e) {}
  }

  Future<List<ItemPedidoModel>> carregarItensPedidos(int idPedido) async {
    final box = await getBox();
    final query = (box.query(ItemPedidoModel_.idPedido.equals(idPedido))).build();
    final results = query.find();
    query.close();
    return results as List<ItemPedidoModel>;
  }

  Future<bool?> lerItemPedidoProduto(int idProduto) async {
    final box = await getBox();
    final query = (box.query(ItemPedidoModel_.idProduto.equals(idProduto))).build();
    final results = query.find();
    query.close();
    return results.isNotEmpty;
  }

  Future<void> editar(PedidoModel pedido) async {}

  Future<ItemPedidoModel> lerPedido(int? id) async {
    final box = await getBox();

    return box.get(id!) as ItemPedidoModel;
  }
}
