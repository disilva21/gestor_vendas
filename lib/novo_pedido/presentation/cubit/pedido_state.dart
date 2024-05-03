import 'package:flutter/material.dart';

import 'package:gestor_vendas/common/base_state.dart';

class PedidoState extends BaseState {
  bool? carregandoImagem = false;
  PedidoState({
    String? mensagem,
    bool? inicio = false,
    bool? carregando = false,
    bool? completo = false,
    bool? sucesso = false,
    bool? falha = false,
    bool? valido = false,
    bool? cadastro = false,
    this.carregandoImagem = false,
  }) : super(
          mensagem: mensagem,
          carregando: carregando,
          valido: valido,
          falha: falha,
          sucesso: sucesso,
          completo: completo,
        );

  factory PedidoState.inicio() {
    return PedidoState(inicio: true);
  }
  factory PedidoState.carregando() {
    return PedidoState(carregando: true);
  }
  factory PedidoState.carregandoImagem() {
    return PedidoState(carregandoImagem: true);
  }
  factory PedidoState.completo() {
    return PedidoState(completo: true);
  }
  factory PedidoState.sucesso({@required String? mensagem}) {
    return PedidoState(sucesso: true, mensagem: mensagem);
  }
  factory PedidoState.falha({@required String? mensagem, bool? valido}) {
    return PedidoState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory PedidoState.valido({@required String? mensagem}) {
    return PedidoState(valido: true, mensagem: mensagem);
  }
}
