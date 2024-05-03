import 'package:flutter/material.dart';

import 'configuracao_state.dart';

class ConfiguracaoCardapioState extends ConfiguracaoState {
  bool nomeCardapioGravado = false;
  bool nomeCardapioValido = false;
  bool personalizacaoSucesso = false;
  ConfiguracaoCardapioState({
    String? mensagem,
    bool? inicio = false,
    bool? carregando = false,
    bool? completo = false,
    bool? sucesso = false,
    bool? falha = false,
    bool? valido = false,
    bool? cadastro = false,
    this.nomeCardapioGravado = false,
    this.nomeCardapioValido = false,
    this.personalizacaoSucesso = false,
  }) : super(
          mensagem: mensagem,
          carregando: carregando,
          valido: valido,
          falha: falha,
          sucesso: sucesso,
          completo: completo,
        );

  factory ConfiguracaoCardapioState.inicio() {
    return ConfiguracaoCardapioState(inicio: true);
  }
  factory ConfiguracaoCardapioState.carregando() {
    return ConfiguracaoCardapioState(carregando: true);
  }
  factory ConfiguracaoCardapioState.completo() {
    return ConfiguracaoCardapioState(completo: true);
  }
  factory ConfiguracaoCardapioState.sucesso({@required String? mensagem}) {
    return ConfiguracaoCardapioState(sucesso: true, mensagem: mensagem);
  }
  factory ConfiguracaoCardapioState.falha({@required String? mensagem, bool? valido}) {
    return ConfiguracaoCardapioState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory ConfiguracaoCardapioState.valido({@required String? mensagem}) {
    return ConfiguracaoCardapioState(valido: true, mensagem: mensagem);
  }
  factory ConfiguracaoCardapioState.cadastroSucesso({bool? isCadastro}) {
    return ConfiguracaoCardapioState(cadastro: isCadastro);
  }
  factory ConfiguracaoCardapioState.personalizacaoSucesso({bool? personalizacao}) {
    return ConfiguracaoCardapioState(personalizacaoSucesso: personalizacao!);
  }
  factory ConfiguracaoCardapioState.nomeCardapioGravado({@required String? mensagem, @required bool? nomeCardapioGravado}) {
    return ConfiguracaoCardapioState(nomeCardapioGravado: nomeCardapioGravado!, mensagem: mensagem);
  }
  factory ConfiguracaoCardapioState.nomeCardapioValido({@required String? mensagem, @required bool? nomeCardapioValido}) {
    return ConfiguracaoCardapioState(nomeCardapioValido: nomeCardapioValido!, mensagem: mensagem);
  }
}
