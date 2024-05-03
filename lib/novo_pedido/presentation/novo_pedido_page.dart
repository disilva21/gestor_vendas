import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/capability_profile.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/enums.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/generator.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_column.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_styles.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_pos_printer_platform/printer.dart';
import 'package:gbk_codec/gbk_codec.dart';

import 'package:gestor_pdv/components/modal_progress.dart';
import 'package:gestor_pdv/configuracao/domain/entities/cliente.dart';
import 'package:gestor_pdv/configuracao/presentation/impressora.dart';
import 'package:gestor_pdv/novo_pedido/domain/entities/cliente.dart';
import 'package:gestor_pdv/novo_pedido/domain/entities/forma_pagamento.dart';
import 'package:gestor_pdv/novo_pedido/domain/entities/pedido.dart';
import 'package:gestor_pdv/novo_pedido/presentation/cubit/novo_pedido_cubit.dart';
import 'package:gestor_pdv/novo_pedido/presentation/cubit/novo_pedido_state.dart';
import 'package:gestor_pdv/produto/domain/entities/produto.dart';
import 'package:gestor_pdv/util/remove_acentos.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/validar_celular.dart';
import '../../categoria/presentation/cubit/categoria_cubit.dart';
import '../../produto/domain/enum/unidade_medida.dart';
import '../../widget/header_widget.dart';
import '../../widget/side_bar.dart';

class NovoPedidoScreen extends StatefulWidget {
  @override
  _NovoPedidoScreenState createState() => _NovoPedidoScreenState();
}

class _NovoPedidoScreenState extends State<NovoPedidoScreen> with SingleTickerProviderStateMixin {
  late NovoPedidoCubit _cubit;

  final nome = TextEditingController();
  bool status = true;
  bool addSabores = false;
  int? qtdSelecionado = 1;
  FormaPagamento? pagamentoSelected;
  String? pagamentoDescSelected;

  late AnimationController controller;

  final maskCelular = MaskTextInputFormatter(mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')});
  TextEditingController searchController = TextEditingController();

  final observacao = TextEditingController();

  final quantidadeQuilo = TextEditingController(text: '1');
  bool? selecionarPontoCarne = false;
  int? quantidadeSelected = 1;
  bool vendaPorKiloValido = false;
  final valorTrocoFormatter = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final valorDescontoFormatter = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final valorTaxaFormatter = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final nomeCompleto = TextEditingController();
  final celular = TextEditingController();

  final cep = TextEditingController();
  final logradouro = TextEditingController();
  final complemento = TextEditingController();
  final numero = TextEditingController();
  final bairro = TextEditingController();
  final cidade = TextEditingController();
  final uf = TextEditingController();
  late int quantidadeItem = 1;
  late num valorTotalItem = 0;
  late num valorTotalItemKilo = 0;

  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  var _reconnect = false;

  @override
  void initState() {
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 1);
    _cubit = NovoPedidoCubit(context);
    _cubit.carregarProdutos();

    _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
      // log(' ----------------- status usb $status ------------------ ');
      _currentUsbStatus = status;
      if (Platform.isAndroid) {
        if (status == USBStatus.connected && pendingTask != null) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance.send(type: PrinterType.usb, bytes: pendingTask!);
            pendingTask = null;
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  BluetoothPrinter? selectedPrinter;
  var printerManager = PrinterManager.instance;
  List<int>? pendingTask;
  BTStatus _currentStatus = BTStatus.none;
  USBStatus _currentUsbStatus = USBStatus.none;
  String? nomeImpressora;
  Codec? codec;
  Uint8List encode(String text, {bool isKanji = false}) {
    // replace some non-ascii characters
    text = text.replaceAll("’", "'").replaceAll("´", "'").replaceAll("»", '"').replaceAll(" ", ' ').replaceAll("•", '.');
    if (!isKanji) {
      return codec!.encode(text);
    } else {
      return Uint8List.fromList(gbk_bytes.encode(text));
    }
  }

  void _scan() async {
    devices.clear();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nomeImpressora = await prefs.getString('selectedPrinter');

    _subscription = printerManager.discovery(type: defaultPrinterType, isBle: _isBle).listen((device) {
      final _device = BluetoothPrinter(deviceName: device.name, address: device.address, isBle: _isBle, vendorId: device.vendorId, productId: device.productId, typePrinter: defaultPrinterType);
      devices.add(_device);
      if (nomeImpressora!.isNotEmpty && device.name == nomeImpressora) {
        selectedPrinter = _device;
      }
      setState(() {});
    });
  }

  Future _printReceiveTest(ThemeData theme, Pedido pedido) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final paperSizeShared = await prefs.getInt('paperSize');
    PaperSize paperSize = PaperSize.mm80;

    switch (paperSizeShared) {
      case 58:
        paperSize = PaperSize.mm58;
        break;
      // case 72:
      //   paperSize = PaperSize.mm72;
      //   break;
      case 80:
        paperSize = PaperSize.mm80;
        break;
      default:
        paperSize = PaperSize.mm80;
    }

    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);

    List<int> bytes = [];
    Empresa empresa = Empresa(
      nomeEmpresa: "Nome da empresa",
    );

    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy H:m');
    final String timestamp = formatter.format(now);

    bytes += generator.text(empresa.nomeEmpresa.toString().withoutDiacriticalMarks, styles: const PosStyles(align: PosAlign.center));

    bytes += generator.row([
      PosColumn(width: 6, text: 'Pedido', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 6, text: pedido.id.toString(), styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);
    bytes += generator.row([
      PosColumn(width: 3, text: 'Data', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 9, text: timestamp, styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1)),
    ]);
    bytes += generator.feed(1);

    bytes += generator.hr();

    bytes += generator.text('Itens:', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1));

    List<PosColumn>? colsItens;

    for (var i = 0; i < pedido.itens!.length; i++) {
      colsItens = [];
      // colsItens.add(PosColumn(
      //     width: 2,
      //     text:
      //         '${pedido.itens![i].unidadeMedida!.id == EnumUnidadeMedida.massa.index ? (pedido.produtos![i].quantidadePeso! * pedido.produtos![i].quantidadeItem!) * 1000 : pedido.produtos![i].quantidadeItem}',
      //     styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)));

      colsItens.add(PosColumn(width: 10, text: "pedido.itens![i].nome!".withoutDiacriticalMarks, styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)));
      bytes += generator.row(colsItens);

      // if (pedido.itens![i].adicionais != null && pedido.produtos![i].adicionais!.length > 0) {
      //   for (var y = 0; y < pedido.produtos![i].adicionais!.length; y++) {
      //     bytes += generator.text('(+ ad) - ${pedido.produtos![i].adicionais![y].nome!.withoutDiacriticalMarks} ', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1));
      //   }
      // }

      // if (pedido.produtos![i].categoriaAcompanhamentos != null && pedido.produtos![i].categoriaAcompanhamentos!.length > 0) {
      //   for (var y = 0; y < pedido.produtos![i].categoriaAcompanhamentos!.length; y++) {
      //     for (var a = 0; a < pedido.produtos![i].categoriaAcompanhamentos![y].acompanhamentos!.length; a++) {
      //       bytes += generator.text('(+ acomp) - ${pedido.produtos![i].categoriaAcompanhamentos![y].acompanhamentos![a].nome!.withoutDiacriticalMarks} ',
      //           styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1));
      //     }
      //   }
      // }

      // if (pedido.produtos![i].sabores != null && pedido.produtos![i].sabores!.length > 0) {
      //   for (var y = 0; y < pedido.produtos![i].sabores!.length; y++) {
      //     bytes += generator.text('- ${pedido.produtos![i].sabores![y].withoutDiacriticalMarks} ', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1));
      //   }
      // }

      //  if (pedido.produtos![i].observacao != null && pedido.produtos![i].observacao != '') {
      bytes += generator.text('Obs: ${"pedido.produtos![i].observacao!".withoutDiacriticalMarks}', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1));
      //}

      // bytes += generator.text(NumberFormat.simpleCurrency(decimalDigits: 2).format(pedido.produtos![i].valorVenda!),
      //     styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1), linesAfter: 1);
    }

    bytes += generator.hr();

    bytes += generator.text('Cliente:', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1));

    bytes += generator.text(
      "pedido.usuarioCardapioEntity!.nome!".withoutDiacriticalMarks,
      styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1, bold: true),
    );

    bytes += generator.row([
      PosColumn(width: 4, text: 'Telefone', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 8, text: "pedido.usuarioCardapioEntity!.celular!", styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(width: 6, text: 'Tipo entrega: ', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 6, text: "descricaoTipoEntrega(pedido.tipoEntrega!)".withoutDiacriticalMarks, styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);

    bytes += generator.hr();

    bytes += generator.text('Pagamento:', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1));

    bytes += generator.row([
      PosColumn(width: 5, text: 'Tipo', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 7, text: "descricaoFormaPagamento(pedido)".withoutDiacriticalMarks, styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(width: 5, text: 'Taxa entrega', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      // PosColumn(width: 7, text: NumberFormat.simpleCurrency(decimalDigits: 2).format(pedido.taxaEntrega!), styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(width: 5, text: 'Total', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      // PosColumn(
      //     width: 7,
      //     text: NumberFormat.simpleCurrency(decimalDigits: 2).format(pedido.total! + pedido.taxaEntrega!).toString(),
      //     styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.feed(1);
    bytes += generator.text('Obrigado por usar Menu Mania', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1));
    generator.cut();
    await _printEscPos(bytes, generator);
  }

  var devices = <BluetoothPrinter>[];
  StreamSubscription<PrinterDevice>? _subscription;
  var defaultPrinterType = PrinterType.usb;
  var _isBle = false;

  _printEscPos(List<int> bytes, Generator generator) async {
    devices.clear();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nomeImpressora = await prefs.getString('selectedPrinter');

    _subscription = printerManager.discovery(type: defaultPrinterType, isBle: _isBle).listen((device) {
      if (device.name == nomeImpressora)
        devices.add(BluetoothPrinter(
          deviceName: device.name,
          address: device.address,
          isBle: _isBle,
          vendorId: device.vendorId,
          productId: device.productId,
          typePrinter: defaultPrinterType,
        ));

      selectedPrinter = devices[0];
      setState(() {});
    });
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter, model: UsbPrinterInput(name: bluetoothPrinter.deviceName, productId: bluetoothPrinter.productId, vendorId: bluetoothPrinter.vendorId));
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: BluetoothPrinterInput(name: bluetoothPrinter.deviceName, address: bluetoothPrinter.address!, isBle: bluetoothPrinter.isBle ?? false, autoConnect: _reconnect));
        pendingTask = null;
        if (Platform.isIOS || Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(type: bluetoothPrinter.typePrinter, model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else if (bluetoothPrinter.typePrinter == PrinterType.usb && Platform.isAndroid) {
      // _currentUsbStatus is only supports on Android
      if (_currentUsbStatus == USBStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<NovoPedidoCubit, NovoPedidoState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.primaryColor,
            body: Column(
              children: [
                HeaderWidget(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SideBar(),
                      Flexible(
                          flex: 4,
                          child: BlocConsumer<NovoPedidoCubit, NovoPedidoState>(
                            listener: (context, state) {
                              if (state.sucesso == true) {
                                BotToast.showText(onlyOne: true, text: state.mensagem!, duration: Duration(seconds: 5));
                                Future.delayed(const Duration(milliseconds: 900)).then((value) {
                                  Navigator.pop(context);
                                });
                              }

                              if (state.falha == true) {
                                BotToast.showText(onlyOne: true, text: state.mensagem!, contentColor: Color.fromARGB(255, 29, 63, 189), duration: Duration(seconds: 5));
                              }
                            },
                            builder: (context, state) {
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Novo Pedido',
                                                style: theme.textTheme.bodyText1,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                '(Faça pedido e mantenha a gestão em um único lugar)',
                                                style: theme.textTheme.bodyText2,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Card(
                                                  child: Column(
                                                    children: [
                                                      cardTitulo(theme, 'Cliente'),
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(12.0),
                                                            child: TextFormField(
                                                              onChanged: (value) {
                                                                if (searchController.text.length == 15) {
                                                                  _cubit.searchCliente(searchController.text);
                                                                }
                                                              },
                                                              controller: searchController,
                                                              inputFormatters: [maskCelular],
                                                              validator: (value) => !ValidarCelular.validarNumeroCelular(value!) ? 'Infome um número válido de celular' : null,
                                                              decoration: InputDecoration(
                                                                labelText: "Informe o telefone",
                                                                labelStyle: TextStyle(color: Colors.blue),
                                                                prefixIcon: Icon(Icons.search, color: Colors.blue),
                                                                suffixIcon: IconButton(
                                                                  icon: Icon(Icons.close),
                                                                  onPressed: () {
                                                                    // _cubit.closeSearchCategorias();
                                                                    searchController.text = '';
                                                                    _cubit.valorDistancia = null;
                                                                    setState(() {});
                                                                  },
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.blue),
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(5.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          //  if (searchController.text.length == 15)

                                                          if (_cubit.cliente != null)
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Nome:',
                                                                    style: theme.textTheme.headlineMedium!.copyWith(fontSize: 14),
                                                                  ),
                                                                  Text(
                                                                    _cubit.cliente!.nome!,
                                                                    style: theme.textTheme.labelMedium!.copyWith(fontSize: 14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                          if (_cubit.cliente == null && searchController.text.length == 15)
                                                            Padding(
                                                              padding: const EdgeInsets.all(12.0),
                                                              child: ElevatedButton(
                                                                  onPressed: () async {
                                                                    await showCadastroClienteCardapio(theme, searchController.text);
                                                                  },
                                                                  child: Text('Adicionar cliente')),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  child: Column(
                                                    children: [
                                                      cardTitulo(theme, 'Item do pedido'),
                                                      Column(
                                                        children: [
                                                          if (_cubit.pedido.itens == null || _cubit.pedido.itens!.isEmpty)
                                                            Center(
                                                                child: Padding(
                                                              padding: const EdgeInsets.all(12.0),
                                                              child: Text('Nenhum produto adicionado, selecione ao lado >>>'),
                                                            )),
                                                          if (_cubit.pedido.itens != null)
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: _cubit.pedido.itens!.map((item) {
                                                                  final index = _cubit.pedido.itens!.indexOf(item);
                                                                  return Container(
                                                                    padding: EdgeInsets.all(5),
                                                                    margin: EdgeInsets.only(bottom: 5),
                                                                    color: Colors.grey[100],
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  item.quantidade.toString(),
                                                                                  style: theme.textTheme.bodyText2!.copyWith(fontSize: 12),
                                                                                ),
                                                                                SizedBox(width: 3),
                                                                                Text(
                                                                                  item.nomeProduto!,
                                                                                  style: theme.textTheme.labelMedium!.copyWith(fontSize: 12),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  NumberFormat.simpleCurrency(locale: 'pt_BR').format(item.valorVenda),
                                                                                  style: theme.textTheme.bodyText1!.copyWith(color: Colors.black, fontSize: 12),
                                                                                ),
                                                                                IconButton(
                                                                                    highlightColor: Colors.transparent,
                                                                                    hoverColor: Colors.transparent,
                                                                                    onPressed: () {
                                                                                      _cubit.pedido.itens!.removeAt(index);
                                                                                      _cubit.pedido.total = _cubit.pedido.total - item.valorVenda!;
                                                                                      //   totalKilo > 0 ? (_cubit.pedido.total! - totalKilo) : _cubit.pedido.total! - item.valorVenda!;
                                                                                      setState(() {});
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.delete,
                                                                                      size: 20,
                                                                                      color: Colors.red,
                                                                                    ))
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  child: Column(
                                                    children: [
                                                      cardTitulo(theme, 'Pagamento'),
                                                      Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: Column(
                                                          children: [
                                                            DropdownButtonFormField<FormaPagamento>(
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
                                                                  hintText: "Selecione a forma de pagamento",
                                                                  hintStyle: theme.textTheme.bodyText2!.copyWith(color: Colors.black)
                                                                  // fillColor: Colors.grey[300],
                                                                  ),
                                                              dropdownColor: Colors.white,
                                                              value: pagamentoSelected,
                                                              items: _cubit.formaPagamentos.map((FormaPagamento e) {
                                                                return DropdownMenuItem<FormaPagamento>(value: e, child: Text(e.nome!));
                                                              }).toList(),
                                                              onChanged: (FormaPagamento? newValue) {
                                                                setState(() {
                                                                  pagamentoSelected = newValue;
                                                                  pagamentoDescSelected = newValue!.nome; //_cubit.formaPagamentos.firstWhere((element) => element.id == pagamentoSelected!).nome;

                                                                  _cubit.pedido.formaPagamento = newValue;
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(height: 5),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // Row(
                                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  //   children: [
                                                                  //     Text(
                                                                  //       'Sub-total:',
                                                                  //       style: theme.textTheme.headlineMedium!.copyWith(fontSize: 12),
                                                                  //     ),
                                                                  //     Text(
                                                                  //       NumberFormat.simpleCurrency(locale: 'pt_BR').format(_cubit.pedido.total),
                                                                  //       style: theme.textTheme.labelMedium!.copyWith(fontSize: 14),
                                                                  //     ),
                                                                  //   ],
                                                                  // ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Total:',
                                                                        style: theme.textTheme.headlineMedium!.copyWith(fontSize: 14),
                                                                      ),
                                                                      Text(
                                                                        NumberFormat.simpleCurrency(locale: 'pt_BR').format(_cubit.pedido.total),
                                                                        style: theme.textTheme.labelMedium!.copyWith(fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: ElevatedButton(
                                                        onPressed: // (_cubit.pedido.produtos == null || _cubit.pedido.produtos!.isEmpty) || _cubit.pedido.formaPagamento == null
                                                            //  ? null
                                                            // :
                                                            () {
                                                          _cubit.enviarPedido();
                                                        },
                                                        child: Text('Enviar Pedido')),
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      _printReceiveTest(theme, Pedido());
                                                      // await _showPrintCupomFiscal(theme, UsuarioDto(), pedidoNovo);
                                                    },
                                                    icon: Icon(Icons.print_outlined)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: double.infinity,
                                                  child: ListView(
                                                    scrollDirection: Axis.horizontal,
                                                    children: _cubit.categoriasProduto.map((cat) {
                                                      return Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: SizedBox(
                                                          child: ElevatedButton(
                                                            child: Text(cat.nome!),
                                                            onPressed: () {
                                                              for (var i = 0; i < _cubit.categoriasProduto.length; i++) {
                                                                _cubit.categoriasProduto[i].selecionado = false;
                                                              }
                                                              cat.selecionado = true;

                                                              _cubit.filtroCategoria(cat);
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  height: 640,
                                                  child: ListView.builder(
                                                    itemCount: _cubit.produtosFiltro.length,
                                                    itemBuilder: (context, index) {
                                                      String _imgUrl = '';

                                                      ProdutoEntity prod = _cubit.produtosFiltro[index];

                                                      return Card(
                                                        color: Colors.white,
                                                        child: ListTile(
                                                          onTap: () async {
                                                            observacao.text = '';

                                                            quantidadeItem = 1;
                                                            await _cubit.loadDetalhe(prod);
                                                            _showProduto(theme, prod.id, _imgUrl);
                                                          },
                                                          leading: SizedBox(
                                                            height: 90,
                                                            child: ModalLoading(
                                                              isLoading: _cubit.state.carregandoImagem!,
                                                              child: Builder(builder: (context) {
                                                                if (prod.imagem != null) {
                                                                  return readImage(prod.imagem);
                                                                } else {
                                                                  return const Icon(Icons.image_search, size: 60);
                                                                }
                                                              }),
                                                            ),
                                                          ),
                                                          title: Row(
                                                            children: [
                                                              Text(
                                                                prod.codigo != null ? prod.codigo.toString() : '00000',
                                                                style: theme.textTheme.bodySmall,
                                                              ),
                                                              const Text(' - '),
                                                              Text(
                                                                prod.nome.toString(),
                                                                style: theme.textTheme.bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                          subtitle: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                                            child: Text(
                                                              prod.descricao.toString(),
                                                              style: theme.textTheme.bodySmall!.copyWith(fontSize: 11),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          trailing: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                            child: Text(
                                                              NumberFormat.simpleCurrency(locale: 'pt_BR').format(prod.valorVenda),
                                                              style: theme.textTheme.bodySmall,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
            //),
          );
        },
      ),
    );
  }

  Widget readImage(String? imagem) {
    var filename = '${_cubit.diretorio}/GPDVProd${imagem}.png';

    return Image.asset(
      filename,
      fit: BoxFit.fitWidth,
    );
  }

  Row cardTitulo(ThemeData theme, String titulo) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Color.fromARGB(255, 164, 190, 211),
            child: Text(
              titulo,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showProduto(ThemeData theme, int id, String img) async {
    final prod = _cubit.prodDetalhe;
    valorTotalItem = prod.valorVenda!;

    valorTotalItemKilo = prod.valorVenda!;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
                child: Container(
              width: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Image.network(
                            //  img, fit: BoxFit.fill,
                            // ),

                            Text(
                              prod.nome!,
                              style: theme.textTheme.headline4,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  Text(
                                    NumberFormat.simpleCurrency(locale: 'pt_BR').format(prod.valorVenda),
                                    style: theme.textTheme.headline4,
                                  ),
                                  Text(
                                    prod.unidadeMedida!.id == EnumUnidadeMedida.massa.index ? '(kg)' : '',
                                    style: theme.textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          prod.descricao ?? '',
                          style: theme.textTheme.bodyText2!.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Observações',
                          style: theme.textTheme.bodyText2!.copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          key: const Key('observacaoKey'),
                          controller: observacao,
                          maxLength: 200,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(counterText: ''),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            actions: <Widget>[
              SizedBox(
                width: 200,
                child: TextButton(
                  child: Text(
                    'Voltar',
                    style: theme.textTheme.bodyText1!.copyWith(color: const Color.fromARGB(255, 42, 117, 179)),
                  ),
                  onPressed: () {
                    myState(() {});
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 230,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          child: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.grey,
                          ),
                          onPressed: quantidadeItem == 1
                              ? null
                              : () {
                                  quantidadeItem = quantidadeItem - 1;

                                  if (vendaPorKiloValido) {
                                    valorTotalItem = valorTotalItem - valorTotalItemKilo;
                                    if (_cubit.valorProdutoAdicional! > 0) {
                                      valorTotalItem = valorTotalItem - _cubit.valorProdutoAdicional!;
                                    }
                                  } else {
                                    if (_cubit.produtosMaisSabores.length > 0) {
                                      valorTotalItem = valorTotalItem - double.parse(_cubit.valorMaiorSabores.toString());
                                    } else {
                                      valorTotalItem = valorTotalItem - prod.valorVenda!;
                                    }
                                  }

                                  myState(() {});
                                },
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 35,
                          height: 27,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            width: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              quantidadeItem.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          child: Icon(
                            Icons.add_circle_outline,
                            color: Colors.grey,
                          ),
                          onPressed: quantidadeItem >= 20
                              ? null
                              : () {
                                  _cubit.addItemPedido(prod, 1);
                                  quantidadeItem = quantidadeItem + 1;

                                  if (vendaPorKiloValido) {
                                    valorTotalItem = valorTotalItemKilo * quantidadeItem;
                                    if (_cubit.valorProdutoAdicional! > 0) {
                                      valorTotalItem = valorTotalItem + _cubit.valorProdutoAdicional! * quantidadeItem;
                                    }
                                  } else {
                                    if (_cubit.produtosMaisSabores.length > 0) {
                                      valorTotalItem = double.parse(_cubit.valorMaiorSabores.toString()) + valorTotalItem;
                                    } else {
                                      valorTotalItem = prod.valorVenda! + valorTotalItem;
                                    }
                                  }

                                  myState(() {});
                                },

                          // Navigator.f(context).pop();
                          //},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 230,
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.simpleCurrency(locale: 'pt_BR').format(valorTotalItem),
                        style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Adicionar',
                        style: theme.textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    prod.observacao = observacao.text;
                    // prod.quantidadePeso = double.parse(quantidadeQuilo.text.replaceAll(',', '.'));
                    prod.quantidadeItem = quantidadeItem;
                    prod.valorVenda = double.parse(valorTotalItem.toString());
                    _cubit.addProdutosPedido(prod);
                    _cubit.pedido.total = _cubit.pedido.total + prod.valorVenda!;
                    // _cubit.pedido.total = _cubit.pedido.total + valorTotalItem;
                    // prod.valorVenda = totalKilo > 0 ? double.parse(totalKilo.toString()) : prod.valorVenda!;

                    quantidadeItem = 1;
                    valorTotalItem = 0;
                    quantidadeQuilo.text = '1';

                    Navigator.of(context).pop();
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> showCadastroClienteCardapio(ThemeData theme, String _celular) async {
    celular.text = _celular;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        key: const Key('celularKey'),
                        controller: celular,
                        maxLength: 80,
                        //  enabled: false,
                        readOnly: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            counterText: '',
                            labelText: 'Celular'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        key: const Key('nomKey'),
                        controller: nomeCompleto,
                        maxLength: 80,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            counterText: '',
                            labelText: 'Nome completo'),
                        validator: (value) => value == null || value.isEmpty || value.length < 2 ? '' : null,
                        onChanged: (value) {
                          myState(() {});
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            )),
            actions: <Widget>[
              SizedBox(
                width: 200,
                child: TextButton(
                  child: Text(
                    'Voltar',
                    style: theme.textTheme.bodyText1!.copyWith(color: const Color.fromARGB(255, 42, 117, 179)),
                  ),
                  onPressed: () {
                    myState(() {});
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  child: Text(
                    'Salvar',
                    style: theme.textTheme.bodyText1!.copyWith(color: Colors.white),
                  ),
                  onPressed: (nomeCompleto.text.isEmpty || nomeCompleto.text.length <= 2 || _celular == '')
                      ? null
                      : () async {
                          _cubit.cliente ??= Cliente();

                          _cubit.cliente!.telefone = _celular;
                          _cubit.cliente!.nome = nomeCompleto.text;

                          _cubit.salvarCliente();

                          Navigator.of(context).pop();
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool validarQuantidade(String value) {
    String patttern = r'(^[0-9.]*$)';

    RegExp regExp = RegExp(patttern);
    bool _valido = false;

    if (value.isEmpty) {
      _valido = false;
    } else if (!regExp.hasMatch(value)) {
      _valido = false;
    } else {
      _valido = true;
    }

    return _valido;
  }

  limparEnderecoUsuario() {
    logradouro.text = '';
    complemento.text = '';
    numero.text = '';
    bairro.text = '';
    cidade.text = '';
    uf.text = '';
  }
}
