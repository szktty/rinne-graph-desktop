// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_editor_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeEntityHash() => r'a497baaae7ce45fa6a1398b44454e64781f14e4e';

/// Provider that manages the entity being edited
///
/// Copied from [ActiveEntity].
@ProviderFor(ActiveEntity)
final activeEntityProvider =
    AutoDisposeNotifierProvider<ActiveEntity, Entity>.internal(
      ActiveEntity.new,
      name: r'activeEntityProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeEntityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveEntity = AutoDisposeNotifier<Entity>;
String _$autoSaveHash() => r'bfd9dec6cff040ad78cd67279e7a9670a806cae3';

/// Provider that manages the enable/disable state of auto-save
///
/// Copied from [AutoSave].
@ProviderFor(AutoSave)
final autoSaveProvider = AutoDisposeNotifierProvider<AutoSave, bool>.internal(
  AutoSave.new,
  name: r'autoSaveProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$autoSaveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoSave = AutoDisposeNotifier<bool>;
String _$entityLockHash() => r'ff59590a1914fab8af4aaa830562d7970db62b47';

/// Provider that manages the edit lock state of an entity
///
/// Copied from [EntityLock].
@ProviderFor(EntityLock)
final entityLockProvider =
    AutoDisposeNotifierProvider<EntityLock, bool>.internal(
      EntityLock.new,
      name: r'entityLockProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$entityLockHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EntityLock = AutoDisposeNotifier<bool>;
String _$propertyOrderHash() => r'3d4691681ce7b2b0a835a0b89ed5c612b6417ce5';

/// Provider that manages the order of properties
///
/// Copied from [PropertyOrder].
@ProviderFor(PropertyOrder)
final propertyOrderProvider =
    AutoDisposeNotifierProvider<PropertyOrder, List<String>>.internal(
      PropertyOrder.new,
      name: r'propertyOrderProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$propertyOrderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PropertyOrder = AutoDisposeNotifier<List<String>>;
String _$recordEditorActionsHash() =>
    r'd8284a50de8e1844dc359436ee7a966a211a00b5';

/// Record editor actions provider
///
/// Copied from [RecordEditorActions].
@ProviderFor(RecordEditorActions)
final recordEditorActionsProvider =
    AutoDisposeNotifierProvider<RecordEditorActions, void>.internal(
      RecordEditorActions.new,
      name: r'recordEditorActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$recordEditorActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RecordEditorActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
