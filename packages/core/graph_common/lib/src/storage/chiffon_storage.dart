/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core_graph_common/src/model/entity.dart';
import 'package:core_graph_common/src/model/entity_description.dart';
import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/model/property.dart';
import 'package:core_graph_common/src/model/property_description.dart';
import 'package:core_graph_common/src/model/property_set.dart';
import 'package:core_graph_common/src/model/property_type.dart';
import 'package:core_graph_common/src/query/graph_query.dart';
import 'package:core_graph_common/src/query/chiffon_query_converter.dart';
import 'package:core_graph_common/src/storage/graph_storage.dart';
import 'package:core_graph_common/src/storage/chiffon_transaction.dart';
import 'package:chiffondb/chiffondb.dart';

/// GraphStorage implementation backed by ChiffonDB.
class ChiffonStorage implements GraphStorage {
  ChiffonStorage({required String path, required String schema})
    : _path = path,
      _schema = schema;

  final String _path;
  final String _schema;

  Connection? _db;
  bool _isInitialized = false;

  /// EntityId (UUIDv7) → RecordId map for nodes (in-memory).
  final Map<String, RecordId> _nodeIdMap = {};

  /// EntityId (UUIDv7) → RecordId map for links (in-memory).
  final Map<String, RecordId> _linkIdMap = {};

  /// Binary data stored in memory (MVP: DB blob storage deferred).
  final Map<EntityId, Uint8List> _binaryData = {};
  final Map<EntityId, String> _binaryMimeTypes = {};
  final Map<EntityId, String> _binaryFilenames = {};

  // ---- GraphStorage interface ----

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    // Callers that arrive while the first initialize is still running await
    // that same run instead of starting another. Without this, the
    // `_isInitialized` flag — only set at the very end — lets a second caller
    // straight through to `Connection.open`, and ChiffonDB refuses to open one
    // file twice in a process. It also means a caller can no longer proceed
    // with half-built id maps, which made deletes fail by reporting the node
    // as missing.
    return _initialization ??= _initialize().whenComplete(() {
      _initialization = null;
    });
  }

  /// The in-flight [initialize] run, if one has not finished yet.
  Future<void>? _initialization;

  Future<void> _initialize() async {
    final file = File(_path);
    if (await file.exists()) {
      _db = await Connection.open(path: _path);
    } else {
      _db = await Connection.create(path: _path);
      await _db!.applySchema(schemaText: _schema);
    }
    await _rebuildIdMaps();
    _isInitialized = true;
  }

  @override
  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
    _nodeIdMap.clear();
    _linkIdMap.clear();
    _binaryData.clear();
    _binaryMimeTypes.clear();
    _binaryFilenames.clear();
    _isInitialized = false;
  }

  @override
  Future<bool> isReady() async => _isInitialized && _db != null;

  @override
  Future<Node> createNode({
    required EntityDescription description,
    Map<String, dynamic>? properties,
    Set<String>? labels,
    String? customId,
  }) async {
    _checkInitialized();
    final id = EntityId();
    final now = DateTime.now();

    // The user's node labels become dynamic labels on the fixed `_Entity` node
    // type; ChiffonDB mints an id for any unknown name without a schema
    // migration. Prefer the explicit `labels`; only fall back to
    // `description.type` when no labels are given, because some callers pass a
    // meaningless placeholder there (e.g. 'node') that must not pollute the
    // label set. The type name is always kept in the `app_type` property.
    final userLabels = <String>{...?labels};
    if (userLabels.isEmpty) {
      userLabels.add(description.type);
    }

    final props = <String, dynamic>{
      'app_id': id.value,
      if (customId != null) 'app_custom_id': customId,
      // Primary type name, kept in a property so traversal results (which return
      // properties, not topology labels) can still recover a label.
      'app_type': description.type,
      'app_created_at': now.millisecondsSinceEpoch,
      'app_updated_at': now.millisecondsSinceEpoch,
      'props': {...?properties},
    };

    final result = await _db!.insertNodeWithDynamicLabels(
      primaryType: '_Entity',
      additionalLabels: userLabels.toList(),
      propsJson: jsonEncode(props),
    );

    _nodeIdMap[id.value] = result.rid;
    return _buildNodeFromRaw(id: id, props: props, labels: userLabels);
  }

  @override
  Future<Node?> getNode(EntityId id) async {
    _checkInitialized();
    final rid = _nodeIdMap[id.value];
    if (rid == null) return null;

    final propsJson = await _db!.getNodeProperties(rid: rid);
    final props = jsonDecode(propsJson) as Map<String, dynamic>;
    final labelsJson = await _db!.getNodeLabels(rid: rid);
    final labels = (jsonDecode(labelsJson) as List).cast<String>().toSet();
    return _buildNodeFromRaw(id: id, props: props, labels: labels);
  }

  @override
  Future<Node?> getNodeByCustomId(String customId) async {
    _checkInitialized();
    for (final entry in _nodeIdMap.entries) {
      final propsJson = await _db!.getNodeProperties(rid: entry.value);
      final props = jsonDecode(propsJson) as Map<String, dynamic>;
      if (props['app_custom_id'] == customId) {
        final id = EntityId.fromString(entry.key);
        final labelsJson = await _db!.getNodeLabels(rid: entry.value);
        final labels = (jsonDecode(labelsJson) as List).cast<String>().toSet();
        return _buildNodeFromRaw(id: id, props: props, labels: labels);
      }
    }
    return null;
  }

  @override
  Future<List<Node>> getNodes(List<EntityId> ids) async {
    _checkInitialized();
    final nodes = <Node>[];
    for (final id in ids) {
      final node = await getNode(id);
      if (node != null) nodes.add(node);
    }
    return nodes;
  }

  @override
  Future<void> updateNode(Node node) async {
    _checkInitialized();
    final rid = _nodeIdMap[node.id.value];
    if (rid == null) return;

    // Preserve app_created_at from existing data
    final existingJson = await _db!.getNodeProperties(rid: rid);
    final existing = jsonDecode(existingJson) as Map<String, dynamic>;

    final props = <String, dynamic>{
      'app_id': node.id.value,
      if (node.customId != null) 'app_custom_id': node.customId!,
      'app_type': node.description.type,
      if (existing.containsKey('app_created_at'))
        'app_created_at': existing['app_created_at'],
      'app_updated_at': DateTime.now().millisecondsSinceEpoch,
      'props': _propertySetToMap(node.properties),
    };

    await _db!.updateNodeProperties(rid: rid, propsJson: jsonEncode(props));
  }

  @override
  Future<bool> deleteNode(EntityId id) async {
    _checkInitialized();
    final rid = _nodeIdMap[id.value];
    if (rid == null) return false;

    // ChiffonDB cascades: deleting a node also deletes every edge touching it
    // (chiffondb-core's delete_node collects in- and out-edges). The edges are
    // therefore gone from the database, but their entries in [_linkIdMap] would
    // survive as RecordIds pointing at freed slots — and getLink,
    // getLinkByCustomId, getLinkTypes and getPropertyKeys all read edges
    // straight from that map. Collect the doomed edges *before* the delete,
    // while the topology can still be queried, and drop them afterwards.
    final cascadedLinkIds = await _linkIdsConnectedTo(rid);

    await _db!.deleteNode(rid: rid);
    _nodeIdMap.remove(id.value);
    for (final linkId in cascadedLinkIds) {
      _linkIdMap.remove(linkId);
    }
    return true;
  }

  /// EntityIds of the links whose edge has [nodeRid] at either end.
  ///
  /// Returns a set so a self-loop — an edge whose endpoints are both
  /// [nodeRid] — is reported once rather than twice.
  Future<Set<String>> _linkIdsConnectedTo(RecordId nodeRid) async {
    final connected = <String>{};
    for (final entry in _linkIdMap.entries) {
      final endpointsJson = await _db!.getEdgeEndpoints(rid: entry.value);
      final endpoints = jsonDecode(endpointsJson) as Map<String, dynamic>;
      if (_isSameRecord(endpoints['from'], nodeRid) ||
          _isSameRecord(endpoints['to'], nodeRid)) {
        connected.add(entry.key);
      }
    }
    return connected;
  }

  /// Whether the `{"page":…,"slot":…}` object [raw] denotes [rid].
  ///
  /// The endpoints arrive as decoded JSON, so they are compared field by field
  /// rather than by constructing a [RecordId] to match against.
  bool _isSameRecord(Object? raw, RecordId rid) {
    if (raw is! Map<String, dynamic>) return false;
    final page = raw['page'];
    final slot = raw['slot'];
    if (page is! num || slot is! num) return false;
    return page.toInt() == rid.page && slot.toInt() == rid.slot;
  }

  @override
  Future<Link> createLink({
    required EntityId sourceId,
    required EntityId targetId,
    required String type,
    required EntityDescription description,
    Map<String, dynamic>? properties,
    String? customId,
  }) async {
    _checkInitialized();
    final fromRid = _nodeIdMap[sourceId.value];
    final toRid = _nodeIdMap[targetId.value];
    if (fromRid == null || toRid == null) {
      throw ArgumentError('Source or target node not found');
    }

    final id = EntityId();
    final now = DateTime.now();
    final props = <String, dynamic>{
      'app_id': id.value,
      if (customId != null) 'app_custom_id': customId,
      'app_type': type,
      'app_source_id': sourceId.value,
      'app_target_id': targetId.value,
      'app_created_at': now.millisecondsSinceEpoch,
      'app_updated_at': now.millisecondsSinceEpoch,
      'props': {...?properties},
    };

    // All edges use the fixed `_Link` type; the user's edge type is attached as
    // a dynamic label (and kept in `app_type` for read-back).
    final rid = await _db!.insertEdge(
      typeName: '_Link',
      from: fromRid,
      to: toRid,
      propsJson: jsonEncode(props),
    );
    await _db!.addEdgeLabelDynamic(rid: rid, typeName: type);

    _linkIdMap[id.value] = rid;
    return _buildLinkFromRaw(id: id, props: props);
  }

  @override
  Future<Link?> getLink(EntityId id) async {
    _checkInitialized();
    final rid = _linkIdMap[id.value];
    if (rid == null) return null;

    final propsJson = await _db!.getEdgeProperties(rid: rid);
    final props = jsonDecode(propsJson) as Map<String, dynamic>;
    return _buildLinkFromRaw(id: id, props: props);
  }

  @override
  Future<Link?> getLinkByCustomId(String customId) async {
    _checkInitialized();
    for (final entry in _linkIdMap.entries) {
      final propsJson = await _db!.getEdgeProperties(rid: entry.value);
      final props = jsonDecode(propsJson) as Map<String, dynamic>;
      if (props['app_custom_id'] == customId) {
        final id = EntityId.fromString(entry.key);
        return _buildLinkFromRaw(id: id, props: props);
      }
    }
    return null;
  }

  @override
  Future<List<Link>> getLinks(List<EntityId> ids) async {
    _checkInitialized();
    final links = <Link>[];
    for (final id in ids) {
      final link = await getLink(id);
      if (link != null) links.add(link);
    }
    return links;
  }

  @override
  Future<void> updateLink(Link link) async {
    _checkInitialized();
    final rid = _linkIdMap[link.id.value];
    if (rid == null) return;

    final existingJson = await _db!.getEdgeProperties(rid: rid);
    final existing = jsonDecode(existingJson) as Map<String, dynamic>;

    final props = <String, dynamic>{
      'app_id': link.id.value,
      if (link.customId != null) 'app_custom_id': link.customId!,
      'app_type': link.type,
      'app_source_id': link.sourceId.value,
      'app_target_id': link.targetId.value,
      if (existing.containsKey('app_created_at'))
        'app_created_at': existing['app_created_at'],
      'app_updated_at': DateTime.now().millisecondsSinceEpoch,
      'props': _propertySetToMap(link.properties),
    };

    await _db!.updateEdgeProperties(rid: rid, propsJson: jsonEncode(props));
  }

  @override
  Future<bool> deleteLink(EntityId id) async {
    _checkInitialized();
    final rid = _linkIdMap[id.value];
    if (rid == null) return false;

    await _db!.deleteEdge(rid: rid);
    _linkIdMap.remove(id.value);
    return true;
  }

  @override
  Future<QueryResult<Node>> queryNodes(GraphQuery<Node> query) async {
    _checkInitialized();
    final command = ChiffonQueryConverter.toTraversalCommand(query);
    final resultJson = await _db!.executeTraversal(
      commandJson: jsonEncode(command),
    );
    final results = jsonDecode(resultJson) as List;
    final nodes = <Node>[];
    for (final r in results) {
      final props = _rowProps(r as Map<String, dynamic>);
      final appId = props['app_id'] as String?;
      final id = appId != null ? EntityId.fromString(appId) : EntityId();
      // Traversal results carry properties only, not topology labels, so read
      // the node's real (user) labels via its RecordId. Fall back to the
      // app_type property when the RecordId is unknown.
      final labels = await _resolveNodeLabels(appId, props);
      nodes.add(_buildNodeFromRaw(id: id, props: props, labels: labels));
    }

    return QueryResult(items: nodes, totalCount: nodes.length, hasMore: false);
  }

  /// Reads a node's user labels from the topology layer via its RecordId,
  /// excluding the fixed `_Entity` meta type. Falls back to `app_type` when the
  /// RecordId cannot be resolved (e.g. a node not in the in-memory map).
  Future<Set<String>> _resolveNodeLabels(
    String? appId,
    Map<String, dynamic> props,
  ) async {
    final rid = appId != null ? _nodeIdMap[appId] : null;
    if (rid == null) return _labelsFromProps(props);
    final labelsJson = await _db!.getNodeLabels(rid: rid);
    final labels =
        (jsonDecode(labelsJson) as List).cast<String>().toSet()
          ..remove('_Entity');
    return labels;
  }

  @override
  Future<QueryResult<Link>> queryLinks(GraphQuery<Link> query) async {
    _checkInitialized();
    final command = ChiffonQueryConverter.toTraversalCommand(query);
    final resultJson = await _db!.executeTraversal(
      commandJson: jsonEncode(command),
    );
    final results = jsonDecode(resultJson) as List;
    final links =
        results.map((r) {
          final props = _rowProps(r as Map<String, dynamic>);
          final appId = props['app_id'] as String?;
          final id = appId != null ? EntityId.fromString(appId) : EntityId();
          return _buildLinkFromRaw(id: id, props: props);
        }).toList();

    return QueryResult(items: links, totalCount: links.length, hasMore: false);
  }

  @override
  Future<T> transaction<T>(Future<T> Function(Transaction) operations) async {
    _checkInitialized();
    final txn = ChiffonTransaction(this);
    try {
      final result = await operations(txn);
      await txn.commit();
      return result;
    } catch (e) {
      await txn.rollback();
      rethrow;
    }
  }

  @override
  Future<T> readTransaction<T>(
    Future<T> Function(Transaction) operations,
  ) async {
    return transaction(operations);
  }

  @override
  Future<EntityId> storeBinaryData(
    Uint8List data, {
    String? mimeType,
    String? filename,
  }) async {
    final id = EntityId();
    _binaryData[id] = data;
    if (mimeType != null) _binaryMimeTypes[id] = mimeType;
    if (filename != null) _binaryFilenames[id] = filename;
    return id;
  }

  @override
  Future<Uint8List?> getBinaryData(EntityId id) async => _binaryData[id];

  @override
  Stream<Uint8List> getBinaryDataStream(EntityId id) {
    final data = _binaryData[id];
    return data != null ? Stream.value(data) : const Stream.empty();
  }

  @override
  Future<bool> deleteBinaryData(EntityId id) async {
    final existed = _binaryData.containsKey(id);
    _binaryData.remove(id);
    _binaryMimeTypes.remove(id);
    _binaryFilenames.remove(id);
    return existed;
  }

  @override
  Future<StorageStatistics> getStatistics() async {
    _checkInitialized();
    var binarySize = 0;
    for (final data in _binaryData.values) {
      binarySize += data.length;
    }
    return StorageStatistics(
      nodeCount: _nodeIdMap.length,
      linkCount: _linkIdMap.length,
      propertyCount: 0,
      binaryDataCount: _binaryData.length,
      binaryDataSize: binarySize,
    );
  }

  @override
  Future<List<String>> getNodeLabels() async {
    _checkInitialized();
    final labels = <String>{};
    for (final rid in _nodeIdMap.values) {
      final labelsJson = await _db!.getNodeLabels(rid: rid);
      labels.addAll((jsonDecode(labelsJson) as List).cast<String>());
    }
    // Exclude the fixed meta-schema type; only user labels are meaningful.
    labels.remove('_Entity');
    return labels.toList()..sort();
  }

  @override
  Future<List<String>> getLinkTypes() async {
    _checkInitialized();
    final types = <String>{};
    for (final rid in _linkIdMap.values) {
      final labelsJson = await _db!.getEdgeLabels(rid: rid);
      types.addAll((jsonDecode(labelsJson) as List).cast<String>());
    }
    // Exclude the fixed meta-schema type; only user edge types are meaningful.
    types.remove('_Link');
    return types.toList()..sort();
  }

  @override
  Future<List<String>> getPropertyKeys() async {
    _checkInitialized();
    final keys = <String>{};
    for (final rid in _nodeIdMap.values) {
      final propsJson = await _db!.getNodeProperties(rid: rid);
      final props = jsonDecode(propsJson) as Map<String, dynamic>;
      keys.addAll(_userPropKeys(props));
    }
    for (final rid in _linkIdMap.values) {
      final propsJson = await _db!.getEdgeProperties(rid: rid);
      final props = jsonDecode(propsJson) as Map<String, dynamic>;
      keys.addAll(_userPropKeys(props));
    }
    return keys.toList()..sort();
  }

  /// Extracts the user's property keys from the nested `props` field.
  Iterable<String> _userPropKeys(Map<String, dynamic> props) {
    final nested = props['props'] as Map<String, dynamic>?;
    return nested?.keys ?? const [];
  }

  @override
  Future<List<T>> executeQuery<T extends Entity>(GraphQuery<T> query) async {
    if (T == Node) {
      final result = await queryNodes(query as GraphQuery<Node>);
      return result.items as List<T>;
    } else if (T == Link) {
      final result = await queryLinks(query as GraphQuery<Link>);
      return result.items as List<T>;
    }
    throw ArgumentError('Unsupported entity type: $T');
  }

  @override
  Future<List<Link>> getNodeLinks(EntityId nodeId) async {
    _checkInitialized();
    final rid = _nodeIdMap[nodeId.value];
    if (rid == null) return [];

    // Use traversal to get both outgoing and incoming edges from the node.
    // The start node is located by its app_id property.
    final command = jsonEncode({
      'version': 1,
      'start': {
        'type': 'Node',
        'label': '_Entity',
        'key': 'app_id',
        'value': nodeId.value,
      },
      'steps': [
        {'action': 'BothEdges'},
      ],
      'collect': {'type': 'Edges', 'properties': []},
    });

    final resultJson = await _db!.executeTraversal(commandJson: command);
    final results = jsonDecode(resultJson) as List;
    final links = <Link>[];
    for (final r in results) {
      final props = _rowProps(r as Map<String, dynamic>);
      final appId = props['app_id'] as String?;
      if (appId == null) continue;
      final id = EntityId.fromString(appId);
      links.add(_buildLinkFromRaw(id: id, props: props));
    }
    return links;
  }

  // ---- Internal helpers ----

  void _checkInitialized() {
    if (!_isInitialized || _db == null) {
      throw StateError('ChiffonStorage is not initialized');
    }
  }

  /// Rebuilds in-memory ID maps by scanning all nodes and edges on startup.
  Future<void> _rebuildIdMaps() async {
    _nodeIdMap.clear();
    _linkIdMap.clear();

    final nodesJson = await _db!.listNodes(typeName: null);
    final nodes = jsonDecode(nodesJson) as List;
    for (final item in nodes) {
      final map = item as Map<String, dynamic>;
      final ridMap = map['rid'] as Map<String, dynamic>;
      final rid = RecordId(
        page: (ridMap['page'] as num).toInt(),
        slot: (ridMap['slot'] as num).toInt(),
      );
      final props = map['props'] as Map<String, dynamic>?;
      final appId = props?['app_id'] as String?;
      if (appId != null) {
        _nodeIdMap[appId] = rid;
      }
    }

    final edgesJson = await _db!.listEdges(typeName: null);
    final edges = jsonDecode(edgesJson) as List;
    for (final item in edges) {
      final map = item as Map<String, dynamic>;
      final ridMap = map['rid'] as Map<String, dynamic>;
      final rid = RecordId(
        page: (ridMap['page'] as num).toInt(),
        slot: (ridMap['slot'] as num).toInt(),
      );
      final props = map['props'] as Map<String, dynamic>?;
      final appId = props?['app_id'] as String?;
      if (appId != null) {
        _linkIdMap[appId] = rid;
      }
    }
  }

  /// Extracts the property map from a traversal result row.
  ///
  /// `executeTraversal` with a `Nodes`/`Edges` collect returns each entity's
  /// properties directly at the top level (no `properties` wrapper). A
  /// `properties` key is still honored for forward compatibility with any
  /// collect shape that wraps them.
  Map<String, dynamic> _rowProps(Map<String, dynamic> row) {
    final wrapped = row['properties'];
    if (wrapped is Map<String, dynamic>) return wrapped;
    return row;
  }

  /// Returns a minimal label set from `app_type` for use in traversal results
  /// where `getNodeLabels` cannot be called (no RecordId available).
  Set<String> _labelsFromProps(Map<String, dynamic> props) {
    final appType = props['app_type'] as String?;
    if (appType != null) return {appType};
    return const {};
  }

  Node _buildNodeFromRaw({
    required EntityId id,
    required Map<String, dynamic> props,
    required Set<String> labels,
  }) {
    // User properties live under the nested `props` field on the meta-schema.
    final userProps = Map<String, dynamic>.from(
      (props['props'] as Map<String, dynamic>?) ?? const {},
    );

    final createdAtMs = props['app_created_at'];
    final updatedAtMs = props['app_updated_at'];
    final createdAt =
        createdAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch((createdAtMs as num).toInt())
            : DateTime.now();
    final updatedAt =
        updatedAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch((updatedAtMs as num).toInt())
            : DateTime.now();

    final appType =
        props['app_type'] as String? ??
        (labels.isNotEmpty ? labels.first : 'node');
    final description = EntityDescription(
      type: appType,
      propertyTypes: const {},
    );

    return Node(
      id: id,
      customId: props['app_custom_id'] as String?,
      description: description,
      labels: labels,
      properties: _toPropertySet(userProps),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Link _buildLinkFromRaw({
    required EntityId id,
    required Map<String, dynamic> props,
  }) {
    // User properties live under the nested `props` field on the meta-schema.
    final userProps = Map<String, dynamic>.from(
      (props['props'] as Map<String, dynamic>?) ?? const {},
    );

    final createdAtMs = props['app_created_at'];
    final updatedAtMs = props['app_updated_at'];
    final createdAt =
        createdAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch((createdAtMs as num).toInt())
            : DateTime.now();
    final updatedAt =
        updatedAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch((updatedAtMs as num).toInt())
            : DateTime.now();

    final type = props['app_type'] as String? ?? 'link';
    final sourceIdStr = props['app_source_id'] as String? ?? '';
    final targetIdStr = props['app_target_id'] as String? ?? '';

    final description = EntityDescription(type: type, propertyTypes: const {});

    return Link(
      id: id,
      customId: props['app_custom_id'] as String?,
      type: type,
      sourceId:
          sourceIdStr.isNotEmpty
              ? EntityId.fromString(sourceIdStr)
              : EntityId(),
      targetId:
          targetIdStr.isNotEmpty
              ? EntityId.fromString(targetIdStr)
              : EntityId(),
      description: description,
      properties: _toPropertySet(userProps),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  PropertySet _toPropertySet(Map<String, dynamic> map) {
    final props = <String, Property>{};
    for (final entry in map.entries) {
      final desc = PropertyDescription(
        key: entry.key,
        type: _inferType(entry.value),
      );
      props[entry.key] = Property(description: desc, value: entry.value);
    }
    return PropertySet(props);
  }

  PropertyType _inferType(dynamic value) {
    if (value is String) return const TextPropertyType();
    if (value is int) return const IntegerPropertyType();
    if (value is double) return const DecimalPropertyType();
    if (value is bool) return const BooleanPropertyType();
    return const AnyPropertyType();
  }

  Map<String, dynamic> _propertySetToMap(PropertySet properties) {
    final result = <String, dynamic>{};
    for (final key in properties.keys) {
      result[key] = properties.getValue(key);
    }
    return result;
  }
}
