import 'dart:io';

import 'package:crop_your_image/crop_your_image.dart' as windCrop;
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_vendas/produto/presentation/cubit/produto_state.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../categoria/domain/entities/categoria.dart';
import '../../categoria/presentation/categoria_page.dart';

import '../domain/entities/produto.dart';
import '../domain/enum/unidade_medida.dart';
import 'cubit/produto_cadastro_state.dart';
import 'cubit/produto_cubit.dart';

class ProdutoCadastroScreen extends StatefulWidget {
  @override
  _ProdutoCadastroPageState createState() => _ProdutoCadastroPageState();
}

class _ProdutoCadastroPageState extends State<ProdutoCadastroScreen> {
  late ProdutoCubit _cubit;
  final nome = TextEditingController();
  final descricao = TextEditingController();

  final codigo = TextEditingController();
  final quantidade_estoque = TextEditingController();
  bool status = true;

  int? unidadeMedidaSelecionado;

  final valorCustoFormatter = MoneyMaskedTextController(leftSymbol: 'R\$ ');

  final valorVendaFormatter = MoneyMaskedTextController(leftSymbol: 'R\$ ');

  int? categoriaIdSelected;
  String? categoriaDescSelected;
  bool? temObrigatorio = false;
  bool? temEscolha = false;
  bool? pontoCarne = false;
  String downloadedUrl = "";
  TextEditingController searchController = TextEditingController();
  XFile? xFile;

  var _isCropping = false;
  var _isSumbnail = false;

  final _controller = windCrop.CropController();
  Uint8List? imageUint8List;

  final GlobalKey<FormState> _formProdutoKey = GlobalKey<FormState>();
  CategoriaEntity? categoriaEntitySelect;

  @override
  void initState() {
    _cubit = BlocProvider.of<ProdutoCubit>(context);

    load_cadastro();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_cubit.categorias.isNotEmpty) {
      _cubit.categorias.removeWhere((element) => element.id == 0);
    }
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ProdutoCubit, ProdutoState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formProdutoKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_cubit.categorias.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_cubit.categorias.isEmpty)
                            Row(
                              children: [
                                Text('Categoria'),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriaPageScreen()));
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                          SizedBox(height: 15),
                          Text('Categoria do produto'),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 520,
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  hintText: "Selecione uma categoria",
                                  hintStyle: theme.textTheme.bodyText2!.copyWith(color: Colors.black)
                                  // fillColor: Colors.grey[300],
                                  ),
                              dropdownColor: Colors.white,
                              value: categoriaIdSelected,
                              items: _cubit.categorias.map((CategoriaEntity e) {
                                return DropdownMenuItem<int>(value: e.id, child: Text(e.nome!));
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  categoriaIdSelected = newValue;
                                  categoriaDescSelected = _cubit.categorias.firstWhere((element) => element.id == categoriaIdSelected!).nome;
                                  categoriaEntitySelect = _cubit.categorias.firstWhere((element) => element.id == categoriaIdSelected!);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 15),
                    Text('Nome do produto'),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: nome,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (nome.text.isEmpty) {
                          return 'O campo nome é obrigatório';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Descrição do produto'),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: descricao,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      maxLength: 300,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 520,
                      child: DropdownButtonFormField<int?>(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromARGB(255, 147, 145, 145), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            hintText: "Selecione a unidade de medida",
                            hintStyle: theme.textTheme.bodyText2!.copyWith(color: Colors.black)
                            // fillColor: Colors.grey[300],
                            ),
                        dropdownColor: Colors.white,
                        value: unidadeMedidaSelecionado,
                        items: _cubit.listaUnidadeMedida.map((UnidadeMedida e) {
                          return DropdownMenuItem<int?>(value: e.id, child: Text(e.nome!));
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            unidadeMedidaSelecionado = newValue!;
                            // categoriaDescSelected = _cubit.categorias.firstWhere((element) => element.id == categoriaSelected!).nome;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Valor da Venda'),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: valorVendaFormatter,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (valorVendaFormatter.text.isEmpty) {
                                    return 'O campo valor da venda é obrigatório';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  //prefixText: _currency,
                                  prefixStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        SizedBox(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Valor de Custo'),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: valorCustoFormatter,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  // prefixText: _currency,
                                  prefixStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Codigo do Produto'),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: codigo,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value!.isEmpty) return 'Campo obrigatório';

                                  return null;
                                },
                              ),
                              SizedBox(height: 5),
                              Text(
                                '*(Se não utiliza o codigo, deixe o valor 0)',
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        SizedBox(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantidade em Estoque'),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: quantidade_estoque,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value!.isEmpty) return 'Campo obrigatório';
                                  // if (num.parse(value) < 0) return 'Informe um valor igual ou maior que 0.';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: 520,
                      child: CheckboxListTile(
                        checkColor: Colors.white,
                        activeColor: Colors.blue,
                        title: Text('Ativar produto?'),
                        subtitle: Text('Ao ativar, ele estará disponível para pedido'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: status,
                        onChanged: (value) {
                          _cubit.produtoEntity.ativo = value;
                          setState(() {
                            status = value!;
                          });
                        },
                      ),
                    ),
                    // SizedBox(height: 15),
                    // const SizedBox(height: 5),
                    // Container(
                    //   width: 220,
                    //   decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey[100]!), borderRadius: BorderRadius.circular(5)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(5),
                    //     child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    //       if (_cubit.fileUint8List != null || _cubit.produtoEntity.imagem != null)
                    //         Container(
                    //           alignment: Alignment.center,
                    //           width: double.infinity,
                    //           height: 100,
                    //           child: _cubit.produtoEntity.imagem != null ? readImage(_cubit.produtoEntity.imagem) : Image.memory(_cubit.fileUint8List!),
                    //         ),
                    //       if (_cubit.fileUint8List == null && _cubit.produtoEntity.imagem == null)
                    //         Container(
                    //           decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.blue)),
                    //           child: TextButton(
                    //             child: Text(
                    //               'Selecione uma imagem',
                    //               style: TextStyle(color: Colors.blue),
                    //             ),
                    //             onPressed: () async {
                    //               xFile = null;
                    //               imageUint8List = null;
                    //               await _pickImage();
                    //             },
                    //           ),
                    //         ),
                    //       SizedBox(height: 15),
                    //       if (_cubit.fileUint8List != null || _cubit.produtoEntity.imagem != null)
                    //         TextButton.icon(
                    //           // style: ElevatedButton.styleFrom(
                    //           //   backgroundColor: Colors.red,
                    //           // ),
                    //           label: Text(
                    //             'remover',
                    //             style: theme.textTheme.bodyText2!.copyWith(color: Colors.red),
                    //           ),
                    //           icon: Icon(Icons.delete, color: Colors.red),
                    //           onPressed: () async {
                    //             if (_cubit.fileUint8List != null) {
                    //               _cubit.fileUint8List = null;
                    //             } else {
                    //               _cubit.isRemoverImagem = true;
                    //             }

                    //             setState(() {
                    //               _cubit.fileUint8List = null;

                    //               _cubit.produtoEntity.imagem = null;
                    //             });
                    //           },
                    //         ),
                    //     ]),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () {
                        clear_cadastro();
                        _cubit.list();
                      },
                      child: Text('Voltar'),
                    ),
                  ),
                  SizedBox(width: 50),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: _formProdutoKey.currentState == null || !_formProdutoKey.currentState!.validate() || categoriaIdSelected == null
                            ? null
                            : () {
                                _cubit.produtoEntity.nome = nome.text;
                                _cubit.produtoEntity.descricao = descricao.text;
                                _cubit.produtoEntity.valorVenda = valorVendaFormatter.numberValue;
                                _cubit.produtoEntity.valorCusto = valorCustoFormatter.numberValue;
                                _cubit.produtoEntity.codigo = codigo.text.isNotEmpty ? int.parse(codigo.text) : 0;
                                _cubit.produtoEntity.quantidadeEstoque = quantidade_estoque.text.isNotEmpty ? int.parse(quantidade_estoque.text) : null;

                                _cubit.produtoEntity.unidadeMedida = unidadeMedidaSelecionado;

                                _cubit.produtoEntity.categoria.targetId = categoriaIdSelected;
                                _cubit.produtoEntity.idCategoria = categoriaIdSelected;
                                _cubit.produtoEntity.ativo = status;
                                if (_cubit.id != null) {
                                  _cubit.editar();
                                } else {
                                  _cubit.cadastrar();
                                }

                                // clear_cadastro();
                              },
                        child: Text('Salvar')),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void load_cadastro() {
    if (_cubit.produtoEntity.id != null && _cubit.produtoEntity.id > 0) {
      nome.text = _cubit.produtoEntity.nome!;
      valorVendaFormatter.updateValue(_cubit.produtoEntity.valorVenda);
      valorCustoFormatter.updateValue(_cubit.produtoEntity.valorCusto);
      codigo.text = _cubit.produtoEntity.codigo == null ? '0' : _cubit.produtoEntity.codigo.toString();
      quantidade_estoque.text = _cubit.produtoEntity.quantidadeEstoque != null ? _cubit.produtoEntity.quantidadeEstoque.toString() : '0';
      categoriaIdSelected = _cubit.produtoEntity.idCategoria;
      descricao.text = _cubit.produtoEntity.descricao!;
      status = _cubit.produtoEntity.ativo!;

      unidadeMedidaSelecionado = _cubit.produtoEntity.unidadeMedida;

      _cubit.produtoEntity.ativo = _cubit.produtoEntity.ativo!;
      _cubit.id = _cubit.produtoEntity.id;

      // Future.delayed(Duration(milliseconds: 500));
    } else {
      clear_cadastro();
    }
  }

  void clear_cadastro() {
    nome.text = '';
    valorVendaFormatter.updateValue(000);
    valorCustoFormatter.updateValue(000);
    codigo.text = '0';
    quantidade_estoque.text = '0';
    downloadedUrl = '';
    categoriaIdSelected = null;
    descricao.text = '';
    status = true;
    _cubit.id = null;
    _cubit.downloadedUrl = '';

    _cubit.fileUint8List = null;
    _cubit.produtoEntity = ProdutoEntity();
    _cubit.produtoEntity.ativo = true;

    temObrigatorio = false;
    temEscolha = false;
    pontoCarne = false;
    categoriaDescSelected = null;
    unidadeMedidaSelecionado = null;
    setState(() {});

    //_cubit.produtoEntity.enumUnidadeMedida = EnumUnidadeMedida.massa;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1200, maxHeight: 900);

    if (pickedFile != null) {
      xFile = pickedFile;
      setState(() {});
    }
    if (xFile != null && !Platform.isWindows && !Platform.isMacOS) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: xFile!.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 90,
        uiSettings: [
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 720,
              height: 420,
            ),
            viewPort: const CroppieViewPort(width: 600, height: 300, type: 'square'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
            enforceBoundary: false,
          ),
        ],
      );
      if (croppedFile != null) {
        _cubit.fileUint8List = await croppedFile.readAsBytes();

        setState(() {});
      }
    } else if (xFile != null && (Platform.isWindows || Platform.isMacOS)) {
      Uint8List bytes = await xFile!.readAsBytes();

      imageUint8List = bytes.buffer.asUint8List();

      setState(() {});

      await _showCropImagem(Theme.of(context));
    }
  }

  Future<void> _showCropImagem(ThemeData theme) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Crop da imagem',
              style: theme.textTheme.bodyText1,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                    width: 800,
                    height: 300,
                    child:
                        // windCrop.Crop(

                        //   willUpdateScale: (newScale) => newScale < 5,
                        //   controller: _controller,
                        //   image: imageUint8List!,
                        //   onCropped: (croppedData) {
                        //     _cubit.fileUint8List = croppedData;
                        //     setState(() {
                        //       _isCropping = false;
                        //     });
                        //   },
                        //   aspectRatio: 4 / 3,
                        //   maskColor: _isSumbnail ? Colors.white : null,
                        //   cornerDotBuilder: (size, edgeAlignment) => const SizedBox.shrink(),
                        //   fixCropRect: true,
                        //   interactive: true,
                        //   radius: 20,
                        // ),
                        Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: windCrop.Crop(
                            willUpdateScale: (newScale) => newScale < 5,
                            controller: _controller,
                            image: imageUint8List!,
                            onCropped: (croppedData) {
                              _cubit.fileUint8List = croppedData;
                              setState(() {
                                _isCropping = false;
                              });
                            },
                            aspectRatio: 4 / 3,
                            maskColor: _isSumbnail ? Colors.white : null,
                            cornerDotBuilder: (size, edgeAlignment) => const SizedBox.shrink(),
                            fixCropRect: true,
                            interactive: true,
                            radius: 20,
                          ),
                        ),
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: GestureDetector(
                            onTapDown: (_) => myState(() => _isSumbnail = true),
                            onTapUp: (_) => myState(() => _isSumbnail = false),
                            child: CircleAvatar(
                              backgroundColor: _isSumbnail ? Colors.blue.shade50 : Colors.blue,
                              child: Center(
                                child: Icon(Icons.crop_free_rounded),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: Text(
                  'Voltar',
                  style: theme.textTheme.bodyText1!.copyWith(color: const Color.fromARGB(255, 42, 117, 179)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                child: Text(
                  'Salvar',
                  style: theme.textTheme.bodyText1!.copyWith(color: Colors.white),
                ),
                onPressed: () {
                  myState(() {
                    _isCropping = true;
                  });
                  _controller.crop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget readImage(String? imagem) {
    var filename = 'assets/gestor_images/${imagem}.png';

    return Image.asset(filename);
  }
}
