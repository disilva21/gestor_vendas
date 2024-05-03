import 'package:flutter/material.dart';

class BaseState {
  String? mensagem;
  bool? inicio = false;
  bool? carregando = false;
  bool? completo = false;
  bool? sucesso = false;
  bool? falha = false;
  bool? valido = false;
  BaseState({
    this.mensagem,
    this.inicio,
    this.carregando = false,
    this.completo,
    this.sucesso,
    this.falha,
    this.valido,
  });

  factory BaseState.inicio() {
    return BaseState(inicio: true);
  }
  factory BaseState.carregando() {
    return BaseState(carregando: true);
  }
  factory BaseState.completo() {
    return BaseState(completo: true);
  }
  factory BaseState.sucesso({@required String? mensagem}) {
    return BaseState(sucesso: true, mensagem: mensagem);
  }
  factory BaseState.falha({@required String? mensagem, bool? valido}) {
    return BaseState(falha: true, mensagem: mensagem, valido: valido);
  }
}
