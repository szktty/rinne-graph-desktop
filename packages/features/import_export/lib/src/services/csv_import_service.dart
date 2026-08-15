/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';
import 'package:excel_community/excel_community.dart';
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

/// What reading a workbook found.
///
/// Sheets that hold no graph data are named rather than silently dropped: a
/// workbook usually contains working notes as well as data, and someone whose
/// sheet was passed over needs to know which one and be able to tell that from
/// a sheet that was read but was empty.
class WorkbookParseResult {
  const WorkbookParseResult({
    required this.tables,
    required this.skippedSheets,
  });

  /// Node tables first, then link tables.
  final List<CsvParseResult> tables;

  /// Names of the sheets whose header identified neither shape.
  final List<String> skippedSheets;
}

/// What an import put into a stack.
///
/// The counts are reported so the user can be told what happened — most of
/// all [skippedNodeRows], since a skipped row looks exactly like a successful
/// one from the outside.
class ImportOutcome {
  const ImportOutcome({
    required this.stack,
    required this.nodeRows,
    required this.linkRows,
    required this.skippedNodeRows,
    required this.skippedLinkRows,
    this.skippedSheets = const [],
  });

  /// The stack that was imported into, whether created or added to.
  final Stack stack;

  /// Node rows read from the file, including any that were skipped.
  final int nodeRows;

  /// Link rows read from the file.
  final int linkRows;

  /// Node rows dropped because the graph already held that id.
  final int skippedNodeRows;

  /// Link rows dropped because the graph already held that exact link, or
  /// because an endpoint could not be resolved.
  final int skippedLinkRows;

  /// Sheets that held no graph data and were passed over.
  final List<String> skippedSheets;
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

    final result = parseRows(rows);
    if (result == null) {
      throw const FormatException(
        'Unknown CSV format: header must contain "id" (node) or '
        '"source", "target", and "type" (link)',
      );
    }
    return result;
  }

  /// How many rows from the top are considered when looking for the header.
  ///
  /// Numbers writes the name of each table ("表1") into the first row of the
  /// sheet it exports, so the header is not always row 0. A handful of rows is
  /// enough for that and for a blank spacer or two, without reaching so far
  /// that a stray word in the data gets mistaken for a header.
  static const int _headerSearchDepth = 5;

  /// Column names that identify a node table, compared case-insensitively.
  static const String _idColumn = 'id';

  /// Column names that identify a link table, compared case-insensitively.
  static const Set<String> _linkColumns = {'source', 'target', 'type'};

  /// Interprets a table of [rows], finding the header row for itself.
  ///
  /// Everything past "a grid of cells" is format-agnostic, so CSV and
  /// spreadsheet imports share this: only the step that produces the grid
  /// differs. Returns null when no row in reach identifies either shape, which
  /// lets a caller holding several tables — the sheets of a workbook — skip
  /// the ones that are not graph data instead of failing the whole import.
  ///
  /// [defaultLabel] is used for node rows that name no labels of their own.
  /// Callers pass the sheet name: someone who has put their characters on a
  /// sheet called "キャラクター" has already said what those rows are, and
  /// making them repeat it in a `labels` column on every row is a tax on the
  /// most common way of laying a spreadsheet out.
  static CsvParseResult? parseRows(
    List<List<dynamic>> rows, {
    String? defaultLabel,
  }) {
    final headerIndex = _findHeaderRow(rows);
    if (headerIndex == null) return null;

    final rawHeaders = rows[headerIndex].map((e) => e.toString()).toList();
    final dataRows = rows.skip(headerIndex + 1).toList();
    final normalised = rawHeaders.map(_normaliseHeader).toSet();

    if (normalised.contains(_idColumn)) {
      return CsvParseResult.nodes(
        _parseNodeRows(rawHeaders, dataRows, defaultLabel: defaultLabel),
      );
    }
    if (normalised.containsAll(_linkColumns)) {
      return CsvParseResult.links(_parseLinkRows(rawHeaders, dataRows));
    }
    return null;
  }

  /// Index of the first row that looks like a header, or null if none does.
  static int? _findHeaderRow(List<List<dynamic>> rows) {
    final depth =
        rows.length < _headerSearchDepth ? rows.length : _headerSearchDepth;
    for (var i = 0; i < depth; i++) {
      final names = rows[i].map((e) => _normaliseHeader(e.toString())).toSet();
      if (names.contains(_idColumn) || names.containsAll(_linkColumns)) {
        return i;
      }
    }
    return null;
  }

  /// A header cell reduced to the form the detector compares.
  ///
  /// Case is dropped because a spreadsheet written by hand says "Id" or "ID"
  /// as readily as "id", and surrounding space because a cell can carry it
  /// invisibly. The original spelling is kept for property keys — only the
  /// matching is relaxed, not what the data ends up called.
  static String _normaliseHeader(String s) =>
      _stripSchema(s.trim()).toLowerCase();

  /// Index of the column called [name], compared as [_normaliseHeader] does,
  /// or -1 when the table has no such column.
  static int _columnIndex(List<String> headers, String name) {
    for (var i = 0; i < headers.length; i++) {
      if (_normaliseHeader(headers[i]) == name) return i;
    }
    return -1;
  }

  /// Whether [row] holds anything at all.
  ///
  /// A spreadsheet in progress is mostly empty rows below the data — the sheet
  /// is sized to the table someone drew, not to what they have filled in — and
  /// those would otherwise be read as rows with no id and reject the file.
  static bool _isNotBlank(List<dynamic> row) =>
      row.any((cell) => cell.toString().trim().isNotEmpty);

  /// Whether a cell holds a value.
  static bool _isFilled(dynamic cell) => cell.toString().trim().isNotEmpty;

  /// Parses every sheet of the workbook in [bytes] that holds graph data.
  ///
  /// Sheets are told apart by their header exactly as a CSV file is, so a
  /// workbook can carry its nodes and its links side by side. Sheets whose
  /// header matches neither shape — a notes tab, a scratch calculation — are
  /// skipped rather than treated as an error, since a spreadsheet is a place
  /// people keep more than one kind of thing.
  ///
  /// Results are returned nodes-first: [importLinksToGraph] resolves a link's
  /// endpoints by looking their custom ids up in the graph, so the nodes have
  /// to be there by the time the links are imported.
  static WorkbookParseResult parseXlsx(Uint8List bytes) {
    final workbook = Excel.decodeBytes(bytes);

    final tables = <CsvParseResult>[];
    final skipped = <String>[];
    for (final entry in workbook.tables.entries) {
      // Blank rows are left in: the header may be preceded by them, and
      // dropping rows here would move the header away from the index
      // _findHeaderRow reports. The row parsers skip the blanks themselves.
      final rows =
          entry.value.rows.map((row) => row.map(_cellValue).toList()).toList();
      final result = parseRows(rows, defaultLabel: entry.key.trim());
      if (result != null) {
        tables.add(result);
      } else {
        skipped.add(entry.key);
      }
    }

    tables.sort((a, b) => a.type.index.compareTo(b.type.index));
    return WorkbookParseResult(tables: tables, skippedSheets: skipped);
  }

  /// Unwraps a spreadsheet cell into the plain value the row parsers expect.
  ///
  /// The CSV reader already hands those parsers real types — an age column
  /// arrives as an `int`, not `'30'` — so the same is done here rather than
  /// stringifying everything, or the two formats would disagree about what a
  /// property holds. Dates become ISO 8601 text: the graph has no date
  /// property type yet, and an unambiguous string survives the round trip.
  static dynamic _cellValue(Data? cell) {
    return switch (cell?.value) {
      null => '',
      TextCellValue(:final value) => value.toString(),
      IntCellValue(:final value) => value,
      DoubleCellValue(:final value) => value,
      BoolCellValue(:final value) => value,
      DateCellValue v => v.asDateTimeLocal().toIso8601String(),
      DateTimeCellValue v => v.asDateTimeLocal().toIso8601String(),
      TimeCellValue v => v.asDuration().toString(),
      FormulaCellValue(:final formula) => formula,
    };
  }

  // ---------------------------------------------------------------------------
  // Node parsing
  // ---------------------------------------------------------------------------

  static List<ParsedNodeRow> _parseNodeRows(
    List<String> headers,
    List<List<dynamic>> dataRows, {
    String? defaultLabel,
  }) {
    final idIdx = _columnIndex(headers, _idColumn);
    final labelsIdx = _columnIndex(headers, 'labels');

    // Indices of columns that become properties (skip id and labels).
    final propIndices = <int, String>{};
    for (int j = 0; j < headers.length; j++) {
      if (j == idIdx || j == labelsIdx) continue;
      propIndices[j] = _stripSchema(headers[j].trim());
    }

    return dataRows
        .where(_isNotBlank)
        // A row with no id is not a node. Half-filled rows are ordinary in a
        // spreadsheet being worked on — a value typed into one column while
        // the rest waits — and rejecting the whole file over one would make
        // the importer unusable on anything unfinished.
        .where((row) => idIdx < row.length && _isFilled(row[idIdx]))
        .map((row) {
          final customId = row[idIdx].toString().trim();

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
          if (labels.isEmpty && defaultLabel != null) {
            labels.add(defaultLabel);
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
        })
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Link parsing
  // ---------------------------------------------------------------------------

  static List<ParsedLinkRow> _parseLinkRows(
    List<String> headers,
    List<List<dynamic>> dataRows,
  ) {
    final sourceIdx = _columnIndex(headers, 'source');
    final targetIdx = _columnIndex(headers, 'target');
    final typeIdx = _columnIndex(headers, 'type');

    // Indices of columns that become properties (skip source, target, type).
    final reservedIndices = {sourceIdx, targetIdx, typeIdx};
    final propIndices = <int, String>{};
    for (int j = 0; j < headers.length; j++) {
      if (reservedIndices.contains(j)) continue;
      propIndices[j] = _stripSchema(headers[j].trim());
    }

    return dataRows
        .where(_isNotBlank)
        // As for nodes: a row missing any of the three is not yet a link, and
        // a half-written row should not cost the reader the rest of the file.
        .where(
          (row) =>
              sourceIdx < row.length &&
              targetIdx < row.length &&
              typeIdx < row.length &&
              _isFilled(row[sourceIdx]) &&
              _isFilled(row[targetIdx]) &&
              _isFilled(row[typeIdx]),
        )
        .map((row) {
          final sourceId = row[sourceIdx].toString().trim();
          final targetId = row[targetIdx].toString().trim();
          final type = _stripSchema(row[typeIdx].toString().trim());

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
        })
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Graph import
  // ---------------------------------------------------------------------------

  /// Creates nodes in [graphContext] from parsed node rows.
  ///
  /// A row whose id already exists in the graph is skipped, and the number of
  /// skips is returned. Importing into a stack that already holds data would
  /// otherwise create a second node with the same id, and the two would be
  /// indistinguishable afterwards — links resolve their endpoints by that id.
  /// Updating the existing node instead is a separate feature; refusing to
  /// duplicate is the part that keeps the graph usable either way.
  ///
  /// [onProgress] is called with values in [0.0, 1.0] as each row is processed.
  static Future<int> importNodesToGraph({
    required GraphContext graphContext,
    required List<ParsedNodeRow> rows,
    void Function(double)? onProgress,
  }) async {
    final total = rows.length;
    if (total == 0) return 0;

    var skipped = 0;
    for (int i = 0; i < total; i++) {
      final row = rows[i];

      if (await graphContext.getNodeByCustomId(row.customId) != null) {
        skipped++;
        onProgress?.call((i + 1) / total);
        continue;
      }

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
    return skipped;
  }

  /// Identifies a link by what it connects and how.
  ///
  /// Links carry no id of their own, so this triple is the only thing "the
  /// same link" can mean. Built in one place so the copy made from a stored
  /// link and the copy made from a row being imported cannot drift apart.
  static String _linkSignature(EntityId source, EntityId target, String type) =>
      '${source.value} ${target.value} $type';

  /// Creates links in [graphContext] from parsed link rows.
  ///
  /// Source and target nodes are resolved by their custom IDs. If a referenced
  /// node is not found the row is silently skipped.
  ///
  /// A link identical to one already in the graph — same endpoints, same type
  /// — is skipped too, and the number of skips is returned. Links carry no id
  /// of their own, so that triple is what "the same link" can mean; without
  /// the check, importing a file twice quietly doubled every link while the
  /// nodes stayed put.
  ///
  /// [onProgress] is called with values in [0.0, 1.0] as each row is
  /// processed (including skipped rows).
  static Future<int> importLinksToGraph({
    required GraphContext graphContext,
    required List<ParsedLinkRow> rows,
    void Function(double)? onProgress,
  }) async {
    final total = rows.length;
    if (total == 0) return 0;

    // Read once: the query walks every edge, and doing that per row turns the
    // import into a quadratic scan.
    final existing = <String>{};
    final currentLinks = await graphContext.queryLinks(
      GraphQuery<Link>(entityType: Link),
    );
    for (final link in currentLinks.items) {
      existing.add(_linkSignature(link.sourceId, link.targetId, link.type));
    }

    var skipped = 0;
    for (int i = 0; i < total; i++) {
      final row = rows[i];

      final sourceNode = await graphContext.getNodeByCustomId(row.sourceId);
      final targetNode = await graphContext.getNodeByCustomId(row.targetId);

      if (sourceNode != null && targetNode != null) {
        final signature = _linkSignature(
          sourceNode.id,
          targetNode.id,
          row.type,
        );
        if (existing.contains(signature)) {
          skipped++;
          onProgress?.call((i + 1) / total);
          continue;
        }

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
        // Also guards against a file that lists the same link twice.
        existing.add(signature);
      }

      onProgress?.call((i + 1) / total);
    }
    return skipped;
  }

  /// High-level helper: reads a CSV or spreadsheet file and imports it.
  ///
  /// Creates a stack named [stackName] unless [targetStack] names one to add
  /// to. The format is chosen by the file's extension: `.xlsx` is read as a
  /// workbook, anything else as CSV.
  static Future<ImportOutcome> importFileToStack({
    required String filePath,
    required String stackName,
    required ProviderContainer container,
    Stack? targetStack,
    void Function(double)? onProgress,
  }) async {
    onProgress?.call(0.0);

    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    final isSpreadsheet = filePath.toLowerCase().endsWith('.xlsx');
    final parsed =
        isSpreadsheet
            ? parseXlsx(await file.readAsBytes())
            : WorkbookParseResult(
              tables: [parseCsv(await file.readAsString(encoding: utf8))],
              skippedSheets: const [],
            );
    final tables = parsed.tables;

    if (tables.isEmpty) {
      // Name the sheets that were passed over. Without them this said only
      // that nothing looked like graph data, which gives the reader nothing to
      // act on when the cause is a column spelled "Id" or a header that is not
      // on the first row.
      final looked =
          parsed.skippedSheets.isEmpty
              ? ''
              : ' Sheets read: ${parsed.skippedSheets.join(', ')}.';
      throw FormatException(
        'No sheet in this file looks like graph data. A node sheet needs an '
        '"id" column; a link sheet needs "source", "target" and "type".'
        '$looked',
      );
    }

    onProgress?.call(0.2);

    final fileName = filePath.split('/').last;
    final stack =
        targetStack ??
        await container
            .read(stackActionsProvider.notifier)
            .createCustomStack(
              name: stackName,
              description: 'Imported from $fileName',
              isScratch: false,
              tags: ['imported', if (isSpreadsheet) 'xlsx' else 'csv'],
            );

    if (stack == null) {
      throw Exception('Failed to create stack');
    }

    onProgress?.call(0.4);

    final graphContext = await _openGraph(container, stack, targetStack);

    // parseXlsx returns node tables first, which matters: importLinksToGraph
    // resolves each endpoint by looking its id up in the graph, so a link
    // imported before its nodes would be dropped.
    var nodeCount = 0;
    var linkCount = 0;
    var skipped = 0;
    var skippedLinks = 0;
    for (var i = 0; i < tables.length; i++) {
      final table = tables[i];
      // Each table gets an equal slice of the bar's remaining 60%.
      void report(double p) =>
          onProgress?.call(0.4 + ((i + p) / tables.length) * 0.6);

      if (table.type == CsvDataType.node) {
        skipped += await importNodesToGraph(
          graphContext: graphContext,
          rows: table.nodes,
          onProgress: report,
        );
        nodeCount += table.nodes.length;
      } else {
        skippedLinks += await importLinksToGraph(
          graphContext: graphContext,
          rows: table.links,
          onProgress: report,
        );
        linkCount += table.links.length;
      }
    }

    if (targetStack != null) {
      // Rows written into the stack on screen have to reach the views, which
      // render activeGraphProvider rather than the database.
      await _reloadActiveGraph(container, graphContext);
    } else {
      // Close the connection this import opened. Until it closes, the writes
      // sit in the database's write-ahead log and the file on its own does not
      // yet describe the graph — the stack listing validates that file, judged
      // the stack unusable and left it out of My Stacks, which is why a
      // freshly imported stack only appeared once something else touched it.
      // The stack is not open in the app, so nothing else holds this storage.
      await graphContext.close();

      // createCustomStack refreshed the list when it made the directory, which
      // was before any of the data existed. Ask again now that it is complete.
      container.read(stackActionsProvider.notifier).triggerRefresh();
    }

    onProgress?.call(1.0);
    return ImportOutcome(
      stack: stack,
      nodeRows: nodeCount,
      linkRows: linkCount,
      skippedNodeRows: skipped,
      skippedLinkRows: skippedLinks,
      skippedSheets: parsed.skippedSheets,
    );
  }

  /// Re-reads the graph the views are rendering from the database.
  static Future<void> _reloadActiveGraph(
    ProviderContainer container,
    GraphContext graphContext,
  ) async {
    final nodes = await graphContext.queryNodes(
      GraphQuery<Node>(entityType: Node),
    );
    final links = await graphContext.queryLinks(
      GraphQuery<Link>(entityType: Link),
    );

    var graph = Graph();
    for (final node in nodes.items) {
      graph = graph.addNode(node);
    }
    for (final link in links.items) {
      graph = graph.addLink(link);
    }
    container.read(activeGraphProvider.notifier).setGraph(graph);
  }

  /// A context over [stack]'s graph.
  ///
  /// When adding to the stack the app already has open, the context it already
  /// uses is reused: ChiffonDB refuses to open one database file twice in a
  /// process, so building a second connection over the same file would fail
  /// outright. A freshly created stack is not open yet and gets its own, which
  /// the caller closes once the import finishes so the writes are flushed out
  /// of the write-ahead log and into the file the stack listing reads.
  static Future<GraphContext> _openGraph(
    ProviderContainer container,
    Stack stack,
    Stack? targetStack,
  ) async {
    if (targetStack != null) {
      final shared = container.read(graphContextProvider);
      await shared.initialize();
      return shared;
    }

    final storage = ChiffonStorage(
      path: '${stack.directory.path}/data/graph.db',
      schema: ChiffonSchemaGenerator.minimalSchema,
    );
    await storage.initialize();
    final context = GraphContext(storage: storage);
    await context.initialize();
    return context;
  }

  /// Kept for callers that predate [importFileToStack].
  static Future<Stack?> importCsvToStack({
    required String filePath,
    required String stackName,
    required ProviderContainer container,
    void Function(double)? onProgress,
  }) async {
    final outcome = await importFileToStack(
      filePath: filePath,
      stackName: stackName,
      container: container,
      onProgress: onProgress,
    );
    return outcome.stack;
  }
}
