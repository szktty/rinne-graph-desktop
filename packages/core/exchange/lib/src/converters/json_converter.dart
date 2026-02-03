import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:core_graph_flutter/core_graph.dart';
import 'package:core_stack_common/core_stack_common.dart';

import '../models/exchange_models.dart';
import 'schema_processor.dart';

/// JSON data converter utility
class JsonConverter {
  /// Import JSON data to stack
  static Future<ExchangeResult<ImportStatistics>> importFromJson({
    required String filePath,
    required Stack stack,
    required GraphContext graphContext,
    ImportConfig? config,
    SchemaDefinition? schema,
    void Function(double progress)? onProgress,
  }) async {
    // Load schema if not provided
    if (schema == null) {
      final schemaDir = path.dirname(filePath);
      schema = await SchemaProcessor.loadSchemaFromDirectory(schemaDir);
      if (schema == null) {
        // Error if schema not found
        return ExchangeResult.error(
          'Schema file not found in directory: $schemaDir',
        );
      }
    }

    return await convertFromJson(
      filePath: filePath,
      graphContext: graphContext,
      schema: schema,
      config: config,
      onProgress: onProgress,
    );
  }

  /// Read JSON file and convert to App format
  static Future<ExchangeResult<ImportStatistics>> convertFromJson({
    required String filePath,
    required GraphContext graphContext,
    ImportConfig? config,
    SchemaDefinition? schema,
    void Function(double progress)? onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();
    var nodesCreated = 0;
    var linksCreated = 0;
    final errors = <String>[];
    final warnings = <String>[];

    try {
      onProgress?.call(0.0);

      // Read JSON file
      final file = File(filePath);
      if (!await file.exists()) {
        return ExchangeResult.error('File not found: $filePath');
      }

      final content = await file.readAsString();
      final jsonData = jsonDecode(content) as Map<String, dynamic>;

      onProgress?.call(0.2);

      // Process node data
      if (jsonData.containsKey('nodes') || jsonData.containsKey('entities')) {
        final nodeData = jsonData['nodes'] ?? jsonData['entities'];
        if (nodeData is List) {
          final totalNodes = nodeData.length;

          for (int i = 0; i < nodeData.length; i++) {
            try {
              final nodeJson = nodeData[i] as Map<String, dynamic>;
              // Process schema references ($-prefixed identifiers)
              final processedNodeJson = SchemaProcessor.processNodeData(
                nodeJson,
                schema,
              );
              await _createNodeFromJson(processedNodeJson, graphContext);
              nodesCreated++;
            } catch (e) {
              final error = 'Node creation error (row ${i + 1}): $e';
              if (config?.skipErrors == true) {
                warnings.add(error);
              } else {
                errors.add(error);
              }
            }

            // Update progress
            final progress = 0.2 + (0.4 * (i + 1) / totalNodes);
            onProgress?.call(progress);
          }
        }
      }

      onProgress?.call(0.6);

      // Process link data
      if (jsonData.containsKey('links') ||
          jsonData.containsKey('edges') ||
          jsonData.containsKey('relations')) {
        final linkData =
            jsonData['links'] ?? jsonData['edges'] ?? jsonData['relations'];

        if (linkData is List) {
          final totalLinks = linkData.length;

          for (int i = 0; i < linkData.length; i++) {
            try {
              final linkJson = linkData[i] as Map<String, dynamic>;
              // Process schema references ($-prefixed identifiers)
              final processedLinkJson = SchemaProcessor.processLinkData(
                linkJson,
                schema,
              );
              await _createLinkFromJson(processedLinkJson, graphContext);
              linksCreated++;
            } catch (e) {
              final error = 'Link creation error (row ${i + 1}): $e';
              if (config?.skipErrors == true) {
                warnings.add(error);
              } else {
                errors.add(error);
              }
            }

            // Update progress
            final progress = 0.6 + (0.4 * (i + 1) / totalLinks);
            onProgress?.call(progress);
          }
        }
      }

      onProgress?.call(1.0);
      stopwatch.stop();

      final statistics = ImportStatistics(
        nodesCreated: nodesCreated,
        linksCreated: linksCreated,
        duration: stopwatch.elapsed,
        errors: errors,
        warnings: warnings,
      );

      if (errors.isNotEmpty && config?.skipErrors != true) {
        return ExchangeResult.error(
          'An error occurred during import: ${errors.first}',
          warnings: warnings,
        );
      }

      return ExchangeResult.success(statistics, warnings: warnings);
    } catch (e) {
      stopwatch.stop();
      return ExchangeResult.error('JSON import error: $e');
    }
  }

  /// Create node from JSON
  static Future<Node> _createNodeFromJson(
    Map<String, dynamic> nodeJson,
    GraphContext graphContext,
  ) async {
    // Check required fields
    final id = nodeJson['id'] as String?;
    if (id == null || id.isEmpty) {
      throw Exception('Node ID is required');
    }

    // Get labels
    final labels = <String>{};
    if (nodeJson.containsKey('labels')) {
      final labelData = nodeJson['labels'];
      if (labelData is List) {
        labels.addAll(labelData.cast<String>());
      } else if (labelData is String) {
        labels.add(labelData);
      }
    }

    // Get properties
    final properties = <String, dynamic>{};
    if (nodeJson.containsKey('properties')) {
      final propData = nodeJson['properties'] as Map<String, dynamic>?;
      if (propData != null) {
        properties.addAll(propData);
      }
    }

    // Set custom ID
    properties['custom_id'] = id;

    // Create EntityDescription
    final description = EntityDescription(
      type: labels.isNotEmpty ? labels.first : 'ImportedNode',
      propertyTypes: properties.map(
        (key, value) => MapEntry(key, _inferPropertyType(value)),
      ),
    );

    return await graphContext.createNode(
      description: description,
      labels: labels.isNotEmpty ? labels : {'ImportedNode'},
      properties: properties,
      customId: id,
    );
  }

  /// Create link from JSON
  static Future<Link> _createLinkFromJson(
    Map<String, dynamic> linkJson,
    GraphContext graphContext,
  ) async {
    // Check required fields
    final sourceId = linkJson['source'] as String?;
    final targetId = linkJson['target'] as String?;
    final type = linkJson['type'] as String?;

    if (sourceId == null || sourceId.isEmpty) {
      throw Exception('Source ID is required');
    }
    if (targetId == null || targetId.isEmpty) {
      throw Exception('Target ID is required');
    }
    if (type == null || type.isEmpty) {
      throw Exception('Link type is required');
    }

    // Get properties
    final properties = <String, dynamic>{};
    if (linkJson.containsKey('properties')) {
      final propData = linkJson['properties'] as Map<String, dynamic>?;
      if (propData != null) {
        properties.addAll(propData);
      }
    }

    // Create EntityDescription
    final description = EntityDescription(
      type: type,
      propertyTypes: properties.map(
        (key, value) => MapEntry(key, _inferPropertyType(value)),
      ),
    );

    return await graphContext.createLink(
      description: description,
      sourceId: EntityId.fromString(sourceId),
      targetId: EntityId.fromString(targetId),
      type: type,
      properties: properties,
    );
  }

  /// Infer property type from value
  static PropertyType _inferPropertyType(dynamic value) {
    if (value is String) return const TextPropertyType();
    if (value is int) return const IntegerPropertyType();
    if (value is double) return const DecimalPropertyType();
    if (value is bool) return const BooleanPropertyType();
    if (value is List) {
      return const AnyPropertyType(); // Use AnyPropertyType for list
    }
    return const TextPropertyType(); // Default
  }
}
