/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../../providers/graph_filter_providers.dart';
import '../../widgets/graph_view.dart';
import '../../models/layout_config.dart';

/// Graph view widget
///
/// Takes the unfiltered graph and hides through [AppGraphView.hiddenNodeIds]
/// rather than rendering the filtered graph the rest of the screen uses. A
/// hidden node has to stay in the graph to keep the position it was laid out
/// at; removing it and adding it back on unhide loses that position and the
/// node returns at the origin. The table view has no such state, so it keeps
/// taking the filtered graph.
class GraphViewWidget extends ConsumerWidget {
  const GraphViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(core_graph.activeGraphProvider);
    if (graph == null) {
      return const SizedBox.shrink();
    }

    final hidden = ref.watch(graphHiddenIdsProvider);

    return AppGraphView(
      appGraph: graph,
      layoutConfig: const ForceDirectedLayoutConfig(),
      hiddenNodeIds: hidden.nodeIds,
      hiddenLinkIds: hidden.linkIds,
    );
  }
}
