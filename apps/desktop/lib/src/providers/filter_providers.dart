/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Class managing filter state
class FilterState {
  const FilterState({
    this.searchQuery = '',
    this.selectedNodeLabels = const {},
    this.selectedLinkTypes = const {},
    this.selectedProperties = const {},
  });

  final String searchQuery;
  final Set<String> selectedNodeLabels;
  final Set<String> selectedLinkTypes;
  final Set<String> selectedProperties;

  FilterState copyWith({
    String? searchQuery,
    Set<String>? selectedNodeLabels,
    Set<String>? selectedLinkTypes,
    Set<String>? selectedProperties,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedNodeLabels: selectedNodeLabels ?? this.selectedNodeLabels,
      selectedLinkTypes: selectedLinkTypes ?? this.selectedLinkTypes,
      selectedProperties: selectedProperties ?? this.selectedProperties,
    );
  }
}

/// フィルター状態を管理するNotifier
class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState()) {
    // On initialization, all are deselected (default FilterState is already an empty Set)
  }

  /// Updates the search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Toggles the selection state of node labels
  void toggleNodeLabel(String label) {
    final newSelection = Set<String>.from(state.selectedNodeLabels);
    if (newSelection.contains(label)) {
      newSelection.remove(label);
    } else {
      newSelection.add(label);
    }
    state = state.copyWith(selectedNodeLabels: newSelection);
  }

  /// Toggles the selection state of link types
  void toggleLinkType(String linkType) {
    final newSelection = Set<String>.from(state.selectedLinkTypes);
    if (newSelection.contains(linkType)) {
      newSelection.remove(linkType);
    } else {
      newSelection.add(linkType);
    }
    state = state.copyWith(selectedLinkTypes: newSelection);
  }

  /// Toggles the selection state of properties
  void toggleProperty(String property) {
    final newSelection = Set<String>.from(state.selectedProperties);
    if (newSelection.contains(property)) {
      newSelection.remove(property);
    } else {
      newSelection.add(property);
    }
    state = state.copyWith(selectedProperties: newSelection);
  }

  /// Selects all
  void selectAll() {
    // Select all with sample data
    state = state.copyWith(
      selectedNodeLabels:
          {
            'Person',
            'Company',
            'Project',
            'Task',
            'Document',
            'Meeting',
            'Location',
            'Event',
          }.toSet(),
      selectedLinkTypes:
          {
            'works_for',
            'manages',
            'assigned_to',
            'depends_on',
            'collaborates_with',
            'reports_to',
            'participates_in',
            'located_at',
            'created_by',
            'reviewed_by',
          }.toSet(),
      selectedProperties:
          {
            'name',
            'email',
            'created_at',
            'updated_at',
            'status',
            'priority',
            'description',
            'tags',
            'category',
            'owner',
            'due_date',
            'completion_rate',
          }.toSet(),
    );
  }

  /// Selects only nodes
  void selectNodesOnly() {
    state = state.copyWith(
      selectedNodeLabels:
          {
            'Person',
            'Company',
            'Project',
            'Task',
            'Document',
            'Meeting',
            'Location',
            'Event',
          }.toSet(),
      selectedLinkTypes: <String>{}.toSet(),
      selectedProperties:
          {
            'name',
            'email',
            'created_at',
            'updated_at',
            'status',
            'description',
            'tags',
            'category',
            'owner',
          }.toSet(),
    );
  }

  /// Selects only links
  void selectLinksOnly() {
    state = state.copyWith(
      selectedNodeLabels: <String>{}.toSet(),
      selectedLinkTypes:
          {
            'works_for',
            'manages',
            'assigned_to',
            'depends_on',
            'collaborates_with',
            'reports_to',
            'participates_in',
            'located_at',
            'created_by',
            'reviewed_by',
          }.toSet(),
      selectedProperties:
          {'created_at', 'updated_at', 'priority', 'status'}.toSet(),
    );
  }

  /// Resets (returns to all deselected state)
  void reset() {
    state = const FilterState(); // Returns to initial state (all deselected)
  }
}

/// Filter state provider
final filterStateProvider = StateNotifierProvider<FilterNotifier, FilterState>((
  ref,
) {
  return FilterNotifier();
});

/// Sample data provider (dynamically acquired in actual implementation)
final availableNodeLabelsProvider = Provider<List<String>>((ref) {
  return [
    'Person',
    'Company',
    'Project',
    'Task',
    'Document',
    'Meeting',
    'Location',
    'Event',
  ];
});

final availableLinkTypesProvider = Provider<List<String>>((ref) {
  return [
    'works_for',
    'manages',
    'assigned_to',
    'depends_on',
    'collaborates_with',
    'reports_to',
    'participates_in',
    'located_at',
    'created_by',
    'reviewed_by',
  ];
});

final availablePropertiesProvider = Provider<List<String>>((ref) {
  return [
    'name',
    'email',
    'created_at',
    'updated_at',
    'status',
    'priority',
    'description',
    'tags',
    'category',
    'owner',
    'due_date',
    'completion_rate',
  ];
});
