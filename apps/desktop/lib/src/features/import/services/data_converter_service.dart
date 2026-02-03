import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:core_graph_flutter/core_graph.dart';

import '../models/import_config.dart';
import '../models/import_result.dart';

/// Data conversion service
class DataConverterService {
  /// Convert CSV file to node data
  Future<List<Node>> convertCsvToNodes({
    required String filePath,
    required CsvMapping mapping,
  }) async {
    final nodes = <Node>[];
    final warnings = <ImportWarning>[];

    try {
      final file = File(filePath);
      final content = await file.readAsString(encoding: utf8);

      final converter = CsvToListConverter();
      final rows = converter.convert(content);

      if (rows.isEmpty) {
        throw ImportException('CSV file is empty');
      }

      final headers = rows.first.cast<String>();
      final dataRows = rows.skip(1);

      for (int rowIndex = 0; rowIndex < dataRows.length; rowIndex++) {
        final row = dataRows.elementAt(rowIndex);
        final lineNumber = rowIndex + 2; // Consider header row

        if (row.length != headers.length) {
          warnings.add(
            ImportWarning.missingData(
              'Column count mismatch (expected: ${headers.length}, actual: ${row.length})',
              line: lineNumber,
            ),
          );
          continue;
        }

        try {
          final node = _convertRowToNode(headers, row, mapping, lineNumber);
          nodes.add(node);
        } catch (e) {
          warnings.add(
            ImportWarning.dataConversion(
              'Node conversion error: $e',
              line: lineNumber,
            ),
          );
        }
      }

      return nodes;
    } catch (e) {
      throw ImportException('CSV conversion error: $e');
    }
  }

  /// Convert link data from CSV file
  Future<List<Link>> convertCsvToLinks({
    required String filePath,
    required CsvMapping mapping,
  }) async {
    final links = <Link>[];
    final warnings = <ImportWarning>[];

    if (mapping.sourceColumn == null || mapping.targetColumn == null) {
      throw ImportException(
        'sourceColumn and targetColumn are required for link conversion',
      );
    }

    try {
      final file = File(filePath);
      final content = await file.readAsString(encoding: utf8);

      final converter = CsvToListConverter();
      final rows = converter.convert(content);

      if (rows.isEmpty) {
        throw ImportException('CSV file is empty');
      }

      final headers = rows.first.cast<String>();
      final dataRows = rows.skip(1);

      for (int rowIndex = 0; rowIndex < dataRows.length; rowIndex++) {
        final row = dataRows.elementAt(rowIndex);
        final lineNumber = rowIndex + 2; // Consider header row

        if (row.length != headers.length) {
          warnings.add(
            ImportWarning.missingData(
              'Column count mismatch (expected: ${headers.length}, actual: ${row.length})',
              line: lineNumber,
            ),
          );
          continue;
        }

        try {
          final link = _convertRowToLink(headers, row, mapping, lineNumber);
          if (link != null) {
            links.add(link);
          }
        } catch (e) {
          warnings.add(
            ImportWarning.dataConversion(
              'Link conversion error: $e',
              line: lineNumber,
            ),
          );
        }
      }

      return links;
    } catch (e) {
      throw ImportException('CSV conversion error: $e');
    }
  }

  /// Convert nodes and links from JSON file
  Future<ConversionResult> convertJsonToGraphData(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString(encoding: utf8);
      final data = json.decode(content) as Map<String, dynamic>;

      final nodes = <Node>[];
      final links = <Link>[];

      // Convert nodes
      if (data.containsKey('entities') && data['entities'] is List) {
        final entitiesData = data['entities'] as List;
        for (int i = 0; i < entitiesData.length; i++) {
          try {
            final entityData = entitiesData[i] as Map<String, dynamic>;
            final node = _convertJsonToNode(entityData);
            nodes.add(node);
          } catch (e) {
            // Handle adding error logs here if needed
          }
        }
      }

      // Convert links
      if (data.containsKey('relations') && data['relations'] is List) {
        final relationsData = data['relations'] as List;
        for (int i = 0; i < relationsData.length; i++) {
          try {
            final relationData = relationsData[i] as Map<String, dynamic>;
            final link = _convertJsonToLink(relationData);
            links.add(link);
          } catch (e) {
            // Handle adding error logs here if needed
          }
        }
      }

      return ConversionResult(nodes: nodes, links: links, warnings: []);
    } catch (e) {
      throw ImportException('JSON conversion error: $e');
    }
  }

  /// Convert row data to node
  Node _convertRowToNode(
    List<String> headers,
    List<dynamic> row,
    CsvMapping mapping,
    int lineNumber,
  ) {
    final rowMap = <String, dynamic>{};
    for (int i = 0; i < headers.length; i++) {
      rowMap[headers[i]] = row[i];
    }

    // Get ID
    final idValue =
        mapping.idColumn != null
            ? rowMap[mapping.idColumn]?.toString()
            : _generateId();

    if (idValue == null || idValue.isEmpty) {
      throw ImportException('Node ID is empty');
    }

    // Extract labels
    final labels = <String>{};
    for (final labelColumn in mapping.labelColumns) {
      final value = rowMap[labelColumn];
      if (value != null && value.toString().isNotEmpty) {
        labels.add(value.toString());
      }
    }

    if (labels.isEmpty) {
      labels.add('Entity'); // Default label
    }

    // Extract properties
    final properties = <String, dynamic>{};
    final excludedColumns =
        {mapping.idColumn, ...mapping.labelColumns}.whereType<String>().toSet();

    if (mapping.propertyColumns.isNotEmpty) {
      // Only specified columns
      for (final column in mapping.propertyColumns) {
        if (!excludedColumns.contains(column) && rowMap.containsKey(column)) {
          final value = rowMap[column];
          if (value != null && value.toString().isNotEmpty) {
            properties[column] = _convertValue(value);
          }
        }
      }
    } else {
      // All except excluded columns
      for (final entry in rowMap.entries) {
        if (!excludedColumns.contains(entry.key)) {
          final value = entry.value;
          if (value != null && value.toString().isNotEmpty) {
            properties[entry.key] = _convertValue(value);
          }
        }
      }
    }

    // Create a simple EntityDescription
    final description = EntityDescription(type: 'Node', propertyTypes: {});

    // Create PropertySet
    final propertySet = PropertySet(_createPropertyMap(properties));

    return Node(
      id: EntityId.fromAnyString(idValue),
      labels: labels,
      properties: propertySet,
      description: description,
    );
  }

  /// Convert row data to link
  Link? _convertRowToLink(
    List<String> headers,
    List<dynamic> row,
    CsvMapping mapping,
    int lineNumber,
  ) {
    final rowMap = <String, dynamic>{};
    for (int i = 0; i < headers.length; i++) {
      rowMap[headers[i]] = row[i];
    }

    final sourceIdValue = rowMap[mapping.sourceColumn]?.toString();
    final targetIdValue = rowMap[mapping.targetColumn]?.toString();

    if (sourceIdValue == null ||
        sourceIdValue.isEmpty ||
        targetIdValue == null ||
        targetIdValue.isEmpty) {
      return null; // Skip
    }

    final type =
        mapping.typeColumn != null
            ? rowMap[mapping.typeColumn]?.toString() ?? 'RELATED_TO'
            : 'RELATED_TO';

    // Extract properties
    final properties = <String, dynamic>{};
    final excludedColumns =
        {
          mapping.sourceColumn,
          mapping.targetColumn,
          mapping.typeColumn,
        }.whereType<String>().toSet();

    if (mapping.propertyColumns.isNotEmpty) {
      // Only specified columns
      for (final column in mapping.propertyColumns) {
        if (!excludedColumns.contains(column) && rowMap.containsKey(column)) {
          final value = rowMap[column];
          if (value != null && value.toString().isNotEmpty) {
            properties[column] = _convertValue(value);
          }
        }
      }
    } else {
      // All except excluded columns
      for (final entry in rowMap.entries) {
        if (!excludedColumns.contains(entry.key)) {
          final value = entry.value;
          if (value != null && value.toString().isNotEmpty) {
            properties[entry.key] = _convertValue(value);
          }
        }
      }
    }

    // Create a simple EntityDescription
    final description = EntityDescription(type: 'Link', propertyTypes: {});

    // Create PropertySet
    final propertySet = PropertySet(_createPropertyMap(properties));

    return Link(
      id: EntityId.fromAnyString(_generateId()),
      type: type,
      sourceId: EntityId.fromAnyString(sourceIdValue),
      targetId: EntityId.fromAnyString(targetIdValue),
      description: description,
      properties: propertySet,
    );
  }

  /// Convert JSON data to node
  Node _convertJsonToNode(Map<String, dynamic> data) {
    final idValue = data['id']?.toString();
    if (idValue == null || idValue.isEmpty) {
      throw ImportException('Node ID is required');
    }

    final labels =
        data['labels'] is List
            ? (data['labels'] as List).cast<String>().toSet()
            : <String>{'Entity'};

    final properties =
        data['properties'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(data['properties'])
            : <String, dynamic>{};

    // Create a simple EntityDescription
    final description = EntityDescription(type: 'Node', propertyTypes: {});

    // Create PropertySet
    final propertySet = PropertySet(_createPropertyMap(properties));

    return Node(
      id: EntityId.fromAnyString(idValue),
      labels: labels,
      properties: propertySet,
      description: description,
    );
  }

  /// Convert JSON data to link
  Link _convertJsonToLink(Map<String, dynamic> data) {
    final sourceIdValue = data['source']?.toString();
    final targetIdValue = data['target']?.toString();
    final type = data['type']?.toString();

    if (sourceIdValue == null || sourceIdValue.isEmpty) {
      throw ImportException('Link source is required');
    }

    if (targetIdValue == null || targetIdValue.isEmpty) {
      throw ImportException('Link target is required');
    }

    if (type == null || type.isEmpty) {
      throw ImportException('Link type is required');
    }

    final idValue = data['id']?.toString() ?? _generateId();

    final properties =
        data['properties'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(data['properties'])
            : <String, dynamic>{};

    // Create a simple EntityDescription
    final description = EntityDescription(type: 'Link', propertyTypes: {});

    // Create PropertySet
    final propertySet = PropertySet(_createPropertyMap(properties));

    return Link(
      id: EntityId.fromAnyString(idValue),
      type: type,
      sourceId: EntityId.fromAnyString(sourceIdValue),
      targetId: EntityId.fromAnyString(targetIdValue),
      description: description,
      properties: propertySet,
    );
  }

  /// Create property map
  Map<String, Property> _createPropertyMap(Map<String, dynamic> properties) {
    final propertyMap = <String, Property>{};
    for (final entry in properties.entries) {
      propertyMap[entry.key] = Property.fromKeyValue(entry.key, entry.value);
    }
    return propertyMap;
  }

  /// Convert value to appropriate type
  dynamic _convertValue(dynamic value) {
    if (value == null) return null;

    final stringValue = value.toString();

    // Attempt to convert to number
    if (RegExp(r'^\d+$').hasMatch(stringValue)) {
      return int.tryParse(stringValue) ?? stringValue;
    }

    if (RegExp(r'^\d+\.\d+$').hasMatch(stringValue)) {
      return double.tryParse(stringValue) ?? stringValue;
    }

    // Attempt to convert to boolean
    if (stringValue.toLowerCase() == 'true') return true;
    if (stringValue.toLowerCase() == 'false') return false;

    // Process as comma-separated array (for CSV)
    if (stringValue.contains(',')) {
      return stringValue.split(',').map((s) => s.trim()).toList();
    }

    return stringValue;
  }

  /// Generate unique ID
  String _generateId() {
    return 'imported_${DateTime.now().millisecondsSinceEpoch}_${_counter++}';
  }

  static int _counter = 0;
}

/// Conversion result
class ConversionResult {
  final List<Node> nodes;
  final List<Link> links;
  final List<ImportWarning> warnings;

  const ConversionResult({
    required this.nodes,
    required this.links,
    required this.warnings,
  });
}

/// Import exception
class ImportException implements Exception {
  final String message;
  const ImportException(this.message);

  @override
  String toString() => 'ImportException: $message';
}
