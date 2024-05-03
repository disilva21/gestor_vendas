

import '../entities/categoria.dart';

abstract class ICategoriaRepository {
  Future<void> cadastrar(CategoriaEntity categoria);
  Future<void> editar(CategoriaEntity categoria);
  Future<List<CategoriaEntity>?> carregarCategorias();
  Future<bool> alterarStatus(CategoriaEntity item);
}
