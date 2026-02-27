/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_common/src/metadata/label_metadata.dart';
import 'package:core_graph_common/src/metadata/label_service.dart';
import 'package:core_graph_common/src/metadata/label_storage.dart';
import 'package:rinne_graph/rinne_graph.dart' as rg;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'label_providers.g.dart';

/// Provider that provides a RinneGraph instance (future implementation)
@riverpod
rg.Graph? rinneGraph(RinneGraphRef ref) {
  // TODO: Get RinneGraph instance from the current stack
  // final currentStack = ref.watch(currentStackProvider);
  // return currentStack?.graphInstance;
  return null;
}

/// Provider that provides label storage
@riverpod
LabelStorage? labelStorage(LabelStorageRef ref) {
  final graph = ref.watch(rinneGraphProvider);

  if (graph != null) {
    // TODO: Get current stack directory
    // final currentStack = ref.watch(currentStackProvider);
    // return RinneGraphLabelStorage(graph, currentStack.directory);
    return null;
  }

  return null;
}

/// Provider that provides label service
@riverpod
LabelService? labelService(LabelServiceRef ref) {
  final graph = ref.watch(rinneGraphProvider);
  final storage = ref.watch(labelStorageProvider);

  if (graph != null && storage != null) {
    return LabelService(graph, storage);
  }
  return null;
}

/// Provider managing label list (RinneGraph integrated version)
@riverpod
class LabelList extends _$LabelList {
  @override
  List<LabelMetadata> build() {
    final storage = ref.watch(labelStorageProvider);

    if (storage == null) {
      // Use dummy data if RinneGraph is not available
      return LabelMetadataFactory.createDummyLabels();
    }

    // TODO: Implement asynchronous loading from RinneGraph storage
    // Currently using dummy data as a simple implementation
    return LabelMetadataFactory.createDummyLabels();
  }

  void setLabels(List<LabelMetadata> labels) {
    state = labels;
  }

  void addLabel(LabelMetadata newLabel) {
    state = [...state, newLabel];
  }

  void updateLabel(LabelMetadata updatedLabel) {
    state =
        state.map((label) {
          return label.name == updatedLabel.name ? updatedLabel : label;
        }).toList();
  }

  void deleteLabel(String labelName) {
    state = state.where((label) => label.name != labelName).toList();
  }
}

/// Provider managing the currently selected label
@riverpod
class SelectedLabel extends _$SelectedLabel {
  @override
  LabelMetadata? build() => null;

  void selectLabel(LabelMetadata? label) {
    state = label;
  }

  void clearSelection() {
    state = null;
  }
}

/// Provider managing label edit mode
@riverpod
class LabelEditMode extends _$LabelEditMode {
  @override
  bool build() => false;

  void setEditMode(bool isEditMode) {
    state = isEditMode;
  }

  void toggle() {
    state = !state;
  }
}

/// Provider managing label search query
@riverpod
class LabelSearchQuery extends _$LabelSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clearQuery() {
    state = '';
  }
}

/// Provider that provides a filtered list of labels
@riverpod
List<LabelMetadata> filteredLabelList(FilteredLabelListRef ref) {
  final labels = ref.watch(labelListProvider);
  final searchQuery = ref.watch(labelSearchQueryProvider);

  if (searchQuery.isEmpty) {
    return labels;
  }

  final query = searchQuery.toLowerCase();
  return labels.where((label) {
    return label.name.toLowerCase().contains(query) ||
        (label.description?.toLowerCase().contains(query) ?? false);
  }).toList();
}

/// Provider for label operation actions
@riverpod
class LabelActions extends _$LabelActions {
  @override
  void build() {
    // No initial state needed
  }

  void addLabel(LabelMetadata newLabel) {
    ref.read(labelListProvider.notifier).addLabel(newLabel);
  }

  void updateLabel(LabelMetadata updatedLabel) {
    ref.read(labelListProvider.notifier).updateLabel(updatedLabel);
    ref.read(selectedLabelProvider.notifier).selectLabel(updatedLabel);
  }

  void deleteLabel(String labelName) {
    ref.read(labelListProvider.notifier).deleteLabel(labelName);
    ref.read(selectedLabelProvider.notifier).clearSelection();
    ref.read(labelEditModeProvider.notifier).setEditMode(false);
  }

  void createNewLabel() {
    final newLabel = LabelMetadataFactory.createNewLabel();
    ref.read(selectedLabelProvider.notifier).selectLabel(newLabel);
    ref.read(labelEditModeProvider.notifier).setEditMode(true);
  }
}

/// Provider that provides label statistics
@riverpod
({
  int totalLabels,
  int labelsWithDescription,
  int labelsWithColor,
  int labelsWithThumbnail,
})
labelStatistics(LabelStatisticsRef ref) {
  final labels = ref.watch(labelListProvider);

  return (
    totalLabels: labels.length,
    labelsWithDescription:
        labels
            .where(
              (label) =>
                  label.description != null && label.description!.isNotEmpty,
            )
            .length,
    labelsWithColor: labels.where((label) => label.color != null).length,
    labelsWithThumbnail:
        labels.where((label) => label.thumbnailImageId != null).length,
  );
}

/// Provider that provides label usage statistics
@riverpod
Map<String, int> labelUsageStats(LabelUsageStatsRef ref) {
  final service = ref.watch(labelServiceProvider);

  if (service == null) {
    // Returns dummy data
    return {
      'Person': 15,
      'Company': 8,
      'Project': 12,
      'Document': 25,
      'Task': 18,
      'Meeting': 6,
      'Archive': 0,
    };
  }

  // TODO: Get actual statistics from RinneGraph
  return {};
}

/// Provider that provides unused labels
@riverpod
List<String> unusedLabels(UnusedLabelsRef ref) {
  final service = ref.watch(labelServiceProvider);

  if (service == null) {
    // Returns dummy data
    return ['Archive'];
  }

  // TODO: Get actual unused labels from RinneGraph
  return [];
}

/// Provider that provides recently used labels
@riverpod
List<LabelMetadata> recentlyUsedLabels(RecentlyUsedLabelsRef ref) {
  final service = ref.watch(labelServiceProvider);

  if (service == null) {
    // Returns dummy data
    final allLabels = LabelMetadataFactory.createDummyLabels();
    return allLabels.take(5).toList();
  }

  // TODO: Get actual recently used labels from RinneGraph
  return [];
}
