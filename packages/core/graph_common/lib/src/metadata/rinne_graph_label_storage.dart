/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core_foundation_common/core_foundation_common.dart';
import 'package:core_graph_common/src/metadata/label_metadata.dart';
import 'package:core_graph_common/src/metadata/label_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:rinne_graph/rinne_graph.dart' as rg;

/// Label metadata storage implementation using RinneGraph
class RinneGraphLabelStorage implements LabelStorage {
  RinneGraphLabelStorage(this._graph, this._stackDirectory);
  final rg.Graph _graph;
  final Directory _stackDirectory;

  /// System-specific label name
  static const String _systemLabelMetadata = '_system_label_metadata';

  /// Property key definitions
  static const String _propLabelName = '_label_name';
  static const String _propDescription = '_description';
  static const String _propColor = '_color';
  static const String _propThumbnailImageId = '_thumbnail_image_id';
  static const String _propCreatedAt = '_created_at';
  static const String _propUpdatedAt = '_updated_at';
  static const String _propCustomProperties = '_custom_properties';

  /// Path to the assets directory
  Directory get _assetsDirectory =>
      Directory(p.join(_stackDirectory.path, 'assets'));

  @override
  Future<List<LabelMetadata>> getAllLabels() async {
    final g = _graph.traversal();
    final results =
        await g.V().hasLabel([_systemLabelMetadata]).valueMap().toList();

    final labels = <LabelMetadata>[];
    for (final data in results) {
      try {
        final label = _mapToLabelMetadata(data);
        labels.add(label);
      } catch (e) {
        // TODO: Use logging framework instead of print
        print('ラベルメタデータの変換に失敗: $e');
      }
    }

    labels.sort((a, b) => a.name.compareTo(b.name));
    return labels;
  }

  @override
  Future<LabelMetadata?> getLabel(String name) async {
    final g = _graph.traversal();
    final results =
        await g
            .V()
            .hasLabel([_systemLabelMetadata])
            .hasKey(_propLabelName, name)
            .valueMap()
            .toList();

    if (results.isEmpty) return null;

    try {
      return _mapToLabelMetadata(results.first);
    } catch (e) {
      // TODO: Use logging framework instead of print
      print('ラベルメタデータの変換に失敗: $e');
      return null;
    }
  }

  @override
  Future<void> saveLabel(LabelMetadata label) async {
    await _graph.transaction((txn) async {
      // Search for existing label metadata
      final g = _graph.traversal();
      final existing =
          await g
              .V()
              .hasLabel([_systemLabelMetadata])
              .hasKey(_propLabelName, label.name)
              .toList();

      final now = DateTime.now();
      final properties = _labelMetadataToProperties(
        label.copyWith(updatedAt: now),
      );

      if (existing.isNotEmpty) {
        // Update existing label metadata
        final vertex = existing.first as rg.Vertex;
        for (final entry in properties.entries) {
          vertex.setProperty(entry.key, entry.value);
        }
      } else {
        // Create new label metadata
        await txn.createVertex(
          rg.Vertex(labels: {_systemLabelMetadata}, properties: properties),
        );
      }
    });
  }

  @override
  Future<bool> deleteLabel(String name) async {
    return _graph.transaction((txn) async {
      final g = _graph.traversal();
      final vertices =
          await g
              .V()
              .hasLabel([_systemLabelMetadata])
              .hasKey(_propLabelName, name)
              .toList();

      if (vertices.isNotEmpty) {
        for (final vertex in vertices) {
          await txn.deleteVertex(vertex.id!);
        }
        return true;
      }
      return false;
    });
  }

  @override
  Future<UniqueId> saveThumbnailImage(Uint8List imageData) async {
    // Create asset directory
    await _assetsDirectory.create(recursive: true);

    // Generate unique ID
    final assetId = UniqueId();
    final assetDir = Directory(
      p.join(_assetsDirectory.path, assetId.toString()),
    );
    await assetDir.create();

    // Save data file
    final dataFile = File(p.join(assetDir.path, 'data'));
    await dataFile.writeAsBytes(imageData);

    // Save metadata file
    final metaFile = File(p.join(assetDir.path, 'meta.json'));
    final metadata = {
      'id': assetId.toString(),
      'mimeType': 'image/png', // Simple implementation
      'size': imageData.length,
      'createdAt': DateTime.now().toIso8601String(),
    };
    await metaFile.writeAsString(json.encode(metadata));

    return assetId;
  }

  @override
  Future<Uint8List?> getThumbnailImage(UniqueId imageId) async {
    final assetDir = Directory(
      p.join(_assetsDirectory.path, imageId.toString()),
    );
    final dataFile = File(p.join(assetDir.path, 'data'));

    if (await dataFile.exists()) {
      return dataFile.readAsBytes();
    }
    return null;
  }

  @override
  Future<void> updateLabelUsageStats(
    String labelName,
    int vertexCount,
    int edgeCount,
  ) async {
    final existing = await getLabel(labelName);
    if (existing != null) {
      // Save usage statistics to custom properties
      final updatedCustomProperties = Map<String, dynamic>.from(
        existing.customProperties,
      );
      updatedCustomProperties['usageStats'] = {
        'vertexCount': vertexCount,
        'edgeCount': edgeCount,
        'totalCount': vertexCount + edgeCount,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final updatedLabel = existing.copyWith(
        customProperties: updatedCustomProperties,
        updatedAt: DateTime.now(),
      );

      await saveLabel(updatedLabel);
    }
  }

  @override
  Future<void> markLabelAsUsed(String labelName) async {
    final existing = await getLabel(labelName);
    if (existing != null) {
      final updatedCustomProperties = Map<String, dynamic>.from(
        existing.customProperties,
      );
      updatedCustomProperties['lastUsed'] = DateTime.now().toIso8601String();

      final updatedLabel = existing.copyWith(
        customProperties: updatedCustomProperties,
        updatedAt: DateTime.now(),
      );

      await saveLabel(updatedLabel);
    }
  }

  @override
  Future<List<String>> getUnusedLabels() async {
    final allLabels = await getAllLabels();
    final unusedLabels = <String>[];

    for (final label in allLabels) {
      final usageStats =
          label.customProperties['usageStats'] as Map<String, dynamic>?;
      final totalCount = usageStats?['totalCount'] as int? ?? 0;

      if (totalCount == 0) {
        unusedLabels.add(label.name);
      }
    }

    return unusedLabels;
  }

  @override
  Future<Map<String, int>> getLabelUsageCounts() async {
    final allLabels = await getAllLabels();
    final usageCounts = <String, int>{};

    for (final label in allLabels) {
      final usageStats =
          label.customProperties['usageStats'] as Map<String, dynamic>?;
      final totalCount = usageStats?['totalCount'] as int? ?? 0;
      usageCounts[label.name] = totalCount;
    }

    return usageCounts;
  }

  @override
  Future<List<LabelMetadata>> getRecentlyUsedLabels({int limit = 10}) async {
    final allLabels = await getAllLabels();

    final labelsWithUsage =
        allLabels.where((label) {
          final lastUsed = label.customProperties['lastUsed'] as String?;
          return lastUsed != null;
        }).toList();

    // Sort by last used date
    labelsWithUsage.sort((a, b) {
      final aLastUsed = DateTime.parse(
        a.customProperties['lastUsed'] as String,
      );
      final bLastUsed = DateTime.parse(
        b.customProperties['lastUsed'] as String,
      );
      return bLastUsed.compareTo(aLastUsed); // Descending order
    });

    return labelsWithUsage.take(limit).toList();
  }

  /// Converts to LabelMetadata from RinneGraph property map
  LabelMetadata _mapToLabelMetadata(Map<String, dynamic> data) {
    return LabelMetadata(
      name: data[_propLabelName] as String,
      description: data[_propDescription] as String?,
      color: data[_propColor] != null ? Color(data[_propColor] as int) : null,
      thumbnailImageId:
          data[_propThumbnailImageId] != null
              ? UniqueId.fromString(data[_propThumbnailImageId] as String)
              : null,
      createdAt: DateTime.parse(data[_propCreatedAt] as String),
      updatedAt: DateTime.parse(data[_propUpdatedAt] as String),
      customProperties:
          data[_propCustomProperties] != null
              ? Map<String, dynamic>.from(
                json.decode(data[_propCustomProperties] as String),
              )
              : {},
    );
  }

  /// Converts LabelMetadata to RinneGraph property map
  Map<String, dynamic> _labelMetadataToProperties(LabelMetadata label) {
    return {
      _propLabelName: label.name,
      _propDescription: label.description,
      _propColor:
          label.color?.value, // TODO: Replace with toARGB32() when available
      _propThumbnailImageId: label.thumbnailImageId?.toString(),
      _propCreatedAt: label.createdAt.toIso8601String(),
      _propUpdatedAt: label.updatedAt.toIso8601String(),
      _propCustomProperties:
          label.customProperties.isNotEmpty
              ? json.encode(label.customProperties)
              : null,
    };
  }
}
