/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

part 'link_creation_providers.g.dart';

/// Steps for link creation mode
enum LinkCreationStep {
  idle, // Inactive
  awaitingSource, // Waiting for source node
  awaitingTarget, // Waiting for target node
  confirming, // Displaying preview and confirmation UI
}

/// How the current link creation was started.
///
/// The steps are identical across entry points; the trigger only decides what
/// happens after a link is committed. Starting from the toolbar means the user
/// asked for a mode and expects to keep drawing, so it returns to
/// [LinkCreationStep.awaitingSource]. The modifier-key shortcuts are one-shot
/// and return to [LinkCreationStep.idle].
enum LinkCreationTrigger {
  /// The toolbar button put the view into link creation mode.
  toolbarMode,

  /// Alt/Option was held while dragging from a node.
  modifierDrag,

  /// Alt/Option was held while tapping a node.
  modifierTap,
}

/// Class to manage the state of link creation
@immutable
class TapLinkCreationState {
  const TapLinkCreationState({
    this.step = LinkCreationStep.idle,
    this.trigger,
    this.sourceNodeId,
    this.targetNodeId,
    this.hoverTargetNodeId,
    this.pointerScenePosition,
  });

  final LinkCreationStep step;
  final LinkCreationTrigger? trigger;
  final core_graph.EntityId? sourceNodeId;
  final core_graph.EntityId? targetNodeId;

  /// Node currently under the pointer while dragging, highlighted as the
  /// prospective drop target. Distinct from [targetNodeId], which is only set
  /// once the target is committed.
  final core_graph.EntityId? hoverTargetNodeId;

  /// Free end of the preview line, in **scene** coordinates.
  ///
  /// Screen coordinates would go stale the moment the user pans or zooms
  /// mid-drag; scene coordinates stay valid and are converted when painting.
  final Offset? pointerScenePosition;

  bool get isActive => step != LinkCreationStep.idle;

  TapLinkCreationState copyWith({
    LinkCreationStep? step,
    LinkCreationTrigger? trigger,
    core_graph.EntityId? sourceNodeId,
    core_graph.EntityId? targetNodeId,
    core_graph.EntityId? hoverTargetNodeId,
    Offset? pointerScenePosition,
    bool clearSource = false,
    bool clearTarget = false,
    bool clearHoverTarget = false,
    bool clearPointer = false,
  }) {
    return TapLinkCreationState(
      step: step ?? this.step,
      trigger: trigger ?? this.trigger,
      sourceNodeId: clearSource ? null : sourceNodeId ?? this.sourceNodeId,
      targetNodeId: clearTarget ? null : targetNodeId ?? this.targetNodeId,
      hoverTargetNodeId:
          clearHoverTarget ? null : hoverTargetNodeId ?? this.hoverTargetNodeId,
      pointerScenePosition:
          clearPointer
              ? null
              : pointerScenePosition ?? this.pointerScenePosition,
    );
  }
}

/// Link creation state provider.
///
/// A single state machine backs all three entry points — the toolbar button,
/// Alt+drag and Alt+tap — because they differ only in how they start and what
/// they do after committing.
@Riverpod(keepAlive: true)
class TapLinkCreation extends _$TapLinkCreation {
  @override
  TapLinkCreationState build() {
    return const TapLinkCreationState();
  }

  /// Enters link creation mode from the toolbar.
  void start() {
    if (state.step == LinkCreationStep.idle) {
      state = const TapLinkCreationState(
        step: LinkCreationStep.awaitingSource,
        trigger: LinkCreationTrigger.toolbarMode,
      );
    }
  }

  /// Toggles the toolbar mode.
  void toggle() {
    if (state.step == LinkCreationStep.idle) {
      start();
    } else {
      cancel();
    }
  }

  /// Starts with a source already chosen, for the modifier-key shortcuts.
  void startWithSource(
    core_graph.EntityId nodeId, {
    required LinkCreationTrigger trigger,
  }) {
    state = TapLinkCreationState(
      step: LinkCreationStep.awaitingTarget,
      trigger: trigger,
      sourceNodeId: nodeId,
    );
  }

  /// Selects the source node
  void selectSource(core_graph.EntityId nodeId) {
    if (state.step == LinkCreationStep.awaitingSource) {
      state = state.copyWith(
        step: LinkCreationStep.awaitingTarget,
        sourceNodeId: nodeId,
      );
    } else if (state.step == LinkCreationStep.awaitingTarget) {
      // Tapping another node re-aims the link rather than completing it.
      state = state.copyWith(
        step: LinkCreationStep.awaitingTarget,
        sourceNodeId: nodeId,
        clearTarget: true,
      );
    }
  }

  /// Selects the target node
  void selectTarget(core_graph.EntityId nodeId) {
    if (state.step != LinkCreationStep.awaitingTarget) return;

    if (state.sourceNodeId == nodeId) {
      // Tapping the source again clears it and waits for a new one.
      state = state.copyWith(
        step: LinkCreationStep.awaitingSource,
        clearSource: true,
        clearHoverTarget: true,
        clearPointer: true,
      );
      return;
    }

    state = state.copyWith(
      step: LinkCreationStep.confirming,
      targetNodeId: nodeId,
      clearHoverTarget: true,
      clearPointer: true,
    );
  }

  /// Updates the free end of the preview line (scene coordinates).
  void updatePointer(Offset scenePosition) {
    if (!state.isActive) return;
    state = state.copyWith(pointerScenePosition: scenePosition);
  }

  /// Marks (or clears) the node the pointer is currently over.
  void setHoverTarget(core_graph.EntityId? nodeId) {
    if (!state.isActive) return;
    if (nodeId == null) {
      if (state.hoverTargetNodeId == null) return;
      state = state.copyWith(clearHoverTarget: true);
      return;
    }
    if (state.hoverTargetNodeId == nodeId) return;
    state = state.copyWith(hoverTargetNodeId: nodeId);
  }

  /// Settles the state after a link has been created.
  ///
  /// Toolbar mode keeps going so several links can be drawn in a row; the
  /// modifier-key shortcuts are one-shot and end here.
  void finish() {
    if (state.trigger == LinkCreationTrigger.toolbarMode) {
      state = const TapLinkCreationState(
        step: LinkCreationStep.awaitingSource,
        trigger: LinkCreationTrigger.toolbarMode,
      );
    } else {
      state = const TapLinkCreationState();
    }
  }

  /// Cancels the operation and exits the mode
  void cancel() {
    state = const TapLinkCreationState();
  }
}
