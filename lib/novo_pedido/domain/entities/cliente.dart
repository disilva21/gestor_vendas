import 'package:objectbox/objectbox.dart';

@Entity()
class ClienteModel {
  int id = 0;
  String? nome;
  String? telefone;

  ClienteModel({
    this.nome,
    this.telefone,
  });
}
