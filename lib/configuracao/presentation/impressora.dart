import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/header_widget.dart';
import '../../widget/side_bar.dart';

import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class ImpressoraScreen extends StatefulWidget {
  @override
  _ImpressoraPageState createState() => _ImpressoraPageState();
}

class _ImpressoraPageState extends State<ImpressoraScreen> with SingleTickerProviderStateMixin {
  static const String route = '/impressora';

  var defaultPrinterType = PrinterType.usb;
  int? defaultPrinterSize = 80;
  var _isBle = false;
  var _reconnect = false;
  var _isConnected = false;
  var printerManager = PrinterManager.instance;
  var devices = <BluetoothPrinter>[];
  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  BTStatus _currentStatus = BTStatus.none;
  // _currentUsbStatus is only supports on Android
  USBStatus _currentUsbStatus = USBStatus.none;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  BluetoothPrinter? selectedPrinter;
  String? nomeImpressora;

  @override
  void initState() {
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
    super.initState();
    _portController.text = _port;
    _scan();

    // subscription to listen change status of bluetooth connection
    _subscriptionBtStatus = PrinterManager.instance.stateBluetooth.listen((status) {
      log(' ----------------- status bt $status ------------------ ');
      _currentStatus = status;
      if (status == BTStatus.connected) {
        setState(() {
          _isConnected = true;
        });
      }
      if (status == BTStatus.none) {
        setState(() {
          _isConnected = false;
        });
      }
      if (status == BTStatus.connected && pendingTask != null) {
        if (Platform.isAndroid) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance.send(type: PrinterType.bluetooth, bytes: pendingTask!);
            pendingTask = null;
          });
        } else if (Platform.isIOS) {
          PrinterManager.instance.send(type: PrinterType.bluetooth, bytes: pendingTask!);
          pendingTask = null;
        }
      }
    });
    //  PrinterManager.instance.stateUSB is only supports on Android
    _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');
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
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _subscriptionUsbStatus?.cancel();
    _portController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  // method to scan devices according PrinterType
  void _scan() async {
    devices.clear();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nomeImpressora = await prefs.getString('selectedPrinter');
    defaultPrinterSize = await prefs.getInt('paperSize') ?? 80;

    _subscription = printerManager.discovery(type: defaultPrinterType, isBle: _isBle).listen((device) {
      final _device = BluetoothPrinter(deviceName: device.name, address: device.address, isBle: _isBle, vendorId: device.vendorId, productId: device.productId, typePrinter: defaultPrinterType);
      devices.add(_device);
      if (nomeImpressora!.isNotEmpty && device.name == nomeImpressora) {
        selectedPrinter = _device;
      }
      setState(() {});
    });
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void setIpAddress(String value) {
    _ipAddress = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) || (device.typePrinter == PrinterType.usb && selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance.disconnect(type: selectedPrinter!.typePrinter);
      }
    }

    selectedPrinter = device;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPrinter', device.deviceName!);
    await prefs.setInt('paperSize', 80);

    // var box = await Hive.openBox('selectdevice');
    // await box.put('selectdevice', device);
    setState(() {});
  }

  Future _printReceiveTest() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text('Test Print', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Product 1');
    bytes += generator.text('Product 2');

    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
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

  // conectar dispositivo
  _connectDevice() async {
    _isConnected = false;
    if (selectedPrinter == null) return;
    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter, model: UsbPrinterInput(name: selectedPrinter!.deviceName, productId: selectedPrinter!.productId, vendorId: selectedPrinter!.vendorId));
        _isConnected = true;
        break;
      case PrinterType.bluetooth:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: BluetoothPrinterInput(name: selectedPrinter!.deviceName, address: selectedPrinter!.address!, isBle: selectedPrinter!.isBle ?? false, autoConnect: _reconnect));
        break;
      case PrinterType.network:
        await printerManager.connect(type: selectedPrinter!.typePrinter, model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
        _isConnected = true;
        break;
      default:
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                SideBar(),
                Flexible(
                    flex: 4,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Impressora',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '(Aqui você configura sua impressora)',
                                    style: theme.textTheme.labelMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButtonFormField<PrinterType>(
                                    value: defaultPrinterType,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.print,
                                        size: 24,
                                      ),
                                      labelText: "Tipo de conexão da impressora",
                                      labelStyle: TextStyle(fontSize: 18.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 147, 145, 145), width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items: <DropdownMenuItem<PrinterType>>[
                                      if (Platform.isAndroid || Platform.isIOS)
                                        const DropdownMenuItem(
                                          value: PrinterType.bluetooth,
                                          child: Text("Bluetooth"),
                                        ),
                                      if (Platform.isAndroid || Platform.isWindows)
                                        const DropdownMenuItem(
                                          value: PrinterType.usb,
                                          child: Text("USB"),
                                        ),
                                      const DropdownMenuItem(
                                        value: PrinterType.network,
                                        child: Text("Wifi"),
                                      ),
                                    ],
                                    onChanged: (PrinterType? value) {
                                      setState(() {
                                        if (value != null) {
                                          setState(() {
                                            defaultPrinterType = value;
                                            selectedPrinter = null;
                                            _isBle = false;
                                            _isConnected = false;
                                            _scan();
                                          });
                                        }
                                      });
                                    },
                                  ),
                                  Visibility(
                                    visible: defaultPrinterType == PrinterType.bluetooth && Platform.isAndroid,
                                    child: SwitchListTile.adaptive(
                                      contentPadding: const EdgeInsets.only(bottom: 20.0, left: 20),
                                      title: const Text(
                                        "Este dispositivo suporta ble (baixa energia)",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 19.0),
                                      ),
                                      value: _isBle,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isBle = value ?? false;
                                          _isConnected = false;
                                          selectedPrinter = null;
                                          _scan();
                                        });
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: defaultPrinterType == PrinterType.bluetooth && Platform.isAndroid,
                                    child: SwitchListTile.adaptive(
                                      contentPadding: const EdgeInsets.only(bottom: 20.0, left: 20),
                                      title: const Text(
                                        "reconectar",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 19.0),
                                      ),
                                      value: _reconnect,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _reconnect = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 680,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: devices
                                            .map(
                                              (device) => ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text('${device.deviceName}'),
                                                subtitle:
                                                    Platform.isAndroid && defaultPrinterType == PrinterType.usb ? null : Visibility(visible: !Platform.isWindows, child: Text("${device.address}")),
                                                onTap: () {
                                                  // do something
                                                  selectDevice(device);
                                                },
                                                leading: selectedPrinter != null &&
                                                        ((device.typePrinter == PrinterType.usb && Platform.isWindows
                                                                ? device.deviceName == selectedPrinter!.deviceName
                                                                : device.vendorId != null && selectedPrinter!.vendorId == device.vendorId) ||
                                                            (device.address != null && selectedPrinter!.address == device.address))
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                        size: 14,
                                                      )
                                                    : null,
                                                trailing: SizedBox(
                                                  width: 240,
                                                  child: Row(
                                                    children: [
                                                      selectedPrinter != null &&
                                                              ((device.typePrinter == PrinterType.usb && Platform.isWindows
                                                                      ? device.deviceName == selectedPrinter!.deviceName
                                                                      : device.vendorId != null && selectedPrinter!.vendorId == device.vendorId) ||
                                                                  (device.address != null && selectedPrinter!.address == device.address))
                                                          ? Expanded(
                                                              child: SizedBox(
                                                                width: 200,
                                                                child: DropdownButtonFormField<int>(
                                                                  value: defaultPrinterSize,
                                                                  decoration: const InputDecoration(
                                                                    labelText: "Tamanho da bobina",
                                                                    labelStyle: TextStyle(fontSize: 14.0),
                                                                    focusedBorder: InputBorder.none,
                                                                    enabledBorder: InputBorder.none,
                                                                  ),
                                                                  items: <DropdownMenuItem<int>>[
                                                                    DropdownMenuItem(
                                                                      value: 58,
                                                                      child: Text("58 mm", style: TextStyle(fontSize: 14.0)),
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      value: 72,
                                                                      child: Text(
                                                                        "72 mm",
                                                                        style: TextStyle(fontSize: 14.0),
                                                                      ),
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      value: 80,
                                                                      child: Text("80 mm", style: TextStyle(fontSize: 14.0)),
                                                                    ),
                                                                  ],
                                                                  onChanged: (int? value) async {
                                                                    if (value != null) {
                                                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                      await prefs.setInt('paperSize', value);
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              width: 200,
                                                            ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: OutlinedButton(
                                                            onPressed: selectedPrinter == null || device.deviceName != selectedPrinter?.deviceName
                                                                ? null
                                                                : () async {
                                                                    _printReceiveTest();
                                                                  },
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 2),
                                                              child: Text(
                                                                "Imprimir teste",
                                                                textAlign: TextAlign.center,
                                                                style: theme.textTheme.labelSmall,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList()),
                                  ),
                                  Visibility(
                                    visible: defaultPrinterType == PrinterType.network && Platform.isWindows,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: TextFormField(
                                        controller: _ipController,
                                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                                        decoration: const InputDecoration(
                                          label: Text("Ip Address"),
                                          prefixIcon: Icon(Icons.wifi, size: 24),
                                        ),
                                        onChanged: setIpAddress,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: defaultPrinterType == PrinterType.network && Platform.isWindows,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: TextFormField(
                                        controller: _portController,
                                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                                        decoration: const InputDecoration(
                                          label: Text("Port"),
                                          prefixIcon: Icon(Icons.numbers_outlined, size: 24),
                                        ),
                                        onChanged: setPort,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: defaultPrinterType == PrinterType.network && Platform.isWindows,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          if (_ipController.text.isNotEmpty) setIpAddress(_ipController.text);
                                          _printReceiveTest();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 50),
                                          child: Text("Print test ticket", textAlign: TextAlign.center),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
                                  Navigator.of(context).pop();
                                },
                                child: Text('Voltar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter({this.deviceName, this.address, this.port, this.state, this.vendorId, this.productId, this.typePrinter = PrinterType.bluetooth, this.isBle = false});
}
