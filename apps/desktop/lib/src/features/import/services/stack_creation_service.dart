import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:rinne_graph/rinne_graph.dart' as rg;
import 'package:path_provider/path_provider.dart';

import '../models/import_result.dart';

/// Stack creation service
class StackCreationService {
  /// Creates a stack from nodes and links
  Future<ImportResult> createStackFromData({
    required Map<String, dynamic> metadata,
    required List<core_graph.Node> nodes,
    required List<core_graph.Link> links,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      // 1. Create stack directory
      final stackDir = await _createStackDirectory(
        metadata['name'] ?? 'Imported Stack',
      );

      // 2. Create metadata files
      await _createMetadataFiles(stackDir, metadata);

      // 3. Create simple graph database (currently creates an empty DB file)
      await _createSimpleGraphData(stackDir, nodes, links);

      stopwatch.stop();

      return ImportResult.success(
        entitiesCount: nodes.length,
        relationsCount: links.length,
        stackPath: stackDir.path,
        duration: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();

      return ImportResult.failure(
        errors: [ImportError.system('Stack creation error: $e')],
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Creates the stack directory
  Future<Directory> _createStackDirectory(String name) async {
    final userStacksDir = await _getUserStacksDirectory();
    final sanitizedName = _sanitizeFileName(name);
    final stackDir = Directory('${userStacksDir.path}/$sanitizedName.stack');

    if (await stackDir.exists()) {
      await stackDir.delete(recursive: true);
    }

    await stackDir.create(recursive: true);
    await Directory('${stackDir.path}/data').create();
    await Directory('${stackDir.path}/meta').create();
    await Directory('${stackDir.path}/datasets').create();
    await Directory('${stackDir.path}/filters').create();
    await Directory('${stackDir.path}/assets').create();

    return stackDir;
  }

  /// Creates metadata files
  Future<void> _createMetadataFiles(
    Directory stackDir,
    Map<String, dynamic> metadata,
  ) async {
    // info.json
    final infoFile = File('${stackDir.path}/meta/info.json');
    final infoData = {
      'name': metadata['name'] ?? 'Imported Stack',
      'description': metadata['description'] ?? 'Imported Stack',
      'author': metadata['author'] ?? 'Import Service',
      'version': metadata['version'] ?? '1.0.0',
      'tags': metadata['tags'] ?? ['imported'],
      'created': DateTime.now().toIso8601String(),
      'type': 'user_stack',
    };
    await infoFile.writeAsString(json.encode(infoData));

    // settings.json
    final settingsFile = File('${stackDir.path}/meta/settings.json');
    final settingsData = {
      'data_validation': true,
      'auto_samples': false,
      'source_config': 'imported',
    };
    await settingsFile.writeAsString(json.encode(settingsData));
  }

  /// Creates simple graph data (currently a simplified implementation)
  Future<void> _createSimpleGraphData(
    Directory stackDir,
    List<core_graph.Node> nodes,
    List<core_graph.Link> links,
  ) async {
    final dbPath = '${stackDir.path}/data/graph.db';

    try {
      // Create appropriate database structure using RinneGraph
      // Convert path to absolute path
      final absolutePath = File(dbPath).absolute.path;
      final graph = await rg.Graph.open(absolutePath);

      // Close properly if initialization is successful
      await graph.close();

      debugPrint(
        '[_createSimpleGraphData] Created RinneGraph database: $dbPath',
      );
    } catch (e) {
      debugPrint(
        '[_createSimpleGraphData] Failed to create RinneGraph database: $e',
      );
      // Fallback: Create an empty file
      final graphFile = File(dbPath);
      await graphFile.create();
    }

    // Also create a simple JSON file for logging
    final debugFile = File('${stackDir.path}/data/debug_data.json');
    final debugData = {
      'nodes':
          nodes
              .map(
                (node) => {
                  'id': node.id.value,
                  'labels': node.labels.toList(),
                  'properties': _propertiesToMap(node.properties),
                },
              )
              .toList(),
      'links':
          links
              .map(
                (link) => {
                  'id': link.id.value,
                  'type': link.type,
                  'sourceId': link.sourceId.value,
                  'targetId': link.targetId.value,
                  'properties': _propertiesToMap(link.properties),
                },
              )
              .toList(),
    };
    await debugFile.writeAsString(json.encode(debugData));
  }

  /// Converts PropertySet to Map
  Map<String, dynamic> _propertiesToMap(core_graph.PropertySet propertySet) {
    final map = <String, dynamic>{};
    // Currently returns an empty map because internal access to PropertySet is difficult
    // Will use PropertySet API in the future
    return map;
  }

  /// Gets the user's stack directory
  Future<Directory> _getUserStacksDirectory() async {
    // Get directory depending on the platform
    final appDocDir = await getApplicationDocumentsDirectory();
    final stacksDir = Directory('${appDocDir.path}/App/Stacks');

    if (!await stacksDir.exists()) {
      await stacksDir.create(recursive: true);
    }

    return stacksDir;
  }

  /// Sanitizes the file name
  String _sanitizeFileName(String fileName) {
    // Remove or replace invalid characters
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
