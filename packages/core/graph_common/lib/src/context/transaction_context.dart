import 'dart:typed_data';

import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';

abstract class TransactionContext {
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
  });

  Future<Node?> getNode(EntityId id);

  Future<List<Node>> getNodes(List<EntityId> ids);

  Future<void> updateNode(Node node);

  Future<bool> deleteNode(EntityId id);

  Future<Link> createLink({
    required EntityId sourceId,
    required EntityId targetId,
    required String type,
    required EntityDescription description,
    Map<String, dynamic>? properties,
  });

  Future<Link?> getLink(EntityId id);

  Future<List<Link>> getLinks(List<EntityId> ids);

  Future<void> updateLink(Link link);

  Future<bool> deleteLink(EntityId id);

  Future<EntityId> storeBinaryData(
    Uint8List data, {
    String? mimeType,
    String? filename,
  });

  Future<Uint8List?> getBinaryData(EntityId id);

  Stream<Uint8List> getBinaryDataStream(EntityId id);

  Future<bool> deleteBinaryData(EntityId id);
}
