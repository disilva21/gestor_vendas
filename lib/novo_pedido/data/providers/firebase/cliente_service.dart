import 'package:flutter/material.dart';
import 'package:gestor_vendas/db_gestor/object_box_database.dart';
import 'package:gestor_vendas/db_gestor/objectbox.g.dart';
import 'package:gestor_vendas/novo_pedido/domain/entities/cliente.dart';
import 'package:objectbox/objectbox.dart';

class ClienteService extends ChangeNotifier {
  ClienteService(this._database);

  late final ObjectBoxDatabase? _database;
  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<ClienteModel>();
  }

  Future<void> cadastrar(ClienteModel cliente) async {
    try {
      final box = await getBox();
      box.put(cliente);
    } catch (e) {}
  }

  Future<ClienteModel?> ler(int idCliente) async {
    try {
      final box = await getBox();
      return box.get(idCliente);
    } catch (e) {}
  }

  Future<ClienteModel?> lerCliente(String telefone) async {
    try {
      final box = await getBox();
      final query = (box.query(ClienteModel_.telefone.equals(telefone))).build();
      final results = query.find().first;
      query.close();
      return results as ClienteModel;
    } catch (e) {}
  }

  Future<void> editar(ClienteModel cliente) async {}
}
