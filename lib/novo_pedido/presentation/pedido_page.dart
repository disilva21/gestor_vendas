import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/capability_profile.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/enums.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/generator.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_column.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_styles.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_pos_printer_platform/printer.dart';
import 'package:gestor_vendas/configuracao/domain/entities/cliente.dart';
import 'package:gestor_vendas/configuracao/presentation/impressora.dart';
import 'package:gestor_vendas/novo_pedido/presentation/cubit/pedido_state.dart';
import 'package:gestor_vendas/produto/presentation/cubit/produto_cubit.dart';
import 'package:gestor_vendas/util/remove_acentos.dart';
import 'package:gestor_vendas/widget/header_widget.dart';
import 'package:gestor_vendas/widget/side_bar.dart';

import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../produto/data/providers/firebase/produto_service.dart';
import '../../produto/domain/enum/unidade_medida.dart';
import '../domain/entities/pedido.dart';
import 'cubit/pedido_cubit.dart';
import 'package:gbk_codec/gbk_codec.dart';

class PedidoPageScreen extends StatefulWidget {
  @override
  _PedidoState createState() => _PedidoState();
}

class _PedidoState extends State<PedidoPageScreen> with SingleTickerProviderStateMixin {
  late PedidoCubit _cubit;
  late ProdutoCubit _cubitProd;

  late AnimationController controller;

  final maskCelular = MaskTextInputFormatter(mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')});
  var inputFormat = DateFormat('dd-MM-yyyy');

  TextEditingController searchController = TextEditingController();

  DateTime date = DateTime.now();

  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  var _reconnect = false;

  @override
  void initState() {
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 2);
    _cubit = PedidoCubit(context);
    _cubit.carregarPedidos();
    _cubit.retornarUltimaData();

    _cubitProd = ProdutoCubit(context);

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

    _scan();
    super.initState();
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

  Future _printReceiveTest(ThemeData theme, PedidoModel pedido) async {
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
      nomeEmpresa: "Edinho",
    );

    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy H:m');
    final String timestamp = formatter.format(now);

    bytes += generator.text(empresa.nomeEmpresa.toString().withoutDiacriticalMarks, styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.row([
      PosColumn(width: 6, text: 'Pedido', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 6, text: pedido.id.toString().padLeft(10, '0'), styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);
    bytes += generator.row([
      PosColumn(width: 3, text: 'Data', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 9, text: timestamp, styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1)),
    ]);
    bytes += generator.feed(1);

    bytes += generator.hr();

    bytes += generator.text('Itens:', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1));

    List<PosColumn>? colsItens;

    for (var i = 0; i < pedido.itens!.length; i++) {
      colsItens = [];
      colsItens.add(PosColumn(width: 12, text: pedido.itens![i].produto!.nome!.withoutDiacriticalMarks, styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)));
      bytes += generator.row(colsItens);

      bytes += generator.row([
        PosColumn(width: 2, text: '${pedido.itens![i].quantidade} x ', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
        PosColumn(
            width: 1,
            text: '${_cubit.listaUnidadeMedida.firstWhere((element) => element.id! == pedido.itens![i].unidadeMedida!).sigla!}  ',
            styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
        PosColumn(
            width: 3,
            text: NumberFormat.simpleCurrency(decimalDigits: 2).format(pedido.itens![i].produto!.valorVenda!).toString(),
            styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
        PosColumn(
            width: 6,
            text: NumberFormat.simpleCurrency(decimalDigits: 2).format(pedido.itens![i].produto!.valorVenda! * pedido.itens![i].quantidade!).toString(),
            styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
      ]);
    }

    bytes += generator.hr();

    bytes += generator.text('Cliente:', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1));

    bytes += generator.text(
      pedido.cliente!.nome!.withoutDiacriticalMarks,
      styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1, bold: true),
    );

    bytes += generator.row([
      PosColumn(width: 4, text: 'Telefone', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 8, text: pedido.cliente!.telefone!, styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);

    bytes += generator.row([
      PosColumn(width: 6, text: 'Tipo entrega: ', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 6, text: "Retira".withoutDiacriticalMarks, styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);

    bytes += generator.hr();

    bytes += generator.text('Pagamento:', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1));

    bytes += generator.row([
      PosColumn(width: 5, text: 'Tipo', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(width: 7, text: pedido.formaPagamento!.nome!.withoutDiacriticalMarks, styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);

    // bytes += generator.row([
    //   PosColumn(width: 5, text: 'Taxa entrega', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
    //   PosColumn(width: 7, text: NumberFormat.simpleCurrency(decimalDigits: 2).format(0), styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    // ]);

    bytes += generator.row([
      PosColumn(width: 5, text: 'Total', styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
      PosColumn(
          width: 7, text: NumberFormat.simpleCurrency(decimalDigits: 2).format(pedido.total + 0).toString(), styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size1, bold: true)),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.feed(1);
    bytes += generator.text('Obrigado por usar Gestor Vendas', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1));
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
    final media = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<PedidoCubit, PedidoState>(
        builder: (context, state) {
          var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
          return BlocConsumer<PedidoCubit, PedidoState>(
            listener: (context, state) {
              if (state.sucesso == true) {
                BotToast.showText(onlyOne: true, text: state.mensagem!);
                Future.delayed(const Duration(milliseconds: 900)).then((value) {
                  Navigator.pop(context);
                });
              }

              if (state.falha == true) {
                BotToast.showText(onlyOne: true, text: state.mensagem!, contentColor: Color.fromARGB(255, 29, 63, 189), duration: Duration(seconds: 5));
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: theme.primaryColor,
                body: Column(
                  children: [
                    HeaderWidget(),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // if (AppResponsive.isDesktop(context))
                          //   Expanded(
                          //     child: SideBar(),
                          //   ),
                          SideBar(),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              color: Colors.white,
                              child: Scaffold(
                                // backgroundColor: AppColors.transparent,
                                body: Column(
                                  children: [
                                    filtro(theme),
                                    const SizedBox(height: 40),
                                    listHeader(theme),
                                    lista(theme, media),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget filtro(ThemeData theme) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 65,
            width: 480,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _cubit.search(searchController.text);
              },
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Buscar pelo número do pedido, nome ou celular do cliente",
                labelStyle: TextStyle(color: Colors.blue, fontSize: 12),
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _cubit.search('');
                    searchController.text = '';
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
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     padding: const EdgeInsets.all(8.0),
          //     child: DropdownButtonFormField<EnumPedidoStatus>(
          //       hint: new Text("Filtre pelo Status"),
          //       decoration: InputDecoration(
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         border: OutlineInputBorder(
          //           borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         filled: true,
          //         // fillColor: Colors.grey[300],
          //       ),
          //       disabledHint: Text("Selecione um entregador"),
          //       dropdownColor: Colors.white,
          //       value: null,
          //       items: _cubit.listaEnumStatus.map((EnumPedidoStatus e) {
          //         return DropdownMenuItem<EnumPedidoStatus>(value: e, child: Text(e.name));
          //       }).toList(),
          //       onChanged: (EnumPedidoStatus? newValue) {
          //         _cubit.searchStatus(newValue!);
          //       },
          //     ),
          //   ),
          // ),
          Container(
            height: 50,
            width: 380,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
            child: Row(
              children: [
                _buildCalendarDialogButton(theme),
                Text(inputFormat.format(_cubit.dataInicio)),
                SizedBox(width: 5),
                Text('até'),
                SizedBox(width: 5),
                Text(inputFormat.format(_cubit.dataFinal!)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      color: Color.fromARGB(255, 24, 94, 164),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Pedido', style: theme.textTheme.bodyText1!.copyWith(color: Colors.white)),
              )),
          SizedBox(width: 230, child: Text('Cliente', style: theme.textTheme.bodyText1!.copyWith(color: Colors.white))),
          SizedBox(width: 140, child: Text('Data', style: theme.textTheme.bodyText1!.copyWith(color: Colors.white))),
          SizedBox(width: 120, child: Text('Pagamento', style: theme.textTheme.bodyText1!.copyWith(color: Colors.white))),
          // SizedBox(width: 100, child: Text('Entrega', style: theme.textTheme.bodyText1!.copyWith(color: Colors.white))),
          SizedBox(width: 100, child: Text('Valor', style: theme.textTheme.bodyText1!.copyWith(color: Colors.white))),
          SizedBox(width: 150, child: Text('Status', style: theme.textTheme.bodyText1!.copyWith(color: Colors.white))),
          SizedBox(width: 150, child: Text('Ações', style: theme.textTheme.bodyText1!.copyWith(color: Colors.white))),
        ],
      ),
    );
  }

  Widget lista(ThemeData theme, Size media) {
    var inputFormat = DateFormat('dd-MM-yyyy');

    return _cubit.listaFiltro.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'Nenhum pedido encontrado',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          )
        : Expanded(
            child: ListView.builder(
                shrinkWrap: false,
                itemCount: _cubit.listaFiltro.length,
                itemBuilder: ((BuildContext context, int index) {
                  final item = _cubit.listaFiltro[index];

                  return SizedBox(
                    height: 50,
                    child: Container(
                      color: isPar(index) ? Colors.white : Color.fromARGB(255, 217, 244, 251),
                      child: Row(
                        children: [
                          SizedBox(width: 100, child: Padding(padding: const EdgeInsets.only(left: 10), child: Text(item.id.toString(), style: theme.textTheme.bodyText1))),
                          SizedBox(width: 230, child: Text(item.cliente!.nome!, style: theme.textTheme.bodyText1)),
                          SizedBox(width: 140, child: Text(inputFormat.format(item.dataCadastro ?? DateTime.now()), style: theme.textTheme.bodyText1)),
                          SizedBox(width: 120, child: Text(item.formaPagamento!.nome!, style: theme.textTheme.bodyText1)),
                          // SizedBox(width: 100, child: Text(descricaoTipoEntrega(item.tipoEntrega!), style: theme.textTheme.bodyText1)),
                          SizedBox(width: 100, child: Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(item.total), style: theme.textTheme.bodyText1)),
                          SizedBox(width: 150, child: Text(descricaoStatus(item.statusPedido ?? 0), style: theme.textTheme.bodyText1)),
                          // SizedBox(
                          //     width: 70,
                          //     child: IconButton(
                          //       icon: Icon(
                          //         Icons.local_activity,
                          //         color: Colors.black,
                          //       ),
                          //       onPressed: () {},
                          //     )),
                          SizedBox(
                              width: 70,
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  _dialogBuilder(media, context, item, theme, index);
                                },
                              )),

                          SizedBox(
                            width: 70,
                            child: IconButton(
                                onPressed: () {
                                  _printReceiveTest(theme, item);
                                  // await _showPrintCupomFiscal(theme, UsuarioDto(), pedidoNovo);
                                },
                                icon: Icon(Icons.print_outlined)),
                          ),
                        ],
                      ),
                    ),
                  );
                })),
          );
  }

  bool isPar(int index) {
    int rest;
    bool retorno = false;
    rest = index % 2;

    if (rest == 0) {
      retorno = true;
    }
    return retorno;
  }

  String descricaoTipoEntrega(int step) {
    switch (step) {
      case 0:
        return 'Entrega';

      case 1:
        return 'Retirada';

      case 2:
        return 'Balcão';

      default:
        return 'Entrega';
    }
  }

  String descricaoStatus(int step) {
    switch (step) {
      case 0:
        return 'Em andamento';

      case 1:
        return 'Finalizado';

      case 2:
        return 'Cancelado';

      default:
        return 'Em andamento';
    }
  }

  Future<void> _dialogBuilder(Size media, BuildContext context, PedidoModel pedidoEntity, ThemeData theme, int index) {
    return showModalBottomSheet<void>(
      transitionAnimationController: controller,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      isDismissible: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (BuildContext context) {
        return detalhe(media, context, pedidoEntity, theme, index);
      },
    );
  }

  Widget detalhe(Size media, BuildContext context, PedidoModel pedido, ThemeData theme, int index) {
    var inputFormat = DateFormat('dd-MM-yyyy');

    return Card(
      elevation: 7,
      child: Container(
        constraints: const BoxConstraints(minHeight: 200),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Pedido: ',
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '#${pedido.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            _printReceiveTest(theme, pedido);
                            // await _showPrintCupomFiscal(theme, UsuarioDto(), pedidoNovo);
                          },
                          icon: Icon(Icons.print_outlined)),
                      Align(
                          alignment: Alignment.topRight,
                          child: TextButton.icon(
                              onPressed: () {
                                //  exibeDetalhe = false;
                                //   setState(() {});
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close_outlined),
                              label: Text('Fechar'))),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Data do pedido:'),
                      SizedBox(width: 8),
                      Text(inputFormat.format(pedido.dataCadastro!)),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Text(
                        'Cliente:',
                      ),
                      SizedBox(width: 8),
                      Text(pedido.cliente!.nome!, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.phone_android,
                        size: 16,
                        color: Colors.black,
                      ),
                      Text(maskCelular.maskText(pedido.cliente!.telefone!), style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),

                  SizedBox(height: 25),
                  Text('Itens do Pedido', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: pedido.itens!.map((itemProduto) {
                      return Container(
                        color: Colors.grey[200],
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${itemProduto.quantidade!}',
                                  style: theme.textTheme.headlineMedium!.copyWith(fontSize: 12),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  ' ${itemProduto.produto!.nome!}',
                                  style: theme.textTheme.headlineMedium!.copyWith(fontSize: 12),
                                ),
                              ],
                            ),

                            //  if (itemProduto.observacao != null && itemProduto.observacao != '')
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 10),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         'Observação',
                            //         style: theme.textTheme.bodyText1!.copyWith(fontSize: 12),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(right: 10, top: 10),
                            //         child: Container(
                            //           width: double.infinity,
                            //           color: Colors.white,
                            //           padding: EdgeInsets.all(20),
                            //           child: Text(
                            //             itemProduto.observacao!,
                            //             style: theme.textTheme.displayMedium!.copyWith(color: Colors.red, fontSize: 12),
                            //             maxLines: 1,
                            //             overflow: TextOverflow.ellipsis,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Itens: '),
                      SizedBox(width: 8),
                      Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(pedido.total), style: theme.textTheme.bodyMedium),
                    ],
                  ),

                  SizedBox(height: 8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('Desconto aplicado: '),
                  //     SizedBox(width: 8),
                  //     Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(pedido.desconto ?? 0), style: theme.textTheme.bodyMedium!.copyWith(color: Colors.red)),
                  //   ],
                  // ),
                  // SizedBox(height: 8),
                  Divider(
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: '),
                      SizedBox(width: 8),
                      Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(pedido.total), style: theme.textTheme.bodyText1),
                    ],
                  ),
                  SizedBox(height: 15),
                  Card(
                    color: Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Forma de pagamento", style: theme.textTheme.bodyText1),
                          Text(pedido.formaPagamento!.nome!, style: theme.textTheme.bodyText1),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, textStyle: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: pedido.statusPedido == 2
                                ? null
                                : () {
                                    _cubit.alterarStatusPedido(2, pedido.id);
                                  },
                            child: Text('Cancelar')),
                      ),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                            onPressed: pedido.statusPedido == 1
                                ? null
                                : () async {
                                    _cubit.alterarStatusPedido(1, pedido.id);
                                  },
                            child: Text('Finalizar')),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildCalendarDialogButton(ThemeData theme) {
    const dayTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle = TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true ? Colors.white : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            icon: Icon(Icons.calendar_today, color: Colors.blue),
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: _cubit.dialogCalendarPickerValue,
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                _cubit.dialogCalendarPickerValue = values;
                _cubit.search(searchController.text);
              }
            },
            label: Text(
              'Filtre por data',
              style: theme.textTheme.bodyText1!.copyWith(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
