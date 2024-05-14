class RelatorioModel {
  String? id;
  String? nome;
  bool? ativo = false;
  String? imagem;
  DateTime? deleteDate;

  RelatorioModel({
    this.id,
    this.nome,
    this.ativo,
    this.imagem,
    this.deleteDate,
  });

  factory RelatorioModel.fromMap(dynamic data, String id) {
    return RelatorioModel(
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
