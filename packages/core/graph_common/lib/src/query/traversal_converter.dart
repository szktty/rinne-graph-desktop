import 'package:core_graph_common/src/model/entity.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:core_graph_common/src/query/graph_query.dart';
import 'package:core_graph_common/src/query/predicate.dart';
import 'package:core_graph_common/src/query/sort_descriptor.dart';
import 'package:rinne_graph/rinne_graph.dart' as rg;

/// Utility class to convert GraphQuery to RinneGraph traversal.
class TraversalConverter {
  /// Converts GraphQuery to RinneGraph traversal.
  ///
  /// [query] The GraphQuery to convert.
  /// [source] The traversal source of RinneGraph.
  /// Returns: The configured traversal.
  static rg.Traversal convertToTraversal<T extends Entity>(
    GraphQuery<T> query,
    rg.TraversalSource source,
  ) {
    // Start traversal based on entity type
    rg.Traversal traversal;

    if (query.entityType == Node) {
      // Start with V() for node queries
      traversal = source.V();
    } else if (query.entityType == Link) {
      // Start with E() for link queries
      traversal = source.E();
    } else {
      throw ArgumentError('Unsupported entity type: ${query.entityType}');
    }

    // Apply predicates
    for (final predicate in query.predicates) {
      traversal = _applyPredicate(traversal, predicate);
    }

    // Apply sort conditions
    if (query.sortDescriptors.isNotEmpty) {
      traversal = _applySorting(traversal, query.sortDescriptors);
    }

    // Apply pagination (offset)
    if (query.offset != null && query.offset! > 0) {
      traversal = traversal.skip(query.offset!);
    }

    // Apply limit
    if (query.limit != null) {
      traversal = traversal.limit(query.limit!);
    }

    return traversal;
  }

  /// Applies a predicate to the traversal.
  static rg.Traversal _applyPredicate(
    rg.Traversal traversal,
    Predicate predicate,
  ) {
    if (predicate is PropertyPredicate) {
      return _applyPropertyPredicate(traversal, predicate);
    } else if (predicate is LabelPredicate) {
      return _applyLabelPredicate(traversal, predicate);
    } else if (predicate is CompoundPredicate) {
      return _applyCompoundPredicate(traversal, predicate);
    } else if (predicate is LinkPredicate) {
      return _applyLinkPredicate(traversal, predicate);
    } else {
      // Ignore unsupported predicates
      return traversal;
    }
  }

  /// Applies a property predicate.
  static rg.Traversal _applyPropertyPredicate(
    rg.Traversal traversal,
    PropertyPredicate predicate,
  ) {
    switch (predicate.operator) {
      case PredicateOperator.equals:
        return traversal.hasKey(predicate.propertyKey, predicate.value);

      case PredicateOperator.contains:
        return traversal.hasKeyContains(
          predicate.propertyKey,
          predicate.value.toString(),
        );

      case PredicateOperator.beginsWith:
        return traversal.hasKeyStartsWith(
          predicate.propertyKey,
          predicate.value.toString(),
        );

      case PredicateOperator.endsWith:
        return traversal.hasKeyEndsWith(
          predicate.propertyKey,
          predicate.value.toString(),
        );

      case PredicateOperator.isNull:
        return traversal.hasNot(predicate.propertyKey);

      case PredicateOperator.notEquals:
        // Implement notEquals operation using filter()
        return traversal.filter((dynamic row) {
          if (row == null || row is! Map<String, dynamic>) return false;
          final value = row[predicate.propertyKey];
          return value != predicate.value;
        });

      case PredicateOperator.greaterThan:
        return traversal.hasKeyGreaterThan(
          predicate.propertyKey,
          predicate.value,
        );

      case PredicateOperator.lessThan:
        return traversal.hasKeyLessThan(predicate.propertyKey, predicate.value);

      case PredicateOperator.greaterThanOrEquals:
        // Implement using hasKeyBetween (inclusive of min value, no max value)
        return traversal.filter((dynamic row) {
          if (row == null || row is! Map<String, dynamic>) return false;
          final value = row[predicate.propertyKey];
          if (value == null) return false;
          try {
            if (value is num && predicate.value is num) {
              return value >= (predicate.value as num);
            }
            return value.toString().compareTo(predicate.value.toString()) >= 0;
          } on Exception {
            return false;
          }
        });

      case PredicateOperator.lessThanOrEquals:
        // Implement using hasKeyBetween (no min value, inclusive of max value)
        return traversal.filter((dynamic row) {
          if (row == null || row is! Map<String, dynamic>) return false;
          final value = row[predicate.propertyKey];
          if (value == null) return false;
          try {
            if (value is num && predicate.value is num) {
              return value <= (predicate.value as num);
            }
            return value.toString().compareTo(predicate.value.toString()) <= 0;
          } on Exception {
            return false;
          }
        });

      case PredicateOperator.inList:
        if (predicate.value is! List) {
          throw ArgumentError('inList operator requires a List value');
        }
        return traversal.hasKeyIn(
          predicate.propertyKey,
          predicate.value as List,
        );

      case PredicateOperator.notInList:
        if (predicate.value is! List) {
          throw ArgumentError('notInList operator requires a List value');
        }
        return traversal.hasKeyNotIn(
          predicate.propertyKey,
          predicate.value as List,
        );

      case PredicateOperator.isNotNull:
        // Implement isNotNull operation using filter()
        return traversal.filter((dynamic row) {
          if (row == null || row is! Map<String, dynamic>) return false;
          return row.containsKey(predicate.propertyKey) &&
              row[predicate.propertyKey] != null;
        });
    }
  }

  /// Applies a label predicate.
  static rg.Traversal _applyLabelPredicate(
    rg.Traversal traversal,
    LabelPredicate predicate,
  ) {
    if (predicate.hasLabel) {
      return traversal.hasLabel([predicate.label]);
    } else {
      return traversal.hasNotLabel([predicate.label]);
    }
  }

  /// Applies a compound predicate.
  static rg.Traversal _applyCompoundPredicate(
    rg.Traversal traversal,
    CompoundPredicate predicate,
  ) {
    switch (predicate.operator) {
      case CompoundOperator.and:
        // AND condition: apply predicates sequentially
        var result = traversal;
        for (final p in predicate.predicates) {
          result = _applyPredicate(result, p);
        }
        return result;

      case CompoundOperator.or:
        // OR condition: execute multiple queries and merge
        // filter() has issues with different data formats, so execute individual queries
        if (predicate.predicates.isEmpty) return traversal;

        // Set a special marker for individual query execution and merging
        // Actual execution needs to be done later in a batch, but here it is temporarily implemented with filter
        return traversal.filter((dynamic row) {
          // Only PropertyPredicate is supported (other predicates are too complex)
          if (row == null || row is! Map<String, dynamic>) return false;

          for (final p in predicate.predicates) {
            if (p is PropertyPredicate && _evaluatePropertyPredicate(row, p)) {
              return true;
            }
          }
          return false;
        });

      case CompoundOperator.not:
        // NOT condition: implement negation condition with filter
        if (predicate.predicates.isEmpty) return traversal;

        return traversal.filter((dynamic row) {
          // Returns true if all predicates are false
          for (final p in predicate.predicates) {
            if (_evaluatePredicate(row, p)) {
              return false; // If even one is true, the result of NOT is false
            }
          }
          return true; // If all are false, the result of NOT is true
        });
    }
  }

  /// Applies a link predicate (used in node queries).
  static rg.Traversal _applyLinkPredicate(
    rg.Traversal traversal,
    LinkPredicate predicate,
  ) {
    rg.Traversal result;

    switch (predicate.direction) {
      case PredicateDirection.outgoing:
        // Traverse outgoing links
        result = traversal.out([predicate.linkType]);

      case PredicateDirection.incoming:
        // Traverse incoming links
        result = traversal.in_([predicate.linkType]);

      case PredicateDirection.both:
        // Traverse bidirectional links
        result = traversal.both([predicate.linkType]);
    }

    // Apply if there is a target predicate
    if (predicate.targetPredicate != null) {
      result = _applyPredicate(result, predicate.targetPredicate!);
    }

    return result;
  }

  /// Apply sort conditions
  static rg.Traversal _applySorting(
    rg.Traversal traversal,
    List<SortDescriptor> sortDescriptors,
  ) {
    // Use RinneGraph's sort API
    var orderedTraversal = traversal.order();

    for (final descriptor in sortDescriptors) {
      final sortOrder =
          descriptor.ascending ? rg.SortOrder.asc : rg.SortOrder.desc;

      orderedTraversal = orderedTraversal.byKey(descriptor.property, sortOrder);
    }

    return orderedTraversal;
  }

  /// Evaluates a single predicate (used within a filter).
  static bool _evaluatePredicate(dynamic row, Predicate predicate) {
    if (row == null || row is! Map<String, dynamic>) return false;

    if (predicate is PropertyPredicate) {
      return _evaluatePropertyPredicate(row, predicate);
    } else if (predicate is LabelPredicate) {
      return _evaluateLabelPredicate(row, predicate);
    } else if (predicate is CompoundPredicate) {
      return _evaluateCompoundPredicate(row, predicate);
    }

    return false;
  }

  /// Evaluates a property predicate.
  static bool _evaluatePropertyPredicate(
    Map<String, dynamic> row,
    PropertyPredicate predicate,
  ) {
    final value = row[predicate.propertyKey];

    switch (predicate.operator) {
      case PredicateOperator.equals:
        return value == predicate.value;

      case PredicateOperator.notEquals:
        return value != predicate.value;

      case PredicateOperator.contains:
        if (value == null) return false;
        return value.toString().contains(predicate.value.toString());

      case PredicateOperator.beginsWith:
        if (value == null) return false;
        return value.toString().startsWith(predicate.value.toString());

      case PredicateOperator.endsWith:
        if (value == null) return false;
        return value.toString().endsWith(predicate.value.toString());

      case PredicateOperator.greaterThan:
        if (value == null) return false;
        try {
          if (value is num && predicate.value is num) {
            return value > (predicate.value as num);
          }
          return value.toString().compareTo(predicate.value.toString()) > 0;
        } on Exception {
          return false;
        }

      case PredicateOperator.lessThan:
        if (value == null) return false;
        try {
          if (value is num && predicate.value is num) {
            return value < (predicate.value as num);
          }
          return value.toString().compareTo(predicate.value.toString()) < 0;
        } on Exception {
          return false;
        }

      case PredicateOperator.greaterThanOrEquals:
        if (value == null) return false;
        try {
          if (value is num && predicate.value is num) {
            return value >= (predicate.value as num);
          }
          return value.toString().compareTo(predicate.value.toString()) >= 0;
        } on Exception {
          return false;
        }

      case PredicateOperator.lessThanOrEquals:
        if (value == null) return false;
        try {
          if (value is num && predicate.value is num) {
            return value <= (predicate.value as num);
          }
          return value.toString().compareTo(predicate.value.toString()) <= 0;
        } on Exception {
          return false;
        }

      case PredicateOperator.inList:
        if (value == null || predicate.value is! List) return false;
        return (predicate.value as List).contains(value);

      case PredicateOperator.notInList:
        if (value == null || predicate.value is! List) return true;
        return !(predicate.value as List).contains(value);

      case PredicateOperator.isNull:
        return !row.containsKey(predicate.propertyKey) || value == null;

      case PredicateOperator.isNotNull:
        return row.containsKey(predicate.propertyKey) && value != null;
    }
  }

  /// Evaluates a label predicate.
  static bool _evaluateLabelPredicate(
    Map<String, dynamic> row,
    LabelPredicate predicate,
  ) {
    // Since label information is not included in the row,
    // simply return true here.
    // In the actual implementation, it is necessary to get the label information
    // from the RinneGraph Vertex/Edge object.
    return predicate.hasLabel;
  }

  /// Evaluates a compound predicate.
  static bool _evaluateCompoundPredicate(
    Map<String, dynamic> row,
    CompoundPredicate predicate,
  ) {
    switch (predicate.operator) {
      case CompoundOperator.and:
        for (final p in predicate.predicates) {
          if (!_evaluatePredicate(row, p)) {
            return false;
          }
        }
        return true;

      case CompoundOperator.or:
        for (final p in predicate.predicates) {
          if (_evaluatePredicate(row, p)) {
            return true;
          }
        }
        return false;

      case CompoundOperator.not:
        for (final p in predicate.predicates) {
          if (_evaluatePredicate(row, p)) {
            return false;
          }
        }
        return true;
    }
  }
}
