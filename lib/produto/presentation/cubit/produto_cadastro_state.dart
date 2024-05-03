import 'package:flutter/material.dart';
import 'package:gestor_vendas/produto/presentation/cubit/produto_state.dart';

class ProdutoCadastroState extends ProdutoState {
  ProdutoCadastroState({
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

  factory ProdutoCadastroState.inicio() {
    return ProdutoCadastroState(inicio: true);
  }
  factory ProdutoCadastroState.carregando() {
    return ProdutoCadastroState(carregando: true);
  }
  factory ProdutoCadastroState.completo() {
    return ProdutoCadastroState(completo: true);
  }
  factory ProdutoCadastroState.sucesso({@required String? mensagem}) {
    return ProdutoCadastroState(sucesso: true, mensagem: mensagem);
  }
  factory ProdutoCadastroState.falha({@required String? mensagem, bool? valido}) {
    return ProdutoCadastroState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory ProdutoCadastroState.valido({@required String? mensagem}) {
    return ProdutoCadastroState(valido: true, mensagem: mensagem);
  }
}
