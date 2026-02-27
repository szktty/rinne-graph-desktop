/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plough/plough.dart' as plough;
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../providers/link_creation_providers.dart';

/// Custom `GraphViewBehavior` that manages link creation via tap operations
class TapLinkCreationBehavior extends plough.GraphViewDefaultBehavior {
  final WidgetRef ref;

  TapLinkCreationBehavior({required this.ref});

  @override
  void onTap(plough.GraphTapEvent event) {
    final linkCreationState = ref.read(tapLinkCreationProvider);

    // Default behavior if not in link creation mode
    if (linkCreationState.step == LinkCreationStep.idle) {
      super.onTap(event);
      return;
    }

    // Get the tapped entity
    final tappedNodeId =
        event.entityIds.isNotEmpty ? event.entityIds.first : null;

    if (tappedNodeId == null || tappedNodeId.type != plough.GraphIdType.node) {
      // If something other than a node is tapped, cancel the mode
      ref.read(tapLinkCreationProvider.notifier).cancel();
      return;
    }

    final coreNodeId = core_graph.EntityId.fromString(tappedNodeId.value);

    // Branch processing based on step
    switch (linkCreationState.step) {
      case LinkCreationStep.awaitingSource:
        ref.read(tapLinkCreationProvider.notifier).selectSource(coreNodeId);
        break;
      case LinkCreationStep.awaitingTarget:
        ref.read(tapLinkCreationProvider.notifier).selectTarget(coreNodeId);
        break;
      case LinkCreationStep.confirming:
        // Ignore graph taps or perform cancellation processing while confirming
        // For now, do nothing
        break;
      case LinkCreationStep.idle:
        // Already processed above
        break;
    }
  }
}
