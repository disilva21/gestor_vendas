import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/categoria/data/providers/firebase/categoria_service.dart';

import 'package:gestor_vendas/novo_pedido/data/providers/firebase/item_pedido_service.dart';
import 'package:gestor_vendas/produto/data/providers/firebase/produto_service.dart';
import 'package:gestor_vendas/produto/domain/enum/unidade_medida.dart';

import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

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

    await unidadeMedidas();

    emit(ProdutoCadastroState.completo());
  }

  Future<List<UnidadeMedida>> unidadeMedidas() async {
    listaUnidadeMedida = [];
    listaUnidadeMedida.add(UnidadeMedida(id: 1, nome: 'Unidade', sigla: 'UN'));
    listaUnidadeMedida.add(UnidadeMedida(id: 2, nome: 'Quilogramas', sigla: 'KG'));
    listaUnidadeMedida.add(UnidadeMedida(id: 3, nome: 'Metro', sigla: 'M'));

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
      // if (fileUint8List != null) {
      //   String _nome_Imagem = DateTime.now().millisecondsSinceEpoch.toString();
      //   await adicionarImagem(_nome_Imagem);
      //   produtoEntity.imagem = _nome_Imagem;
      // }

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
        // if (isRemoverImagem) {
        //   produtoEntity.imagem = null;
        // }

        // if (fileUint8List != null) {
        //   String _nome_Imagem = DateTime.now().millisecondsSinceEpoch.toString();
        //   await adicionarImagem(_nome_Imagem);
        //   produtoEntity.imagem = _nome_Imagem;
        // }

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

    bool? temPedido = await _context.read<ItemPedidoService>().lerItemPedidoProduto(idProduto);
    if (temPedido == false) {
      await _context.read<ProdutoService>().deletar(idProduto);
      lista.removeWhere((element) => element.id == idProduto);

      listaFiltro = lista;
      emit(ProdutoState.completo());
    } else {
      emit(ProdutoState.falha(mensagem: "Esse produto não pode ser excluido, existe pedido feito com ele."));
    }
  }

  Future<void> carregarCategorias() async {
    categorias = await _context.read<CategoriaService>().carregarCategorias();

    categorias = categorias.where((element) => element.ativo == true).toList();

    categorias.add(CategoriaEntity(nome: "Todos"));

    categorias.sort((a, b) => a.id.compareTo(b.id));
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
    await carregarCategorias();
    emit(ProdutoListState.completo());
  }

  String? filtroTexto;
  int? filtroCategoriaID;
  Future<void> seachProdutos(String texto) async {
    emit(ProdutoListState.carregando());

    listaFiltro = lista
        .where((element) =>
            (element.nome!.toLowerCase().contains(texto.toLowerCase()) ||
                element.codigo != null && element.codigo!.toString().contains(texto.toLowerCase()) ||
                element.id.toString().contains(texto.toLowerCase())) &&
            filtroCategoriaID != null &&
            element.idCategoria! == filtroCategoriaID!)
        .toList();

    emit(ProdutoListState.completo());
  }

  Future<void> filtroCategoria(CategoriaEntity item) async {
    emit(ProdutoListState.carregando());
    if (item.id > 0) {
      listaFiltro = lista.where((element) => element.idCategoria == item.id).toList();
    } else {
      listaFiltro = lista;
    }

    emit(ProdutoListState.completo());
  }

  Future<String> nomeCategoria(int idCategoria) async {
    final categoria = await _context.read<CategoriaService>().lerCategoria(idCategoria);
    return categoria!.nome!;
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
      var filename = 'assets\\gestor_images\\${nome_Imagem}.png';

      final file = File(filename);
      await file.writeAsBytes(fileUint8List!);

      fileUint8List = null;
      // await FileSaver.instance.saveFile(name: nome_Imagem, file: file, ext: "png");

      emit(ProdutoCadastroState.completo());
    } catch (e) {
      emit(ProdutoCadastroState.falha(mensagem: 'Erro ao fazer upload da imagem'));
    }
  }

  Future<void> importarExcel() async {
    emit(ProdutoListState.carregando());
    const file = 'C:/GestorVendas/excel_importar/produtos_excel.xlsx';

    try {
      var bytes = File(file).readAsBytesSync();
      Excel excel = Excel.decodeBytes(bytes);

      List<ProdutoEntity> lista = [];
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          ProdutoEntity produtoEntity = ProdutoEntity();
          for (var cell in row) {
            if (cell!.rowIndex > 0) {
              final value = cell.value;
              if (value is TextCellValue) {
                if (cell.columnIndex == 0) {
                  produtoEntity.id = int.parse(value.value);
                }
                if (cell.columnIndex == 1) {
                  produtoEntity.nome = value.value;
                }
                if (cell.columnIndex == 2) {
                  produtoEntity.codigo = int.parse(value.value);
                }
                if (cell.columnIndex == 3) {
                  produtoEntity.idCategoria = int.parse(value.value);
                }
                if (cell.columnIndex == 4) {
                  produtoEntity.nomeCategoria = value.value;
                }
                if (cell.columnIndex == 5) {
                  produtoEntity.valorVenda = double.parse(value.value.toString());
                }
                if (cell.columnIndex == 6) {
                  produtoEntity.valorCusto = double.parse(value.value.toString());
                }
                if (cell.columnIndex == 7) {
                  produtoEntity.quantidadeEstoque = int.parse(value.value);
                }
                if (cell.columnIndex == 8) {
                  produtoEntity.descricao = value.value;
                }
                if (cell.columnIndex == 9) {
                  produtoEntity.unidadeMedida = int.parse(value.value);
                }
                if (cell.columnIndex == 10) {
                  produtoEntity.ativo = value.value == "true" ? true : false;
                }
                if (cell.columnIndex == 11) {
                  produtoEntity.imagem = value.value;
                }
              }
            }
          }

          lista.add(produtoEntity);
        }
      }

      if (lista.isNotEmpty) {
        lista.removeAt(0);
        List<ProdutoEntity> listaProdutosSave = [];
        List<CategoriaEntity> listaCategoria = [];
        List<String> listaCategoriaNome = [];

        listaCategoria = await _context.read<CategoriaService>().carregarCategorias();
        for (var i = 0; i < lista.length; i++) {
          if (!listaCategoriaNome.contains(lista[i].nomeCategoria)) {
            if (!listaCategoria.any((element) => element.nome == lista[i].nomeCategoria)) {
              listaCategoriaNome.add(lista[i].nomeCategoria!);
            }
          }
        }

        //Cadastro das categorias
        for (var i = 0; i < listaCategoriaNome.length; i++) {
          await _context.read<CategoriaService>().cadastrar(CategoriaEntity(nome: listaCategoriaNome[i], ativo: true));
        }

        listaProdutosSave = await _context.read<ProdutoService>().carregarProdutos();
        for (var i = 0; i < lista.length; i++) {
          if (listaProdutosSave.isNotEmpty && !listaProdutosSave.any((element) => element.id == lista[i].id)) {
            ProdutoEntity prod = lista[i];
            prod.idCategoria = listaCategoria.firstWhere((element) => element.nome! == prod.nomeCategoria!).id;
            prod.nomeCategoria = listaCategoria.firstWhere((element) => element.nome! == prod.nomeCategoria!).nome;
            // prod.imagem = "";
            // if (prod.imagem != null) {
            //   fileUint8List = base64.decode(prod.imagem!);
            //   if (fileUint8List != null) {
            //     String _nome_Imagem = DateTime.now().millisecondsSinceEpoch.toString();
            //     prod.imagem = _nome_Imagem;
            //     await adicionarImagem(_nome_Imagem);
            //   }
            // }

            await _context.read<ProdutoService>().cadastrar(prod);
          }
        }
      }

      await carregarProdutos();

      emit(ProdutoListState.sucesso(mensagem: "Planilha importada com sucesso!"));
    } catch (e) {
      emit(ProdutoListState.falha(mensagem: "Erro ao importar planilha, veja as instruções e tente novamente"));
    }
  }

  Future<void> exportarExcel() async {
    emit(ProdutoState.carregando());
    try {
      final xcel.Workbook workbook = xcel.Workbook();
      final xcel.Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByIndex(1, 1).setText("Id");
      sheet.getRangeByIndex(1, 2).setText("Nome");
      sheet.getRangeByIndex(1, 3).setText("Codigo");
      sheet.getRangeByIndex(1, 4).setText("Categoria ID");
      sheet.getRangeByIndex(1, 5).setText("Categoria Desc");
      sheet.getRangeByIndex(1, 6).setText("Valor");
      sheet.getRangeByIndex(1, 7).setText("Valor Custo");
      sheet.getRangeByIndex(1, 8).setText("Estoque");
      sheet.getRangeByIndex(1, 9).setText("Descricao");
      sheet.getRangeByIndex(1, 10).setText("Unidade");
      sheet.getRangeByIndex(1, 11).setText("Status");
      sheet.getRangeByIndex(1, 12).setText("Base64 Imagem");

      for (var i = 0; i < lista.length; i++) {
        final item = lista[i];
        String base64Image = "";
        // if (item.imagem != null) {
        //   var filename = 'assets\\gestor_images\\${item.imagem}.png';

        //   try {
        //     final List<int> bytesImagem = File(filename).readAsBytesSync();
        //     base64Image = base64Encode(bytesImagem);
        //   } catch (e) {
        //     base64Image = "";
        //   }
        // } else {
        //   base64Image = "";
        // }

        sheet.getRangeByIndex(i + 2, 1).setText(item.id.toString());
        sheet.getRangeByIndex(i + 2, 2).setText(item.nome.toString());
        sheet.getRangeByIndex(i + 2, 3).setText(item.codigo.toString());
        sheet.getRangeByIndex(i + 2, 4).setText(item.idCategoria.toString());
        sheet.getRangeByIndex(i + 2, 5).setText(item.nomeCategoria.toString());
        sheet.getRangeByIndex(i + 2, 6).setText(item.valorVenda.toString());
        sheet.getRangeByIndex(i + 2, 7).setText(item.valorCusto.toString());
        sheet.getRangeByIndex(i + 2, 8).setText(item.quantidadeEstoque.toString());
        sheet.getRangeByIndex(i + 2, 9).setText(item.descricao.toString());
        sheet.getRangeByIndex(i + 2, 10).setText(item.unidadeMedida.toString());
        sheet.getRangeByIndex(i + 2, 11).setText(item.ativo.toString());
        sheet.getRangeByIndex(i + 2, 12).setText(base64Image);
      }
      final List<int> bytes = workbook.saveAsStream();
      String _nome_excel = DateTime.now().millisecondsSinceEpoch.toString();
      File('C:/GestorVendas/excel_exportar/produtos_excel_${_nome_excel}.xlsx').writeAsBytes(bytes);
      workbook.dispose();

      emit(ProdutoState.sucesso(mensagem: "Planilha exportada com suceso: C:/GestorVendas/excel_exportar/produtos_excel_${_nome_excel}.xlsx"));
    } catch (e) {
      emit(ProdutoState.falha(mensagem: "Erro ao exportar a planilha, tente novamente"));
    }
  }
}
