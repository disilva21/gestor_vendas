import 'package:flutter/material.dart';
import 'package:gestor_pdv/database/object_box_database.dart';
import 'package:gestor_pdv/database/objectbox.g.dart';
import 'package:gestor_pdv/novo_pedido/domain/entities/cliente.dart';
import 'package:objectbox/objectbox.dart';
import 'package:objectbox/objectbox.dart';

class ClienteService extends ChangeNotifier {
  ClienteService(this._database);

  late final ObjectBoxDatabase? _database;
  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<Cliente>();
  }

  Future<void> cadastrar(Cliente cliente) async {
    try {
      final box = await getBox();
      box.put(cliente);
    } catch (e) {}
  }

  Future<Cliente?> ler(int idCliente) async {
    try {
      final box = await getBox();
      return box.get(idCliente);
    } catch (e) {}
  }

  Future<Cliente?> lerCliente(String telefone) async {
    try {
      final box = await getBox();
      final query = (box.query(Cliente_.telefone.equals(telefone))).build();
      final results = query.find().first;
      query.close();
      return results as Cliente;
    } catch (e) {}
  }

  Future<void> editar(Cliente cliente) async {}
}
