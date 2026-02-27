/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

part 'graph_status_providers.g.dart';

/// Provider that provides detailed information about the selected entity
@riverpod
class SelectedEntityInfo extends _$SelectedEntityInfo {
  @override
  Future<SelectedEntityData?> build() async {
    // Monitor core_graph's unified selection ID provider
    final selectedEntityId = ref.watch(core_graph.selectedEntityIdProvider);
    if (selectedEntityId == null) {
      return null;
    }

    // Get active graph
    final graph = ref.watch(core_graph.activeGraphProvider);
    if (graph == null) {
      return null;
    }

    try {
      // TODO: Change to implementation that gets entity information from actual graph data
      // Currently returns basic information as a temporary implementation
      final displayName = 'Entity ${selectedEntityId.value}';

      // Temporary implementation: treat as node
      return SelectedEntityData.node(
        displayName: displayName,
        linkCount: 0, // TODO: Get actual link count
      );
    } catch (e) {
      // Return null if an error occurs
      return null;
    }
  }
}

/// Provider that provides graph statistics information
@riverpod
class GraphStatisticsInfo extends _$GraphStatisticsInfo {
  @override
  Future<GraphStatisticsData?> build() async {
    // Use core_graph's graph statistics provider
    try {
      final stats = await ref.watch(core_graph.graphStatisticsProvider.future);
      final nodeCount = stats.nodeCount;
      final linkCount = stats.linkCount;
      final totalRecords = nodeCount + linkCount;

      // Currently, displayed items = total items (will be updated when filter is applied in the future)
      final displayedRecords = totalRecords;

      return GraphStatisticsData(
        totalRecords: totalRecords,
        displayedRecords: displayedRecords,
        nodeCount: nodeCount,
        linkCount: linkCount,
      );
    } catch (e) {
      // Return null if an error occurs
      return null;
    }
  }
}

/// Provider that manages search and filter state
@riverpod
class SearchFilterState extends _$SearchFilterState {
  @override
  SearchFilterData build() {
    // TODO: Monitor actual search and filter state
    // Currently returns always non-applied state as temporary implementation
    return const SearchFilterData(isActive: false, filteredRecords: 0);
  }

  /// Updates search and filter state
  void updateState({required bool isActive, required int filteredRecords}) {
    state = SearchFilterData(
      isActive: isActive,
      filteredRecords: filteredRecords,
    );
  }
}

/// Data class for selected entity
sealed class SelectedEntityData {
  const SelectedEntityData({required this.displayName});

  final String displayName;

  const factory SelectedEntityData.node({
    required String displayName,
    required int linkCount,
  }) = SelectedNodeData;

  const factory SelectedEntityData.link({
    required String displayName,
    required int nodeCount,
  }) = SelectedLinkData;
}

/// Data class for selected node
class SelectedNodeData extends SelectedEntityData {
  const SelectedNodeData({required super.displayName, required this.linkCount});

  final int linkCount;
}

/// Data class for selected link
class SelectedLinkData extends SelectedEntityData {
  const SelectedLinkData({required super.displayName, required this.nodeCount});

  final int nodeCount;
}

/// Data class for graph statistics information
class GraphStatisticsData {
  const GraphStatisticsData({
    required this.totalRecords,
    required this.displayedRecords,
    required this.nodeCount,
    required this.linkCount,
  });

  /// Total record count (nodes + links)
  final int totalRecords;

  /// Currently displayed record count
  final int displayedRecords;

  /// Node count
  final int nodeCount;

  /// Link count
  final int linkCount;
}

/// Data class for search and filter state
class SearchFilterData {
  const SearchFilterData({
    required this.isActive,
    required this.filteredRecords,
  });

  /// Whether search and filter are applied
  final bool isActive;

  /// Number of records after filter is applied
  final int filteredRecords;
}
