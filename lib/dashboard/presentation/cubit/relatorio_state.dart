import 'package:flutter/material.dart';

import 'package:gestor_vendas/common/base_state.dart';

class RelatorioState extends BaseState {
  RelatorioState({
    String? mensagem,
    bool? inicio = false,
    bool? carregando = false,
    bool? completo = false,
    bool? sucesso = false,
    bool? falha = false,
    bool? valido = false,
    bool? cadastro = false,
  }) : super(
          mensagem: mensagem,
          carregando: carregando,
          valido: valido,
          falha: falha,
          sucesso: sucesso,
          completo: completo,
        );

  factory RelatorioState.inicio() {
    return RelatorioState(inicio: true);
  }
  factory RelatorioState.carregando() {
    return RelatorioState(carregando: true);
  }
  factory RelatorioState.completo() {
    return RelatorioState(completo: true);
  }
  factory RelatorioState.sucesso({@required String? mensagem}) {
    return RelatorioState(sucesso: true, mensagem: mensagem);
  }
  factory RelatorioState.falha({@required String? mensagem, bool? valido}) {
    return RelatorioState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory RelatorioState.valido({@required String? mensagem}) {
    return RelatorioState(valido: true, mensagem: mensagem);
  }
}
