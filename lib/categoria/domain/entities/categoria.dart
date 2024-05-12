import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity()
class CategoriaEntity {
  int id = 0;
  String? nome;
  String? descricao;
  String? imagem;
  bool? ativo;
  @Property(type: PropertyType.date)
  DateTime? dataCadastro = DateTime.now();
  int? orderm;
  bool? selecionado = false;
  CategoriaEntity({
    this.nome,
    this.descricao,
    this.ativo,
    this.dataCadastro,
    this.orderm,
    this.selecionado,
    this.imagem,
  });
  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(dataCadastro!);
}
