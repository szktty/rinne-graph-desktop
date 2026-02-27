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

/// Class to manage the state of link creation
@immutable
class TapLinkCreationState {
  final LinkCreationStep step;
  final core_graph.EntityId? sourceNodeId;
  final core_graph.EntityId? targetNodeId;

  const TapLinkCreationState({
    this.step = LinkCreationStep.idle,
    this.sourceNodeId,
    this.targetNodeId,
  });

  TapLinkCreationState copyWith({
    LinkCreationStep? step,
    core_graph.EntityId? sourceNodeId,
    core_graph.EntityId? targetNodeId,
    bool clearSource = false,
    bool clearTarget = false,
  }) {
    return TapLinkCreationState(
      step: step ?? this.step,
      sourceNodeId: clearSource ? null : sourceNodeId ?? this.sourceNodeId,
      targetNodeId: clearTarget ? null : targetNodeId ?? this.targetNodeId,
    );
  }
}

/// Tap-based link creation mode state provider
@riverpod
class TapLinkCreation extends _$TapLinkCreation {
  @override
  TapLinkCreationState build() {
    return const TapLinkCreationState();
  }

  /// Starts link creation mode
  void start() {
    if (state.step == LinkCreationStep.idle) {
      state = state.copyWith(step: LinkCreationStep.awaitingSource);
    }
  }

  /// Toggles the mode
  void toggle() {
    if (state.step == LinkCreationStep.idle) {
      start();
    } else {
      cancel();
    }
  }

  /// Selects the source node
  void selectSource(core_graph.EntityId nodeId) {
    if (state.step == LinkCreationStep.awaitingSource) {
      state = state.copyWith(
        step: LinkCreationStep.awaitingTarget,
        sourceNodeId: nodeId,
      );
    } else if (state.step == LinkCreationStep.awaitingTarget) {
      // Assume the second node is selected and set it as the new source
      state = state.copyWith(
        step: LinkCreationStep.awaitingTarget,
        sourceNodeId: nodeId,
        clearTarget: true,
      );
    }
  }

  /// Selects the target node
  void selectTarget(core_graph.EntityId nodeId) {
    if (state.step == LinkCreationStep.awaitingTarget &&
        state.sourceNodeId != nodeId) {
      state = state.copyWith(
        step: LinkCreationStep.confirming,
        targetNodeId: nodeId,
      );
    } else if (state.step == LinkCreationStep.awaitingTarget &&
        state.sourceNodeId == nodeId) {
      // If the same node is tapped, cancel source selection
      state = state.copyWith(
        step: LinkCreationStep.awaitingSource,
        clearSource: true,
      );
    }
  }

  /// Completes link creation and maintains mode for continuous creation
  void completeAndContinue() {
    state = const TapLinkCreationState(step: LinkCreationStep.awaitingSource);
  }

  /// Cancels the operation and exits the mode
  void cancel() {
    state = const TapLinkCreationState();
  }
}
