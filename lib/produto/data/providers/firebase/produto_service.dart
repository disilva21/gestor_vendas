import 'package:flutter/material.dart';
import 'package:gestor_vendas/db_gestor/object_box_database.dart';

import 'package:objectbox/objectbox.dart';

import '../../../../produto/domain/entities/produto.dart';

class ProdutoService extends ChangeNotifier {
  ProdutoService(this._database);
  late final ObjectBoxDatabase? _database;

  Future<Box> getBox() async {
    final store = await _database!.getStore();
    return store.box<ProdutoModel>();
  }

  Future<void> cadastrar(ProdutoModel produto) async {
    try {
      final box = await getBox();
      box.put(produto);
    } catch (e) {}
  }

  Future<void> editar(ProdutoModel produto) async {
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

  Future<List<ProdutoModel>> carregarProdutos() async {
    final box = await getBox();

    return box.getAll() as List<ProdutoModel>;
  }

  alterarStatus(ProdutoModel item) async {
    final box = await getBox();

    box.put(item);
  }

  Future<ProdutoModel> lerProduto(int? idProduto) async {
    final box = await getBox();

    return box.get(idProduto!) as ProdutoModel;
  }

  Future<void> baixarQuantidadeEstoque(int? idProduto, int quantidade) async {
    try {
      final box = await getBox();
      ProdutoModel prod = box.get(idProduto!);
      prod.quantidadeEstoque = prod.quantidadeEstoque! - quantidade;

      box.put(prod);
    } catch (e) {}
  }
}
