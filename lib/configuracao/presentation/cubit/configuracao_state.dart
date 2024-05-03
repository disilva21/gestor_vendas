import 'package:flutter/material.dart';
import 'package:gestor_vendas/common/base_state.dart';

class ConfiguracaoState extends BaseState {
  bool nomeCardapioGravado = false;
  bool nomeCardapioValido = false;
  bool personalizacaoSucesso = false;
  ConfiguracaoState({
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

  factory ConfiguracaoState.inicio() {
    return ConfiguracaoState(inicio: true);
  }
  factory ConfiguracaoState.carregando() {
    return ConfiguracaoState(carregando: true);
  }
  factory ConfiguracaoState.completo() {
    return ConfiguracaoState(completo: true);
  }
  factory ConfiguracaoState.sucesso({@required String? mensagem}) {
    return ConfiguracaoState(sucesso: true, mensagem: mensagem);
  }
  factory ConfiguracaoState.falha({@required String? mensagem, bool? valido}) {
    return ConfiguracaoState(falha: true, mensagem: mensagem, valido: valido);
  }
  factory ConfiguracaoState.valido({@required String? mensagem}) {
    return ConfiguracaoState(valido: true, mensagem: mensagem);
  }
  factory ConfiguracaoState.cadastroSucesso({bool? isCadastro}) {
    return ConfiguracaoState(cadastro: isCadastro);
  }
  factory ConfiguracaoState.personalizacaoSucesso({bool? personalizacao}) {
    return ConfiguracaoState(personalizacaoSucesso: personalizacao!);
  }
  factory ConfiguracaoState.nomeCardapioGravado({@required String? mensagem, @required bool? nomeCardapioGravado}) {
    return ConfiguracaoState(nomeCardapioGravado: nomeCardapioGravado!, mensagem: mensagem);
  }
  factory ConfiguracaoState.nomeCardapioValido({@required String? mensagem, @required bool? nomeCardapioValido}) {
    return ConfiguracaoState(nomeCardapioValido: nomeCardapioValido!, mensagem: mensagem);
  }
}
