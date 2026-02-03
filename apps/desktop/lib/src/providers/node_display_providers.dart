import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_settings/core_settings.dart';
import '../models/node_display_settings.dart';

part 'node_display_providers.g.dart';

/// Provider that manages node display content settings
@riverpod
class NodeDisplayContentState extends _$NodeDisplayContentState {
  @override
  NodeDisplayContent build() {
    // Execute initial value loading
    _loadInitialValue();
    return NodeDisplayContent.labelWithIcon;
  }

  /// Asynchronously loads initial value
  void _loadInitialValue() async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      final savedValue = await storageService.getString('node_display_content');

      if (savedValue != null) {
        final savedContent = NodeDisplayContent.values.firstWhere(
          (content) => content.name == savedValue,
          orElse: () => NodeDisplayContent.labelWithIcon,
        );
        state = savedContent;
      }
    } catch (e) {
      debugPrint('[NodeDisplayContentProvider] Failed to load saved value: $e');
    }
  }

  /// Sets display content
  void setDisplayContent(NodeDisplayContent content) {
    state = content;
    _saveValue(content);
  }

  /// Persists value
  void _saveValue(NodeDisplayContent content) async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      await storageService.setString('node_display_content', content.name);
      debugPrint(
        '[NodeDisplayContentProvider] Saved display content: ${content.name}',
      );
    } catch (e) {
      debugPrint('[NodeDisplayContentProvider] Failed to save value: $e');
    }
  }
}

/// Node display content provider (value only)
@riverpod
NodeDisplayContent nodeDisplayContent(NodeDisplayContentRef ref) {
  return ref.watch(nodeDisplayContentStateProvider);
}

/// Provider that manages node size settings
@riverpod
class NodeSizeState extends _$NodeSizeState {
  @override
  NodeSize build() {
    // Execute initial value loading
    _loadInitialValue();
    return NodeSize.medium;
  }

  /// Asynchronously loads initial value
  void _loadInitialValue() async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      final savedValue = await storageService.getString('node_size');

      if (savedValue != null) {
        final savedSize = NodeSize.values.firstWhere(
          (size) => size.name == savedValue,
          orElse: () => NodeSize.medium,
        );
        state = savedSize;
      }
    } catch (e) {
      debugPrint('[NodeSizeProvider] Failed to load saved value: $e');
    }
  }

  /// Sets node size
  void setNodeSize(NodeSize size) {
    state = size;
    _saveValue(size);
  }

  /// Persists value
  void _saveValue(NodeSize size) async {
    try {
      final storageService = ref.read(settingsStorageServiceProvider);
      await storageService.setString('node_size', size.name);
      debugPrint('[NodeSizeProvider] Saved node size: ${size.name}');
    } catch (e) {
      debugPrint('[NodeSizeProvider] Failed to save value: $e');
    }
  }
}

/// Node size provider (value only)
@riverpod
NodeSize nodeSize(NodeSizeRef ref) {
  return ref.watch(nodeSizeStateProvider);
}

/// Provider that manages node visual data
@riverpod
class NodeVisualDataMap extends _$NodeVisualDataMap {
  @override
  Map<String, NodeVisualData> build() {
    return {};
  }

  /// Updates node visual data
  void updateNodeVisualData(String entityId, NodeVisualData visualData) {
    final newMap = Map<String, NodeVisualData>.from(state);
    newMap[entityId] = visualData;
    state = newMap;
    debugPrint(
      '[NodeVisualDataProvider] Updated visual data for entity: $entityId',
    );
  }

  /// Gets node visual data
  NodeVisualData getNodeVisualData(String entityId, Set<String> labels) {
    final existingData = state[entityId];
    if (existingData != null) {
      return existingData;
    }

    // Set default icon
    final defaultIcon = NodeVisualData.getDefaultIconForLabels(labels);
    return NodeVisualData(icon: defaultIcon);
  }
}

/// Function provider that gets visual data for a specific entity
@riverpod
NodeVisualData Function(String entityId, Set<String> labels)
nodeVisualDataForEntity(NodeVisualDataForEntityRef ref) {
  final visualDataMapNotifier = ref.watch(nodeVisualDataMapProvider.notifier);

  return (String entityId, Set<String> labels) {
    return visualDataMapNotifier.getNodeVisualData(entityId, labels);
  };
}
