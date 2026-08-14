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
import 'package:desktop/src/providers/graph_filter_providers.dart';
import 'package:flutter_test/flutter_test.dart';

/// Hiding a label removes those nodes, and the links that needed them.
///
/// The rule that is easy to get wrong is the second half: a link whose other
/// end is still visible must go too, or the graph draws an edge running off to
/// nothing — which is indistinguishable from a node that failed to render.
void main() {
  const nodeDescription = g.EntityDescription(type: 'node', propertyTypes: {});
  const linkDescription = g.EntityDescription(type: 'link', propertyTypes: {});

  g.Node node(String id, Set<String> labels) => g.Node(
    id: g.EntityId.fromString(id),
    description: nodeDescription,
    labels: labels,
  );

  g.Link link(String id, g.Node source, g.Node target, String type) => g.Link(
    id: g.EntityId.fromString(id),
    description: linkDescription,
    sourceId: source.id,
    targetId: target.id,
    type: type,
  );

  // A character owns a skill; two characters know each other.
  final mika = node('01000000-0000-7000-8000-000000000001', {'キャラクター'});
  final fred = node('01000000-0000-7000-8000-000000000002', {'キャラクター'});
  final fire = node('01000000-0000-7000-8000-000000000003', {'スキル'});

  final learns = link('01000000-0000-7000-8000-00000000000a', mika, fire, '習得');
  final knows = link('01000000-0000-7000-8000-00000000000b', mika, fred, '知人');

  g.Graph buildGraph() {
    var graph = g.Graph();
    for (final n in [mika, fred, fire]) {
      graph = graph.addNode(n);
    }
    for (final l in [learns, knows]) {
      graph = graph.addLink(l);
    }
    return graph;
  }

  test('an unfiltered graph passes through whole', () {
    final result = applyGraphFilter(buildGraph(), const GraphFilterState());

    expect(result.nodes, hasLength(3));
    expect(result.links, hasLength(2));
  });

  test('hiding a label removes its nodes', () {
    final result = applyGraphFilter(
      buildGraph(),
      const GraphFilterState(hiddenNodeLabels: {'スキル'}),
    );

    expect(result.nodes.keys, isNot(contains(fire.id)));
    expect(result.nodes.keys, contains(mika.id));
    expect(result.nodes.keys, contains(fred.id));
  });

  test('a link loses its place when either endpoint is hidden', () {
    final result = applyGraphFilter(
      buildGraph(),
      const GraphFilterState(hiddenNodeLabels: {'スキル'}),
    );

    // 習得 reached the hidden skill, so it goes even though ミカ remains.
    expect(result.links.keys, isNot(contains(learns.id)));
    // 知人 joins two visible nodes and stays.
    expect(result.links.keys, contains(knows.id));
  });

  test('hiding a link type leaves its endpoints alone', () {
    final result = applyGraphFilter(
      buildGraph(),
      const GraphFilterState(hiddenLinkTypes: {'習得'}),
    );

    expect(result.nodes, hasLength(3), reason: 'nodes are not link types');
    expect(result.links.keys, isNot(contains(learns.id)));
    expect(result.links.keys, contains(knows.id));
  });

  test('a node keeps its place while any of its labels is shown', () {
    final hybrid = node('01000000-0000-7000-8000-000000000004', {
      'キャラクター',
      'スキル',
    });
    final graph = buildGraph().addNode(hybrid);

    final result = applyGraphFilter(
      graph,
      const GraphFilterState(hiddenNodeLabels: {'スキル'}),
    );

    // Hiding one of its labels does not outweigh the one still asked for.
    expect(result.nodes.keys, contains(hybrid.id));
  });

  test('hiding every label a node carries removes it', () {
    final hybrid = node('01000000-0000-7000-8000-000000000004', {
      'キャラクター',
      'スキル',
    });
    final graph = buildGraph().addNode(hybrid);

    final result = applyGraphFilter(
      graph,
      const GraphFilterState(hiddenNodeLabels: {'スキル', 'キャラクター'}),
    );

    expect(result.nodes, isEmpty);
    expect(result.links, isEmpty, reason: 'no endpoints left to join');
  });

  test('a node with no labels at all is never hidden', () {
    final orphan = node('01000000-0000-7000-8000-000000000005', {});
    final graph = buildGraph().addNode(orphan);

    final result = applyGraphFilter(
      graph,
      const GraphFilterState(hiddenNodeLabels: {'スキル', 'キャラクター'}),
    );

    // Nothing the user hid describes it, so hiding it would be unexplainable.
    expect(result.nodes.keys, contains(orphan.id));
  });
}
