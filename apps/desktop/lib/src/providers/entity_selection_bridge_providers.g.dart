// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_selection_bridge_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that links entity selection state with the editor
///
/// This provider provides the following functionalities:
/// 1. Transmits selected entity ID to the entity_editor package
/// 2. Transmits the active graph to the entity_editor package
/// 3. Automatically displays the secondary sidebar when an entity is selected

@ProviderFor(EntitySelectionBridge)
final entitySelectionBridgeProvider = EntitySelectionBridgeProvider._();

/// Provider that links entity selection state with the editor
///
/// This provider provides the following functionalities:
/// 1. Transmits selected entity ID to the entity_editor package
/// 2. Transmits the active graph to the entity_editor package
/// 3. Automatically displays the secondary sidebar when an entity is selected
final class EntitySelectionBridgeProvider
    extends $NotifierProvider<EntitySelectionBridge, void> {
  /// Provider that links entity selection state with the editor
  ///
  /// This provider provides the following functionalities:
  /// 1. Transmits selected entity ID to the entity_editor package
  /// 2. Transmits the active graph to the entity_editor package
  /// 3. Automatically displays the secondary sidebar when an entity is selected
  EntitySelectionBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitySelectionBridgeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitySelectionBridgeHash();

  @$internal
  @override
  EntitySelectionBridge create() => EntitySelectionBridge();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$entitySelectionBridgeHash() =>
    r'9cc45b17d8ace2c51b8956aa76a549ee98a16abc';

/// Provider that links entity selection state with the editor
///
/// This provider provides the following functionalities:
/// 1. Transmits selected entity ID to the entity_editor package
/// 2. Transmits the active graph to the entity_editor package
/// 3. Automatically displays the secondary sidebar when an entity is selected

abstract class _$EntitySelectionBridge extends $Notifier<void> {
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

/// Entity selection state initialization provider
///
/// Executed only once when the application starts,
/// and starts the collaboration between entity selection and the editor.

@ProviderFor(initializeEntitySelectionBridge)
final initializeEntitySelectionBridgeProvider =
    InitializeEntitySelectionBridgeProvider._();

/// Entity selection state initialization provider
///
/// Executed only once when the application starts,
/// and starts the collaboration between entity selection and the editor.

final class InitializeEntitySelectionBridgeProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Entity selection state initialization provider
  ///
  /// Executed only once when the application starts,
  /// and starts the collaboration between entity selection and the editor.
  InitializeEntitySelectionBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initializeEntitySelectionBridgeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initializeEntitySelectionBridgeHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return initializeEntitySelectionBridge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$initializeEntitySelectionBridgeHash() =>
    r'b41820e31572b82e7a4b430e4840de9d99cb197d';
