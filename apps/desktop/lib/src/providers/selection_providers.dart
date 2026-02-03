import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_events/core_events.dart';

import '../events/selection_events.dart';

part 'selection_providers.g.dart';

/// Event bus provider for selection events
@riverpod
EventBus<SelectionEvent> selectionEventBus(SelectionEventBusRef ref) {
  final eventBus = EventBus<SelectionEvent>();

  ref.onDispose(() {
    // Event bus cleanup if needed
  });

  return eventBus;
}

/// Class representing selection state
class SelectionState {
  /// ID of the selected entity (null if no selection)
  final core_graph.EntityId? selectedEntityId;

  /// Source of the last selection operation
  final SelectionSource lastSource;

  const SelectionState({this.selectedEntityId, required this.lastSource});

  /// Initial state (nothing selected)
  static const initial = SelectionState(
    selectedEntityId: null,
    lastSource: SelectionSource.program,
  );

  /// Helper method to create a new state
  SelectionState copyWith({
    core_graph.EntityId? selectedEntityId,
    SelectionSource? lastSource,
  }) {
    return SelectionState(
      selectedEntityId: selectedEntityId ?? this.selectedEntityId,
      lastSource: lastSource ?? this.lastSource,
    );
  }

  @override
  String toString() =>
      'SelectionState(selectedEntityId: ${selectedEntityId?.value}, lastSource: $lastSource)';
}

/// Dispatcher provider for dispatching selection events
@riverpod
void Function(SelectionEvent) selectionEventDispatcher(
  SelectionEventDispatcherRef ref,
) {
  final eventBus = ref.watch(selectionEventBusProvider);

  void dispatch(SelectionEvent event) {
    eventBus.dispatch(event);
  }

  return dispatch;
}

/// Provider that manages selection state
@riverpod
class SelectionStateNotifier extends _$SelectionStateNotifier {
  @override
  SelectionState build() {
    // Get event bus
    final eventBus = ref.watch(selectionEventBusProvider);

    // Subscribe to event bus and update selection state
    void handleEvent(SelectionEvent event) {
      debugPrint('Handling selection event: $event');

      if (event is EntitySelectedEvent) {
        // Do nothing if the same entity is selected from the same source
        if (state.selectedEntityId?.value == event.entityId.value &&
            state.lastSource == event.source) {
          debugPrint('Skipping duplicate selection event');
          return;
        }

        // Entity selected
        final newState = SelectionState(
          selectedEntityId: event.entityId,
          lastSource: event.source,
        );
        state = newState;
        debugPrint('Selection state updated: $newState');
      } else if (event is SelectionClearedEvent) {
        // Do nothing if already deselected
        if (state.selectedEntityId == null &&
            state.lastSource == event.source) {
          debugPrint('Skipping duplicate clear event');
          return;
        }

        // Selection cleared
        final newState = SelectionState(
          selectedEntityId: null,
          lastSource: event.source,
        );
        state = newState;
        debugPrint('Selection state updated: $newState');
      }
    }

    // Subscribe to event bus
    eventBus.subscribe(handleEvent);

    // Set up cleanup
    ref.onDispose(() {
      eventBus.unsubscribe(handleEvent);
    });

    return SelectionState.initial;
  }

  /// Selects an entity
  void selectEntity(
    core_graph.EntityId entityId, {
    SelectionSource source = SelectionSource.program,
  }) {
    final dispatch = ref.read(selectionEventDispatcherProvider);
    dispatch(
      EntitySelectedEvent(
        entityId: entityId,
        source: source,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Clears selection
  void clearSelection({SelectionSource source = SelectionSource.program}) {
    final dispatch = ref.read(selectionEventDispatcherProvider);
    dispatch(SelectionClearedEvent(source: source, timestamp: DateTime.now()));
  }
}

/// Provider that provides helper functions for selection operations
@riverpod
SelectionActions selectionActions(SelectionActionsRef ref) {
  final selectionNotifier = ref.read(selectionStateNotifierProvider.notifier);

  return SelectionActions(
    selectEntity: selectionNotifier.selectEntity,
    clearSelection: selectionNotifier.clearSelection,
  );
}

/// Class that provides selection operations
class SelectionActions {
  const SelectionActions({
    required this.selectEntity,
    required this.clearSelection,
  });

  final void Function(core_graph.EntityId, {SelectionSource source})
  selectEntity;
  final void Function({SelectionSource source}) clearSelection;
}
