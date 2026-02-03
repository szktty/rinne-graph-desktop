import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

part 'link_creation_providers.g.dart';

/// State of the link creation mode
class LinkCreationState {
  /// Whether link creation mode is active
  final bool isActive;

  /// Start node ID for link creation (set when mode is active)
  final core_graph.EntityId? sourceNodeId;

  /// Target node ID during drag (set on hover)
  final core_graph.EntityId? targetNodeId;

  const LinkCreationState({
    this.isActive = false,
    this.sourceNodeId,
    this.targetNodeId,
  });

  /// Activate the mode
  LinkCreationState activate() {
    return LinkCreationState(
      isActive: true,
      sourceNodeId: sourceNodeId,
      targetNodeId: targetNodeId,
    );
  }

  /// Deactivate the mode
  LinkCreationState deactivate() {
    return const LinkCreationState(
      isActive: false,
      sourceNodeId: null,
      targetNodeId: null,
    );
  }

  LinkCreationState setSourceNode(core_graph.EntityId? nodeId) {
    return LinkCreationState(
      isActive: isActive,
      sourceNodeId: nodeId,
      targetNodeId: targetNodeId,
    );
  }

  LinkCreationState setTargetNode(core_graph.EntityId? nodeId) {
    return LinkCreationState(
      isActive: isActive,
      sourceNodeId: sourceNodeId,
      targetNodeId: nodeId,
    );
  }
}

/// Link creation mode state provider
@riverpod
class LinkCreationMode extends _$LinkCreationMode {
  @override
  LinkCreationState build() {
    return const LinkCreationState();
  }

  /// Activate link creation mode
  void activate() {
    state = state.activate();
  }

  /// Deactivate link creation mode
  void deactivate() {
    state = state.deactivate();
  }

  /// Set the source node
  void setSourceNode(core_graph.EntityId nodeId) {
    state = state.setSourceNode(nodeId);
  }

  /// Set the target node
  void setTargetNode(core_graph.EntityId? nodeId) {
    state = state.setTargetNode(nodeId);
  }

  /// Complete link creation (exit mode)
  void complete() {
    state = state.deactivate();
  }

  /// Cancel link creation (exit mode)
  void cancel() {
    state = state.deactivate();
  }
}

/// Provider for the pointer position during drag
@riverpod
class LinkCreationDragPosition extends _$LinkCreationDragPosition {
  @override
  Offset? build() => null;

  /// Update the pointer position during drag
  void updatePosition(Offset position) {
    state = position;
  }

  /// Clear the pointer position at the end of drag
  void clear() {
    state = null;
  }
}
