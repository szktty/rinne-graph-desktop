// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_selection_bridge_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$initializeEntitySelectionBridgeHash() =>
    r'b41820e31572b82e7a4b430e4840de9d99cb197d';

/// Entity selection state initialization provider
///
/// Executed only once when the application starts,
/// and starts the collaboration between entity selection and the editor.
///
/// Copied from [initializeEntitySelectionBridge].
@ProviderFor(initializeEntitySelectionBridge)
final initializeEntitySelectionBridgeProvider =
    AutoDisposeProvider<void>.internal(
      initializeEntitySelectionBridge,
      name: r'initializeEntitySelectionBridgeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$initializeEntitySelectionBridgeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitializeEntitySelectionBridgeRef = AutoDisposeProviderRef<void>;
String _$entitySelectionBridgeHash() =>
    r'4b1b0e8b8db436f0a83f7b1f3587b2dd4f7407bf';

/// Provider that links entity selection state with the editor
///
/// This provider provides the following functionalities:
/// 1. Transmits selected entity ID to the entity_editor package
/// 2. Transmits the active graph to the entity_editor package
/// 3. Automatically displays the secondary sidebar when an entity is selected
///
/// Copied from [EntitySelectionBridge].
@ProviderFor(EntitySelectionBridge)
final entitySelectionBridgeProvider =
    AutoDisposeNotifierProvider<EntitySelectionBridge, void>.internal(
      EntitySelectionBridge.new,
      name: r'entitySelectionBridgeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$entitySelectionBridgeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EntitySelectionBridge = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
