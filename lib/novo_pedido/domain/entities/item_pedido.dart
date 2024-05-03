import 'package:objectbox/objectbox.dart';

@Entity()
class ItemPedido {
  int id = 0;
  int? idProduto;
  int? idPedido;
  int? quantidade;
  double? valorVenda;
  @Transient()
  String? nomeProduto;

  ItemPedido({
    this.idProduto,
    this.idPedido,
    this.quantidade,
    this.valorVenda,
    this.nomeProduto,
  });
}
