/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart';

part 'entity_properties_providers.g.dart';

/// Set of property keys to hide as internal information
const _hiddenPropertyKeys = {'app_custom_id', 'app_type'};

/// Thrown when a property fails validation and the save is abandoned.
///
/// A distinct type rather than a plain [Exception] so the UI can tell an
/// invalid memo from a genuine storage failure without matching on message
/// text, and present it as a validation error instead of a crash.
class PropertyValidationException implements Exception {
  const PropertyValidationException({
    required this.propertyName,
    required this.length,
    required this.maxLength,
  });

  /// Name of the offending property.
  final String propertyName;

  /// Length of the value in grapheme clusters — what the user counts as
  /// characters, not UTF-16 code units.
  final int length;

  /// Limit the value exceeded.
  final int maxLength;

  /// Message suitable for showing to the user as-is.
  String get message =>
      'The memo "$propertyName" is $length characters, over the '
      '$maxLength character limit.';

  @override
  String toString() => 'PropertyValidationException: $message';
}

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

  /// Adds a property, leaving its value empty.
  ///
  /// Does nothing if [key] is already present, so adding a duplicate name
  /// cannot silently overwrite an existing value.
  void addProperty(String key) {
    if (state.containsKey(key)) {
      return;
    }
    state = {...state, key: ''};
  }

  /// Removes a property.
  void removeProperty(String key) {
    final next = Map<String, dynamic>.from(state)..remove(key);
    state = next;
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

  /// Checks [properties] against the types declared for the entity's labels.
  ///
  /// Only memos are length-checked: the limit is deliberate design rather than
  /// a storage constraint, and it is enforced here because the editor cannot
  /// enforce it while typing — Flutter's maxLength counts UTF-16 units, which
  /// would truncate an emoji-heavy memo well short of 500 characters and split
  /// the surrogate pair. The field shows the overrun, and this refuses it.
  ///
  /// Throws [PropertyValidationException] on the first offending property.
  Future<void> _validateProperties(Map<String, dynamic> properties) async {
    final labels = ref.read(selectedEntityLabelsProvider);
    final types = await ref.read(propertyTypesForLabelsProvider(labels).future);

    for (final entry in properties.entries) {
      if (types[entry.key] is! MemoPropertyType) continue;

      final value = entry.value;
      if (value is! String) continue;

      final length = MemoPropertyType.lengthOf(value);
      if (length > MemoPropertyType.maxLength) {
        print(
          '[SaveEntityAction] Memo "${entry.key}" is $length characters, '
          'over the limit',
        );
        throw PropertyValidationException(
          propertyName: entry.key,
          length: length,
          maxLength: MemoPropertyType.maxLength,
        );
      }
    }
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

      // The rename is already applied to the edited map by the time it gets
      // here — the editor rewrites the key as soon as the name is committed —
      // so the name changes are only re-applied for entries that somehow still
      // carry the old key. Applying them unconditionally overwrote the renamed
      // property with the null returned by removing a key that was no longer
      // there, which saved the value away as null.
      final finalProperties = Map<String, dynamic>.from(editingProperties);
      for (final change in propertyNameChanges.entries) {
        if (!finalProperties.containsKey(change.key)) continue;
        finalProperties[change.value] = finalProperties.remove(change.key);
      }

      print('[SaveEntityAction] Final properties: $finalProperties');

      // Validated against the renamed map, so a memo renamed in the same edit
      // is checked under the name it will actually be saved as. Throws before
      // anything is written, leaving the database untouched.
      await _validateProperties(finalProperties);

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
