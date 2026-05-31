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

import '../models/search_models.dart';
import '../services/search_execution_service.dart';
import '../services/search_pattern_translator.dart';
import 'graph_providers.dart';

part 'search_providers.g.dart';

/// Provider managing exploration options state
@riverpod
class ExplorationOptionsState extends _$ExplorationOptionsState {
  @override
  ExplorationOptions build() => const ExplorationOptions();

  void setOptions(ExplorationOptions options) {
    state = options;
  }

  void updateDepth(int depth) {
    state = state.copyWith(depth: depth);
  }
}

/// Provider managing search pattern state
@riverpod
class SearchPatternState extends _$SearchPatternState {
  @override
  SearchPatternStateData build() {
    // Set node patterns as initial state
    final initialNodePatterns = [
      PatternEntity(
        id: 'node1',
        type: PatternEntityType.node,
        label: 'Person',
        keyword: '\'John*\'',
      ),
    ];

    return SearchPatternStateData(
      nodePatterns: initialNodePatterns,
      linkConfigurations: {},
    );
  }

  void setNodePatterns(List<PatternEntity> patterns) {
    state = state.copyWith(nodePatterns: patterns);
  }

  void setLinkConfigurations(Map<String, LinkConfiguration> configurations) {
    state = state.copyWith(linkConfigurations: configurations);
  }

  void addNodePattern(PatternEntity pattern) {
    state = state.copyWith(nodePatterns: [...state.nodePatterns, pattern]);
  }

  void removeNodePattern(String patternId) {
    state = state.copyWith(
      nodePatterns: state.nodePatterns.where((p) => p.id != patternId).toList(),
    );
  }

  void updateNodePattern(String patternId, PatternEntity updatedPattern) {
    final updatedPatterns =
        state.nodePatterns.map((pattern) {
          return pattern.id == patternId ? updatedPattern : pattern;
        }).toList();

    state = state.copyWith(nodePatterns: updatedPatterns);
  }

  void addLinkConfiguration(String key, LinkConfiguration configuration) {
    final updatedConfigurations = Map<String, LinkConfiguration>.from(
      state.linkConfigurations,
    );
    updatedConfigurations[key] = configuration;
    state = state.copyWith(linkConfigurations: updatedConfigurations);
  }

  void removeLinkConfiguration(String key) {
    final updatedConfigurations = Map<String, LinkConfiguration>.from(
      state.linkConfigurations,
    );
    updatedConfigurations.remove(key);
    state = state.copyWith(linkConfigurations: updatedConfigurations);
  }
}

/// Search pattern state data class
class SearchPatternStateData {
  final List<PatternEntity> nodePatterns;
  final Map<String, LinkConfiguration> linkConfigurations;

  const SearchPatternStateData({
    required this.nodePatterns,
    required this.linkConfigurations,
  });

  SearchPatternStateData copyWith({
    List<PatternEntity>? nodePatterns,
    Map<String, LinkConfiguration>? linkConfigurations,
  }) {
    return SearchPatternStateData(
      nodePatterns: nodePatterns ?? this.nodePatterns,
      linkConfigurations: linkConfigurations ?? this.linkConfigurations,
    );
  }
}

/// Provider managing search result state
@riverpod
class SearchResultState extends _$SearchResultState {
  @override
  SearchResult? build() => null;

  void setResult(SearchResult? result) {
    state = result;
  }

  void clearResult() {
    state = null;
  }
}

/// Provider managing search execution state
@riverpod
class SearchExecuting extends _$SearchExecuting {
  @override
  bool build() => false;

  void setExecuting(bool executing) {
    state = executing;
  }

  void startExecution() {
    state = true;
  }

  void stopExecution() {
    state = false;
  }
}

/// Provider managing search error state
@riverpod
class SearchError extends _$SearchError {
  @override
  String? build() => null;

  void setError(String? error) {
    state = error;
  }

  void clearError() {
    state = null;
  }
}

/// Search execution service provider
@riverpod
SearchExecutionService? searchExecutionService(Ref ref) {
  final activeGraphStorage = ref.watch(activeStackGraphStorageProvider);
  if (activeGraphStorage == null) return null;
  return SearchExecutionService(activeGraphStorage);
}

/// Search pattern translation service provider
@riverpod
SearchPatternTranslator searchPatternTranslator(Ref ref) {
  return SearchPatternTranslator();
}

// ---------------------------------------------------------------------------
// Keyword search providers
// ---------------------------------------------------------------------------

/// Keyword search input text.
///
/// Kept alive so the query, results, and highlight survive when the user leaves
/// the search tab (which unmounts the search UI) and so commands that populate
/// these providers before the tab is shown are not discarded by auto-dispose.
@Riverpod(keepAlive: true)
class KeywordSearchQuery extends _$KeywordSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

/// Label/type filter state for keyword search
class KeywordSearchFilters {
  final Set<String> nodeLabels; // empty = all
  final Set<String> linkTypes; // empty = all

  const KeywordSearchFilters({
    this.nodeLabels = const {},
    this.linkTypes = const {},
  });

  KeywordSearchFilters copyWith({
    Set<String>? nodeLabels,
    Set<String>? linkTypes,
  }) => KeywordSearchFilters(
    nodeLabels: nodeLabels ?? this.nodeLabels,
    linkTypes: linkTypes ?? this.linkTypes,
  );
}

@Riverpod(keepAlive: true)
class KeywordSearchFiltersState extends _$KeywordSearchFiltersState {
  @override
  KeywordSearchFilters build() => const KeywordSearchFilters();

  void toggleNodeLabel(String label) {
    final updated = Set<String>.from(state.nodeLabels);
    if (updated.contains(label)) {
      updated.remove(label);
    } else {
      updated.add(label);
    }
    state = state.copyWith(nodeLabels: updated);
  }

  void toggleLinkType(String type) {
    final updated = Set<String>.from(state.linkTypes);
    if (updated.contains(type)) {
      updated.remove(type);
    } else {
      updated.add(type);
    }
    state = state.copyWith(linkTypes: updated);
  }

  void clear() => state = const KeywordSearchFilters();
}

/// Keyword search result (separate from Path Search result)
@Riverpod(keepAlive: true)
class KeywordSearchResult extends _$KeywordSearchResult {
  @override
  SearchResult? build() => null;

  void setResult(SearchResult? result) => state = result;
  void clear() => state = null;
}

/// Keyword search executing flag (separate from Path Search)
@Riverpod(keepAlive: true)
class KeywordSearchExecuting extends _$KeywordSearchExecuting {
  @override
  bool build() => false;

  void start() => state = true;
  void stop() => state = false;
}

/// Available node labels from real graph data
@riverpod
Future<List<String>> availableNodeLabels(Ref ref) async {
  final service = ref.watch(searchExecutionServiceProvider);
  if (service == null) return [];
  final data = await service.getAvailableLabelsAndTypes();
  return (data['nodeLabels'] as List).cast<String>();
}

/// Available link types from real graph data
@riverpod
Future<List<String>> availableLinkTypes(Ref ref) async {
  final service = ref.watch(searchExecutionServiceProvider);
  if (service == null) return [];
  final data = await service.getAvailableLabelsAndTypes();
  return (data['linkTypes'] as List).cast<String>();
}

// ---------------------------------------------------------------------------
// Search highlight and focus providers
// ---------------------------------------------------------------------------

/// Sentinel used so [SearchHighlightState.copyWith] can distinguish "leave
/// [focusedNodeId] unchanged" from "set it to null".
const Object _unset = Object();

/// State for dimming non-matching nodes in the graph view.
///
/// [nodeIds] is the set of highlighted node IDs; [linkIds] the highlighted link
/// IDs. While focused (see [focusedNodeId]) these hold the focused node and its
/// 1-hop neighbourhood instead of the full search result set.
/// [dimEnabled] controls whether the dim effect is active.
/// Dimming is only applied when [dimEnabled] is true and at least one of
/// [nodeIds]/[linkIds] is non-empty.
class SearchHighlightState {
  final Set<core_graph.EntityId> nodeIds;
  final Set<core_graph.EntityId> linkIds;
  final bool dimEnabled;

  /// The node whose neighbourhood the highlight is currently focused on, or
  /// null when showing the full search result set.
  final core_graph.EntityId? focusedNodeId;

  const SearchHighlightState({
    this.nodeIds = const {},
    this.linkIds = const {},
    this.dimEnabled = false,
    this.focusedNodeId,
  });

  SearchHighlightState copyWith({
    Set<core_graph.EntityId>? nodeIds,
    Set<core_graph.EntityId>? linkIds,
    bool? dimEnabled,
    Object? focusedNodeId = _unset,
  }) => SearchHighlightState(
    nodeIds: nodeIds ?? this.nodeIds,
    linkIds: linkIds ?? this.linkIds,
    dimEnabled: dimEnabled ?? this.dimEnabled,
    focusedNodeId:
        identical(focusedNodeId, _unset)
            ? this.focusedNodeId
            : focusedNodeId as core_graph.EntityId?,
  );

  bool get isActive => dimEnabled && (nodeIds.isNotEmpty || linkIds.isNotEmpty);
}

@Riverpod(keepAlive: true)
class SearchHighlight extends _$SearchHighlight {
  @override
  SearchHighlightState build() => const SearchHighlightState();

  /// Sets the matched entity IDs and turns dimming on automatically.
  ///
  /// A search only carries meaning visually when the non-matching entities are
  /// dimmed, so running a search enables the dim effect by default. The user
  /// can still turn it off via [toggleDim]; clearing the search via [clear]
  /// resets everything.
  void setIds({
    required Set<core_graph.EntityId> nodeIds,
    required Set<core_graph.EntityId> linkIds,
  }) =>
      state = state.copyWith(
        nodeIds: nodeIds,
        linkIds: linkIds,
        dimEnabled: true,
        focusedNodeId: null,
      );

  /// Narrows the highlight to [nodeId] and its 1-hop neighbourhood so the graph
  /// dims everything outside that neighbourhood, letting the user concentrate on
  /// the connections of a single result. Toggle back with [clearFocus].
  void focusNeighborhood({
    required core_graph.EntityId nodeId,
    required Set<core_graph.EntityId> neighborNodeIds,
    required Set<core_graph.EntityId> neighborLinkIds,
  }) =>
      state = state.copyWith(
        nodeIds: {nodeId, ...neighborNodeIds},
        linkIds: neighborLinkIds,
        dimEnabled: true,
        focusedNodeId: nodeId,
      );

  /// Restores the highlight to the full search result set, ending focus mode.
  void clearFocus({
    required Set<core_graph.EntityId> nodeIds,
    required Set<core_graph.EntityId> linkIds,
  }) =>
      state = state.copyWith(
        nodeIds: nodeIds,
        linkIds: linkIds,
        focusedNodeId: null,
      );

  void toggleDim() => state = state.copyWith(dimEnabled: !state.dimEnabled);

  void clear() => state = const SearchHighlightState();
}

/// Holds the entity ID that the graph view should animate to focus on.
@riverpod
class SearchFocusTarget extends _$SearchFocusTarget {
  @override
  core_graph.EntityId? build() => null;

  void focus(core_graph.EntityId id) => state = id;
  void clear() => state = null;
}

// ---------------------------------------------------------------------------
// Path Search providers (kept for future restoration)
// ---------------------------------------------------------------------------

/// Search execution action provider
@riverpod
class SearchActions extends _$SearchActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Executes a search
  Future<void> executeSearch() async {
    final searchService = ref.read(searchExecutionServiceProvider);
    final patternState = ref.read(searchPatternStateProvider);
    final explorationOptions = ref.read(explorationOptionsStateProvider);

    final searchResultNotifier = ref.read(searchResultStateProvider.notifier);
    final searchExecutingNotifier = ref.read(searchExecutingProvider.notifier);
    final searchErrorNotifier = ref.read(searchErrorProvider.notifier);

    if (searchService == null) {
      searchErrorNotifier.setError('Search service is not available');
      return;
    }

    try {
      searchExecutingNotifier.startExecution();
      searchErrorNotifier.clearError();

      // 検索実行
      final result = await searchService.executePatternSearch(
        nodePatterns: patternState.nodePatterns,
        linkConfigurations: patternState.linkConfigurations,
        options: explorationOptions,
      );

      searchResultNotifier.setResult(result);
    } catch (e) {
      searchErrorNotifier.setError('Search execution error: $e');
    } finally {
      searchExecutingNotifier.stopExecution();
    }
  }

  /// Clears search results
  void clearSearchResult() {
    final searchResultNotifier = ref.read(searchResultStateProvider.notifier);
    final searchErrorNotifier = ref.read(searchErrorProvider.notifier);

    searchResultNotifier.clearResult();
    searchErrorNotifier.clearError();
  }
}
