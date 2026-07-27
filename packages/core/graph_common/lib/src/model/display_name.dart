/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_common/core_graph_common.dart';

/// Resolves the caption shown for a node.
///
/// The rules live here, rather than next to a particular renderer, because
/// several places have to agree on what a node is called: the circle in the
/// graph view, the link lists in the record editor, UI-test commands and
/// exports. See `docs/stack/stack_exchange_format_specification.md` for the
/// reserved-property side of this.
abstract final class DisplayName {
  /// Property keys tried, in order, when a node has no `_display_name`.
  ///
  /// Follows the convention Neo4j Browser uses: rather than requiring the user
  /// to configure a caption property, probe the names data usually carries.
  /// English keys come before Japanese ones so that a stack mixing both is
  /// resolved predictably. `name` has no special status here — it is simply the
  /// most common member of this list.
  static const List<String> candidateKeys = [
    'name',
    'title',
    'label',
    'caption',
    '名前',
    '名称',
    '氏名',
    'タイトル',
    'ラベル',
    'キャプション',
  ];

  /// The reserved property that names a node explicitly.
  static const String displayNameKey = '_display_name';

  /// Resolves a caption from an arbitrary property lookup.
  ///
  /// [property] returns the value for a key, or null. Taking a lookup function
  /// rather than a [Node] lets callers holding a different node representation
  /// — plough's `GraphNode`, say — resolve captions by the same rules.
  ///
  /// Resolution order:
  ///   1. `_display_name` — the reserved property that names a node explicitly
  ///      (e.g. a short form to use when `name` is too long for the circle).
  ///   2. the candidate keys above.
  ///   3. the node's type label (`人物`, `god`, ...). Every node carries one on
  ///      the ChiffonDB meta-schema, so this must come *after* the name
  ///      lookups — probing labels first would render the type on every node.
  ///   4. a fragment of the node's ID.
  ///
  /// A future `_display_name_key` schema entry will slot in between 1 and 2,
  /// letting a label declare which property holds its name.
  static String resolve({
    required Object? Function(String key) property,
    required Set<String> labels,
    required String id,
  }) {
    final explicit = property(displayNameKey)?.toString();
    if (explicit != null && explicit.isNotEmpty) {
      return explicit;
    }

    for (final key in candidateKeys) {
      final value = property(key)?.toString();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    if (labels.isNotEmpty) {
      return labels.first;
    }

    return id.length > 8 ? '${id.substring(0, 8)}...' : id;
  }

  /// Resolves the caption for [node].
  static String ofNode(Node node) {
    final properties = node.properties.toMap();
    return resolve(
      property: (key) => properties[key],
      labels: node.labels,
      id: node.id.value,
    );
  }
}
