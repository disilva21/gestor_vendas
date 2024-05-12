import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'configuracao_cardapio_state.dart';
import 'configuracao_dados_state.dart';
import 'configuracao_endereco_state.dart';
import 'configuracao_state.dart';

class ConfiguracaoCubit extends Cubit<ConfiguracaoState> {
  BuildContext _context;
  ConfiguracaoCubit(this._context) : super(ConfiguracaoState());

  String id = '';
  bool menuVisivel = true;
  String linkCardapio = '';
  String linkPagamento = '00020126360014BR.GOV.BCB.PIX0114+5511947579781520400005303986540549.905802BR5924Edvaldo Moreira da Silva6009SAO PAULO61080540900062260522pgtoebeltecmensalidade63047B56';
  String downloadedUrl = '';

  String? versaoSistema;
  num? buildNumber;

  Future<void> loadEndereco() async {
    emit(ConfiguracaoEnderecoState.inicio());

    emit(ConfiguracaoEnderecoState.completo());
  }

  Future<void> loadDados() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    buildNumber = int.parse(packageInfo.buildNumber);
    versaoSistema = packageInfo.version + '-' + packageInfo.buildNumber;
  }

  Future<void> loadCardapio() async {
    emit(ConfiguracaoCardapioState.inicio());

    emit(ConfiguracaoCardapioState.completo());
  }

  Future<void> validarNomeNegocio(String value) async {
    String patttern = r'(^[a-z-0-9-]*$)';
    RegExp regExp = new RegExp(patttern);
    bool _valido = false;
    String _mensagem = '';
    if (value.length == 0) {
      _mensagem = "Informe o nome do seu negócio";
    } else if (!regExp.hasMatch(value)) {
      _mensagem = "O nome não pode conter caracteres especiais";
    } else {
      _valido = true;
    }

    emit(ConfiguracaoState.nomeCardapioValido(mensagem: _mensagem, nomeCardapioValido: _valido));
  }

  Future<void> addMarcacaoMenu(String pageName) async {
    clearStatusMenu();
    switch (pageName) {
      case 'pedido':
        pedido = true;
        break;
      case 'categoria':
        categoria = true;
        break;
      case 'variacao':
        variacao = true;
        break;
      case 'acompanhamento':
        acompanhamento = true;
        break;

      case 'adicional':
        adicional = true;
        break;
      case 'forma-pagamento':
        formapagamento = true;
        break;
      case 'forma-entrega':
        formaentrega = true;
        break;
      case 'entregador':
        entregador = true;
        break;
      case 'pedido_realtime':
        pedido_realtime = true;
        break;
      case 'novo_pedido':
        novo_pedido = true;
        break;
      case 'produto':
        produto = true;
        break;
      case 'usuario':
        usuario = true;
        break;
      case 'pagamento':
        pagamento = true;
        break;
      case 'relatorio':
        relatorio = true;
        break;
      case 'impressora':
        impressora = true;
        break;

      default:
        configuracao = true;
    }
    emit(ConfiguracaoState.completo());
  }

  clearStatusMenu() {
    pedido = false;
    categoria = false;
    acompanhamento = false;
    adicional = false;
    formapagamento = false;
    formaentrega = false;
    entregador = false;
    pedido_realtime = false;
    produto = false;
    usuario = false;
    configuracao = false;
    impressora = false;
    pagamento = false;
    relatorio = false;
    novo_pedido = false;
    variacao = false;
  }

  bool pedido = false;
  bool categoria = false;
  bool acompanhamento = false;
  bool adicional = false;
  bool formapagamento = false;
  bool formaentrega = false;
  bool entregador = false;
  bool pedido_realtime = true;
  bool produto = false;
  bool usuario = false;
  bool configuracao = false;
  bool impressora = false;
  bool pagamento = false;
  bool relatorio = false;
  bool novo_pedido = false;
  bool variacao = false;
}
