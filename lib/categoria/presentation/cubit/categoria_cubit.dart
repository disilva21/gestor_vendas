import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/categoria/data/providers/firebase/categoria_service.dart';

import '../../../produto/data/providers/firebase/produto_service.dart';
import '../../domain/entities/categoria.dart';
import 'categoria_cadastro_state.dart';
import 'categoria_list_state.dart';
import 'categoria_state.dart';

class CategoriaCubit extends Cubit<CategoriaState> {
  BuildContext _context;
  CategoriaCubit(this._context) : super(CategoriaState());
  CategoriaEntity categoriaEntity = CategoriaEntity();

  List<CategoriaEntity> lista = [];
  List<CategoriaEntity> listaFiltro = [];
  List<int> listaQuantidadeSabores = [1, 2, 3, 4];

  String id = '';
  int tabIndex = 0;
  Future<void> list() async {
    emit(CategoriaListState.inicio());

    emit(CategoriaListState.completo());
  }

  Future<void> cadastro(CategoriaEntity item) async {
    emit(CategoriaCadastroState.inicio());
    categoriaEntity = item;
    emit(CategoriaCadastroState.completo());
  }

  Future<void> cadastrar() async {
    emit(CategoriaState.carregando());

    try {
      bool existe = false;

      if (lista.isNotEmpty) {
        for (var i = 0; i < lista.length; i++) {
          if (lista[i].nome!.toLowerCase() == categoriaEntity.nome!.toLowerCase()) {
            existe = true;
            break;
          }
        }
      }

      if (!existe) {
        lista.add(categoriaEntity);
        await _context.read<CategoriaService>().cadastrar(categoriaEntity);

        emit(CategoriaState.sucesso(mensagem: 'Categoria cadastrada com sucesso!'));
      } else {
        emit(CategoriaState.falha(mensagem: 'Categoria já existe'));
      }
    } catch (e) {
      emit(CategoriaState.falha(mensagem: e.toString()));
    }
  }

  Future<void> editar() async {
    emit(CategoriaState.carregando());

    _context.read<CategoriaService>().editar(categoriaEntity);

    emit(CategoriaState.sucesso(mensagem: 'Categoria salva com sucesso!'));
  }

  Future<void> carregarCategorias() async {
    emit(CategoriaState.inicio());

    lista = await _context.read<CategoriaService>().carregarCategorias();

    listaFiltro = lista;
    for (var i = 0; i < lista.length; i++) {
      await _context.read<CategoriaService>().deletar(lista[i].id);
    }

    emit(CategoriaState.completo());
  }

  Future<void> searchCategoria(String nome) async {
    emit(CategoriaListState.carregando());

    listaFiltro = lista.where((element) => element.nome!.toLowerCase().contains(nome.toLowerCase())).toList();

    emit(CategoriaListState.completo());
  }

  Future<void> closeSearchCategorias() async {
    emit(CategoriaState.carregando());

    listaFiltro = lista;

    emit(CategoriaState.completo());
  }

  Future<void> alterarStatus(CategoriaEntity item) async {
    emit(CategoriaState.carregando());
    item.ativo = !item.ativo!;

    _context.read<CategoriaService>().alterarStatus(item);

    emit(CategoriaState.completo());
  }

  Future<void> deletar(int idCategoria) async {
    emit(CategoriaState.carregando());

    if (!await existeProduto(idCategoria)) {
      await _context.read<CategoriaService>().deletar(idCategoria);
      lista.removeWhere((element) => element.id == idCategoria);
      listaFiltro.removeWhere((element) => element.id == idCategoria);
      emit(CategoriaState.completo());
    } else {
      emit(CategoriaState.falha(mensagem: 'Essa categoria não pode ser deletada, porque está sendo usada em algum(s) produto(s)'));
    }
  }

  existeProduto(int idCategoria) async {
    final listaProd = await _context.read<ProdutoService>().carregarProdutos();
    bool existe = false;
    for (var i = 0; i < listaProd.length; i++) {
      if (listaProd[i].idCategoria == idCategoria) {
        existe = true;
        break;
      }
    }
    return existe;
  }
}
