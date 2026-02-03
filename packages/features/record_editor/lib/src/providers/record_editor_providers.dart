import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart';

part 'record_editor_providers.g.dart';

/// Provider that manages the entity being edited
@riverpod
class ActiveEntity extends _$ActiveEntity {
  @override
  Entity build() {
    // Create a basic node as an initial value
    final description = EntityDescription(
      type: 'DefaultNode',
      propertyTypes: {'name': const TextPropertyType(isRequired: true)},
    );
    return Node(
      id: EntityId(),
      description: description,
    ).withProperty('name', 'New Node');
  }

  void setEntity(Entity entity) {
    state = entity;
  }

  void updateProperty(String propertyName, dynamic value) {
    state = state.withProperty(propertyName, value);
  }

  void addProperty(String name, PropertyType type) {
    state = state.withProperty(name, null);
  }

  void removeProperty(String propertyName) {
    state = state.withoutProperty(propertyName);
  }

  void switchEntityType(EntityKind kind) {
    // Create entity based on selected type
    final Entity newEntity;

    if (kind == EntityKind.node) {
      final description = EntityDescription(
        type: 'DefaultNode',
        propertyTypes: {'name': const TextPropertyType(isRequired: true)},
      );
      newEntity = Node(
        id: EntityId(),
        description: description,
      ).withProperty('name', 'New Node');
    } else {
      final description = EntityDescription(
        type: 'DefaultLink',
        propertyTypes: {'name': const TextPropertyType(isRequired: true)},
      );
      newEntity = Link(
        id: EntityId(),
        type: 'DEFAULT_LINK',
        sourceId: EntityId(),
        targetId: EntityId(),
        description: description,
      ).withProperty('name', 'New Link');
    }

    state = newEntity;
  }
}

/// Provider that manages the enable/disable state of auto-save
@riverpod
class AutoSave extends _$AutoSave {
  @override
  bool build() => true;

  void toggle() {
    state = !state;
  }

  void setEnabled(bool enabled) {
    state = enabled;
  }
}

/// Provider that manages the edit lock state of an entity
@riverpod
class EntityLock extends _$EntityLock {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void setLocked(bool locked) {
    state = locked;
  }
}

/// Provider that manages the order of properties
@riverpod
class PropertyOrder extends _$PropertyOrder {
  @override
  List<String> build() {
    final entity = ref.watch(activeEntityProvider);
    // Get entity property keys as a list
    return entity.properties.toMap().keys.toList();
  }

  void setOrder(List<String> order) {
    state = order;
  }

  void addProperty(String propertyName) {
    state = [...state, propertyName];
  }

  void removeProperty(String propertyName) {
    state = state.where((name) => name != propertyName).toList();
  }

  void reorderProperty(int oldIndex, int newIndex) {
    final currentOrder = List<String>.from(state);

    // Move elements within the list
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = currentOrder.removeAt(oldIndex);
    currentOrder.insert(newIndex, item);

    state = currentOrder;
  }
}

/// Record editor actions provider
@riverpod
class RecordEditorActions extends _$RecordEditorActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Adds a property
  void addProperty({required String name, required PropertyType type}) {
    final activeEntityNotifier = ref.read(activeEntityProvider.notifier);
    final propertyOrderNotifier = ref.read(propertyOrderProvider.notifier);

    activeEntityNotifier.addProperty(name, type);
    propertyOrderNotifier.addProperty(name);
  }

  /// Removes a property
  void removeProperty(String propertyName) {
    final activeEntityNotifier = ref.read(activeEntityProvider.notifier);
    final propertyOrderNotifier = ref.read(propertyOrderProvider.notifier);

    activeEntityNotifier.removeProperty(propertyName);
    propertyOrderNotifier.removeProperty(propertyName);
  }

  /// Updates a property (considering auto-save)
  void updateProperty(String propertyName, dynamic value) {
    final autoSaveEnabled = ref.read(autoSaveProvider);

    // Update only if auto-save is enabled
    if (autoSaveEnabled) {
      final activeEntityNotifier = ref.read(activeEntityProvider.notifier);
      activeEntityNotifier.updateProperty(propertyName, value);
    }
  }

  /// Changes the order of properties
  void reorderProperty(int oldIndex, int newIndex) {
    final propertyOrderNotifier = ref.read(propertyOrderProvider.notifier);
    propertyOrderNotifier.reorderProperty(oldIndex, newIndex);
  }

  /// Switches the entity type
  void switchEntityType(EntityKind kind) {
    final activeEntityNotifier = ref.read(activeEntityProvider.notifier);
    activeEntityNotifier.switchEntityType(kind);
  }
}
