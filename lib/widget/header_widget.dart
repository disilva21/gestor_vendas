import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerencianet/gerencianet.dart';
import 'package:gestor_vendas/common/app_colors.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../util/credentials.dart';

import 'package:flutter/services.dart';
import 'dart:io' as mobile;

const alarmAudioPath = "sound_alarm.mp3";

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> with TickerProviderStateMixin {
  // late ConfiguracaoCubit _cubit;
  // late MensagemCubit _cubitMensagem;
  //Gerencianet gn = Gerencianet(credentials);

  // late LoginCubit _cubitLogin;
  Uint8List? uin8List;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  @override
  void initState() {
    // _cubit = BlocProvider.of<ConfiguracaoCubit>(context);
    // _cubitLogin = BlocProvider.of<LoginCubit>(context);
    // _cubitMensagem = MensagemCubit(context);

    // _cubit.carregarConfiguracoes();
    super.initState();
  }

  // AudioPlayer? _player;
  // AudioPlayer? player;
  // bool audioPlayer = false;

  @override
  void dispose() {
    // _player?.dispose();
    _controller.dispose();
    super.dispose();
  }

  // void _play() {
  //   _player?.dispose();
  //   final player = _player = AudioPlayer();
  //   // player.play(AssetSource('sound_alarm.mp3'));
  // }

  // void stopSound() {
  //   player?.stop();
  //   player?.pause();
  //   _player?.dispose();
  //   player?.dispose();

  //   //_cubitDash.listaNovosPedidos = [];
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
    // if (_cubitDash.listaNovosPedidos.isNotEmpty) {
    //   _play();
    //   audioPlayer = true;
    //   setState(() {});
    // }
    final theme = Theme.of(context);
    // return BlocProvider<ConfiguracaoCubit>.value(
    //   value: _cubit,
    //   child: BlocBuilder<ConfiguracaoCubit, ConfiguracaoState>(
    //     builder: (context, state) {
    //       return Container(
    //         color: Color.fromARGB(255, 15, 33, 64),
    //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             logoWidget(),
    //             // Container(
    //             //   width: 190,
    //             //   decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(width: 1, color: Colors.white)),
    //             //   child: TextButton.icon(
    //             //       onPressed: () async {
    //             //         String acao = 'abrir';

    //             //         if (_cubit.configuracaoEntity.online != null && _cubit.configuracaoEntity.online!) {
    //             //           acao = 'fechar';
    //             //         }

    //             //         final data = await _showConfirmacaoOpenCloseDelivery(theme, acao);
    //             //         if (data == true) {
    //             //           _cubit.alterarStatusOnline();
    //             //         }
    //             //       },
    //             //       icon: Image.asset(
    //             //         _cubit.configuracaoEntity.online != null && _cubit.configuracaoEntity.online == true ? "assets/icons/icons8-open.png" : "assets/icons/icons8-closed.png",
    //             //         width: 30,
    //             //       ),
    //             //       label: Text(
    //             //         _cubit.configuracaoEntity.online != null && _cubit.configuracaoEntity.online! ? 'Fechar o delivery?' : 'Abrir o delivery?',
    //             //         style: TextStyle(color: _cubit.configuracaoEntity.online != null && _cubit.configuracaoEntity.online! ? Colors.black : Colors.black, fontWeight: FontWeight.bold),
    //             //       )),
    //             // ),
    //             // if (_cubitLogin.diasRestantes != null || _cubitLogin.horasRestantes != null)
    //             //   Row(
    //             //     children: [
    //             //       TextButton.icon(
    //             //         icon: Icon(Icons.warning_rounded, color: Colors.white),
    //             //         label: Column(
    //             //           children: [
    //             //             if (_cubitLogin.diasRestantes != null)
    //             //               Text(
    //             //                 'Restam ${_cubitLogin.diasRestantes.toString()} dia(s)',
    //             //                 style: theme.textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 12),
    //             //               ),
    //             //             if (_cubitLogin.diasRestantes == null && _cubitLogin.horasRestantes != null && _cubitLogin.horasRestantes! > 0)
    //             //               Text(
    //             //                 'Restam ${_cubitLogin.horasRestantes.toString()} hora(s)',
    //             //                 style: theme.textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 12),
    //             //               ),
    //             //             if (_cubitLogin.diasRestantes == null &&
    //             //                 _cubitLogin.horasRestantes != null &&
    //             //                 _cubitLogin.horasRestantes! == 0 &&
    //             //                 _cubitLogin.minRestantes != null &&
    //             //                 _cubitLogin.minRestantes! > 0)
    //             //               Text(
    //             //                 'Restam ${_cubitLogin.minRestantes.toString()} min(s)',
    //             //                 style: theme.textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 12),
    //             //               ),
    //             //             if (_cubitLogin.permitirAcesso == false)
    //             //               Text(
    //             //                 'Garanta seu acesso',
    //             //                 style: theme.textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 12),
    //             //               ),
    //             //           ],
    //             //         ),
    //             //         onPressed: () {
    //             //           _createCharge();
    //             //           // html.window.history.pushState(null, 'pagamento', '#/pagamento');
    //             //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => PagamentoPageScreen()));
    //             //           //_showMyDialogPagamento(theme);
    //             //         },
    //             //       ),
    //             //       SizedBox(
    //             //         width: 5,
    //             //       ),
    //             //       SizedBox(
    //             //         width: 105,
    //             //         height: 30,
    //             //         child: ElevatedButton(
    //             //             onPressed: () {
    //             //               // _showMyDialogPagamento(theme);
    //             //               // html.window.history.pushState(null, 'pagamento', '#/pagamento');
    //             //               Navigator.of(context).push(MaterialPageRoute(builder: (context) => PagamentoPageScreen()));
    //             //             },
    //             //             child: Text('Contratar', style: theme.textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 12))),
    //             //       ),
    //             //     ],
    //             //   ),
    //             // // if (audioPlayer)
    //             //   Builder(builder: (context) {
    //             //     return ScaleTransition(
    //             //       scale: _animation,
    //             //       child: IconButton(
    //             //         icon: Image.asset(
    //             //           "assets/icons/icons8-alarm.png",
    //             //           width: 30,
    //             //         ),
    //             //         onPressed: () {
    //             //           stopSound();
    //             //           audioPlayer = false;
    //             //           setState(() {});
    //             //         },
    //             //       ),
    //             //     );
    //             //   }),
    //             // if (!audioPlayer)
    //             //   Builder(builder: (context) {
    //             //     return IconButton(
    //             //       icon: Image.asset(
    //             //         "assets/icons/icons8-alarm.png",
    //             //         color: Colors.grey,
    //             //         width: 30,
    //             //       ),
    //             //       onPressed: null,
    //             //     );
    //             //   }),
    //             // if (_cubitLogin.usuarioEntity.configuracaoEntity != null && _cubitLogin.usuarioEntity.configuracaoEntity!.path == null)
    //             //   Container(
    //             //     width: 190,
    //             //     child: TextButton.icon(
    //             //         onPressed: () {
    //             //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfiguracaoScreen()));
    //             //         },
    //             //         icon: Image.asset(
    //             //           "assets/icons/icons8-cardapio.png",
    //             //           width: 30,
    //             //         ),
    //             //         label: Text(
    //             //           'Montar meu cardápio',
    //             //           style: theme.textTheme.bodyText2!.copyWith(color: Colors.white),
    //             //         )),
    //             //   ),
    //             // Container(
    //             //   width: 190,
    //             //   child: TextButton.icon(
    //             //       onPressed: () {
    //             //         if (_cubitLogin.usuarioEntity.configuracaoEntity!.path == null) {
    //             //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfiguracaoScreen()));
    //             //         } else {
    //             //           _cubit.carregarConfiguracoes();
    //             //           _showVerMeuCardapio(theme);
    //             //         }
    //             //       },
    //             //       icon: Image.asset(
    //             //         "assets/icons/icons8-cardapio.png",
    //             //         width: 30,
    //             //       ),
    //             //       label: Text(
    //             //         'Ver meu cardápio',
    //             //         style: theme.textTheme.bodyText2!.copyWith(color: Colors.white),
    //             //       )),
    //             // ),
    //             notificationThemeProfileIcon(),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  // Widget _qrCode() {
  //   return Image.memory(uin8List!.buffer.asUint8List());
  // }

  _createCharge() {
    Gerencianet gerencianet = Gerencianet(credentials);

    Map<String, dynamic> body = {
      'calendario': {
        'expiracao': 900,
      },
      'valor': {'original': 001},
      'chave': '3699cef0-83f3-4744-ae2b-8b5edaaefb23'
    };

    gerencianet.call('pixCreateImmediateCharge', body: body).then((value) {
      print(value);

      gerencianet.call('pixGenerateQRCode', params: {'id': value['loc']['id']}).then((value) {
        setState(() {
          uin8List = Base64Decoder().convert(value['imagemQrcode'].split(',').last);
        });

        print(value);
      }).catchError((onError) => print(onError));
    }).catchError((onError) => print(onError));
  }

  WidgetBuilder get _localDialogBuilder {
    return (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Card(
            color: Colors.white.withOpacity(0.7),
            child: Container(
              width: 350,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                // color: Color.fromARGB(255, 252, 252, 250),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 18, color: Colors.black87),
                child: IntrinsicWidth(
                    // child: StreamBuilder(
                    //  // stream: _cubit.novasMensagensGenericasStream,
                    //   builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    //     // if (!snapshot.hasData) {
                    //     //   return const Text('Carregando...');
                    //     // }
                    //     // if (snapshot.connectionState == ConnectionState.waiting) {
                    //     //   return Column(
                    //     //     children: const [Center(child: CircularProgressIndicator())],
                    //     //   );
                    //     // }

                    //     // QuerySnapshot documentos = snapshot.data;
                    //     var documentos = null;

                    //     final listaMensagens = documentos.docs.map((e) => MensagemEntity.fromMap(e.data())).toList();

                    //     return ListView.builder(
                    //       itemCount: listaMensagens.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         final mensagem = listaMensagens[index];
                    //         return Card(
                    //           elevation: 4,
                    //           color: Colors.white,
                    //           child: Theme(
                    //             data: mensagem.lido == false ? ThemeData.light() : Theme.of(context),
                    //             child: ListTile(
                    //               contentPadding: EdgeInsets.zero,
                    //               leading: Image.asset(
                    //                 'assets/images/menu_mania_branco.png',
                    //               ),
                    //               title: Text(mensagem.titulo!),
                    //               subtitle: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(mensagem.descricao!),
                    //                   SizedBox(height: 10),
                    //                   if (mensagem.url != null)
                    //                     OutlinedButton(
                    //                       onPressed: () {
                    //                         _cubitMensagem.alterarStatusMensagem(true);
                    //                       },
                    //                       child: Text(
                    //                         mensagem.url != null ? 'Conheça agora' : '',
                    //                         style: TextStyle(color: Colors.blueAccent),
                    //                       ),
                    //                     ),
                    //                   SizedBox(height: 10),
                    //                 ],
                    //               ),
                    //               trailing: Padding(
                    //                 padding: const EdgeInsets.only(right: 10),
                    //                 child: Icon(
                    //                   Icons.circle,
                    //                   color: mensagem.lido == false ? Colors.grey : Colors.blue,
                    //                   size: 14,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    ),
              ),
            ),
          ),
        ),
      );
    };
  }

  Widget notificationThemeProfileIcon() {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications),
          color: Color(0xff33b6e0),
          iconSize: 30,
          onPressed: (() {
            showAlignedDialog(
                context: context,
                builder: _localDialogBuilder,
                followerAnchor: Alignment.topRight,
                targetAnchor: Alignment.bottomRight,
                barrierColor: Colors.transparent,
                //offset: Offset(10, 10),
                avoidOverflow: true);
            // Navigator.of(context)
            //     .push(MaterialPageRoute(
            //       builder: (context) {
            //         return Container(width: 300, child: MensagemScreen());
            //       },
            //       fullscreenDialog: true,
            //     ))
            //     .then((value) => null);
          }),
        ),
        Positioned(
          right: 5,
          top: 2,
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 224, 51, 51),
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }

  Future<void> _showPushNotification(String mensagem) async {
    return showDialog<void>(
      context: context,

      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mensagem,
              ),
              IconButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: mensagem));
                  },
                  icon: const Icon(Icons.copy)),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  child: const Text('SAIR'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget roundedIcon({IconData? icon, Color? color, bool isNewNotification = false}) {
    return Stack(
      children: [
        Icon(
          icon,
          color: color ?? AppColors.txtGry,
          size: 30,
        ),
        if (isNewNotification)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 224, 51, 51),
                shape: BoxShape.circle,
              ),
            ),
          )
      ],
    );
  }

  Widget logoWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // if (!AppResponsive.isMobile(context)) ...{
        //   Image.asset(
        //     'assets/images/menu_mania_letra.png',
        //     width: 50,
        //   ),
        //   // SvgPicture.asset('assets/images/menu_mania_logo.svg', width: 90, semanticsLabel: 'EBEL TEC'),
        // },
      ],
    );
  }

  Future<void> _showVerMeuCardapio(ThemeData theme) async {
    return showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Meu cardápio',
              style: theme.textTheme.bodyText1,
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      // Container(
                      //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      //     decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey[200]!)),
                      //     child: Text(_cubit.linkCardapio)),
                      SizedBox(width: 3),
                      // TextButton(
                      //   onPressed: () async {
                      //     Clipboard.setData(ClipboardData(text: _cubit.linkCardapio));
                      //   },
                      //   style: ButtonStyle(
                      //       //  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      //       ),
                      //   child: const Icon(Icons.copy_outlined, color: Colors.blue),
                      // ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            actions: <Widget>[
              SizedBox(
                width: 200,
                height: 30,
                child: OutlinedButton(
                  child: Text(
                    'Fechar',
                    style: theme.textTheme.bodyText1!.copyWith(color: const Color.fromARGB(255, 42, 117, 179)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 200,
                height: 30,
                child: ElevatedButton(
                    onPressed: () async {
                      // final Uri _url = Uri.parse(_cubit.linkCardapio);
                      // if (!await launchUrl(_url)) {
                      //   throw Exception('Não foi possível abrir $_url');
                      // }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Acessar o cardápio',
                    )),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<bool?> _showConfirmacaoOpenCloseDelivery(ThemeData theme, String acao) async {
    return showDialog<bool?>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meu Delivery',
                  style: theme.textTheme.bodyText1,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Text('Tem certeza que deseja ${acao} o delivery?', style: theme.textTheme.bodyText2!),
                  SizedBox(height: 40),
                ],
              ),
            ),
            actions: <Widget>[
              SizedBox(
                width: 200,
                height: 30,
                child: TextButton(
                  child: Text(
                    'Cancelar',
                    style: theme.textTheme.bodyText1!.copyWith(color: const Color.fromARGB(255, 42, 117, 179)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 200,
                height: 30,
                child: ElevatedButton(
                  child: Text(
                    'Sim, tenho',
                    style: theme.textTheme.bodyText1!.copyWith(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Future<void> _showMyDialogPagamento(ThemeData theme, PagamentoCubit cubitPagamento) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (_) => StatefulBuilder(
  //       builder: (BuildContext context, StateSetter myState) {
  //         return AlertDialog(
  //           backgroundColor: Colors.white,
  //           title: Text(
  //             'Pagamento',
  //             style: theme.textTheme.bodyText1,
  //           ),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Faça o pagamento e envie o comprovante para whatsapp',
  //                   style: theme.textTheme.bodyText2,
  //                 ),
  //                 SizedBox(height: 20),
  //                 InkWell(
  //                   onTap: () async {
  //                     await launchWhatsAppUri('1194757-9781');
  //                   },
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Icon(Icons.whatsapp_outlined, color: Color.fromARGB(255, 53, 153, 56)),
  //                       SizedBox(width: 5),
  //                       Text(
  //                         '(11) 94757-9781',
  //                         style: theme.textTheme.bodyText1!.copyWith(color: Color.fromARGB(255, 53, 153, 56)),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(height: 30),
  //                 Builder(builder: (context) {
  //                   if (_cubitPagamento)
  //                     return Row(
  //                       children: [
  //                         Container(
  //                             width: 400,
  //                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                             decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey[200]!)),
  //                             child: Text(
  //                               _cubit.linkPagamento,
  //                               maxLines: 3,
  //                               overflow: TextOverflow.ellipsis,
  //                             )),
  //                         SizedBox(width: 3),
  //                         TextButton(
  //                           onPressed: () async {
  //                             Clipboard.setData(ClipboardData(text: _cubit.linkPagamento));
  //                           },
  //                           style: ButtonStyle(
  //                               //  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  //                               ),
  //                           child: const Icon(Icons.copy_outlined, color: Colors.blue),
  //                         ),
  //                       ],
  //                     );
  //                 }),
  //                 SizedBox(height: 20),
  //                 SizedBox(
  //                   width: 180,
  //                   height: 180,
  //                   child: Container(
  //                       // decoration: BoxDecoration(
  //                       //   border: Border.all(width: 1, color: Colors.grey[200]!),
  //                       // ),
  //                       child: _cubitPa != null ? _qrCode() : Container() //Image.asset('assets/images/qrCodeCobrancaEbel.jpeg'),
  //                       ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             SizedBox(
  //               width: 200,
  //               height: 30,
  //               child: TextButton(
  //                 child: Text(
  //                   'Fechar',
  //                   style: theme.textTheme.bodyText1!.copyWith(color: const Color.fromARGB(255, 42, 117, 179)),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ),
  //             const SizedBox(width: 20),
  //             SizedBox(
  //               width: 200,
  //               height: 30,
  //               child: ElevatedButton(
  //                 child: Text(
  //                   'OK',
  //                   style: theme.textTheme.bodyText1!.copyWith(color: Colors.white),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  launchWhatsAppUri(String celular) async {
    // final link = WhatsAppUnilink(
    //   phoneNumber: '+55-${celular}',
    //   text: "Olá, fiz o pagamento e estou enviando o comprovante, minha identificação: ${_cubitLogin.usuarioEntity.documento}",
    // );

    // if (!await launchUrl(link.asUri())) {
    //   throw Exception('Não foi possível abrir');
    // }

    //cubit.cadastrar();
  }
}
