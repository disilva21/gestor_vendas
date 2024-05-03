import 'package:objectbox/objectbox.dart';

@Entity()
class Cliente {
  int id = 0;
  String? nome;
  String? telefone;

  Cliente({
    this.nome,
    this.telefone,
  });
}
