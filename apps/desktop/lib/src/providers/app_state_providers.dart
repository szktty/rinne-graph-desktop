/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:presentation_components/presentation_components.dart';

part 'app_state_providers.g.dart';

/// Manages the selected index of the main activity bar.
@riverpod
class ActivityBarState extends _$ActivityBarState {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

/// Alias for selected activity index for compatibility
@riverpod
int selectedActivityIndex(Ref ref) {
  return ref.watch(activityBarStateProvider);
}

/// Manages the selected index within the graph navigation sidebar.
/// -1 indicates no specific item is selected (e.g., showing "All" stacks).
@riverpod
class GraphNavSidebarState extends _$GraphNavSidebarState {
  @override
  int build() => -1;

  void setIndex(int index) {
    state = index;
  }
}

/// Manages the selected index for the settings sidebar categories.
@riverpod
class SettingsUiState extends _$SettingsUiState {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

// activeStackProvider は core_stack_flutter パッケージに移動されました
// import 'package:core_stack_flutter/core_stack.dart' as core_stack;
// final activeStackProvider = core_stack.activeStackProvider;

/// Provider managing the tab state of the unified sidebar
/// 0: browse tab, 1: search tab
@riverpod
class UnifiedSidebarTab extends _$UnifiedSidebarTab {
  @override
  int build() => 0; // Default is browse tab

  void setTab(int tab) {
    state = tab;
  }

  void setBrowseTab() {
    state = 0;
  }

  void setSearchTab() {
    state = 1;
  }
}

/// Provider managing secondary sidebar state per screen
/// Retains and restores state based on activity bar index
@riverpod
class ScreenBasedSecondarySidebarState
    extends _$ScreenBasedSecondarySidebarState {
  @override
  bool build() {
    // Get current activity bar index
    final currentScreenIndex = ref.watch(activityBarStateProvider);

    // Get current screen state from provider managing state per screen
    final perScreenStateNotifier = ref.watch(
      perScreenSecondarySidebarStateProvider.notifier,
    );
    final currentState = perScreenStateNotifier.getStateForScreen(
      currentScreenIndex,
    );

    return currentState;
  }

  /// Show secondary sidebar
  void show() {
    final currentScreenIndex = ref.read(activityBarStateProvider);
    ref
        .read(perScreenSecondarySidebarStateProvider.notifier)
        .setStateForScreen(currentScreenIndex, true);

    // Also update current state
    ref.read(secondarySidebarStateProvider.notifier).show();
  }

  /// Hide secondary sidebar
  void hide() {
    final currentScreenIndex = ref.read(activityBarStateProvider);
    ref
        .read(perScreenSecondarySidebarStateProvider.notifier)
        .setStateForScreen(currentScreenIndex, false);

    // Also update current state
    ref.read(secondarySidebarStateProvider.notifier).hide();
  }

  /// Toggle secondary sidebar
  void toggle() {
    final currentScreenIndex = ref.read(activityBarStateProvider);
    ref
        .read(perScreenSecondarySidebarStateProvider.notifier)
        .toggleStateForScreen(currentScreenIndex);

    // Also update current state
    ref.read(secondarySidebarStateProvider.notifier).toggle();
  }

  /// Set visibility state
  void setVisible(bool visible) {
    final currentScreenIndex = ref.read(activityBarStateProvider);
    ref
        .read(perScreenSecondarySidebarStateProvider.notifier)
        .setStateForScreen(currentScreenIndex, visible);

    // Also update current state
    ref.read(secondarySidebarStateProvider.notifier).setVisible(visible);
  }
}

/// Provider that monitors activity bar changes and restores secondary sidebar state
@riverpod
class ActivityBarChangeListener extends _$ActivityBarChangeListener {
  @override
  void build() {
    // Monitor activity bar changes
    ref.listen(activityBarStateProvider, (previous, next) {
      if (previous != null && previous != next) {
        // If screen switched, restore new screen state
        final perScreenStateNotifier = ref.read(
          perScreenSecondarySidebarStateProvider.notifier,
        );
        final newScreenState = perScreenStateNotifier.getStateForScreen(next);

        // Update secondary sidebar state to new screen state
        ref
            .read(secondarySidebarStateProvider.notifier)
            .setVisible(newScreenState);

        debugPrint(
          '[ActivityBarChangeListener] Screen changed from $previous to $next, sidebar state: $newScreenState',
        );
      }
    });
  }
}

/// Provider managing tab state of graph navigator sidebar
/// 0: navigator tab, 1: search tab
@riverpod
class GraphNavigatorTab extends _$GraphNavigatorTab {
  @override
  int build() => 0; // Default is navigator tab

  void setTab(int tab) {
    state = tab;
  }

  void setNavigationTab() {
    state = 0;
  }

  void setSearchTab() {
    state = 1;
  }
}

/// Simple pathfinder state for graph search functionality
class PathfinderState {
  PathfinderState({this.activeGraph});

  core_graph.Graph? activeGraph;
  List<core_graph.Entity> recentItems = [];

  void setActiveGraph(core_graph.Graph? graph) {
    activeGraph = graph;
  }

  List<core_graph.Entity> searchEntities(String query) {
    if (activeGraph == null || query.isEmpty) {
      return [];
    }

    final results = <core_graph.Entity>[];

    // Search in nodes
    for (final node in activeGraph!.nodes.values) {
      final nameProperty = node.properties.getValue('name');
      if (nameProperty != null &&
          nameProperty.toString().toLowerCase().contains(query.toLowerCase())) {
        results.add(node);
      }
    }

    // Search in links
    for (final link in activeGraph!.links.values) {
      final descProperty = link.properties.getValue('description');
      if (descProperty != null &&
          descProperty.toString().toLowerCase().contains(query.toLowerCase())) {
        results.add(link);
      }
    }

    return results;
  }

  void addRecentItem(core_graph.Entity entity) {
    recentItems.removeWhere((item) => item.id == entity.id);
    recentItems.insert(0, entity);
    if (recentItems.length > 10) {
      recentItems = recentItems.take(10).toList();
    }
  }
}

/// Pathfinder state provider for graph navigation
@riverpod
class PathfinderStateNotifier extends _$PathfinderStateNotifier {
  @override
  PathfinderState build() => PathfinderState();

  void setActiveGraph(core_graph.Graph? graph) {
    state.setActiveGraph(graph);
    // Trigger rebuild
    state = PathfinderState(activeGraph: graph)
      ..recentItems = state.recentItems;
  }

  List<core_graph.Entity> searchEntities(String query) {
    return state.searchEntities(query);
  }

  void addRecentItem(core_graph.Entity entity) {
    state.addRecentItem(entity);
    // Trigger rebuild
    state = PathfinderState(activeGraph: state.activeGraph)
      ..recentItems = state.recentItems;
  }
}

/// Provider for current stack path (overrides core_graph provider)
// @riverpod
// String? currentStackPath(Ref ref) {
//   final activeStack = ref.watch(activeStackProvider);
//   return activeStack?.path;
// }

/// Provider managing welcome dialog visibility state
final welcomeDialogVisibilityProvider = StateProvider<bool>((ref) => false);

/// Provider to prevent duplicate display of welcome dialog
final welcomeDialogShowingProvider = StateProvider<bool>((ref) => false);

/// Remote command server enabled/disabled (switched by dart-define)
final remoteCommandsEnabledProvider = Provider<bool>((ref) {
  return const String.fromEnvironment(
        'ENABLE_REMOTE_COMMANDS',
        defaultValue: 'true',
      ) ==
      'true';
});

/// Provider managing import dialog visibility state
final importDialogShowingProvider = StateProvider<bool>((ref) => false);
