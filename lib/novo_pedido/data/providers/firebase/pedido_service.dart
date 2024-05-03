import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestor_vendas/database/object_box_database.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/item_pedido.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/pedido.dart';
import 'package:objectbox/objectbox.dart';

class PedidoService extends ChangeNotifier {
  PedidoService(this._database);

  late final ObjectBoxDatabase? _database;
  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<Pedido>();
  }

  Future cadastrar(Pedido pedido) async {
    try {
      final box = await getBox();
      box.put(pedido);

      return pedido;
    } catch (e) {}
  }

  Future<void> deletar(int idPedido) async {
    final box = await getBox();
    box.remove(idPedido);
  }

  Future<List<Pedido>> carregarPedidos() async {
    final box = await getBox();

    return box.getAll() as List<Pedido>;
  }
}
