import '../entities/categoria.dart';

abstract class ICategoriaRepository {
  Future<void> cadastrar(CategoriaModel categoria);
  Future<void> editar(CategoriaModel categoria);
  Future<List<CategoriaModel>?> carregarCategorias();
  Future<bool> alterarStatus(CategoriaModel item);
}
