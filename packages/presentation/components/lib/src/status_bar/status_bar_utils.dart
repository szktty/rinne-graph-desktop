/// A class providing utility functions for the status bar.
class StatusBarUtils {
  StatusBarUtils._();

  /// Formats a number in an appropriate format.
  ///
  /// - 99,999件以下: カンマ区切りで表示（例: 1,234件）
  /// - 100,000 items or more: Display in ten thousands (e.g., 123k items)
  /// - Update in units of 1,000 (e.g., 100k items → 101k items)
  static String formatCount(int count) {
    if (count < 100000) {
      // Less than 99,999 items: Comma-separated
      return _addCommas(count);
    } else {
      // 100,000 items or more: Display in ten thousands
      final manCount = count / 10000.0;
      return '${manCount.toStringAsFixed(1)}k';
    }
  }

  /// Adds commas to a number.
  static String _addCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }

  /// Determines the display name of an entity (heuristic method).
  ///
  /// 優先順位:
  /// 1. Search for priority keys: name, title, label, summary, headline, name, designation
  /// 2. Use the first property value
  /// 3. Use record label (enclosed in square brackets)
  /// 4. Last resort: Display ID
  static String determineDisplayName(dynamic entity) {
    // 1. Search for priority keys
    const priorityKeys = [
      'name',
      'title',
      'label',
      'summary',
      'headline',
      'name',
      'designation',
    ];

    for (final key in priorityKeys) {
      final value = entity.properties[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return _truncateDisplayName(value.toString().trim());
      }
    }

    // 2. Use the first property value
    if (entity.properties is Map<String, dynamic>) {
      final properties = entity.properties as Map<String, dynamic>;
      if (properties.isNotEmpty) {
        final firstValue = properties.values.first;
        if (firstValue != null && firstValue.toString().trim().isNotEmpty) {
          return _truncateDisplayName(firstValue.toString().trim());
        }
      }
    } else {
      // For PropertySet
      final propertyKeys = entity.properties.keys;
      if (propertyKeys.isNotEmpty) {
        final firstKey = propertyKeys.first;
        final firstValue = entity.properties[firstKey];
        if (firstValue != null && firstValue.toString().trim().isNotEmpty) {
          return _truncateDisplayName(firstValue.toString().trim());
        }
      }
    }

    // 3. Use record label
    if (entity.labels != null && entity.labels.isNotEmpty) {
      return '[${entity.labels.first}]';
    }

    // 4. Last resort: Display part of ID
    final entityIdStr = entity.id.toString();
    if (entityIdStr.length > 8) {
      return 'ID: ${entityIdStr.substring(0, 8)}...';
    } else {
      return 'ID: $entityIdStr';
    }
  }

  /// Limits the display name to 20 characters and truncates if necessary.
  static String _truncateDisplayName(String name) {
    const maxLength = 20;
    if (name.length <= maxLength) {
      return name;
    }
    return '${name.substring(0, maxLength - 3)}...';
  }

  /// Generates the display string when search/filter is applied.
  static String formatSearchResultText({
    required int displayedCount,
    required int filteredTotalCount,
    required int totalCount,
  }) {
    return 'Search results: ${formatCount(displayedCount)} / ${formatCount(filteredTotalCount)} (out of ${formatCount(totalCount)} total)';
  }

  /// Generates the display string for normal view.
  static String formatNormalViewText({
    required int displayedCount,
    required int totalCount,
  }) {
    return 'Displaying: ${formatCount(displayedCount)} / ${formatCount(totalCount)} items';
  }

  /// Generates the display string for selected node information.
  static String formatSelectedNodeText({
    required String displayName,
    required int linkCount,
  }) {
    return 'Selected: $displayName | Links: ${formatCount(linkCount)}';
  }

  /// Generates the display string for selected link information.
  static String formatSelectedLinkText({
    required String displayName,
    required int nodeCount,
  }) {
    return 'Selected: $displayName | Connected Nodes: ${formatCount(nodeCount)}';
  }
}
