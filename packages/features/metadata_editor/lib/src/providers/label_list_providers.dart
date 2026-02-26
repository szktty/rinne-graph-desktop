import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/label_item.dart';

/// Types of quick access filters
enum QuickAccessFilter {
  all('All'),
  starred('Starred'),
  recentlyModified('Recently Modified'),
  recentlyAdded('Recently Added'),
  unused('Unused Items');

  const QuickAccessFilter(this.displayName);
  final String displayName;
}

/// Types of label sort methods
enum LabelSortMethod {
  name('By Name'),
  recentlyModified('By Recently Modified'),
  recentlyAdded('By Recently Added'),
  usageCount('By Usage Count');

  const LabelSortMethod(this.label);
  final String label;
}

/// Mock label data
final mockLabelsProvider = Provider<List<LabelItem>>((ref) {
  return [
    LabelItem(
      id: 'person',
      name: 'person',
      color: const Color(0xFF2196F3), // Blue
      usageCount: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      modifiedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    LabelItem(
      id: 'company',
      name: 'company',
      color: const Color(0xFF4CAF50), // Green
      usageCount: 23,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      modifiedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    LabelItem(
      id: 'project',
      name: 'project',
      color: const Color(0xFFFF9800), // Orange
      usageCount: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      modifiedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LabelItem(
      id: 'task',
      name: 'task',
      color: const Color(0xFF9C27B0), // Purple
      usageCount: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      modifiedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    LabelItem(
      id: 'document',
      name: 'document',
      color: const Color(0xFF795548), // Brown
      usageCount: 0, // Unused
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      modifiedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    LabelItem(
      id: 'meeting',
      name: 'meeting',
      color: const Color(0xFFE91E63), // Pink
      usageCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      modifiedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];
});

/// Selected quick access filter
final selectedQuickAccessFilterProvider = StateProvider<QuickAccessFilter>((
  ref,
) {
  return QuickAccessFilter.all;
});

/// Search query
final labelSearchQueryProvider = StateProvider<String>((ref) {
  return '';
});

/// Sort method
final labelSortMethodProvider = StateProvider<LabelSortMethod>((ref) {
  return LabelSortMethod.name;
});

/// Selected label for editing
final selectedLabelForEditProvider = StateProvider<LabelItem?>((ref) {
  return null;
});

/// Filtered and sorted list of labels
final filteredAndSortedLabelsProvider = Provider<List<LabelItem>>((ref) {
  final labels = ref.watch(mockLabelsProvider);
  final filter = ref.watch(selectedQuickAccessFilterProvider);
  final searchQuery = ref.watch(labelSearchQueryProvider);
  final sortMethod = ref.watch(labelSortMethodProvider);

  // Filtering
  var filteredLabels =
      labels.where((label) {
        // Quick access filter
        switch (filter) {
          case QuickAccessFilter.all:
            break; // Display all
          case QuickAccessFilter.starred:
            // Star functionality has been removed, so display nothing
            return false;
          case QuickAccessFilter.recentlyModified:
            final threeDaysAgo = DateTime.now().subtract(
              const Duration(days: 3),
            );
            if (label.modifiedAt.isBefore(threeDaysAgo)) return false;
            break;
          case QuickAccessFilter.recentlyAdded:
            final sevenDaysAgo = DateTime.now().subtract(
              const Duration(days: 7),
            );
            if (label.createdAt.isBefore(sevenDaysAgo)) return false;
            break;
          case QuickAccessFilter.unused:
            if (label.usageCount > 0) return false;
            break;
        }

        // Search query filter
        if (searchQuery.isNotEmpty) {
          final query = searchQuery.toLowerCase();
          return label.name.toLowerCase().contains(query);
        }

        return true;
      }).toList();

  // Sorting
  switch (sortMethod) {
    case LabelSortMethod.name:
      filteredLabels.sort((a, b) => a.name.compareTo(b.name));
      break;
    case LabelSortMethod.recentlyModified:
      filteredLabels.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
      break;
    case LabelSortMethod.recentlyAdded:
      filteredLabels.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case LabelSortMethod.usageCount:
      filteredLabels.sort((a, b) => b.usageCount.compareTo(a.usageCount));
      break;
  }

  return filteredLabels;
});
