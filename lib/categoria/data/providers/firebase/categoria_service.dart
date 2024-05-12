import 'package:flutter/material.dart';
import 'package:gestor_vendas/database/object_box_database.dart';
import 'package:gestor_vendas/database/objectbox.g.dart';

import '../../../domain/entities/categoria.dart';

class CategoriaService extends ChangeNotifier {
  CategoriaService(this._database);

  late final ObjectBoxDatabase? _database;

  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<CategoriaEntity>();
  }

  Future<void> cadastrar(CategoriaEntity categoria) async {
    try {
      final box = await getBox();
      box.put(categoria);
    } catch (e) {
      final teste = e;
    }
  }

  Future<void> editar(CategoriaEntity categoria) async {
    try {
      final box = await getBox();
      box.put(categoria);
    } catch (e) {}
  }

  Future<List<CategoriaEntity>> carregarCategorias() async {
    final box = await getBox();

    return box.getAll() as List<CategoriaEntity>;
  }

  Future<CategoriaEntity?> lerCategoria(int idCategoria) async {
    final box = await getBox();
    final data = box.get(idCategoria);
    if (data == null) {
      return null;
    }

    return box.get(idCategoria) as CategoriaEntity?;
  }

  alterarStatus(CategoriaEntity item) async {
    final box = await getBox();

    box.put(item);
  }

  Future<void> deletar(int id) async {
    try {
      final box = await getBox();
      box.remove(id);
    } catch (e) {}
  }
}
