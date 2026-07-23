/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_common/src/model/entity.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/query/graph_query.dart';
import 'package:core_graph_common/src/query/predicate.dart';
import 'package:core_graph_common/src/query/sort_descriptor.dart';

/// Converts GraphQuery to ChiffonDB traversal command JSON.
class ChiffonQueryConverter {
  /// Converts a GraphQuery to a ChiffonDB traversal command map.
  static Map<String, dynamic> toTraversalCommand<T extends Entity>(
    GraphQuery<T> query,
  ) {
    final steps = <Map<String, dynamic>>[];

    // Build label filter for the start step
    String? primaryLabel;
    if (T == Node) {
      primaryLabel = null; // scans all nodes by default
    } else if (T == Link) {
      primaryLabel = null; // scans all edges by default
    }

    // Predicate steps
    final combinedPredicate =
        query.predicates.isEmpty
            ? null
            : query.predicates.length == 1
            ? query.predicates.first
            : CompoundPredicate(CompoundOperator.and, query.predicates);

    if (combinedPredicate != null) {
      _addPredicateSteps(steps, combinedPredicate, primaryLabel);
    }

    // Sort
    for (final descriptor in query.sortDescriptors) {
      steps.add(_sortStep(descriptor));
    }

    // Pagination: skip then limit
    if (query.offset != null && query.offset! > 0) {
      steps.add({'action': 'Skip', 'skip': query.offset});
    }
    if (query.limit != null) {
      steps.add({'action': 'Limit', 'count': query.limit});
    }

    final collectType = T == Link ? 'Edges' : 'Nodes';

    return {
      'version': 1,
      'start': {
        'type': T == Link ? 'AllEdges' : 'AllNodes',
        if (primaryLabel != null) 'label': primaryLabel,
      },
      'steps': steps,
      'collect': {'type': collectType, 'properties': []},
    };
  }

  static void _addPredicateSteps(
    List<Map<String, dynamic>> steps,
    Predicate predicate,
    String? label,
  ) {
    if (predicate is AnyKeyContainsPredicate) {
      steps.add({'action': 'Filter', 'any_key_contains': predicate.value});
    } else if (predicate is PropertyPredicate) {
      final filter = _propertyPredicateToFilter(predicate);
      if (filter != null) {
        steps.add({'action': 'Filter', 'filter': filter});
      }
    } else if (predicate is LabelPredicate) {
      steps.add({
        'action': 'HasLabel',
        'label': predicate.label,
        'has': predicate.hasLabel,
      });
    } else if (predicate is CompoundPredicate) {
      steps.add({'action': 'Filter', 'filter': _compoundToFilter(predicate)});
    }
    // LinkPredicate is not applicable to flat node/edge queries
  }

  static Map<String, dynamic>? _propertyPredicateToFilter(
    PropertyPredicate predicate,
  ) {
    final key = predicate.propertyKey;
    final value = predicate.value;

    return switch (predicate.operator) {
      PredicateOperator.equals => {
        'operator': 'Equals',
        'property': _propertyRef(key),
        'value': value,
      },
      PredicateOperator.notEquals => {
        'operator': 'NotEquals',
        'property': _propertyRef(key),
        'value': value,
      },
      PredicateOperator.greaterThan => {
        'operator': 'GreaterThan',
        'property': _propertyRef(key),
        'value': value,
      },
      PredicateOperator.lessThan => {
        'operator': 'LessThan',
        'property': _propertyRef(key),
        'value': value,
      },
      PredicateOperator.greaterThanOrEquals => {
        'operator': 'GreaterThanOrEquals',
        'property': _propertyRef(key),
        'value': value,
      },
      PredicateOperator.lessThanOrEquals => {
        'operator': 'LessThanOrEquals',
        'property': _propertyRef(key),
        'value': value,
      },
      PredicateOperator.contains => {
        'operator': 'Contains',
        'property': _propertyRef(key),
        'value': value,
      },
      PredicateOperator.beginsWith => {
        'operator': 'StartsWith',
        'property': _propertyRef(key),
        'value': value,
      },
      PredicateOperator.endsWith => {
        'operator': 'EndsWith',
        'property': _propertyRef(key),
        'value': value,
      },
      PredicateOperator.inList => {
        'type': 'compound_filter',
        'operator': 'Or',
        'filters':
            (value as List)
                .map(
                  (v) => {
                    'operator': 'Equals',
                    'property': _propertyRef(key),
                    'value': v,
                  },
                )
                .toList(),
      },
      PredicateOperator.notInList => {
        'type': 'compound_filter',
        'operator': 'And',
        'filters':
            (value as List)
                .map(
                  (v) => {
                    'operator': 'NotEquals',
                    'property': _propertyRef(key),
                    'value': v,
                  },
                )
                .toList(),
      },
      PredicateOperator.isNull => {
        'operator': 'IsNull',
        'property': _propertyRef(key),
      },
      PredicateOperator.isNotNull => {
        'operator': 'Exists',
        'property': _propertyRef(key),
      },
    };
  }

  static Map<String, dynamic> _compoundToFilter(CompoundPredicate predicate) {
    final operator = switch (predicate.operator) {
      CompoundOperator.and => 'And',
      CompoundOperator.or => 'Or',
      CompoundOperator.not => 'Not',
    };

    if (predicate.operator == CompoundOperator.not) {
      final inner = _predicateToFilter(predicate.predicates.first);
      return {'type': 'compound_filter', 'operator': operator, 'filter': inner};
    }

    return {
      'type': 'compound_filter',
      'operator': operator,
      'filters':
          predicate.predicates
              .map((p) => _predicateToFilter(p))
              .whereType<Map<String, dynamic>>()
              .toList(),
    };
  }

  static Map<String, dynamic>? _predicateToFilter(Predicate predicate) {
    if (predicate is PropertyPredicate) {
      return _propertyPredicateToFilter(predicate);
    } else if (predicate is CompoundPredicate) {
      return _compoundToFilter(predicate);
    } else if (predicate is AnyKeyContainsPredicate) {
      return {'any_key_contains': predicate.value};
    }
    return null;
  }

  static Map<String, dynamic> _sortStep(SortDescriptor descriptor) {
    return {
      'action': 'OrderBy',
      'order_by': {
        'key': _propertyRef(descriptor.property),
        'direction': descriptor.ascending ? 'Asc' : 'Desc',
      },
    };
  }

  /// Resolves a logical property key to a ChiffonDB traversal property
  /// reference.
  ///
  /// On the meta-schema, the app's own metadata (`app_id`, `app_type`, …) lives
  /// at the top level, while the user's arbitrary properties are nested under a
  /// single `props` Json field. Metadata keys stay flat; everything else is
  /// addressed with a nested path `["props", key]`, which ChiffonDB resolves
  /// into the Json value (see the 0.2.0 path-search support).
  static Object _propertyRef(String key) {
    if (key.startsWith('app_')) return key;
    return {
      'path': ['props', key],
    };
  }
}
