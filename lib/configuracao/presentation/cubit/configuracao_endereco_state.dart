import 'package:flutter/material.dart';

import 'configuracao_state.dart';

class ConfiguracaoEnderecoState extends ConfiguracaoState {
  bool nomeCardapioGravado = false;
  bool nomeCardapioValido = false;
  bool enderecoSucesso = false;
  ConfiguracaoEnderecoState({
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
    this.enderecoSucesso = false,
  }) : super(
          mensagem: mensagem,
          carregando: carregando,
          valido: valido,
          falha: falha,
          sucesso: sucesso,
          completo: completo,
        );

  factory ConfiguracaoEnderecoState.inicio() {
    return ConfiguracaoEnderecoState(inicio: true);
  }
  factory ConfiguracaoEnderecoState.carregando() {
    return ConfiguracaoEnderecoState(carregando: true);
  }
  factory ConfiguracaoEnderecoState.completo() {
    return ConfiguracaoEnderecoState(completo: true);
  }
  factory ConfiguracaoEnderecoState.sucesso({@required String? mensagem}) {
    return ConfiguracaoEnderecoState(sucesso: true, mensagem: mensagem);
  }
  factory ConfiguracaoEnderecoState.falha({@required String? mensagem, bool? valido}) {
    return ConfiguracaoEnderecoState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory ConfiguracaoEnderecoState.valido({@required String? mensagem}) {
    return ConfiguracaoEnderecoState(valido: true, mensagem: mensagem);
  }
  factory ConfiguracaoEnderecoState.cadastroSucesso({bool? isCadastro}) {
    return ConfiguracaoEnderecoState(cadastro: isCadastro);
  }
  factory ConfiguracaoEnderecoState.cadastroEnderecoSucesso({bool? endereco}) {
    return ConfiguracaoEnderecoState(enderecoSucesso: endereco!);
  }
  factory ConfiguracaoEnderecoState.nomeCardapioGravado({@required String? mensagem, @required bool? nomeCardapioGravado}) {
    return ConfiguracaoEnderecoState(nomeCardapioGravado: nomeCardapioGravado!, mensagem: mensagem);
  }
  factory ConfiguracaoEnderecoState.nomeCardapioValido({@required String? mensagem, @required bool? nomeCardapioValido}) {
    return ConfiguracaoEnderecoState(nomeCardapioValido: nomeCardapioValido!, mensagem: mensagem);
  }
}
