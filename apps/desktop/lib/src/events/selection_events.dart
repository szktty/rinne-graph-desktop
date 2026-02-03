import 'package:core_events/core_events.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

/// Source of selection operation
enum SelectionSource {
  /// Selection from UI (graph view)
  ui,

  /// Selection from external source (e.g., inspector panel)
  external,

  /// Programmatic selection (e.g., during initialization)
  program,
}

/// Type definition for selection events
typedef SelectionEvent = Event;

/// Event when an entity is selected
class EntitySelectedEvent extends Event {
  /// ID of the selected entity
  final core_graph.EntityId entityId;

  /// Source of the event
  final SelectionSource source;

  EntitySelectedEvent({
    required this.entityId,
    required this.source,
    super.timestamp,
  });

  @override
  String toString() =>
      'EntitySelectedEvent(entityId: ${entityId.value}, source: $source, timestamp: $timestamp)';
}

/// Event when selection is cleared
class SelectionClearedEvent extends Event {
  /// Source of the event
  final SelectionSource source;

  SelectionClearedEvent({required this.source, super.timestamp});

  @override
  String toString() =>
      'SelectionClearedEvent(source: $source, timestamp: $timestamp)';
}
