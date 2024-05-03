import 'package:flutter/material.dart';

import 'package:gestor_vendas/common/base_state.dart';

class NovoPedidoState extends BaseState {
  bool? carregandoImagem = false;
  NovoPedidoState({
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

  factory NovoPedidoState.inicio() {
    return NovoPedidoState(inicio: true);
  }
  factory NovoPedidoState.carregando() {
    return NovoPedidoState(carregando: true);
  }
  factory NovoPedidoState.carregandoImagem() {
    return NovoPedidoState(carregandoImagem: true);
  }
  factory NovoPedidoState.completo() {
    return NovoPedidoState(completo: true);
  }
  factory NovoPedidoState.sucesso({@required String? mensagem}) {
    return NovoPedidoState(sucesso: true, mensagem: mensagem);
  }
  factory NovoPedidoState.falha({@required String? mensagem, bool? valido}) {
    return NovoPedidoState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory NovoPedidoState.valido({@required String? mensagem}) {
    return NovoPedidoState(valido: true, mensagem: mensagem);
  }
}
