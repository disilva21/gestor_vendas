import 'package:gestor_vendas/produto/domain/entities/produto.dart';
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
  @Transient()
  int? unidadeMedida;
  @Transient()
  ProdutoEntity? produto;

  ItemPedido({
    this.idProduto,
    this.idPedido,
    this.quantidade,
    this.valorVenda,
    this.nomeProduto,
    this.unidadeMedida,
    this.produto,
  });
}
