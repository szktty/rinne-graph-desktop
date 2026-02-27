/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart';

part 'navigation_providers.g.dart';

/// Provider for managing navigation state.
///
/// Manages the selection state of navigation items and the expansion state of groups.
@riverpod
class NavigationState extends _$NavigationState {
  @override
  NavigationStateData build() {
    return NavigationStateData(expandedGroupIds: [], selectedItemId: null);
  }

  /// Toggle the expansion state of a group.
  void toggleGroup(EntityId groupId) {
    final current = state;
    final isExpanded = current.expandedGroupIds.contains(groupId);

    if (isExpanded) {
      // If expanded, collapse it.
      state = current.copyWith(
        expandedGroupIds:
            current.expandedGroupIds.where((id) => id != groupId).toList(),
      );
    } else {
      // If collapsed, expand it.
      state = current.copyWith(
        expandedGroupIds: [...current.expandedGroupIds, groupId],
      );
    }
  }

  /// Select an item.
  void selectItem(EntityId itemId) {
    state = state.copyWith(selectedItemId: itemId);
  }

  /// Clear the selection.
  void clearSelection() {
    state = state.copyWith(selectedItemId: null);
  }

  /// Check if the specified group ID is expanded.
  bool isGroupExpanded(EntityId groupId) {
    return state.expandedGroupIds.contains(groupId);
  }

  /// Check if the specified item ID is selected.
  bool isItemSelected(EntityId itemId) {
    return state.selectedItemId == itemId;
  }
}

/// Navigation state data class.
class NavigationStateData {
  const NavigationStateData({
    required this.expandedGroupIds,
    required this.selectedItemId,
  });

  /// List of IDs of expanded groups.
  final List<EntityId> expandedGroupIds;

  /// ID of the selected item.
  final EntityId? selectedItemId;

  NavigationStateData copyWith({
    List<EntityId>? expandedGroupIds,
    EntityId? selectedItemId,
  }) {
    return NavigationStateData(
      expandedGroupIds: expandedGroupIds ?? this.expandedGroupIds,
      selectedItemId: selectedItemId ?? this.selectedItemId,
    );
  }
}
