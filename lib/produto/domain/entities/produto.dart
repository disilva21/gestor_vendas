import 'dart:ffi';

import 'package:gestor_vendas/categoria/domain/entities/categoria.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import '../enum/unidade_medida.dart';

@Entity()
class ProdutoModel {
  int id = 0;
  final categoria = ToOne<CategoriaModel>();
  int? idCategoria;
  String? nomeCategoria;
  String? nome;
  String? descricao;
  bool? ativo = true;
  String? imagem;
  @Property(type: PropertyType.date)
  DateTime? deleteDate;

  double? valorVenda;
  double? valorCusto;
  int? codigo;
  int? quantidadeEstoque;

  String? observacao;
  int? quantidadeItem = 1;

  int? unidadeMedida;
  int? quantidadePeso;
  int? quantidadeVenda;

  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(deleteDate!);

  ProdutoModel({
    this.nome,
    this.ativo,
    this.imagem,
    this.deleteDate,
    this.idCategoria,
    this.valorVenda,
    this.valorCusto,
    this.codigo,
    this.quantidadeEstoque,
    this.descricao,
    this.observacao,
    this.quantidadeItem = 1,
    this.unidadeMedida,
    this.quantidadePeso,
    this.quantidadeVenda = 0,
  });
}

class UnidadeMedida {
  int? id;
  String? nome;
  String? sigla;

  UnidadeMedida({
    this.id,
    this.nome,
    this.sigla,
  });

  factory UnidadeMedida.fromMap(dynamic data) {
    return UnidadeMedida(
      id: data!['id'] == null ? null : data['id'],
      nome: data!['nome'] == null ? null : data['nome'],
      sigla: data!['sigla'] == null ? null : data['sigla'],
    );
  }
  Map toMap() {
    return {
      'id': id,
      'nome': nome,
      'sigla': sigla,
    };
  }
}
