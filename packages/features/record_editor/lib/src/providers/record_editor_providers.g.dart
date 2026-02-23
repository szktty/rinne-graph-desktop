// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_editor_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the entity being edited

@ProviderFor(ActiveEntity)
final activeEntityProvider = ActiveEntityProvider._();

/// Provider that manages the entity being edited
final class ActiveEntityProvider
    extends $NotifierProvider<ActiveEntity, Entity> {
  /// Provider that manages the entity being edited
  ActiveEntityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeEntityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeEntityHash();

  @$internal
  @override
  ActiveEntity create() => ActiveEntity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Entity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Entity>(value),
    );
  }
}

String _$activeEntityHash() => r'a497baaae7ce45fa6a1398b44454e64781f14e4e';

/// Provider that manages the entity being edited

abstract class _$ActiveEntity extends $Notifier<Entity> {
  Entity build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Entity, Entity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Entity, Entity>,
              Entity,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the enable/disable state of auto-save

@ProviderFor(AutoSave)
final autoSaveProvider = AutoSaveProvider._();

/// Provider that manages the enable/disable state of auto-save
final class AutoSaveProvider extends $NotifierProvider<AutoSave, bool> {
  /// Provider that manages the enable/disable state of auto-save
  AutoSaveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSaveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSaveHash();

  @$internal
  @override
  AutoSave create() => AutoSave();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$autoSaveHash() => r'bfd9dec6cff040ad78cd67279e7a9670a806cae3';

/// Provider that manages the enable/disable state of auto-save

abstract class _$AutoSave extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the edit lock state of an entity

@ProviderFor(EntityLock)
final entityLockProvider = EntityLockProvider._();

/// Provider that manages the edit lock state of an entity
final class EntityLockProvider extends $NotifierProvider<EntityLock, bool> {
  /// Provider that manages the edit lock state of an entity
  EntityLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entityLockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entityLockHash();

  @$internal
  @override
  EntityLock create() => EntityLock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$entityLockHash() => r'ff59590a1914fab8af4aaa830562d7970db62b47';

/// Provider that manages the edit lock state of an entity

abstract class _$EntityLock extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the order of properties

@ProviderFor(PropertyOrder)
final propertyOrderProvider = PropertyOrderProvider._();

/// Provider that manages the order of properties
final class PropertyOrderProvider
    extends $NotifierProvider<PropertyOrder, List<String>> {
  /// Provider that manages the order of properties
  PropertyOrderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'propertyOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$propertyOrderHash();

  @$internal
  @override
  PropertyOrder create() => PropertyOrder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$propertyOrderHash() => r'3d4691681ce7b2b0a835a0b89ed5c612b6417ce5';

/// Provider that manages the order of properties

abstract class _$PropertyOrder extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Record editor actions provider

@ProviderFor(RecordEditorActions)
final recordEditorActionsProvider = RecordEditorActionsProvider._();

/// Record editor actions provider
final class RecordEditorActionsProvider
    extends $NotifierProvider<RecordEditorActions, void> {
  /// Record editor actions provider
  RecordEditorActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordEditorActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordEditorActionsHash();

  @$internal
  @override
  RecordEditorActions create() => RecordEditorActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$recordEditorActionsHash() =>
    r'd8284a50de8e1844dc359436ee7a966a211a00b5';

/// Record editor actions provider

abstract class _$RecordEditorActions extends $Notifier<void> {
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
