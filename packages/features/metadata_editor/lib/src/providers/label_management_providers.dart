import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart';

part 'label_management_providers.g.dart';

/// Provider that manages the label search query.
@riverpod
class LabelSearchQuery extends _$LabelSearchQuery {
  @override
  String build() => '';

  void setSearchQuery(String query) {
    state = query;
  }

  void clearQuery() {
    state = '';
  }
}

/// Provider that manages the selected label.
@riverpod
class SelectedLabel extends _$SelectedLabel {
  @override
  LabelMetadata? build() => null;

  void setSelectedLabel(LabelMetadata? label) {
    state = label;
  }

  void clearSelection() {
    state = null;
  }
}

/// Provider that offers label management actions.
@riverpod
class LabelActions extends _$LabelActions {
  @override
  void build() {
    // No initial state needed
  }

  Future<void> createNewLabel() async {
    // TODO: Implement new label creation
    // 1. Display dialog
    // 2. Collect user input
    // 3. Create label via graphContext
    // 4. Update list
  }

  Future<void> updateLabel(LabelMetadata label) async {
    // TODO: Implement label update
  }

  Future<void> deleteLabel(LabelMetadata label) async {
    // TODO: Implement label deletion
  }
}

/// Provider that provides a filtered list of labels.
@riverpod
List<LabelMetadata> filteredLabels(Ref ref) {
  final searchQuery = ref.watch(labelSearchQueryProvider).toLowerCase();

  // TODO: Get actual label list
  // final graphContext = ref.watch(graphContextProvider);
  // final allLabels = await graphContext.labelManager.getAllLabels();

  // Temporary data
  final allLabels = <LabelMetadata>[];

  if (searchQuery.isEmpty) {
    return allLabels;
  }

  return allLabels.where((label) {
    return label.name.toLowerCase().contains(searchQuery) ||
        (label.description?.toLowerCase().contains(searchQuery) ?? false);
  }).toList();
}
