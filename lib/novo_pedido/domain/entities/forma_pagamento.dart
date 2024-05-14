import 'package:objectbox/objectbox.dart';

@Entity()
class FormaPagamentoModel {
  int id = 0;
  String? nome;
  bool? ativo;

  FormaPagamentoModel({
    this.nome,
    this.ativo,
  });
}
