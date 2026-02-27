/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';

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
