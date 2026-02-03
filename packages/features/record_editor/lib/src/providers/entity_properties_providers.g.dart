// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_properties_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedEntityPropertiesHash() =>
    r'87386aabe04aaaab6fc88e0989fe3aa44514984d';

/// Provider that provides entity properties in map format
///
/// Dynamically extracts all properties from the selected entity and
/// returns them as a map of key-value pairs.
/// Internal information (e.g., app_custom_id, type) is filtered.
///
/// Copied from [selectedEntityProperties].
@ProviderFor(selectedEntityProperties)
final selectedEntityPropertiesProvider =
    Provider<Map<String, dynamic>>.internal(
      selectedEntityProperties,
      name: r'selectedEntityPropertiesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedEntityPropertiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedEntityPropertiesRef = ProviderRef<Map<String, dynamic>>;
String _$selectedEntityPropertyKeysHash() =>
    r'3d70f32fcf72fab41129c432f2b9aa2f49bf9afe';

/// Provider that provides a list of entity property keys
///
/// Copied from [selectedEntityPropertyKeys].
@ProviderFor(selectedEntityPropertyKeys)
final selectedEntityPropertyKeysProvider = Provider<List<String>>.internal(
  selectedEntityPropertyKeys,
  name: r'selectedEntityPropertyKeysProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedEntityPropertyKeysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedEntityPropertyKeysRef = ProviderRef<List<String>>;
String _$selectedEntityLabelsHash() =>
    r'aad99e4a40c821b574249c214d6f4b06e5673315';

/// Provider that provides entity labels
///
/// Gets the label set of a Node or the type of a Link.
/// Converts the label set to a list for Nodes, and returns the type as a single-element list for Links.
///
/// Copied from [selectedEntityLabels].
@ProviderFor(selectedEntityLabels)
final selectedEntityLabelsProvider = Provider<List<String>>.internal(
  selectedEntityLabels,
  name: r'selectedEntityLabelsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedEntityLabelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedEntityLabelsRef = ProviderRef<List<String>>;
String _$editingEntityPropertiesHash() =>
    r'265b4a48f222670f91d53983a70aba81aa83b4c7';

/// Provider that manages property values being edited
///
/// Temporarily holds property values that the user is editing.
/// Updates the entity using this value upon saving.
///
/// Copied from [EditingEntityProperties].
@ProviderFor(EditingEntityProperties)
final editingEntityPropertiesProvider = AutoDisposeNotifierProvider<
  EditingEntityProperties,
  Map<String, dynamic>
>.internal(
  EditingEntityProperties.new,
  name: r'editingEntityPropertiesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$editingEntityPropertiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EditingEntityProperties = AutoDisposeNotifier<Map<String, dynamic>>;
String _$editingPropertyNameChangesHash() =>
    r'6f31930f8df9bf40e62438c08f1dd4a46d5d122f';

/// Provider that manages changes in property names being edited
///
/// Tracks changes in property names (key changes).
/// Format: {oldKey: newKey}
///
/// Copied from [EditingPropertyNameChanges].
@ProviderFor(EditingPropertyNameChanges)
final editingPropertyNameChangesProvider = AutoDisposeNotifierProvider<
  EditingPropertyNameChanges,
  Map<String, String>
>.internal(
  EditingPropertyNameChanges.new,
  name: r'editingPropertyNameChangesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$editingPropertyNameChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EditingPropertyNameChanges = AutoDisposeNotifier<Map<String, String>>;
String _$editingPropertyNamesHash() =>
    r'3fa489696ff448f46939fa99f0e02c5b9b56c7ed';

/// Provider that manages property names being edited
///
/// Tracks the currently edited property names.
/// Format: {key: editingName}
///
/// Copied from [EditingPropertyNames].
@ProviderFor(EditingPropertyNames)
final editingPropertyNamesProvider = AutoDisposeNotifierProvider<
  EditingPropertyNames,
  Map<String, String>
>.internal(
  EditingPropertyNames.new,
  name: r'editingPropertyNamesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$editingPropertyNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EditingPropertyNames = AutoDisposeNotifier<Map<String, String>>;
String _$saveEntityActionHash() => r'4c274b46efa5ef15e3dc8fb61c9151af0fa414c1';

/// Entity save action provider
///
/// Saves the entity being edited to the database.
///
/// Copied from [SaveEntityAction].
@ProviderFor(SaveEntityAction)
final saveEntityActionProvider =
    AutoDisposeNotifierProvider<SaveEntityAction, void>.internal(
      SaveEntityAction.new,
      name: r'saveEntityActionProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$saveEntityActionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SaveEntityAction = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
