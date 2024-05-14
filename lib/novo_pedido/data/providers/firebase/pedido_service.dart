import 'package:flutter/material.dart';
import 'package:gestor_vendas/db_gestor/object_box_database.dart';

import 'package:gestor_vendas/novo_pedido/domain/entities/pedido.dart';
import 'package:objectbox/objectbox.dart';

class PedidoService extends ChangeNotifier {
  PedidoService(this._database);

  late final ObjectBoxDatabase? _database;
  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<PedidoModel>();
  }

  Future cadastrar(PedidoModel pedido) async {
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

  Future<List<PedidoModel>> carregarPedidos() async {
    final box = await getBox();

    return box.getAll() as List<PedidoModel>;
  }

  Future alterarStatusPedido(int status, int id) async {
    try {
      final box = await getBox();
      PedidoModel ped = box.get(id);

      ped.statusPedido = status;

      box.put(ped);
    } catch (e) {}
  }
}
