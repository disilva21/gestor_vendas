import 'package:flutter/material.dart';
import 'categoria_state.dart';

class CategoriaCadastroState extends CategoriaState {
  CategoriaCadastroState({
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

  factory CategoriaCadastroState.inicio() {
    return CategoriaCadastroState(inicio: true);
  }
  factory CategoriaCadastroState.carregando() {
    return CategoriaCadastroState(carregando: true);
  }
  factory CategoriaCadastroState.completo() {
    return CategoriaCadastroState(completo: true);
  }
  factory CategoriaCadastroState.sucesso({@required String? mensagem}) {
    return CategoriaCadastroState(sucesso: true, mensagem: mensagem);
  }
  factory CategoriaCadastroState.falha({@required String? mensagem, bool? valido}) {
    return CategoriaCadastroState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory CategoriaCadastroState.valido({@required String? mensagem}) {
    return CategoriaCadastroState(valido: true, mensagem: mensagem);
  }
  factory CategoriaCadastroState.cadastroSucesso({bool? isCadastro}) {
    return CategoriaCadastroState(cadastro: isCadastro);
  }
}
