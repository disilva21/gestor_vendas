import 'package:objectbox/objectbox.dart';

@Entity()
class FormaPagamento {
  int id = 0;
  String? nome;
  bool? ativo;

  FormaPagamento({
    this.nome,
    this.ativo,
  });
}
