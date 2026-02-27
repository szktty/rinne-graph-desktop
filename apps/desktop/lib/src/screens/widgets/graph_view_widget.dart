/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../../widgets/graph_view.dart';
import '../../models/layout_config.dart';

/// Graph view widget
class GraphViewWidget extends StatelessWidget {
  const GraphViewWidget({required this.activeGraph, super.key});

  final core_graph.Graph activeGraph;

  @override
  Widget build(BuildContext context) {
    return AppGraphView(
      appGraph: activeGraph,
      layoutConfig: const ForceDirectedLayoutConfig(),
    );
  }
}
