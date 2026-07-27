/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart';

part 'entity_properties_providers.g.dart';

/// Set of property keys to hide as internal information
const _hiddenPropertyKeys = {'app_custom_id', 'app_type'};

/// Provider that provides entity properties in map format
///
/// Dynamically extracts all properties from the selected entity and
/// returns them as a map of key-value pairs.
/// Internal information (e.g., app_custom_id, type) is filtered.
@Riverpod(keepAlive: true)
Map<String, dynamic> selectedEntityProperties(Ref ref) {
  // Get the selected entity
  final selectedEntity = ref.watch(selectedEntityProvider);

  if (selectedEntity == null) {
    return {};
  }

  // Get properties using PropertySet's toMap() method
  final allProperties = selectedEntity.properties.toMap();

  // Filter internal information
  final filteredProperties = <String, dynamic>{};
  for (final entry in allProperties.entries) {
    if (!_hiddenPropertyKeys.contains(entry.key)) {
      filteredProperties[entry.key] = entry.value;
    }
  }

  return filteredProperties;
}

/// Provider that provides a list of entity property keys
@Riverpod(keepAlive: true)
List<String> selectedEntityPropertyKeys(Ref ref) {
  final properties = ref.watch(selectedEntityPropertiesProvider);
  return properties.keys.toList();
}

/// Provider that provides entity labels
///
/// Gets the label set of a Node or the type of a Link.
/// Converts the label set to a list for Nodes, and returns the type as a single-element list for Links.
@Riverpod(keepAlive: true)
List<String> selectedEntityLabels(Ref ref) {
  final selectedEntity = ref.watch(selectedEntityProvider);

  if (selectedEntity == null) {
    return [];
  }

  // Get label set for Node
  if (selectedEntity is Node) {
    return selectedEntity.labels.toList();
  }

  // Return type for Link
  if (selectedEntity is Link) {
    return [selectedEntity.type];
  }

  return [];
}

/// Provider that manages property values being edited
///
/// Temporarily holds property values that the user is editing.
/// Updates the entity using this value upon saving.
@Riverpod(keepAlive: true)
class EditingEntityProperties extends _$EditingEntityProperties {
  @override
  Map<String, dynamic> build() {
    // Initialize with properties of the selected entity
    final properties = ref.watch(selectedEntityPropertiesProvider);
    return Map<String, dynamic>.from(properties);
  }

  /// Updates a property value
  void updateProperty(String key, dynamic value) {
    state = {...state, key: value};
  }

  /// Replaces all properties
  void setProperties(Map<String, dynamic> properties) {
    state = Map<String, dynamic>.from(properties);
  }

  /// Resets properties being edited
  void reset() {
    final properties = ref.read(selectedEntityPropertiesProvider);
    state = Map<String, dynamic>.from(properties);
  }
}

/// Provider that manages changes in property names being edited
///
/// Tracks changes in property names (key changes).
/// Format: {oldKey: newKey}
@riverpod
class EditingPropertyNameChanges extends _$EditingPropertyNameChanges {
  @override
  Map<String, String> build() {
    return {};
  }

  /// Renames a property
  void renameProperty(String oldKey, String newKey) {
    state = {...state, oldKey: newKey};
  }

  /// Resets property name changes
  void reset() {
    state = {};
  }
}

/// Provider that manages property names being edited
///
/// Tracks the currently edited property names.
/// Format: {key: editingName}
@riverpod
class EditingPropertyNames extends _$EditingPropertyNames {
  @override
  Map<String, String> build() {
    return {};
  }

  /// Starts editing a property name
  void startEditing(String key, String currentName) {
    state = {...state, key: currentName};
  }

  /// Ends editing a property name
  void stopEditing(String key) {
    final newState = Map<String, String>.from(state);
    newState.remove(key);
    state = newState;
  }

  /// Updates the property name being edited
  void updateName(String key, String newName) {
    state = {...state, key: newName};
  }

  /// Resets all edits
  void reset() {
    state = {};
  }
}

/// Entity save action provider
///
/// Saves the entity being edited to the database.
///
/// Kept alive because saveEntity() spans several awaits. A caller that only
/// reads the notifier to invoke it — the record_editor.save command, for
/// instance — holds no subscription, so an auto-disposed provider would be
/// torn down mid-save and the next use of its `ref` would throw.
@Riverpod(keepAlive: true)
class SaveEntityAction extends _$SaveEntityAction {
  @override
  void build() {
    // No initial state needed
  }

  /// Saves the entity
  Future<void> saveEntity() async {
    print('[SaveEntityAction] ===== Save started =====');
    final selectedEntity = ref.read(selectedEntityProvider);
    if (selectedEntity == null) {
      print('[SaveEntityAction] No entity selected');
      return;
    }
    print('[SaveEntityAction] Selected entity: ${selectedEntity.id}');

    final editingProperties = ref.read(editingEntityPropertiesProvider);
    print('[SaveEntityAction] Properties being edited: $editingProperties');

    final propertyNameChanges = ref.read(editingPropertyNameChangesProvider);
    print('[SaveEntityAction] Property name changes: $propertyNameChanges');

    final graphContext = ref.read(graphContextProvider);
    print('[SaveEntityAction] graphContext obtained');

    // Wait for GraphContext initialization to complete
    print('[SaveEntityAction] Waiting for GraphContext initialization...');
    final isReady = await graphContext.isReady();
    print('[SaveEntityAction] GraphContext initialization completed: $isReady');

    try {
      // Create an entity with updated properties
      var updatedEntity = selectedEntity;
      print(
        '[SaveEntityAction] Original properties: ${selectedEntity.properties.toMap()}',
      );

      // Create final property map based on properties being edited and name changes
      final finalProperties = Map<String, dynamic>.from(editingProperties);
      for (final change in propertyNameChanges.entries) {
        final oldValue = finalProperties.remove(change.key);
        finalProperties[change.value] = oldValue;
      }

      print('[SaveEntityAction] Final properties: $finalProperties');

      // Update entity with new property set
      updatedEntity = selectedEntity.copyWith(
        properties: PropertySet.fromMap(finalProperties),
      );

      print(
        '[SaveEntityAction] Updated properties: ${updatedEntity.properties.toMap()}',
      );

      // Save node or link within a transaction
      if (updatedEntity is Node) {
        print('[SaveEntityAction] Saving node: ${updatedEntity.id}');
        final node = updatedEntity;
        await graphContext.transaction((txContext) async {
          await txContext.updateNode(node);
          print('[SaveEntityAction] Node save complete');
        });
      } else if (updatedEntity is Link) {
        print('[SaveEntityAction] Saving link: ${updatedEntity.id}');
        final link = updatedEntity;
        await graphContext.transaction((txContext) async {
          await txContext.updateLink(link);
          print('[SaveEntityAction] Link save complete');
        });
      }

      // Reflect the saved entity in the active graph before resetting.
      //
      // reset() re-reads selectedEntityPropertiesProvider, which resolves the
      // entity through activeGraphProvider. Without this the graph still holds
      // the pre-save entity, so resetting would restore the old values and the
      // editor would appear to discard what was just written to the database.
      final activeGraph = ref.read(activeGraphProvider);
      if (activeGraph != null) {
        final entity = updatedEntity;
        if (entity is Node) {
          ref
              .read(activeGraphProvider.notifier)
              .setGraph(activeGraph.addNode(entity));
        } else if (entity is Link) {
          ref
              .read(activeGraphProvider.notifier)
              .setGraph(activeGraph.addLink(entity));
        }
      }

      // After saving, reset editing state
      print('[SaveEntityAction] Resetting editing state');
      ref.read(editingPropertyNameChangesProvider.notifier).reset();
      ref.read(editingPropertyNamesProvider.notifier).reset();
      ref.read(editingEntityPropertiesProvider.notifier).reset();
      print('[SaveEntityAction] ===== Save complete =====');
    } catch (e, stackTrace) {
      print('[SaveEntityAction] ===== Error occurred =====');
      print('[SaveEntityAction] Error: $e');
      print('[SaveEntityAction] Stack trace: $stackTrace');
      rethrow;
    }
  }
}
