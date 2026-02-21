import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../models/exchange_models.dart';

/// Schema processing utility
class SchemaProcessor {
  /// Auto-detect and load schema file from directory
  static Future<SchemaDefinition?> loadSchemaFromDirectory(
    String directoryPath,
  ) async {
    try {
      // Search for schema.json file
      final schemaFile = File(path.join(directoryPath, 'schema.json'));
      if (await schemaFile.exists()) {
        return await loadSchemaFromFile(schemaFile.path);
      }
      return null;
    } catch (e) {
      // Return null if schema file loading fails
      return null;
    }
  }

  /// Get schema file path from manifest file and load
  static Future<SchemaDefinition?> loadSchemaFromManifest(
    String manifestPath,
  ) async {
    try {
      final manifestFile = File(manifestPath);
      if (!await manifestFile.exists()) return null;

      final content = await manifestFile.readAsString();
      final manifestData = jsonDecode(content) as Map<String, dynamic>;

      // If manifest has schema field
      final schemaPath = manifestData['schema'] as String?;
      if (schemaPath != null) {
        final manifestDir = path.dirname(manifestPath);
        final fullSchemaPath = path.join(manifestDir, schemaPath);
        return await loadSchemaFromFile(fullSchemaPath);
      }

      // If no schema field, search for schema.json in same directory
      return await loadSchemaFromDirectory(path.dirname(manifestPath));
    } catch (e) {
      return null;
    }
  }

  /// Load definition from schema file
  static Future<SchemaDefinition?> loadSchemaFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      final jsonData = jsonDecode(content) as Map<String, dynamic>;
      return SchemaDefinition.fromJson(jsonData);
    } catch (e) {
      return null;
    }
  }

  /// Process identifiers with $ prefix in data based on schema
  static Map<String, dynamic> processNodeData(
    Map<String, dynamic> nodeData,
    SchemaDefinition? schema,
  ) {
    if (schema == null || schema.isEmpty) {
      return _removeDollarPrefixes(nodeData);
    }

    final processedData = <String, dynamic>{};

    nodeData.forEach((key, value) {
      switch (key) {
        case 'labels':
          processedData[key] = _processLabels(value, schema);
          break;
        case 'properties':
          processedData[key] = _processProperties(value, schema);
          break;
        default:
          processedData[key] = value;
      }
    });

    return processedData;
  }

  /// Processes $-prefixed identifiers in link data based on schema
  static Map<String, dynamic> processLinkData(
    Map<String, dynamic> linkData,
    SchemaDefinition? schema,
  ) {
    if (schema == null || schema.isEmpty) {
      return _removeDollarPrefixes(linkData);
    }

    final processedData = <String, dynamic>{};

    linkData.forEach((key, value) {
      switch (key) {
        case 'type':
          processedData[key] = _processLinkType(value, schema);
          break;
        case 'properties':
          processedData[key] = _processProperties(value, schema);
          break;
        default:
          processedData[key] = value;
      }
    });

    return processedData;
  }

  /// Processes $-prefixed property names in CSV headers
  static List<String> processHeaders(
    List<String> headers,
    SchemaDefinition? schema,
  ) {
    if (schema == null || schema.isEmpty) {
      return headers.map(_removeDollarPrefix).toList();
    }

    return headers.map((header) {
      if (header.startsWith('\$')) {
        return schema.getName(header, SchemaItemType.property);
      }
      return header;
    }).toList();
  }

  /// Processes $-prefixed values in CSV cell values (for labels and type columns)
  static String processCellValue(
    String value,
    SchemaDefinition? schema,
    SchemaItemType type,
  ) {
    if (schema == null || schema.isEmpty) {
      return _removeDollarPrefix(value);
    }

    if (value.startsWith('\$')) {
      return schema.getName(value, type);
    }
    return value;
  }

  /// Processes label array
  static List<String> _processLabels(dynamic labels, SchemaDefinition schema) {
    if (labels is! List) return [];

    return labels.map((label) {
      if (label is String && label.startsWith('\$')) {
        return schema.getName(label, SchemaItemType.label);
      }
      return label.toString();
    }).toList();
  }

  /// Processes link type
  static String _processLinkType(dynamic type, SchemaDefinition schema) {
    if (type is String && type.startsWith('\$')) {
      return schema.getName(type, SchemaItemType.linkType);
    }
    return type.toString();
  }

  /// Processes property map
  static Map<String, dynamic> _processProperties(
    dynamic properties,
    SchemaDefinition schema,
  ) {
    if (properties is! Map<String, dynamic>) return {};

    final processedProperties = <String, dynamic>{};

    properties.forEach((key, value) {
      final processedKey =
          key.startsWith('\$')
              ? schema.getName(key, SchemaItemType.property)
              : key;
      processedProperties[processedKey] = value;
    });

    return processedProperties;
  }

  /// Removes $ prefix (processing when no schema is present)
  static Map<String, dynamic> _removeDollarPrefixes(Map<String, dynamic> data) {
    final processedData = <String, dynamic>{};

    data.forEach((key, value) {
      if (key == 'labels' && value is List) {
        processedData[key] = value.map(_removeDollarPrefix).toList();
      } else if (key == 'type' && value is String) {
        processedData[key] = _removeDollarPrefix(value);
      } else if (key == 'properties' && value is Map<String, dynamic>) {
        final processedProperties = <String, dynamic>{};
        value.forEach((propKey, propValue) {
          processedProperties[_removeDollarPrefix(propKey)] = propValue;
        });
        processedData[key] = processedProperties;
      } else {
        processedData[key] = value;
      }
    });

    return processedData;
  }

  /// Removes $ prefix from a single string
  static String _removeDollarPrefix(dynamic value) {
    if (value is String && value.startsWith('\$')) {
      return value.substring(1);
    }
    return value.toString();
  }
}
