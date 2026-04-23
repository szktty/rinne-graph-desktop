/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';

import 'package:core_graph_flutter/core_graph.dart' hide contains, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import 'package:features_import_export/src/services/csv_import_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------------
  // parseCsv — auto-detection
  // ---------------------------------------------------------------------------

  group('CsvImportService.parseCsv — auto-detection', () {
    test('detects node CSV when header contains id', () {
      const csv = 'id,name\nperson_001,Alice';
      final result = CsvImportService.parseCsv(csv);
      expect(result.type, CsvDataType.node);
    });

    test('detects link CSV when header contains source, target, type', () {
      const csv = 'source,target,type\nperson_001,person_002,KNOWS';
      final result = CsvImportService.parseCsv(csv);
      expect(result.type, CsvDataType.link);
    });

    test('throws FormatException on empty content', () {
      expect(() => CsvImportService.parseCsv(''), throwsFormatException);
    });

    test('throws FormatException when header is unrecognised', () {
      const csv = 'name,age\nAlice,30';
      expect(() => CsvImportService.parseCsv(csv), throwsFormatException);
    });

    test('returns empty node list for header-only node CSV', () {
      const csv = 'id,name';
      final result = CsvImportService.parseCsv(csv);
      expect(result.type, CsvDataType.node);
      expect(result.nodes, isEmpty);
    });

    test('returns empty link list for header-only link CSV', () {
      const csv = 'source,target,type';
      final result = CsvImportService.parseCsv(csv);
      expect(result.type, CsvDataType.link);
      expect(result.links, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // parseCsv — node CSV
  // ---------------------------------------------------------------------------

  group('CsvImportService.parseCsv — node rows', () {
    test('parses customId from id column', () {
      const csv = 'id,name\nperson_001,Alice';
      final rows = CsvImportService.parseCsv(csv).nodes;
      expect(rows, hasLength(1));
      expect(rows[0].customId, 'person_001');
    });

    test('parses name property', () {
      const csv = 'id,name\nperson_001,Alice';
      final row = CsvImportService.parseCsv(csv).nodes[0];
      expect(row.properties['name'].toString(), 'Alice');
    });

    test('parses multiple data rows', () {
      const csv = 'id,name\nperson_001,Alice\nperson_002,Bob';
      final rows = CsvImportService.parseCsv(csv).nodes;
      expect(rows, hasLength(2));
      expect(rows[1].customId, 'person_002');
    });

    test('parses labels column — single label with \$ prefix stripped', () {
      const csv = 'id,labels\nperson_001,\$Person';
      final row = CsvImportService.parseCsv(csv).nodes[0];
      expect(row.labels, contains('Person'));
      expect(row.labels, isNot(contains('\$Person')));
    });

    test('parses labels column — multiple comma-separated labels', () {
      // Multiple labels must be quoted in CSV since comma is the field delimiter.
      const csv = 'id,labels\nperson_001,"\$Person,\$Employee"';
      final row = CsvImportService.parseCsv(csv).nodes[0];
      expect(row.labels, containsAll(['Person', 'Employee']));
    });

    test('parses labels column — labels without \$ prefix kept as-is', () {
      const csv = 'id,labels\nperson_001,Person';
      final row = CsvImportService.parseCsv(csv).nodes[0];
      expect(row.labels, contains('Person'));
    });

    test('strips \$ prefix from property header keys', () {
      const csv = 'id,\$name\nperson_001,Alice';
      final row = CsvImportService.parseCsv(csv).nodes[0];
      expect(row.properties.containsKey('name'), isTrue);
      expect(row.properties.containsKey('\$name'), isFalse);
    });

    test('excludes empty cells from properties', () {
      const csv = 'id,name,age\nperson_001,Alice,';
      final row = CsvImportService.parseCsv(csv).nodes[0];
      expect(row.properties.containsKey('name'), isTrue);
      expect(row.properties.containsKey('age'), isFalse);
    });

    test('id and labels columns are not included in properties', () {
      const csv = 'id,labels,name\nperson_001,Person,Alice';
      final row = CsvImportService.parseCsv(csv).nodes[0];
      expect(row.properties.containsKey('id'), isFalse);
      expect(row.properties.containsKey('labels'), isFalse);
      expect(row.properties.containsKey('name'), isTrue);
    });

    test('handles quoted values containing commas', () {
      const csv = 'id,address\nperson_001,"Tokyo, Shibuya"';
      final row = CsvImportService.parseCsv(csv).nodes[0];
      expect(row.properties['address'].toString(), 'Tokyo, Shibuya');
    });

    test('handles CRLF line endings', () {
      const csv = 'id,name\r\nperson_001,Alice\r\nperson_002,Bob';
      final rows = CsvImportService.parseCsv(csv).nodes;
      expect(rows, hasLength(2));
    });
  });

  // ---------------------------------------------------------------------------
  // parseCsv — link CSV
  // ---------------------------------------------------------------------------

  group('CsvImportService.parseCsv — link rows', () {
    test('parses source, target, type columns', () {
      const csv = 'source,target,type\nperson_001,person_002,KNOWS';
      final row = CsvImportService.parseCsv(csv).links[0];
      expect(row.sourceId, 'person_001');
      expect(row.targetId, 'person_002');
      expect(row.type, 'KNOWS');
    });

    test('strips \$ prefix from type', () {
      const csv = 'source,target,type\nperson_001,person_002,\$KNOWS';
      final row = CsvImportService.parseCsv(csv).links[0];
      expect(row.type, 'KNOWS');
    });

    test('strips \$ prefix from property header keys', () {
      const csv = 'source,target,type,\$weight\nperson_001,person_002,KNOWS,1.0';
      final row = CsvImportService.parseCsv(csv).links[0];
      expect(row.properties.containsKey('weight'), isTrue);
      expect(row.properties.containsKey('\$weight'), isFalse);
    });

    test('excludes empty cells from link properties', () {
      const csv = 'source,target,type,weight\nperson_001,person_002,KNOWS,';
      final row = CsvImportService.parseCsv(csv).links[0];
      expect(row.properties.containsKey('weight'), isFalse);
    });

    test('source/target/type columns not in link properties', () {
      const csv = 'source,target,type,weight\nperson_001,person_002,KNOWS,1.0';
      final row = CsvImportService.parseCsv(csv).links[0];
      expect(row.properties.containsKey('source'), isFalse);
      expect(row.properties.containsKey('target'), isFalse);
      expect(row.properties.containsKey('type'), isFalse);
      expect(row.properties.containsKey('weight'), isTrue);
    });

    test('parses multiple link rows', () {
      const csv =
          'source,target,type\nperson_001,person_002,KNOWS\nperson_002,person_003,MANAGES';
      final rows = CsvImportService.parseCsv(csv).links;
      expect(rows, hasLength(2));
      expect(rows[1].type, 'MANAGES');
    });
  });

  // ---------------------------------------------------------------------------
  // importNodesToGraph
  // ---------------------------------------------------------------------------

  group('CsvImportService.importNodesToGraph', () {
    late Directory tempDir;
    late RinneGraphStorage storage;
    late GraphContext graphContext;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('csv_import_test_');
      final dbPath = '${tempDir.path}/graph.db';
      storage = RinneGraphStorage(dbPath);
      await storage.initialize();
      graphContext = GraphContext(storage: storage);
      await graphContext.initialize();
    });

    tearDown(() async {
      await storage.close();
      await tempDir.delete(recursive: true);
    });

    test('creates correct number of nodes', () async {
      final rows = [
        ParsedNodeRow(
          customId: 'n1',
          labels: {'Person'},
          properties: {'name': 'Alice'},
        ),
        ParsedNodeRow(
          customId: 'n2',
          labels: {'Person'},
          properties: {'name': 'Bob'},
        ),
      ];

      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: rows,
      );

      final result = await graphContext.queryNodes(GraphQuery(entityType: Node));
      expect(result.items, hasLength(2));
    });

    test('sets customId on created nodes — retrievable by custom ID', () async {
      final rows = [
        ParsedNodeRow(
          customId: 'person_001',
          labels: {'Person'},
          properties: {},
        ),
      ];

      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: rows,
      );

      // getNodeByCustomId must find the node by the custom ID we passed.
      final node = await graphContext.getNodeByCustomId('person_001');
      expect(node, isNotNull);
    });

    test('sets labels on created nodes', () async {
      final rows = [
        ParsedNodeRow(
          customId: 'n1',
          labels: {'Employee', 'Person'},
          properties: {},
        ),
      ];

      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: rows,
      );

      final result = await graphContext.queryNodes(GraphQuery(entityType: Node));
      final node = result.items.first;
      expect(node.labels, containsAll(['Employee', 'Person']));
    });

    test('uses ImportedNode label when no labels provided', () async {
      final rows = [
        ParsedNodeRow(customId: 'n1', labels: {}, properties: {}),
      ];

      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: rows,
      );

      final result = await graphContext.queryNodes(GraphQuery(entityType: Node));
      final node = result.items.first;
      expect(node.labels, contains('ImportedNode'));
    });

    test('sets properties on created nodes', () async {
      final rows = [
        ParsedNodeRow(
          customId: 'n1',
          labels: {},
          properties: {'name': 'Alice', 'city': 'Tokyo'},
        ),
      ];

      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: rows,
      );

      final node = await graphContext.getNodeByCustomId('n1');
      expect(node!.properties.getValue('name'), 'Alice');
      expect(node.properties.getValue('city'), 'Tokyo');
    });

    test('reports progress from first to last node', () async {
      final rows = List.generate(
        4,
        (i) => ParsedNodeRow(customId: 'n$i', labels: {}, properties: {}),
      );
      final progressValues = <double>[];

      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: rows,
        onProgress: progressValues.add,
      );

      expect(progressValues, hasLength(4));
      expect(progressValues.first, moreOrLessEquals(0.25, epsilon: 0.001));
      expect(progressValues.last, moreOrLessEquals(1.0, epsilon: 0.001));
    });

    test('progress values are strictly increasing', () async {
      final rows = List.generate(
        5,
        (i) => ParsedNodeRow(customId: 'n$i', labels: {}, properties: {}),
      );
      final progressValues = <double>[];

      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: rows,
        onProgress: progressValues.add,
      );

      for (int i = 1; i < progressValues.length; i++) {
        expect(progressValues[i], greaterThan(progressValues[i - 1]));
      }
    });

    test('does nothing for empty rows', () async {
      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: [],
      );

      final result = await graphContext.queryNodes(GraphQuery(entityType: Node));
      expect(result.items, isEmpty);
    });

    test('does not call onProgress for empty rows', () async {
      var called = false;
      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: [],
        onProgress: (_) => called = true,
      );
      expect(called, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // importLinksToGraph
  // ---------------------------------------------------------------------------

  group('CsvImportService.importLinksToGraph', () {
    late Directory tempDir;
    late RinneGraphStorage storage;
    late GraphContext graphContext;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('csv_import_link_test_');
      final dbPath = '${tempDir.path}/graph.db';
      storage = RinneGraphStorage(dbPath);
      await storage.initialize();
      graphContext = GraphContext(storage: storage);
      await graphContext.initialize();
    });

    tearDown(() async {
      await storage.close();
      await tempDir.delete(recursive: true);
    });

    /// Helper: creates a node with the given custom ID.
    Future<void> createNode(String customId) async {
      await CsvImportService.importNodesToGraph(
        graphContext: graphContext,
        rows: [
          ParsedNodeRow(customId: customId, labels: {'Person'}, properties: {}),
        ],
      );
    }

    test('creates a link when source and target nodes exist', () async {
      await createNode('n1');
      await createNode('n2');

      await CsvImportService.importLinksToGraph(
        graphContext: graphContext,
        rows: [
          ParsedLinkRow(
            sourceId: 'n1',
            targetId: 'n2',
            type: 'KNOWS',
            properties: {},
          ),
        ],
      );

      final result =
          await graphContext.queryLinks(GraphQuery(entityType: Link));
      expect(result.items, hasLength(1));
    });

    test('sets link type', () async {
      await createNode('n1');
      await createNode('n2');

      await CsvImportService.importLinksToGraph(
        graphContext: graphContext,
        rows: [
          ParsedLinkRow(
            sourceId: 'n1',
            targetId: 'n2',
            type: 'MANAGES',
            properties: {},
          ),
        ],
      );

      final result =
          await graphContext.queryLinks(GraphQuery(entityType: Link));
      expect(result.items.first.type, 'MANAGES');
    });

    test('sets link properties', () async {
      await createNode('n1');
      await createNode('n2');

      await CsvImportService.importLinksToGraph(
        graphContext: graphContext,
        rows: [
          ParsedLinkRow(
            sourceId: 'n1',
            targetId: 'n2',
            type: 'KNOWS',
            properties: {'since': '2023-01-01'},
          ),
        ],
      );

      final result =
          await graphContext.queryLinks(GraphQuery(entityType: Link));
      expect(result.items.first.properties.getValue('since'), '2023-01-01');
    });

    test('skips link when source node does not exist', () async {
      await createNode('n2');

      await CsvImportService.importLinksToGraph(
        graphContext: graphContext,
        rows: [
          ParsedLinkRow(
            sourceId: 'missing',
            targetId: 'n2',
            type: 'KNOWS',
            properties: {},
          ),
        ],
      );

      final result =
          await graphContext.queryLinks(GraphQuery(entityType: Link));
      expect(result.items, isEmpty);
    });

    test('skips link when target node does not exist', () async {
      await createNode('n1');

      await CsvImportService.importLinksToGraph(
        graphContext: graphContext,
        rows: [
          ParsedLinkRow(
            sourceId: 'n1',
            targetId: 'missing',
            type: 'KNOWS',
            properties: {},
          ),
        ],
      );

      final result =
          await graphContext.queryLinks(GraphQuery(entityType: Link));
      expect(result.items, isEmpty);
    });

    test('creates multiple links', () async {
      await createNode('n1');
      await createNode('n2');
      await createNode('n3');

      await CsvImportService.importLinksToGraph(
        graphContext: graphContext,
        rows: [
          ParsedLinkRow(
            sourceId: 'n1',
            targetId: 'n2',
            type: 'KNOWS',
            properties: {},
          ),
          ParsedLinkRow(
            sourceId: 'n2',
            targetId: 'n3',
            type: 'MANAGES',
            properties: {},
          ),
        ],
      );

      final result =
          await graphContext.queryLinks(GraphQuery(entityType: Link));
      expect(result.items, hasLength(2));
    });

    test('reports progress', () async {
      await createNode('n1');
      await createNode('n2');

      final progressValues = <double>[];

      await CsvImportService.importLinksToGraph(
        graphContext: graphContext,
        rows: [
          ParsedLinkRow(
            sourceId: 'n1',
            targetId: 'n2',
            type: 'KNOWS',
            properties: {},
          ),
        ],
        onProgress: progressValues.add,
      );

      expect(progressValues, hasLength(1));
      expect(progressValues.last, moreOrLessEquals(1.0, epsilon: 0.001));
    });

    test('does nothing for empty rows', () async {
      await CsvImportService.importLinksToGraph(
        graphContext: graphContext,
        rows: [],
      );

      final result =
          await graphContext.queryLinks(GraphQuery(entityType: Link));
      expect(result.items, isEmpty);
    });

    test('does not call onProgress for empty rows', () async {
      var called = false;
      await CsvImportService.importLinksToGraph(
        graphContext: graphContext,
        rows: [],
        onProgress: (_) => called = true,
      );
      expect(called, isFalse);
    });
  });
}
