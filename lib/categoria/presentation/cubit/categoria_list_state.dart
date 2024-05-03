import 'package:flutter/material.dart';
import 'categoria_state.dart';

class CategoriaListState extends CategoriaState {
  CategoriaListState({
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

  factory CategoriaListState.inicio() {
    return CategoriaListState(inicio: true);
  }
  factory CategoriaListState.carregando() {
    return CategoriaListState(carregando: true);
  }
  factory CategoriaListState.completo() {
    return CategoriaListState(completo: true);
  }
  factory CategoriaListState.sucesso({@required String? mensagem}) {
    return CategoriaListState(sucesso: true, mensagem: mensagem);
  }
  factory CategoriaListState.falha({@required String? mensagem, bool? valido}) {
    return CategoriaListState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory CategoriaListState.valido({@required String? mensagem}) {
    return CategoriaListState(valido: true, mensagem: mensagem);
  }
  factory CategoriaListState.cadastroSucesso({bool? isCadastro}) {
    return CategoriaListState(cadastro: isCadastro);
  }
}
