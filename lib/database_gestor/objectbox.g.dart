// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../categoria/domain/entities/categoria.dart';
import '../novo_pedido/domain/entities/cliente.dart';
import '../novo_pedido/domain/entities/forma_pagamento.dart';
import '../novo_pedido/domain/entities/item_pedido.dart';
import '../novo_pedido/domain/entities/pedido.dart';
import '../produto/domain/entities/produto.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 3904452162044211973),
      name: 'CategoriaEntity',
      lastPropertyId: const obx_int.IdUid(8, 7051242020462050057),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7603360845135547914),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 2532657542506138066),
            name: 'nome',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 6243334699091263301),
            name: 'descricao',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 8418146780199997114),
            name: 'imagem',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 1602183082896120802),
            name: 'ativo',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 8875512110755923613),
            name: 'dataCadastro',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 3369960921652087188),
            name: 'orderm',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 7051242020462050057),
            name: 'selecionado',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 9189646011596407543),
      name: 'Cliente',
      lastPropertyId: const obx_int.IdUid(3, 5928078411051349923),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 9015026713434551680),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 4357155569107754068),
            name: 'nome',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 5928078411051349923),
            name: 'telefone',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 2166795882843366475),
      name: 'FormaPagamento',
      lastPropertyId: const obx_int.IdUid(3, 8971694952392503029),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 8987480674869222190),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 7441329729661419187),
            name: 'nome',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 8971694952392503029),
            name: 'ativo',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(4, 1130474072324115655),
      name: 'ItemPedido',
      lastPropertyId: const obx_int.IdUid(5, 1948760533683804517),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 1191159157668292440),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 5835533787572722994),
            name: 'idProduto',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 2187186512979015848),
            name: 'idPedido',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 483977909147551780),
            name: 'quantidade',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 1948760533683804517),
            name: 'valorVenda',
            type: 8,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(5, 1255792386979914240),
      name: 'Pedido',
      lastPropertyId: const obx_int.IdUid(8, 5535263248185553300),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 2417846862582492537),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 7924738969149422300),
            name: 'idCliente',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7121287665951351466),
            name: 'descricao',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 5274017803116338112),
            name: 'idFormaPagamento',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 867170592397236047),
            name: 'jaPagou',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 9167560076408509530),
            name: 'total',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 4941439435277749945),
            name: 'statusPedido',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 5535263248185553300),
            name: 'dataCadastro',
            type: 10,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(6, 3369816714007424682),
      name: 'ProdutoEntity',
      lastPropertyId: const obx_int.IdUid(18, 2631591702310326063),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5327803450225702691),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3913082325439851283),
            name: 'categoriaId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(1, 9216148358816325933),
            relationTarget: 'CategoriaEntity'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 8280518258846729298),
            name: 'idCategoria',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7393613829166710084),
            name: 'nomeCategoria',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 8977175500153802944),
            name: 'nome',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 1026883351186484449),
            name: 'descricao',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 4216034252200553454),
            name: 'ativo',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 448215447852512795),
            name: 'imagem',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 2872136742584412640),
            name: 'deleteDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 1949706559187880581),
            name: 'valorVenda',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 4731259696972695337),
            name: 'valorCusto',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(12, 8250781583710059044),
            name: 'codigo',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(13, 1958583220893523931),
            name: 'quantidadeEstoque',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(14, 8382764870488160523),
            name: 'observacao',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(15, 4366498026681747942),
            name: 'quantidadeItem',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(16, 8992159603010296040),
            name: 'unidadeMedida',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(17, 8953789443091001610),
            name: 'quantidadePeso',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(18, 2631591702310326063),
            name: 'quantidadeVenda',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(6, 3369816714007424682),
      lastIndexId: const obx_int.IdUid(1, 9216148358816325933),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    CategoriaEntity: obx_int.EntityDefinition<CategoriaEntity>(
        model: _entities[0],
        toOneRelations: (CategoriaEntity object) => [],
        toManyRelations: (CategoriaEntity object) => {},
        getId: (CategoriaEntity object) => object.id,
        setId: (CategoriaEntity object, int id) {
          object.id = id;
        },
        objectToFB: (CategoriaEntity object, fb.Builder fbb) {
          final nomeOffset =
              object.nome == null ? null : fbb.writeString(object.nome!);
          final descricaoOffset = object.descricao == null
              ? null
              : fbb.writeString(object.descricao!);
          final imagemOffset =
              object.imagem == null ? null : fbb.writeString(object.imagem!);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nomeOffset);
          fbb.addOffset(2, descricaoOffset);
          fbb.addOffset(3, imagemOffset);
          fbb.addBool(4, object.ativo);
          fbb.addInt64(5, object.dataCadastro?.millisecondsSinceEpoch);
          fbb.addInt64(6, object.orderm);
          fbb.addBool(7, object.selecionado);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dataCadastroValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 14);
          final nomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 6);
          final descricaoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 8);
          final ativoParam =
              const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 12);
          final dataCadastroParam = dataCadastroValue == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(dataCadastroValue);
          final ordermParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 16);
          final selecionadoParam =
              const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 18);
          final imagemParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 10);
          final object = CategoriaEntity(
              nome: nomeParam,
              descricao: descricaoParam,
              ativo: ativoParam,
              dataCadastro: dataCadastroParam,
              orderm: ordermParam,
              selecionado: selecionadoParam,
              imagem: imagemParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    Cliente: obx_int.EntityDefinition<Cliente>(
        model: _entities[1],
        toOneRelations: (Cliente object) => [],
        toManyRelations: (Cliente object) => {},
        getId: (Cliente object) => object.id,
        setId: (Cliente object, int id) {
          object.id = id;
        },
        objectToFB: (Cliente object, fb.Builder fbb) {
          final nomeOffset =
              object.nome == null ? null : fbb.writeString(object.nome!);
          final telefoneOffset = object.telefone == null
              ? null
              : fbb.writeString(object.telefone!);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nomeOffset);
          fbb.addOffset(2, telefoneOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 6);
          final telefoneParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 8);
          final object = Cliente(nome: nomeParam, telefone: telefoneParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    FormaPagamento: obx_int.EntityDefinition<FormaPagamento>(
        model: _entities[2],
        toOneRelations: (FormaPagamento object) => [],
        toManyRelations: (FormaPagamento object) => {},
        getId: (FormaPagamento object) => object.id,
        setId: (FormaPagamento object, int id) {
          object.id = id;
        },
        objectToFB: (FormaPagamento object, fb.Builder fbb) {
          final nomeOffset =
              object.nome == null ? null : fbb.writeString(object.nome!);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nomeOffset);
          fbb.addBool(2, object.ativo);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 6);
          final ativoParam =
              const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 8);
          final object = FormaPagamento(nome: nomeParam, ativo: ativoParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    ItemPedido: obx_int.EntityDefinition<ItemPedido>(
        model: _entities[3],
        toOneRelations: (ItemPedido object) => [],
        toManyRelations: (ItemPedido object) => {},
        getId: (ItemPedido object) => object.id,
        setId: (ItemPedido object, int id) {
          object.id = id;
        },
        objectToFB: (ItemPedido object, fb.Builder fbb) {
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.idProduto);
          fbb.addInt64(2, object.idPedido);
          fbb.addInt64(3, object.quantidade);
          fbb.addFloat64(4, object.valorVenda);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idProdutoParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 6);
          final idPedidoParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 8);
          final quantidadeParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 10);
          final valorVendaParam = const fb.Float64Reader()
              .vTableGetNullable(buffer, rootOffset, 12);
          final object = ItemPedido(
              idProduto: idProdutoParam,
              idPedido: idPedidoParam,
              quantidade: quantidadeParam,
              valorVenda: valorVendaParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    Pedido: obx_int.EntityDefinition<Pedido>(
        model: _entities[4],
        toOneRelations: (Pedido object) => [],
        toManyRelations: (Pedido object) => {},
        getId: (Pedido object) => object.id,
        setId: (Pedido object, int id) {
          object.id = id;
        },
        objectToFB: (Pedido object, fb.Builder fbb) {
          final descricaoOffset = object.descricao == null
              ? null
              : fbb.writeString(object.descricao!);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.idCliente);
          fbb.addOffset(2, descricaoOffset);
          fbb.addInt64(3, object.idFormaPagamento);
          fbb.addBool(4, object.jaPagou);
          fbb.addFloat64(5, object.total);
          fbb.addInt64(6, object.statusPedido);
          fbb.addInt64(7, object.dataCadastro?.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dataCadastroValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 18);
          final idClienteParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 6);
          final descricaoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 8);
          final idFormaPagamentoParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 10);
          final jaPagouParam =
              const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 12);
          final dataCadastroParam = dataCadastroValue == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(dataCadastroValue);
          final statusPedidoParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 16);
          final object = Pedido(
              idCliente: idClienteParam,
              descricao: descricaoParam,
              idFormaPagamento: idFormaPagamentoParam,
              jaPagou: jaPagouParam,
              dataCadastro: dataCadastroParam,
              statusPedido: statusPedidoParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..total =
                const fb.Float64Reader().vTableGet(buffer, rootOffset, 14, 0);

          return object;
        }),
    ProdutoEntity: obx_int.EntityDefinition<ProdutoEntity>(
        model: _entities[5],
        toOneRelations: (ProdutoEntity object) => [object.categoria],
        toManyRelations: (ProdutoEntity object) => {},
        getId: (ProdutoEntity object) => object.id,
        setId: (ProdutoEntity object, int id) {
          object.id = id;
        },
        objectToFB: (ProdutoEntity object, fb.Builder fbb) {
          final nomeCategoriaOffset = object.nomeCategoria == null
              ? null
              : fbb.writeString(object.nomeCategoria!);
          final nomeOffset =
              object.nome == null ? null : fbb.writeString(object.nome!);
          final descricaoOffset = object.descricao == null
              ? null
              : fbb.writeString(object.descricao!);
          final imagemOffset =
              object.imagem == null ? null : fbb.writeString(object.imagem!);
          final observacaoOffset = object.observacao == null
              ? null
              : fbb.writeString(object.observacao!);
          fbb.startTable(19);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.categoria.targetId);
          fbb.addInt64(2, object.idCategoria);
          fbb.addOffset(3, nomeCategoriaOffset);
          fbb.addOffset(4, nomeOffset);
          fbb.addOffset(5, descricaoOffset);
          fbb.addBool(6, object.ativo);
          fbb.addOffset(7, imagemOffset);
          fbb.addInt64(8, object.deleteDate?.millisecondsSinceEpoch);
          fbb.addFloat64(9, object.valorVenda);
          fbb.addFloat64(10, object.valorCusto);
          fbb.addInt64(11, object.codigo);
          fbb.addInt64(12, object.quantidadeEstoque);
          fbb.addOffset(13, observacaoOffset);
          fbb.addInt64(14, object.quantidadeItem);
          fbb.addInt64(15, object.unidadeMedida);
          fbb.addInt64(16, object.quantidadePeso);
          fbb.addInt64(17, object.quantidadeVenda);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final deleteDateValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 20);
          final nomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 12);
          final ativoParam =
              const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 16);
          final imagemParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 18);
          final deleteDateParam = deleteDateValue == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(deleteDateValue);
          final idCategoriaParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 8);
          final valorVendaParam = const fb.Float64Reader()
              .vTableGetNullable(buffer, rootOffset, 22);
          final valorCustoParam = const fb.Float64Reader()
              .vTableGetNullable(buffer, rootOffset, 24);
          final codigoParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 26);
          final quantidadeEstoqueParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 28);
          final descricaoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 14);
          final observacaoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 30);
          final quantidadeItemParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 32);
          final unidadeMedidaParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 34);
          final quantidadePesoParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 36);
          final quantidadeVendaParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 38);
          final object = ProdutoEntity(
              nome: nomeParam,
              ativo: ativoParam,
              imagem: imagemParam,
              deleteDate: deleteDateParam,
              idCategoria: idCategoriaParam,
              valorVenda: valorVendaParam,
              valorCusto: valorCustoParam,
              codigo: codigoParam,
              quantidadeEstoque: quantidadeEstoqueParam,
              descricao: descricaoParam,
              observacao: observacaoParam,
              quantidadeItem: quantidadeItemParam,
              unidadeMedida: unidadeMedidaParam,
              quantidadePeso: quantidadePesoParam,
              quantidadeVenda: quantidadeVendaParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..nomeCategoria = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 10);
          object.categoria.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.categoria.attach(store);
          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [CategoriaEntity] entity fields to define ObjectBox queries.
class CategoriaEntity_ {
  /// see [CategoriaEntity.id]
  static final id =
      obx.QueryIntegerProperty<CategoriaEntity>(_entities[0].properties[0]);

  /// see [CategoriaEntity.nome]
  static final nome =
      obx.QueryStringProperty<CategoriaEntity>(_entities[0].properties[1]);

  /// see [CategoriaEntity.descricao]
  static final descricao =
      obx.QueryStringProperty<CategoriaEntity>(_entities[0].properties[2]);

  /// see [CategoriaEntity.imagem]
  static final imagem =
      obx.QueryStringProperty<CategoriaEntity>(_entities[0].properties[3]);

  /// see [CategoriaEntity.ativo]
  static final ativo =
      obx.QueryBooleanProperty<CategoriaEntity>(_entities[0].properties[4]);

  /// see [CategoriaEntity.dataCadastro]
  static final dataCadastro =
      obx.QueryDateProperty<CategoriaEntity>(_entities[0].properties[5]);

  /// see [CategoriaEntity.orderm]
  static final orderm =
      obx.QueryIntegerProperty<CategoriaEntity>(_entities[0].properties[6]);

  /// see [CategoriaEntity.selecionado]
  static final selecionado =
      obx.QueryBooleanProperty<CategoriaEntity>(_entities[0].properties[7]);
}

/// [Cliente] entity fields to define ObjectBox queries.
class Cliente_ {
  /// see [Cliente.id]
  static final id =
      obx.QueryIntegerProperty<Cliente>(_entities[1].properties[0]);

  /// see [Cliente.nome]
  static final nome =
      obx.QueryStringProperty<Cliente>(_entities[1].properties[1]);

  /// see [Cliente.telefone]
  static final telefone =
      obx.QueryStringProperty<Cliente>(_entities[1].properties[2]);
}

/// [FormaPagamento] entity fields to define ObjectBox queries.
class FormaPagamento_ {
  /// see [FormaPagamento.id]
  static final id =
      obx.QueryIntegerProperty<FormaPagamento>(_entities[2].properties[0]);

  /// see [FormaPagamento.nome]
  static final nome =
      obx.QueryStringProperty<FormaPagamento>(_entities[2].properties[1]);

  /// see [FormaPagamento.ativo]
  static final ativo =
      obx.QueryBooleanProperty<FormaPagamento>(_entities[2].properties[2]);
}

/// [ItemPedido] entity fields to define ObjectBox queries.
class ItemPedido_ {
  /// see [ItemPedido.id]
  static final id =
      obx.QueryIntegerProperty<ItemPedido>(_entities[3].properties[0]);

  /// see [ItemPedido.idProduto]
  static final idProduto =
      obx.QueryIntegerProperty<ItemPedido>(_entities[3].properties[1]);

  /// see [ItemPedido.idPedido]
  static final idPedido =
      obx.QueryIntegerProperty<ItemPedido>(_entities[3].properties[2]);

  /// see [ItemPedido.quantidade]
  static final quantidade =
      obx.QueryIntegerProperty<ItemPedido>(_entities[3].properties[3]);

  /// see [ItemPedido.valorVenda]
  static final valorVenda =
      obx.QueryDoubleProperty<ItemPedido>(_entities[3].properties[4]);
}

/// [Pedido] entity fields to define ObjectBox queries.
class Pedido_ {
  /// see [Pedido.id]
  static final id =
      obx.QueryIntegerProperty<Pedido>(_entities[4].properties[0]);

  /// see [Pedido.idCliente]
  static final idCliente =
      obx.QueryIntegerProperty<Pedido>(_entities[4].properties[1]);

  /// see [Pedido.descricao]
  static final descricao =
      obx.QueryStringProperty<Pedido>(_entities[4].properties[2]);

  /// see [Pedido.idFormaPagamento]
  static final idFormaPagamento =
      obx.QueryIntegerProperty<Pedido>(_entities[4].properties[3]);

  /// see [Pedido.jaPagou]
  static final jaPagou =
      obx.QueryBooleanProperty<Pedido>(_entities[4].properties[4]);

  /// see [Pedido.total]
  static final total =
      obx.QueryDoubleProperty<Pedido>(_entities[4].properties[5]);

  /// see [Pedido.statusPedido]
  static final statusPedido =
      obx.QueryIntegerProperty<Pedido>(_entities[4].properties[6]);

  /// see [Pedido.dataCadastro]
  static final dataCadastro =
      obx.QueryDateProperty<Pedido>(_entities[4].properties[7]);
}

/// [ProdutoEntity] entity fields to define ObjectBox queries.
class ProdutoEntity_ {
  /// see [ProdutoEntity.id]
  static final id =
      obx.QueryIntegerProperty<ProdutoEntity>(_entities[5].properties[0]);

  /// see [ProdutoEntity.categoria]
  static final categoria =
      obx.QueryRelationToOne<ProdutoEntity, CategoriaEntity>(
          _entities[5].properties[1]);

  /// see [ProdutoEntity.idCategoria]
  static final idCategoria =
      obx.QueryIntegerProperty<ProdutoEntity>(_entities[5].properties[2]);

  /// see [ProdutoEntity.nomeCategoria]
  static final nomeCategoria =
      obx.QueryStringProperty<ProdutoEntity>(_entities[5].properties[3]);

  /// see [ProdutoEntity.nome]
  static final nome =
      obx.QueryStringProperty<ProdutoEntity>(_entities[5].properties[4]);

  /// see [ProdutoEntity.descricao]
  static final descricao =
      obx.QueryStringProperty<ProdutoEntity>(_entities[5].properties[5]);

  /// see [ProdutoEntity.ativo]
  static final ativo =
      obx.QueryBooleanProperty<ProdutoEntity>(_entities[5].properties[6]);

  /// see [ProdutoEntity.imagem]
  static final imagem =
      obx.QueryStringProperty<ProdutoEntity>(_entities[5].properties[7]);

  /// see [ProdutoEntity.deleteDate]
  static final deleteDate =
      obx.QueryDateProperty<ProdutoEntity>(_entities[5].properties[8]);

  /// see [ProdutoEntity.valorVenda]
  static final valorVenda =
      obx.QueryDoubleProperty<ProdutoEntity>(_entities[5].properties[9]);

  /// see [ProdutoEntity.valorCusto]
  static final valorCusto =
      obx.QueryDoubleProperty<ProdutoEntity>(_entities[5].properties[10]);

  /// see [ProdutoEntity.codigo]
  static final codigo =
      obx.QueryIntegerProperty<ProdutoEntity>(_entities[5].properties[11]);

  /// see [ProdutoEntity.quantidadeEstoque]
  static final quantidadeEstoque =
      obx.QueryIntegerProperty<ProdutoEntity>(_entities[5].properties[12]);

  /// see [ProdutoEntity.observacao]
  static final observacao =
      obx.QueryStringProperty<ProdutoEntity>(_entities[5].properties[13]);

  /// see [ProdutoEntity.quantidadeItem]
  static final quantidadeItem =
      obx.QueryIntegerProperty<ProdutoEntity>(_entities[5].properties[14]);

  /// see [ProdutoEntity.unidadeMedida]
  static final unidadeMedida =
      obx.QueryIntegerProperty<ProdutoEntity>(_entities[5].properties[15]);

  /// see [ProdutoEntity.quantidadePeso]
  static final quantidadePeso =
      obx.QueryIntegerProperty<ProdutoEntity>(_entities[5].properties[16]);

  /// see [ProdutoEntity.quantidadeVenda]
  static final quantidadeVenda =
      obx.QueryIntegerProperty<ProdutoEntity>(_entities[5].properties[17]);
}