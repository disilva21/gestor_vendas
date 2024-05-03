import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_pdv/categoria/data/providers/firebase/categoria_service.dart';
import 'package:gestor_pdv/produto/data/providers/firebase/produto_service.dart';
import 'package:gestor_pdv/produto/domain/enum/unidade_medida.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../categoria/domain/entities/categoria.dart';

import '../../domain/entities/produto.dart';

import 'produto_cadastro_state.dart';
import 'produto_list_state.dart';
import 'produto_state.dart';

class ProdutoCubit extends Cubit<ProdutoState> {
  BuildContext _context;
  ProdutoCubit(this._context) : super(ProdutoState());
  ProdutoEntity produtoEntity = ProdutoEntity();

  List<ProdutoEntity> lista = [];
  List<ProdutoEntity> listaFiltro = [];
  List<CategoriaEntity> categorias = [];
  List<UnidadeMedida> listaUnidadeMedida = [];

  String downloadedUrl = "";
  bool isRemoverImagem = false;
  String? idImagemRemovida = null;
  Uint8List? fileUint8List = null;
  String diretorio = '';

  List<EnumUnidadeMedida> listaEnumUnidadeMedida = [];

  Future<void> list() async {
    emit(ProdutoListState.inicio());

    emit(ProdutoListState.completo());
  }

  Future<void> cadastro(ProdutoEntity item) async {
    emit(ProdutoCadastroState.inicio());
    produtoEntity = item;
    final dir = await getTemporaryDirectory();
    diretorio = dir.path;

    await carregarCategorias();
    await unidadeMedidas();

    emit(ProdutoCadastroState.completo());
  }

  Future<List<UnidadeMedida>> unidadeMedidas() async {
    listaUnidadeMedida = [];
    listaUnidadeMedida.add(UnidadeMedida(id: 1, nome: 'Unidade'));
    listaUnidadeMedida.add(UnidadeMedida(id: 2, nome: 'Kilogramas'));
    listaUnidadeMedida.add(UnidadeMedida(id: 3, nome: 'Peça'));
    listaUnidadeMedida.add(UnidadeMedida(id: 4, nome: 'Tamanho'));

    return listaUnidadeMedida;
  }

  Future<void> loadEnumUnidadeMedida() async {
    emit(ProdutoState.carregando());

    for (var i = 0; i < EnumUnidadeMedida.values.length; i++) {
      listaEnumUnidadeMedida.add(EnumUnidadeMedida.values[i]);
    }

    emit(ProdutoState.completo());
  }

  int? id;

  Future<void> cadastrar() async {
    emit(ProdutoState.carregando());

    bool existe = false;
    bool existeCodigo = false;
    String? existeMensagem;
    if (lista.isNotEmpty) {
      for (var i = 0; i < lista.length; i++) {
        if (lista[i].nome!.toLowerCase() == produtoEntity.nome!.toLowerCase() && lista[i].idCategoria == produtoEntity.idCategoria) {
          existe = true;
          existeMensagem = 'nome';
          break;
        }
        // if (lista[i].codigo! == produtoEntity.codigo && produtoEntity.codigo != 0) {
        //   existeCodigo = true;
        //   existeMensagem = 'código';
        //   break;
        // }
      }
    }

    if (existe || existeCodigo) {
      emit(ProdutoCadastroState.falha(mensagem: 'Produto já existe ($existeMensagem)'));
    } else {
      if (fileUint8List != null) {
        String _nome_Imagem = DateTime.now().millisecondsSinceEpoch.toString();
        await adicionarImagem(_nome_Imagem);
        produtoEntity.imagem = _nome_Imagem;
      }

      try {
        await _context.read<ProdutoService>().cadastrar(produtoEntity);

        produtoEntity = ProdutoEntity();

        emit(ProdutoState.sucesso(mensagem: 'Produto cadastrado com sucesso!'));
      } catch (e) {
        emit(ProdutoCadastroState.falha(mensagem: e.toString()));
      }
    }
  }

  Future<void> editar() async {
    emit(ProdutoState.carregando());
    if (id != null) {
      produtoEntity.id = id!;

      bool existe = false;
      bool existeCodigo = false;
      String? existeMensagem;

      if (lista.isNotEmpty) {
        for (var i = 0; i < lista.length; i++) {
          if (lista[i].nome!.toLowerCase() == produtoEntity.nome!.toLowerCase() && lista[i].idCategoria == produtoEntity.idCategoria && lista[i].id != id) {
            existe = true;
            existeMensagem = 'nome';
            break;
          }
          if (lista[i].codigo != null && lista[i].codigo! == produtoEntity.codigo && produtoEntity.codigo != 0 && lista[i].id != id) {
            existeCodigo = true;
            existeMensagem = 'código';
            break;
          }
        }
      }

      if (existe || existeCodigo) {
        emit(ProdutoCadastroState.falha(mensagem: 'Produto já existe ($existeMensagem)'));
      } else {
        if (isRemoverImagem) {
          produtoEntity.imagem = null;
        }

        if (fileUint8List != null) {
          String _nome_Imagem = DateTime.now().millisecondsSinceEpoch.toString();
          await adicionarImagem(_nome_Imagem);
          produtoEntity.imagem = _nome_Imagem;
        }

        await _context.read<ProdutoService>().editar(produtoEntity);

        produtoEntity = ProdutoEntity();

        emit(ProdutoState.sucesso(mensagem: 'Produto salvo com sucesso!'));
      }
    }
  }

  Future<void> lerProduto(int idProduto) async {
    produtoEntity = await _context.read<ProdutoService>().lerProduto(idProduto);
  }

  Future<void> deletar(int idProduto) async {
    emit(ProdutoState.carregando());
    await _context.read<ProdutoService>().deletar(idProduto);
    lista.removeWhere((element) => element.id == idProduto);
    // listaFiltro.removeWhere((element) => element.id == idProduto);

    emit(ProdutoState.completo());
  }

  Future<void> carregarCategorias() async {
    categorias = await _context.read<CategoriaService>().carregarCategorias();

    categorias = categorias.where((element) => element.ativo == true).toList();
  }

  Future<void> carregarProdutos() async {
    emit(ProdutoListState.carregando());

    await loadEnumUnidadeMedida();
    lista = await _context.read<ProdutoService>().carregarProdutos();

    for (var i = 0; i < lista.length; i++) {
      if (lista[i].idCategoria != null) {
        CategoriaEntity? categoria = await _context.read<CategoriaService>().lerCategoria(lista[i].idCategoria!);
        if (categoria != null) {
          lista[i].nomeCategoria = categoria.nome;
        } else {
          lista[i].nomeCategoria = '';
        }
      }
    }

    listaFiltro = lista;

    emit(ProdutoListState.completo());
  }

  Future<String> nomeCategoria(int idCategoria) async {
    final categoria = await _context.read<CategoriaService>().lerCategoria(idCategoria);
    return categoria!.nome!;
  }

  Future<void> seachProdutos(String texto) async {
    emit(ProdutoListState.carregando());

    listaFiltro = lista
        .where((element) =>
            element.nome!.toLowerCase().contains(texto.toLowerCase()) ||
            element.codigo != null && element.codigo!.toString().contains(texto.toLowerCase()) ||
            element.nomeCategoria != null && element.nomeCategoria!.toLowerCase().contains(texto.toLowerCase()))
        .toList();

    emit(ProdutoListState.completo());
  }

  Future<void> closeSeachProdutos() async {
    emit(ProdutoListState.carregando());

    listaFiltro = lista;

    emit(ProdutoListState.completo());
  }

  Future<void> alterarStatus(ProdutoEntity item) async {
    emit(ProdutoListState.carregando());
    item.ativo = !item.ativo!;
    await _context.read<ProdutoService>().alterarStatus(item);

    emit(ProdutoListState.completo());
  }

  Future<void> adicionarImagem(String nome_Imagem) async {
    emit(ProdutoCadastroState.carregando());
    try {
      final dir = await getTemporaryDirectory();
      var filename = '${dir.path}/GPDVProd${nome_Imagem}.png';
      final file = File(filename);
      await file.writeAsBytes(fileUint8List!);

      fileUint8List = null;

      emit(ProdutoCadastroState.completo());
    } catch (e) {
      emit(ProdutoCadastroState.falha(mensagem: 'Erro ao fazer upload da imagem'));
    }
  }
}
