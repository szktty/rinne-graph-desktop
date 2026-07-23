/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:core_stack_flutter/core_stack.dart';
import 'package:core_graph_flutter/core_graph.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detected CSV data type.
enum CsvDataType { node, link }

/// A parsed node row from a node CSV.
class ParsedNodeRow {
  const ParsedNodeRow({
    required this.customId,
    required this.labels,
    required this.properties,
  });

  /// Value of the `id` column.
  final String customId;

  /// Values from the `labels` column (comma-separated, `$` prefix stripped).
  final Set<String> labels;

  /// Remaining columns, with empty cells excluded and `$` prefixes stripped
  /// from keys.
  final Map<String, dynamic> properties;
}

/// A parsed link row from a link CSV.
class ParsedLinkRow {
  const ParsedLinkRow({
    required this.sourceId,
    required this.targetId,
    required this.type,
    required this.properties,
  });

  /// Custom ID of the source node (value of the `source` column).
  final String sourceId;

  /// Custom ID of the target node (value of the `target` column).
  final String targetId;

  /// Link type (`$` prefix stripped).
  final String type;

  /// Remaining columns, with empty cells excluded and `$` prefixes stripped
  /// from keys.
  final Map<String, dynamic> properties;
}

/// Result of [CsvImportService.parseCsv].
class CsvParseResult {
  const CsvParseResult.nodes(List<ParsedNodeRow> nodes)
    : type = CsvDataType.node,
      nodes = nodes,
      links = const [];

  const CsvParseResult.links(List<ParsedLinkRow> links)
    : type = CsvDataType.link,
      nodes = const [],
      links = links;

  final CsvDataType type;
  final List<ParsedNodeRow> nodes;
  final List<ParsedLinkRow> links;
}

class CsvImportService {
  /// Strips the `$` schema-reference prefix from [s] when no schema file is
  /// loaded.  Without a schema file the prefix carries no meaning, so it is
  /// removed to produce a clean label/type/key name.
  static String _stripSchema(String s) =>
      s.startsWith('\$') ? s.substring(1) : s;

  /// Parses CSV content into a [CsvParseResult].
  ///
  /// Auto-detection rules (based on the header row):
  /// - Header contains `id`                           → node CSV
  /// - Header contains `source`, `target`, and `type` → link CSV
  /// - Otherwise                                       → [FormatException]
  ///
  /// The first row is treated as headers. Throws [FormatException] if [content]
  /// is empty.
  static CsvParseResult parseCsv(String content) {
    final rows = const CsvToListConverter(eol: '\n').convert(content);

    if (rows.isEmpty) {
      throw const FormatException('CSV content is empty');
    }

    final rawHeaders = rows.first.map((e) => e.toString()).toList();
    final dataRows = rows.skip(1).toList();

    // Auto-detect type from header names (compare against raw headers).
    final headerSet = rawHeaders.toSet();

    if (headerSet.contains('id')) {
      return CsvParseResult.nodes(_parseNodeRows(rawHeaders, dataRows));
    } else if (headerSet.containsAll({'source', 'target', 'type'})) {
      return CsvParseResult.links(_parseLinkRows(rawHeaders, dataRows));
    } else {
      throw const FormatException(
        'Unknown CSV format: header must contain "id" (node) or '
        '"source", "target", and "type" (link)',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Node parsing
  // ---------------------------------------------------------------------------

  static List<ParsedNodeRow> _parseNodeRows(
    List<String> headers,
    List<List<dynamic>> dataRows,
  ) {
    final idIdx = headers.indexOf('id');
    final labelsIdx = headers.indexOf('labels');

    // Indices of columns that become properties (skip id and labels).
    final propIndices = <int, String>{};
    for (int j = 0; j < headers.length; j++) {
      if (j == idIdx || j == labelsIdx) continue;
      propIndices[j] = _stripSchema(headers[j]);
    }

    return dataRows.map((row) {
      final customId = idIdx < row.length ? row[idIdx].toString().trim() : '';
      if (customId.isEmpty) {
        throw const FormatException('Node row has empty id');
      }

      // Parse labels from the `labels` column.
      final labels = <String>{};
      if (labelsIdx != -1 && labelsIdx < row.length) {
        final raw = row[labelsIdx].toString().trim();
        if (raw.isNotEmpty) {
          for (final part in raw.split(',')) {
            final label = _stripSchema(part.trim());
            if (label.isNotEmpty) labels.add(label);
          }
        }
      }

      // Parse remaining columns as properties, skipping empty cells.
      final properties = <String, dynamic>{};
      propIndices.forEach((idx, key) {
        if (idx < row.length) {
          final value = row[idx];
          final strVal = value.toString().trim();
          if (strVal.isNotEmpty) {
            properties[key] = value;
          }
        }
      });

      return ParsedNodeRow(
        customId: customId,
        labels: labels,
        properties: properties,
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Link parsing
  // ---------------------------------------------------------------------------

  static List<ParsedLinkRow> _parseLinkRows(
    List<String> headers,
    List<List<dynamic>> dataRows,
  ) {
    final sourceIdx = headers.indexOf('source');
    final targetIdx = headers.indexOf('target');
    final typeIdx = headers.indexOf('type');

    // Indices of columns that become properties (skip source, target, type).
    final reservedIndices = {sourceIdx, targetIdx, typeIdx};
    final propIndices = <int, String>{};
    for (int j = 0; j < headers.length; j++) {
      if (reservedIndices.contains(j)) continue;
      propIndices[j] = _stripSchema(headers[j]);
    }

    return dataRows.map((row) {
      final sourceId =
          sourceIdx < row.length ? row[sourceIdx].toString().trim() : '';
      final targetId =
          targetIdx < row.length ? row[targetIdx].toString().trim() : '';
      final rawType =
          typeIdx < row.length ? row[typeIdx].toString().trim() : '';

      if (sourceId.isEmpty || targetId.isEmpty || rawType.isEmpty) {
        throw const FormatException(
          'Link row must have non-empty source, target, and type',
        );
      }

      final type = _stripSchema(rawType);

      // Parse remaining columns as properties, skipping empty cells.
      final properties = <String, dynamic>{};
      propIndices.forEach((idx, key) {
        if (idx < row.length) {
          final value = row[idx];
          final strVal = value.toString().trim();
          if (strVal.isNotEmpty) {
            properties[key] = value;
          }
        }
      });

      return ParsedLinkRow(
        sourceId: sourceId,
        targetId: targetId,
        type: type,
        properties: properties,
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Graph import
  // ---------------------------------------------------------------------------

  /// Creates nodes in [graphContext] from parsed node rows.
  ///
  /// [onProgress] is called with values in [0.0, 1.0] as each node is created.
  static Future<void> importNodesToGraph({
    required GraphContext graphContext,
    required List<ParsedNodeRow> rows,
    void Function(double)? onProgress,
  }) async {
    final total = rows.length;
    if (total == 0) return;

    for (int i = 0; i < total; i++) {
      final row = rows[i];

      final description = EntityDescription(
        type: row.labels.isNotEmpty ? row.labels.first : 'ImportedNode',
        propertyTypes: row.properties.map(
          (key, value) => MapEntry(key, TextPropertyType()),
        ),
      );

      await graphContext.createNode(
        description: description,
        labels: row.labels.isNotEmpty ? row.labels : {'ImportedNode'},
        properties: row.properties,
        customId: row.customId,
      );

      onProgress?.call((i + 1) / total);
    }
  }

  /// Creates links in [graphContext] from parsed link rows.
  ///
  /// Source and target nodes are resolved by their custom IDs. If a referenced
  /// node is not found the row is silently skipped.
  ///
  /// [onProgress] is called with values in [0.0, 1.0] as each row is
  /// processed (including skipped rows).
  static Future<void> importLinksToGraph({
    required GraphContext graphContext,
    required List<ParsedLinkRow> rows,
    void Function(double)? onProgress,
  }) async {
    final total = rows.length;
    if (total == 0) return;

    for (int i = 0; i < total; i++) {
      final row = rows[i];

      final sourceNode = await graphContext.getNodeByCustomId(row.sourceId);
      final targetNode = await graphContext.getNodeByCustomId(row.targetId);

      if (sourceNode != null && targetNode != null) {
        final description = EntityDescription(
          type: row.type,
          propertyTypes: row.properties.map(
            (key, value) => MapEntry(key, TextPropertyType()),
          ),
        );

        await graphContext.createLink(
          sourceId: sourceNode.id,
          targetId: targetNode.id,
          type: row.type,
          description: description,
          properties: row.properties.isNotEmpty ? row.properties : null,
        );
      }

      onProgress?.call((i + 1) / total);
    }
  }

  /// High-level helper: reads a CSV file, parses it, creates a new stack, and
  /// imports the data.
  static Future<Stack?> importCsvToStack({
    required String filePath,
    required String stackName,
    required ProviderContainer container,
    void Function(double)? onProgress,
  }) async {
    try {
      onProgress?.call(0.0);

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final contents = await file.readAsString(encoding: utf8);
      final parseResult = parseCsv(contents);

      onProgress?.call(0.2);

      final stackActions = container.read(stackActionsProvider.notifier);

      final stack = await stackActions.createCustomStack(
        name: stackName,
        description: 'Imported from CSV: ${filePath.split('/').last}',
        isScratch: false,
        tags: ['imported', 'csv'],
      );

      if (stack == null) {
        throw Exception('Failed to create stack');
      }

      onProgress?.call(0.4);

      final graphDbPath = '${stack.directory.path}/data/graph.db';
      final storage = ChiffonStorage(
        path: graphDbPath,
        schema: ChiffonSchemaGenerator.minimalSchema,
      );
      await storage.initialize();

      final graphContext = GraphContext(storage: storage);
      await graphContext.initialize();

      if (parseResult.type == CsvDataType.node) {
        await importNodesToGraph(
          graphContext: graphContext,
          rows: parseResult.nodes,
          onProgress: (p) => onProgress?.call(0.4 + p * 0.6),
        );
      } else {
        await importLinksToGraph(
          graphContext: graphContext,
          rows: parseResult.links,
          onProgress: (p) => onProgress?.call(0.4 + p * 0.6),
        );
      }

      return stack;
    } catch (e) {
      rethrow;
    }
  }
}
