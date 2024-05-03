import 'package:flutter/material.dart';
import 'package:gestor_vendas/produto/presentation/cubit/produto_state.dart';

class ProdutoListState extends ProdutoState {
  ProdutoListState({
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

  factory ProdutoListState.inicio() {
    return ProdutoListState(inicio: true);
  }
  factory ProdutoListState.carregando() {
    return ProdutoListState(carregando: true);
  }
  factory ProdutoListState.completo() {
    return ProdutoListState(completo: true);
  }
  factory ProdutoListState.sucesso({@required String? mensagem}) {
    return ProdutoListState(sucesso: true, mensagem: mensagem);
  }
  factory ProdutoListState.falha({@required String? mensagem, bool? valido}) {
    return ProdutoListState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory ProdutoListState.valido({@required String? mensagem}) {
    return ProdutoListState(valido: true, mensagem: mensagem);
  }
}
