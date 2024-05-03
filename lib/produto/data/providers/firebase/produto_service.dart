import 'package:flutter/material.dart';
import 'package:gestor_pdv/database/object_box_database.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../produto/domain/entities/produto.dart';

class ProdutoService extends ChangeNotifier {
  ProdutoService(this._database);
  late final ObjectBoxDatabase? _database;

  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<ProdutoEntity>();
  }

  Future<void> cadastrar(ProdutoEntity produto) async {
    try {
      final box = await getBox();
      box.put(produto);
    } catch (e) {}
  }

  Future<void> editar(ProdutoEntity produto) async {
    try {
      final box = await getBox();
      box.put(produto);
    } catch (e) {}
  }

  Future<void> deletar(int id) async {
    try {
      final box = await getBox();
      box.remove(id);
    } catch (e) {}
  }

  Future<List<ProdutoEntity>> carregarProdutos() async {
    final box = await getBox();

    return box.getAll() as List<ProdutoEntity>;
  }

  alterarStatus(ProdutoEntity item) async {
    final box = await getBox();

    box.put(item);
  }

  Future<ProdutoEntity> lerProduto(int? idProduto) async {
    final box = await getBox();

    return box.get(idProduto!) as ProdutoEntity;
  }
}