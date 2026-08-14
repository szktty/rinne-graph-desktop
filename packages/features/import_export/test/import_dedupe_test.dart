/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

// Prefixed because core_graph's query predicates export names that collide
// with matcher's (`isNotNull`, `contains`).
import 'package:core_graph_flutter/core_graph.dart' as g;
import 'package:features_import_export/src/services/csv_import_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Importing the same file twice must not double the graph.
///
/// A spreadsheet is edited and re-imported; without these guards the second
/// pass appends a parallel copy of everything, and because links carry no id
/// of their own the duplicates are indistinguishable afterwards.
void main() {
  late g.GraphContext context;
  late g.InMemoryGraphStorage storage;

  setUp(() async {
    storage = g.InMemoryGraphStorage();
    await storage.initialize();
    context = g.GraphContext(storage: storage);
    await context.initialize();
  });

  const nodeRows = [
    ParsedNodeRow(customId: 'a1', labels: {'animal'}, properties: {}),
    ParsedNodeRow(customId: 'h1', labels: {'human'}, properties: {}),
  ];
  const linkRows = [
    ParsedLinkRow(sourceId: 'h1', targetId: 'a1', type: 'owns', properties: {}),
  ];

  // Counted straight off the storage: GraphContext's query path goes through
  // the traversal converter, which the in-memory storage answers with every
  // row regardless of the query, and the counts here need to be exact.
  Future<int> countNodes() async {
    final result = await storage.queryNodes(
      g.GraphQuery<g.Node>(entityType: g.Node),
    );
    return result.items.length;
  }

  Future<int> countLinks() async {
    final result = await storage.queryLinks(
      g.GraphQuery<g.Link>(entityType: g.Link),
    );
    return result.items.length;
  }

  test('a second import of the same rows adds nothing', () async {
    await CsvImportService.importNodesToGraph(
      graphContext: context,
      rows: nodeRows,
    );
    await CsvImportService.importLinksToGraph(
      graphContext: context,
      rows: linkRows,
    );

    expect(await countNodes(), 2);
    expect(await countLinks(), 1);

    final skippedNodes = await CsvImportService.importNodesToGraph(
      graphContext: context,
      rows: nodeRows,
    );
    final skippedLinks = await CsvImportService.importLinksToGraph(
      graphContext: context,
      rows: linkRows,
    );

    expect(skippedNodes, 2, reason: 'both node rows already existed');
    expect(skippedLinks, 1, reason: 'the link already existed');
    expect(await countNodes(), 2, reason: 'nodes must not be duplicated');
    expect(await countLinks(), 1, reason: 'links must not be duplicated');
  });

  test('new rows still land when mixed with ones already imported', () async {
    await CsvImportService.importNodesToGraph(
      graphContext: context,
      rows: nodeRows,
    );
    await CsvImportService.importLinksToGraph(
      graphContext: context,
      rows: linkRows,
    );

    final skippedNodes = await CsvImportService.importNodesToGraph(
      graphContext: context,
      rows: const [
        ParsedNodeRow(customId: 'a1', labels: {'animal'}, properties: {}),
        ParsedNodeRow(customId: 'a2', labels: {'animal'}, properties: {}),
      ],
    );
    final skippedLinks = await CsvImportService.importLinksToGraph(
      graphContext: context,
      rows: const [
        ParsedLinkRow(
          sourceId: 'h1',
          targetId: 'a1',
          type: 'owns',
          properties: {},
        ),
        ParsedLinkRow(
          sourceId: 'h1',
          targetId: 'a2',
          type: 'owns',
          properties: {},
        ),
      ],
    );

    expect(skippedNodes, 1);
    expect(skippedLinks, 1);
    expect(await countNodes(), 3);
    expect(await countLinks(), 2);
  });

  test('the same link twice within one file is added once', () async {
    await CsvImportService.importNodesToGraph(
      graphContext: context,
      rows: nodeRows,
    );
    final skipped = await CsvImportService.importLinksToGraph(
      graphContext: context,
      rows: const [
        ParsedLinkRow(
          sourceId: 'h1',
          targetId: 'a1',
          type: 'owns',
          properties: {},
        ),
        ParsedLinkRow(
          sourceId: 'h1',
          targetId: 'a1',
          type: 'owns',
          properties: {},
        ),
      ],
    );

    expect(skipped, 1);
    expect(await countLinks(), 1);
  });

  test(
    'the same endpoints with a different type are different links',
    () async {
      await CsvImportService.importNodesToGraph(
        graphContext: context,
        rows: nodeRows,
      );
      await CsvImportService.importLinksToGraph(
        graphContext: context,
        rows: const [
          ParsedLinkRow(
            sourceId: 'h1',
            targetId: 'a1',
            type: 'owns',
            properties: {},
          ),
          ParsedLinkRow(
            sourceId: 'h1',
            targetId: 'a1',
            type: 'feeds',
            properties: {},
          ),
        ],
      );

      expect(await countLinks(), 2);
    },
  );
}
