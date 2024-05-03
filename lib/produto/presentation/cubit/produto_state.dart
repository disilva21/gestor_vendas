import 'package:flutter/material.dart';
import 'package:gestor_pdv/common/base_state.dart';

class ProdutoState extends BaseState {
  ProdutoState({
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

  factory ProdutoState.inicio() {
    return ProdutoState(inicio: true);
  }
  factory ProdutoState.carregando() {
    return ProdutoState(carregando: true);
  }
  factory ProdutoState.completo() {
    return ProdutoState(completo: true);
  }
  factory ProdutoState.sucesso({@required String? mensagem}) {
    return ProdutoState(sucesso: true, mensagem: mensagem);
  }
  factory ProdutoState.falha({@required String? mensagem, bool? valido}) {
    return ProdutoState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory ProdutoState.valido({@required String? mensagem}) {
    return ProdutoState(valido: true, mensagem: mensagem);
  }
  factory ProdutoState.cadastroSucesso({bool? isCadastro}) {
    return ProdutoState(cadastro: isCadastro);
  }
}
