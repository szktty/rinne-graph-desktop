import 'dart:io';
import 'package:csv/csv.dart';
import 'package:core_graph_flutter/core_graph.dart';
import 'package:core_stack_flutter/core_stack.dart';

import '../models/exchange_models.dart';
import 'schema_processor.dart';

/// CSV data converter to App stack
class CsvConverter {
  /// Import data from CSV file to stack
  static Future<ExchangeResult<ImportStatistics>> importFromCsv({
    required String filePath,
    required Stack stack,
    required GraphContext graphContext,
    required CsvMappingConfig mapping,
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

      // Read CSV file
      final file = File(filePath);
      if (!await file.exists()) {
        return ExchangeResult.error('File not found: $filePath');
      }

      final content = await file.readAsString();
      final converter = CsvToListConverter(
        fieldDelimiter: mapping.delimiter,
        shouldParseNumbers: false, // Read as string, convert later
      );
      final rows = converter.convert(content);

      if (rows.isEmpty) {
        return ExchangeResult.error('CSV file is empty');
      }

      onProgress?.call(0.2);

      // Process header row
      List<String>? headers;
      int dataStartRow = 0;

      if (mapping.hasHeader && rows.isNotEmpty) {
        headers = rows[0].map((e) => e.toString()).toList();
        // If schema exists, process header $ prefix
        if (schema != null) {
          headers = SchemaProcessor.processHeaders(headers, schema);
        }
        dataStartRow = 1;
      }

      final totalRows = rows.length - dataStartRow;
      if (totalRows <= 0) {
        return ExchangeResult.error('No data rows');
      }

      // Determine data type
      if (mapping.isNodeConfig) {
        // Process as node data
        for (int i = dataStartRow; i < rows.length; i++) {
          try {
            final row = rows[i];
            await _createNodeFromCsv(
              row,
              headers,
              mapping,
              graphContext,
              schema,
            );
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
          final progress = 0.2 + (0.8 * (i - dataStartRow + 1) / totalRows);
          onProgress?.call(progress);
        }
      } else if (mapping.isLinkConfig) {
        // Process as link data
        for (int i = dataStartRow; i < rows.length; i++) {
          try {
            final row = rows[i];
            await _createLinkFromCsv(
              row,
              headers,
              mapping,
              graphContext,
              schema,
            );
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
          final progress = 0.2 + (0.8 * (i - dataStartRow + 1) / totalRows);
          onProgress?.call(progress);
        }
      } else {
        return ExchangeResult.error(
          'Invalid CSV mapping configuration. Node or Link configuration is required.',
        );
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
      return ExchangeResult.error('CSV import error: $e');
    }
  }

  /// Create node from CSV
  static Future<Node> _createNodeFromCsv(
    List<dynamic> row,
    List<String>? headers,
    CsvMappingConfig mapping,
    GraphContext graphContext,
    SchemaDefinition? schema,
  ) async {
    // Get ID
    final idColumnIndex = headers?.indexOf(mapping.idColumn!) ?? -1;
    if (idColumnIndex == -1 || idColumnIndex >= row.length) {
      throw Exception('ID column not found: ${mapping.idColumn}');
    }

    final id = row[idColumnIndex].toString().trim();
    if (id.isEmpty) {
      throw Exception('Node ID is empty');
    }

    // Get labels
    final labels = <String>{};
    for (final labelColumn in mapping.labelColumns) {
      final labelIndex = headers?.indexOf(labelColumn) ?? -1;
      if (labelIndex != -1 && labelIndex < row.length) {
        final labelValue = row[labelIndex].toString().trim();
        if (labelValue.isNotEmpty) {
          // Split if comma-separated
          if (labelValue.contains(',')) {
            final splitLabels = labelValue.split(',').map((e) => e.trim());
            for (final label in splitLabels) {
              // Apply schema processing
              final processedLabel = SchemaProcessor.processCellValue(
                label,
                schema,
                SchemaItemType.label,
              );
              labels.add(processedLabel);
            }
          } else {
            // Apply schema processing
            final processedLabel = SchemaProcessor.processCellValue(
              labelValue,
              schema,
              SchemaItemType.label,
            );
            labels.add(processedLabel);
          }
        }
      }
    }

    // Get properties
    final properties = <String, dynamic>{};
    for (final propColumn in mapping.propertyColumns) {
      final propIndex = headers?.indexOf(propColumn) ?? -1;
      if (propIndex != -1 && propIndex < row.length) {
        final value = row[propIndex].toString().trim();
        if (value.isNotEmpty) {
          properties[propColumn] = _parseValue(value);
        }
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

  /// Create link from CSV
  static Future<Link> _createLinkFromCsv(
    List<dynamic> row,
    List<String>? headers,
    CsvMappingConfig mapping,
    GraphContext graphContext,
    SchemaDefinition? schema,
  ) async {
    // Get source ID
    final sourceIndex = headers?.indexOf(mapping.sourceColumn!) ?? -1;
    if (sourceIndex == -1 || sourceIndex >= row.length) {
      throw Exception('Source column not found: ${mapping.sourceColumn}');
    }

    // Get target ID
    final targetIndex = headers?.indexOf(mapping.targetColumn!) ?? -1;
    if (targetIndex == -1 || targetIndex >= row.length) {
      throw Exception('Target column not found: ${mapping.targetColumn}');
    }

    // Get type
    final typeIndex = headers?.indexOf(mapping.typeColumn!) ?? -1;
    if (typeIndex == -1 || typeIndex >= row.length) {
      throw Exception('Type column not found: ${mapping.typeColumn}');
    }

    final sourceId = row[sourceIndex].toString().trim();
    final targetId = row[targetIndex].toString().trim();
    final rawType = row[typeIndex].toString().trim();

    if (sourceId.isEmpty || targetId.isEmpty || rawType.isEmpty) {
      throw Exception('Source ID, target ID, and type are required');
    }

    // Apply schema processing to convert link type
    final type = SchemaProcessor.processCellValue(
      rawType,
      schema,
      SchemaItemType.linkType,
    );

    // Get properties
    final properties = <String, dynamic>{};
    for (final propColumn in mapping.propertyColumns) {
      final propIndex = headers?.indexOf(propColumn) ?? -1;
      if (propIndex != -1 && propIndex < row.length) {
        final value = row[propIndex].toString().trim();
        if (value.isNotEmpty) {
          properties[propColumn] = _parseValue(value);
        }
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

  /// Convert string value to appropriate type
  static dynamic _parseValue(String value) {
    // Check for numeric value
    if (RegExp(r'^\d+$').hasMatch(value)) {
      return int.tryParse(value) ?? value;
    }
    if (RegExp(r'^\d+\.\d+$').hasMatch(value)) {
      return double.tryParse(value) ?? value;
    }

    // Check for boolean value
    final lowerValue = value.toLowerCase();
    if (lowerValue == 'true' || lowerValue == 'false') {
      return lowerValue == 'true';
    }

    // Check for comma-separated array
    if (value.contains(',')) {
      return value.split(',').map((e) => e.trim()).toList();
    }

    return value;
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
