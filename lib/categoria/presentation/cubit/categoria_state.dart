import 'package:flutter/material.dart';

import '../../../common/base_state.dart';

class CategoriaState extends BaseState {
  CategoriaState({
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

  factory CategoriaState.inicio() {
    return CategoriaState(inicio: true);
  }
  factory CategoriaState.carregando() {
    return CategoriaState(carregando: true);
  }
  factory CategoriaState.completo() {
    return CategoriaState(completo: true);
  }
  factory CategoriaState.sucesso({@required String? mensagem}) {
    return CategoriaState(sucesso: true, mensagem: mensagem);
  }
  factory CategoriaState.falha({@required String? mensagem, bool? valido}) {
    return CategoriaState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory CategoriaState.valido({@required String? mensagem}) {
    return CategoriaState(valido: true, mensagem: mensagem);
  }
}
