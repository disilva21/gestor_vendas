import 'package:flutter/material.dart';

import 'configuracao_state.dart';

class ConfiguracaoDadosState extends ConfiguracaoState {
  bool nomeCardapioGravado = false;
  bool nomeCardapioValido = false;
  bool personalizacaoSucesso = false;
  ConfiguracaoDadosState({
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

  factory ConfiguracaoDadosState.inicio() {
    return ConfiguracaoDadosState(inicio: true);
  }
  factory ConfiguracaoDadosState.carregando() {
    return ConfiguracaoDadosState(carregando: true);
  }
  factory ConfiguracaoDadosState.completo() {
    return ConfiguracaoDadosState(completo: true);
  }
  factory ConfiguracaoDadosState.sucesso({@required String? mensagem}) {
    return ConfiguracaoDadosState(sucesso: true, mensagem: mensagem);
  }
  factory ConfiguracaoDadosState.falha({@required String? mensagem, bool? valido}) {
    return ConfiguracaoDadosState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory ConfiguracaoDadosState.valido({@required String? mensagem}) {
    return ConfiguracaoDadosState(valido: true, mensagem: mensagem);
  }
  factory ConfiguracaoDadosState.cadastroSucesso({bool? isCadastro}) {
    return ConfiguracaoDadosState(cadastro: isCadastro);
  }
  factory ConfiguracaoDadosState.personalizacaoSucesso({bool? personalizacao}) {
    return ConfiguracaoDadosState(personalizacaoSucesso: personalizacao!);
  }
  factory ConfiguracaoDadosState.nomeCardapioGravado({@required String? mensagem, @required bool? nomeCardapioGravado}) {
    return ConfiguracaoDadosState(nomeCardapioGravado: nomeCardapioGravado!, mensagem: mensagem);
  }
  factory ConfiguracaoDadosState.nomeCardapioValido({@required String? mensagem, @required bool? nomeCardapioValido}) {
    return ConfiguracaoDadosState(nomeCardapioValido: nomeCardapioValido!, mensagem: mensagem);
  }
}
