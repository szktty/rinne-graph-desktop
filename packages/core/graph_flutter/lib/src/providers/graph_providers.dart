import 'package:core_graph_common/src/context/graph_context.dart';
import 'package:core_graph_common/src/model/entity.dart';
import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/graph.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/query/graph_query.dart';
import 'package:core_graph_common/src/storage/graph_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'graph_providers.g.dart';

/// Provider that provides graph storage
///
/// This is typically set during application startup and
/// is used by graphContextProvider.
@riverpod
GraphStorage graphStorage(Ref ref) {
  // Implementation varies by application
  // Here it simply serves as a dependency injection point
  throw UnimplementedError(
    'graphStorageProvider must be overridden with concrete implementation',
  );
}

/// Provider that provides graph context
///
/// This provider provides the context for the graph database.
/// Used to share a single GraphContext instance across the entire application.
@riverpod
GraphContext graphContext(Ref ref) {
  final storage = ref.watch(graphStorageProvider);
  final context = GraphContext(storage: storage);

  // Initialization is async but executed during provider initialization
  // For actual apps, it's recommended to use the WarmUp pattern
  context.initialize();

  ref.onDispose(() async {
    await context.close();
  });

  return context;
}

/// Provider that manages active graph
///
/// This provider manages the currently active graph instance.
/// Set from the application layer and used in editors and views.
///
/// Note: keepAlive: true maintains state without automatic disposal.
@Riverpod(keepAlive: true)
class ActiveGraph extends _$ActiveGraph {
  @override
  Graph? build() => null;

  /// Set active graph
  void setGraph(Graph? graph) {
    debugPrint(
      '[ActiveGraph] Setting active graph: ${graph != null ? "${graph.nodes.length} nodes, ${graph.links.length} links" : "null"}',
    );
    state = graph;
  }

  /// Clear active graph
  void clearGraph() {
    debugPrint('[ActiveGraph] Clearing active graph');
    state = null;
  }
}

/// Provider that manages selected entity ID
///
/// This provider manages the ID of the currently selected entity.
/// Set from the application layer and used in editors.
///
/// Note: keepAlive: true maintains state without automatic disposal.
@Riverpod(keepAlive: true)
class SelectedEntityId extends _$SelectedEntityId {
  @override
  EntityId? build() => null;

  /// Set entity ID
  void setEntityId(EntityId? entityId) {
    debugPrint('[SelectedEntityId] ===== SETTING ENTITY ID =====');
    debugPrint('[SelectedEntityId] Previous: ${state?.value}');
    debugPrint('[SelectedEntityId] New: ${entityId?.value}');
    state = entityId;
    debugPrint('[SelectedEntityId] ✅ Entity ID set successfully');
  }

  /// Clear selection
  void clearSelection() {
    debugPrint('[SelectedEntityId] ===== CLEARING SELECTION =====');
    debugPrint('[SelectedEntityId] Previous: ${state?.value}');
    state = null;
    debugPrint('[SelectedEntityId] ✅ Selection cleared successfully');
  }
}

/// Provider that retrieves selected entity
///
/// Retrieves the actual entity instance from the active graph
/// and selected entity ID.
///
/// Note: keepAlive: true maintains state without automatic disposal.
@Riverpod(keepAlive: true)
Entity? selectedEntity(Ref ref) {
  final selectedEntityId = ref.watch(selectedEntityIdProvider);
  // Watch unified provider
  final activeGraph = ref.watch(activeGraphProvider);

  debugPrint('[selectedEntity] ===== PROVIDER CALLED =====');
  debugPrint(
    '[selectedEntity] selectedEntityIdProvider: $selectedEntityIdProvider',
  );
  debugPrint('[selectedEntity] activeGraphProvider: $activeGraphProvider');
  debugPrint(
    '[selectedEntity] activeGraphProvider hashCode: ${activeGraphProvider.hashCode}',
  );
  debugPrint('[selectedEntity] Selected entity ID: ${selectedEntityId?.value}');
  debugPrint('[selectedEntity] Selected entity ID object: $selectedEntityId');
  debugPrint(
    '[selectedEntity] Selected entity ID hashCode: ${selectedEntityId.hashCode}',
  );
  debugPrint(
    '[selectedEntity] Active graph: ${activeGraph != null ? "available (${activeGraph.nodes.length} nodes, ${activeGraph.links.length} links)" : "null"}',
  );
  debugPrint('[selectedEntity] Active graph object: $activeGraph');
  debugPrint('[selectedEntity] Active graph hashCode: ${activeGraph.hashCode}');

  if (selectedEntityId == null) {
    debugPrint('[selectedEntity] No entity selected - returning null');
    return null;
  }

  if (activeGraph == null) {
    debugPrint('[selectedEntity] No active graph - returning null');
    return null;
  }

  // Search in nodes
  if (activeGraph.nodes.containsKey(selectedEntityId)) {
    final entity = activeGraph.nodes[selectedEntityId];
    debugPrint('[selectedEntity] ✅ Found node: ${entity?.id}');
    return entity;
  }

  // Search in links
  if (activeGraph.links.containsKey(selectedEntityId)) {
    final entity = activeGraph.links[selectedEntityId];
    debugPrint('[selectedEntity] ✅ Found link: ${entity?.id}');
    return entity;
  }

  debugPrint('[selectedEntity] ❌ Entity not found in graph');
  debugPrint(
    '[selectedEntity] Available node IDs: ${activeGraph.nodes.keys.take(5).toList()}',
  );
  debugPrint(
    '[selectedEntity] Available link IDs: ${activeGraph.links.keys.take(5).toList()}',
  );
  return null;
}

/// Provider that provides node operations
///
/// Provider for creating, retrieving, updating, and deleting nodes through GraphContext.
@riverpod
NodeOperations nodeOperations(Ref ref) {
  final context = ref.watch(graphContextProvider);
  return NodeOperations(context);
}

/// Provider that provides link operations
///
/// Provider for creating, retrieving, updating, and deleting links through GraphContext.
@riverpod
LinkOperations linkOperations(Ref ref) {
  final context = ref.watch(graphContextProvider);
  return LinkOperations(context);
}

/// Provider that provides binary data operations
///
/// Provider for saving, retrieving, and deleting binary data through GraphContext.
@riverpod
BinaryDataOperations binaryDataOperations(Ref ref) {
  final context = ref.watch(graphContextProvider);
  return BinaryDataOperations(context);
}

/// Provider that provides transaction operations
///
/// Provider for executing transactions through GraphContext.
@riverpod
TransactionOperations transactionOperations(Ref ref) {
  final context = ref.watch(graphContextProvider);
  return TransactionOperations(context);
}

/// Provider that provides graph statistics
///
/// This provider retrieves statistics from the graph database.
/// Returns AsyncValue so UI can properly handle async state.
@riverpod
Future<StorageStatistics> graphStatistics(Ref ref) async {
  final context = ref.watch(graphContextProvider);
  return context.getStatistics();
}

/// Provider that provides available graph metadata
///
/// Retrieves metadata such as node labels, link types, and property keys.
@riverpod
Future<GraphMetadata> graphMetadata(Ref ref) async {
  final context = ref.watch(graphContextProvider);

  final results = await Future.wait([
    context.getNodeLabels(),
    context.getLinkTypes(),
    context.getPropertyKeys(),
  ]);

  return GraphMetadata(
    nodeLabels: results[0],
    linkTypes: results[1],
    propertyKeys: results[2],
  );
}

/// Factory provider for node query builder
///
/// Factory provider that generates query builders for nodes.
@riverpod
GraphQuery<Node> Function() nodeQueryBuilderFactory(Ref ref) {
  return () => GraphQuery<Node>(entityType: Node);
}

/// Factory provider for link query builder
///
/// Factory provider that generates query builders for links.
@riverpod
GraphQuery<Link> Function() linkQueryBuilderFactory(Ref ref) {
  return () => GraphQuery<Link>(entityType: Link);
}

/// Node list cache provider
///
/// Retrieves a list of nodes based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.
@riverpod
Future<List<Node>> nodesList(Ref ref, GraphQuery<Node> query) async {
  final nodeOps = ref.watch(nodeOperationsProvider);
  final result = await nodeOps.queryNodes(query);
  return result.items;
}

/// Link list cache provider
///
/// Retrieves a list of links based on specific conditions and returns as AsyncValue.
/// This provider caches query results so UI can display the latest data.
@riverpod
Future<List<Link>> linksList(Ref ref, GraphQuery<Link> query) async {
  final linkOps = ref.watch(linkOperationsProvider);
  final result = await linkOps.queryLinks(query);
  return result.items;
}

/// Class that manages node operations
class NodeOperations {
  NodeOperations(this._context);
  final GraphContext _context;

  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
  }) => _context.createNode(
    description: description,
    properties: properties,
    labels: labels,
  );

  Future<Node?> getNode(EntityId id) => _context.getNode(id);

  Future<List<Node>> getNodes(List<EntityId> ids) => _context.getNodes(ids);

  Future<void> updateNode(Node node) => _context.updateNode(node);

  Future<bool> deleteNode(EntityId id) => _context.deleteNode(id);

  Future<QueryResult<Node>> queryNodes(GraphQuery<Node> query) =>
      _context.queryNodes(query);
}

/// Class that manages link operations
class LinkOperations {
  LinkOperations(this._context);
  final GraphContext _context;

  Future<Link> createLink({
    required EntityId sourceId,
    required EntityId targetId,
    required String type,
    required EntityDescription description,
    Map<String, dynamic>? properties,
  }) => _context.createLink(
    sourceId: sourceId,
    targetId: targetId,
    type: type,
    description: description,
    properties: properties,
  );

  Future<Link?> getLink(EntityId id) => _context.getLink(id);

  Future<List<Link>> getLinks(List<EntityId> ids) => _context.getLinks(ids);

  Future<void> updateLink(Link link) => _context.updateLink(link);

  Future<bool> deleteLink(EntityId id) => _context.deleteLink(id);

  Future<QueryResult<Link>> queryLinks(GraphQuery<Link> query) =>
      _context.queryLinks(query);

  Future<Node?> getSourceNode(Link link) => _context.getSourceNode(link);

  Future<Node?> getDestinationNode(Link link) =>
      _context.getDestinationNode(link);

  Future<(Node?, Node?)> getLinkNodes(Link link) => _context.getLinkNodes(link);
}

/// Class that manages binary data operations
class BinaryDataOperations {
  BinaryDataOperations(this._context);
  final GraphContext _context;

  Future<EntityId> storeBinaryData(
    Uint8List data, {
    String? mimeType,
    String? filename,
  }) => _context.storeBinaryData(data, mimeType: mimeType, filename: filename);

  Future<Uint8List?> getBinaryData(EntityId id) => _context.getBinaryData(id);

  Stream<Uint8List> getBinaryDataStream(EntityId id) =>
      _context.getBinaryDataStream(id);

  Future<bool> deleteBinaryData(EntityId id) => _context.deleteBinaryData(id);
}

/// Class that manages transaction operations
class TransactionOperations {
  TransactionOperations(this._context);
  final GraphContext _context;

  Future<T> transaction<T>(Future<T> Function(GraphContext) operations) =>
      _context.transaction(operations);

  Future<T> readTransaction<T>(Future<T> Function(GraphContext) operations) =>
      _context.readTransaction(operations);
}

/// Class representing graph metadata
class GraphMetadata {
  const GraphMetadata({
    required this.nodeLabels,
    required this.linkTypes,
    required this.propertyKeys,
  });
  final List<String> nodeLabels;
  final List<String> linkTypes;
  final List<String> propertyKeys;
}
