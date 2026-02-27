/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../models/pathfinder_item.dart';
import '../models/recent_items_manager.dart';
import '../services/entity_search_service.dart';

part 'pathfinder_providers.g.dart';

/// Provider that manages the open/closed state of the pathfinder.
@riverpod
class PathfinderOpen extends _$PathfinderOpen {
  @override
  bool build() => false;

  void setIsOpen(bool isOpen) {
    state = isOpen;
  }

  void toggle() {
    state = !state;
  }
}

/// Provider that manages the search query for the pathfinder.
@riverpod
class PathfinderSearchQuery extends _$PathfinderSearchQuery {
  @override
  String build() => '';

  void setSearchQuery(String query) {
    state = query;
  }

  void clearQuery() {
    state = '';
  }
}

/// Provider that manages the selected index for the pathfinder.
@riverpod
class PathfinderSelectedIndex extends _$PathfinderSelectedIndex {
  @override
  int build() => 0;

  void setSelectedIndex(int index) {
    state = index;
  }

  void selectNext(List<PathfinderItem> items) {
    if (items.isEmpty) return;
    state = (state + 1) % items.length;
  }

  void selectPrevious(List<PathfinderItem> items) {
    if (items.isEmpty) return;
    state = (state - 1 + items.length) % items.length;
  }
}

/// Provider that manages the item list for the pathfinder.
@riverpod
class PathfinderItems extends _$PathfinderItems {
  @override
  List<PathfinderItem> build() => [];

  void setItems(List<PathfinderItem> items) {
    state = items;
  }

  void addItem(PathfinderItem item) {
    final existingIndex = state.indexWhere((i) => i.id == item.id);
    if (existingIndex >= 0) {
      // Update existing item
      final newItems = List<PathfinderItem>.from(state);
      newItems[existingIndex] = item;
      state = newItems;
    } else {
      // Add new item
      state = [...state, item];
    }
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }
}

/// Provider for the recent items manager.
@riverpod
RecentItemsManager recentItemsManager(Ref ref) {
  final manager = RecentItemsManager(maxItems: 10);

  // Add mock data for development
  if (manager.items.isEmpty) {
    for (final item in generateMockRecentItems()) {
      manager.addItem(item);
    }
  }

  ref.onDispose(() {
    manager.clear();
  });

  return manager;
}

/// Provider for the entity search service.
@riverpod
EntitySearchService entitySearchService(Ref ref) {
  return EntitySearchService();
}

/// Provider that manages the active graph for the pathfinder.
@riverpod
class PathfinderActiveGraph extends _$PathfinderActiveGraph {
  @override
  core_graph.Graph? build() => null;

  void setActiveGraph(core_graph.Graph? graph) {
    state = graph;
  }
}

/// Provider that manages the selected entity.
@riverpod
class SelectedEntity extends _$SelectedEntity {
  @override
  PathfinderItem? build() => null;

  void setSelectedEntity(PathfinderItem? entity) {
    state = entity;
  }

  void clearSelection() {
    state = null;
  }
}

/// Provider that provides a list of recent items.
@riverpod
List<PathfinderItem> recentItems(Ref ref) {
  final manager = ref.watch(recentItemsManagerProvider);
  return manager.items;
}

/// Provider that provides a list of filtered items.
@riverpod
List<PathfinderItem> filteredItems(Ref ref) {
  final recentItems = ref.watch(recentItemsProvider);
  final items = ref.watch(pathfinderItemsProvider);
  final searchQuery = ref.watch(pathfinderSearchQueryProvider);

  final allItems = [...recentItems, ...items];

  if (searchQuery.isEmpty) {
    return allItems;
  }

  return allItems.where((item) {
    return item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        (item.description?.toLowerCase().contains(searchQuery.toLowerCase()) ??
            false);
  }).toList();
}

/// Provider that searches for entities from graph data.
@riverpod
List<PathfinderItem> searchEntities(Ref ref, String query) {
  final activeGraph = ref.watch(pathfinderActiveGraphProvider);
  final searchService = ref.watch(entitySearchServiceProvider);

  if (activeGraph == null || query.isEmpty) {
    return [];
  }

  return searchService.searchEntities(activeGraph, query);
}

/// Action provider for the pathfinder.
@riverpod
class PathfinderActions extends _$PathfinderActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Add to recent items
  void addRecentItem(PathfinderItem item) {
    final manager = ref.read(recentItemsManagerProvider);
    manager.addItem(item);
    // Create a new instance to update the list
    ref.invalidate(recentItemsProvider);
  }

  /// Execute the selected item
  void executeSelectedItem() {
    final filteredItems = ref.read(filteredItemsProvider);
    final selectedIndex = ref.read(pathfinderSelectedIndexProvider);

    if (filteredItems.isEmpty) return;

    final selectedItem = filteredItems[selectedIndex];

    // Add the selected entity to the recent items list
    addRecentItem(selectedItem);

    // Set the selected entity
    ref.read(selectedEntityProvider.notifier).setSelectedEntity(selectedItem);

    debugPrint('Selected item: ${selectedItem.title} (${selectedItem.type})');
  }

  /// Select the next item
  void selectNextItem() {
    final filteredItems = ref.read(filteredItemsProvider);
    ref
        .read(pathfinderSelectedIndexProvider.notifier)
        .selectNext(filteredItems);
  }

  /// Select the previous item
  void selectPreviousItem() {
    final filteredItems = ref.read(filteredItemsProvider);
    ref
        .read(pathfinderSelectedIndexProvider.notifier)
        .selectPrevious(filteredItems);
  }

  /// Register a pathfinder item
  void registerItem(PathfinderItem item) {
    ref.read(pathfinderItemsProvider.notifier).addItem(item);
  }

  /// Register a pathfinder item解除
  void unregisterItem(String itemId) {
    ref.read(pathfinderItemsProvider.notifier).removeItem(itemId);
  }
}

/// Action provider for processing the selected entity.
@riverpod
class SelectedEntityActions extends _$SelectedEntityActions {
  @override
  void build() {
    // No initial state needed
  }

  void processSelectedEntity(PathfinderItem item) {
    // Set the selected entity
    ref.read(selectedEntityProvider.notifier).setSelectedEntity(item);

    // Process based on the type of the selected entity
    switch (item.type) {
      case PathfinderItemType.stack:
        debugPrint('Stack selected: ${item.title}');
        break;
      case PathfinderItemType.node:
        debugPrint('Node selected: ${item.title}');
        break;
      case PathfinderItemType.link:
        debugPrint('Link selected: ${item.title}');
        break;
      case PathfinderItemType.command:
        debugPrint('Command executed: ${item.title}');
        break;
      case PathfinderItemType.searchResult:
        debugPrint('Search result displayed: ${item.title}');
        break;
    }
  }
}
