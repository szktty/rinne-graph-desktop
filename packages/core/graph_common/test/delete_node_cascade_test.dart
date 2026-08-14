/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:test/test.dart';
// Prefixed because core_graph_common's query predicates export names that
// collide with matcher's (`contains`, `isNull`).
import 'package:core_graph_common/core_graph_common.dart' as graph;

/// Deleting a node must take its links with it.
///
/// A link stores its endpoints by id, so a link left behind by a deleted node
/// refers to something that is no longer there — the graph model treats that
/// as impossible. ChiffonDB cascades in its own `delete_node`; these tests pin
/// the same behaviour on [graph.InMemoryGraphStorage], which is the storage the
/// pure-Dart tests can exercise without the native library.
void main() {
  late graph.InMemoryGraphStorage storage;

  const nodeDescription = graph.EntityDescription(
    type: 'Person',
    propertyTypes: {},
  );
  const linkDescription = graph.EntityDescription(
    type: 'Link',
    propertyTypes: {},
  );

  Future<graph.Node> createNode() =>
      storage.createNode(description: nodeDescription, properties: const {});

  Future<List<graph.Link>> remainingLinks() async {
    final result = await storage.queryLinks(
      graph.GraphQuery<graph.Link>(entityType: graph.Link),
    );
    return result.items;
  }

  setUp(() async {
    storage = graph.InMemoryGraphStorage();
    await storage.initialize();
  });

  test('deleting a node removes the links that start at it', () async {
    final source = await createNode();
    final target = await createNode();
    await storage.createLink(
      sourceId: source.id,
      targetId: target.id,
      type: 'knows',
      description: linkDescription,
    );

    expect(await storage.deleteNode(source.id), isTrue);

    expect(await remainingLinks(), isEmpty);
    // The node at the other end is not part of the cascade.
    expect(await storage.getNode(target.id), isNotNull);
  });

  test('deleting a node removes the links that end at it', () async {
    final source = await createNode();
    final target = await createNode();
    await storage.createLink(
      sourceId: source.id,
      targetId: target.id,
      type: 'knows',
      description: linkDescription,
    );

    expect(await storage.deleteNode(target.id), isTrue);

    expect(await remainingLinks(), isEmpty);
    expect(await storage.getNode(source.id), isNotNull);
  });

  test('links between other nodes survive', () async {
    final doomed = await createNode();
    final a = await createNode();
    final b = await createNode();
    await storage.createLink(
      sourceId: doomed.id,
      targetId: a.id,
      type: 'knows',
      description: linkDescription,
    );
    final survivor = await storage.createLink(
      sourceId: a.id,
      targetId: b.id,
      type: 'knows',
      description: linkDescription,
    );

    await storage.deleteNode(doomed.id);

    final links = await remainingLinks();
    expect(links.map((link) => link.id), [survivor.id]);
  });

  test('a self-loop is removed once, without disturbing other links', () async {
    final looping = await createNode();
    final other = await createNode();
    await storage.createLink(
      sourceId: looping.id,
      targetId: looping.id,
      type: 'refers_to',
      description: linkDescription,
    );
    final survivor = await storage.createLink(
      sourceId: other.id,
      targetId: other.id,
      type: 'refers_to',
      description: linkDescription,
    );

    await storage.deleteNode(looping.id);

    final links = await remainingLinks();
    expect(links.map((link) => link.id), [survivor.id]);
  });

  test(
    'deleting an unknown node reports failure and changes nothing',
    () async {
      final source = await createNode();
      final target = await createNode();
      await storage.createLink(
        sourceId: source.id,
        targetId: target.id,
        type: 'knows',
        description: linkDescription,
      );

      expect(await storage.deleteNode(graph.EntityId()), isFalse);

      expect(await remainingLinks(), hasLength(1));
    },
  );
}
