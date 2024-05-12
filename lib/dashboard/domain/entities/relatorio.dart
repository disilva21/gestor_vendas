class RelatorioEntity {
  String? id;
  String? nome;
  bool? ativo = false;
  String? imagem;
  DateTime? deleteDate;

  RelatorioEntity({
    this.id,
    this.nome,
    this.ativo,
    this.imagem,
    this.deleteDate,
  });

  factory RelatorioEntity.fromMap(dynamic data, String id) {
    return RelatorioEntity(
      id: id.isEmpty
          ? data!['id'] == null
              ? null
              : data!['id']
          : id,
      ativo: data!['ativo'] == null ? null : data['ativo'],
      nome: data!['nome'] == null ? null : data['nome'],
      imagem: data!['imagem'] == null ? null : data['imagem'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'ativo': ativo,
      'nome': nome,
      'imagem': imagem,
    };
  }
}
