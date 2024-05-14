import 'package:gestor_vendas/db_gestor/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class ObjectBoxDatabase {
  Store? _store;

  Future<Store> getStore() async {
    // _store!.close();

    // _store!.runInTransaction(TxMode.write, () {
    //   _store!.box<CategoriaEntity>().removeAll();
    //   _store!.box<ItemPedido>().removeAll();
    //   _store!.box<FormaPagamento>().removeAll();
    //   _store!.box<Cliente>().removeAll();
    //   _store!.box<Pedido>().removeAll();
    // });
    return _store ??= await openStore();
  }
}
