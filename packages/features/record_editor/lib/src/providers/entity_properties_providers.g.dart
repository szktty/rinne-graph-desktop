// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_properties_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that provides entity properties in map format
///
/// Dynamically extracts all properties from the selected entity and
/// returns them as a map of key-value pairs.
/// Internal information (e.g., app_custom_id, type) is filtered.

@ProviderFor(selectedEntityProperties)
final selectedEntityPropertiesProvider = SelectedEntityPropertiesProvider._();

/// Provider that provides entity properties in map format
///
/// Dynamically extracts all properties from the selected entity and
/// returns them as a map of key-value pairs.
/// Internal information (e.g., app_custom_id, type) is filtered.

final class SelectedEntityPropertiesProvider
    extends
        $FunctionalProvider<
          Map<String, dynamic>,
          Map<String, dynamic>,
          Map<String, dynamic>
        >
    with $Provider<Map<String, dynamic>> {
  /// Provider that provides entity properties in map format
  ///
  /// Dynamically extracts all properties from the selected entity and
  /// returns them as a map of key-value pairs.
  /// Internal information (e.g., app_custom_id, type) is filtered.
  SelectedEntityPropertiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEntityPropertiesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEntityPropertiesHash();

  @$internal
  @override
  $ProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, dynamic> create(Ref ref) {
    return selectedEntityProperties(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$selectedEntityPropertiesHash() =>
    r'87386aabe04aaaab6fc88e0989fe3aa44514984d';

/// Provider that provides a list of entity property keys

@ProviderFor(selectedEntityPropertyKeys)
final selectedEntityPropertyKeysProvider =
    SelectedEntityPropertyKeysProvider._();

/// Provider that provides a list of entity property keys

final class SelectedEntityPropertyKeysProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// Provider that provides a list of entity property keys
  SelectedEntityPropertyKeysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEntityPropertyKeysProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEntityPropertyKeysHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return selectedEntityPropertyKeys(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$selectedEntityPropertyKeysHash() =>
    r'3d70f32fcf72fab41129c432f2b9aa2f49bf9afe';

/// Provider that provides entity labels
///
/// Gets the label set of a Node or the type of a Link.
/// Converts the label set to a list for Nodes, and returns the type as a single-element list for Links.

@ProviderFor(selectedEntityLabels)
final selectedEntityLabelsProvider = SelectedEntityLabelsProvider._();

/// Provider that provides entity labels
///
/// Gets the label set of a Node or the type of a Link.
/// Converts the label set to a list for Nodes, and returns the type as a single-element list for Links.

final class SelectedEntityLabelsProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// Provider that provides entity labels
  ///
  /// Gets the label set of a Node or the type of a Link.
  /// Converts the label set to a list for Nodes, and returns the type as a single-element list for Links.
  SelectedEntityLabelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEntityLabelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEntityLabelsHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return selectedEntityLabels(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$selectedEntityLabelsHash() =>
    r'aad99e4a40c821b574249c214d6f4b06e5673315';

/// Provider that manages property values being edited
///
/// Temporarily holds property values that the user is editing.
/// Updates the entity using this value upon saving.

@ProviderFor(EditingEntityProperties)
final editingEntityPropertiesProvider = EditingEntityPropertiesProvider._();

/// Provider that manages property values being edited
///
/// Temporarily holds property values that the user is editing.
/// Updates the entity using this value upon saving.
final class EditingEntityPropertiesProvider
    extends $NotifierProvider<EditingEntityProperties, Map<String, dynamic>> {
  /// Provider that manages property values being edited
  ///
  /// Temporarily holds property values that the user is editing.
  /// Updates the entity using this value upon saving.
  EditingEntityPropertiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editingEntityPropertiesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editingEntityPropertiesHash();

  @$internal
  @override
  EditingEntityProperties create() => EditingEntityProperties();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$editingEntityPropertiesHash() =>
    r'b97b3843cda3c2e93a0c90089faaa069f2c07af2';

/// Provider that manages property values being edited
///
/// Temporarily holds property values that the user is editing.
/// Updates the entity using this value upon saving.

abstract class _$EditingEntityProperties
    extends $Notifier<Map<String, dynamic>> {
  Map<String, dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, dynamic>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, dynamic>, Map<String, dynamic>>,
              Map<String, dynamic>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages changes in property names being edited
///
/// Tracks changes in property names (key changes).
/// Format: {oldKey: newKey}

@ProviderFor(EditingPropertyNameChanges)
final editingPropertyNameChangesProvider =
    EditingPropertyNameChangesProvider._();

/// Provider that manages changes in property names being edited
///
/// Tracks changes in property names (key changes).
/// Format: {oldKey: newKey}
final class EditingPropertyNameChangesProvider
    extends $NotifierProvider<EditingPropertyNameChanges, Map<String, String>> {
  /// Provider that manages changes in property names being edited
  ///
  /// Tracks changes in property names (key changes).
  /// Format: {oldKey: newKey}
  EditingPropertyNameChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editingPropertyNameChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editingPropertyNameChangesHash();

  @$internal
  @override
  EditingPropertyNameChanges create() => EditingPropertyNameChanges();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$editingPropertyNameChangesHash() =>
    r'6f31930f8df9bf40e62438c08f1dd4a46d5d122f';

/// Provider that manages changes in property names being edited
///
/// Tracks changes in property names (key changes).
/// Format: {oldKey: newKey}

abstract class _$EditingPropertyNameChanges
    extends $Notifier<Map<String, String>> {
  Map<String, String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, String>, Map<String, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, String>, Map<String, String>>,
              Map<String, String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages property names being edited
///
/// Tracks the currently edited property names.
/// Format: {key: editingName}

@ProviderFor(EditingPropertyNames)
final editingPropertyNamesProvider = EditingPropertyNamesProvider._();

/// Provider that manages property names being edited
///
/// Tracks the currently edited property names.
/// Format: {key: editingName}
final class EditingPropertyNamesProvider
    extends $NotifierProvider<EditingPropertyNames, Map<String, String>> {
  /// Provider that manages property names being edited
  ///
  /// Tracks the currently edited property names.
  /// Format: {key: editingName}
  EditingPropertyNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editingPropertyNamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editingPropertyNamesHash();

  @$internal
  @override
  EditingPropertyNames create() => EditingPropertyNames();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$editingPropertyNamesHash() =>
    r'3fa489696ff448f46939fa99f0e02c5b9b56c7ed';

/// Provider that manages property names being edited
///
/// Tracks the currently edited property names.
/// Format: {key: editingName}

abstract class _$EditingPropertyNames extends $Notifier<Map<String, String>> {
  Map<String, String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, String>, Map<String, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, String>, Map<String, String>>,
              Map<String, String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Entity save action provider
///
/// Saves the entity being edited to the database.

@ProviderFor(SaveEntityAction)
final saveEntityActionProvider = SaveEntityActionProvider._();

/// Entity save action provider
///
/// Saves the entity being edited to the database.
final class SaveEntityActionProvider
    extends $NotifierProvider<SaveEntityAction, void> {
  /// Entity save action provider
  ///
  /// Saves the entity being edited to the database.
  SaveEntityActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveEntityActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveEntityActionHash();

  @$internal
  @override
  SaveEntityAction create() => SaveEntityAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$saveEntityActionHash() => r'4c274b46efa5ef15e3dc8fb61c9151af0fa414c1';

/// Entity save action provider
///
/// Saves the entity being edited to the database.

abstract class _$SaveEntityAction extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
