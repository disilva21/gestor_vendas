import 'package:flutter/material.dart';
import 'package:gestor_vendas/db_gestor/object_box_database.dart';
import 'package:objectbox/objectbox.dart';

import '../../../domain/entities/categoria.dart';

class CategoriaService extends ChangeNotifier {
  CategoriaService(this._database);

  late final ObjectBoxDatabase? _database;

  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<CategoriaModel>();
  }

  Future<void> cadastrar(CategoriaModel categoria) async {
    try {
      final box = await getBox();
      box.put(categoria);
    } catch (e) {
      final teste = e;
    }
  }

  Future<void> editar(CategoriaModel categoria) async {
    try {
      final box = await getBox();
      box.put(categoria);
    } catch (e) {}
  }

  Future<List<CategoriaModel>> carregarCategorias() async {
    try {
      final box = await getBox();

      return box.getAll() as List<CategoriaModel>;
    } catch (e) {
      final teste = e;
      return [];
    }
  }

  Future<CategoriaModel?> lerCategoria(int idCategoria) async {
    final box = await getBox();
    final data = box.get(idCategoria);
    if (data == null) {
      return null;
    }

    return box.get(idCategoria) as CategoriaModel?;
  }

  alterarStatus(CategoriaModel item) async {
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
